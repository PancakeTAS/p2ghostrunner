IncludeScript("player/stamina");
IncludeScript("player/dash");
IncludeScript("player/wallrun");
IncludeScript("player/footsteps");
IncludeScript("player/grapple");

const JUMP_FORCE = 300; // force applied to the player on jump
const MAX_SPEED = 275; // max speed for raw movement not including special modifiers such as dashing
const SLOWDOWN_FACTOR = 0.05; // factor to slow down the game by when dashing
const GRAVITY = 15; // gravity applied to the player
const GROUND_ACCEL = 100; // acceleration applied to the player when on the ground
const AIR_ACCEL = 75; // ... in the air
const SLOWDOWN_ACCEL = 175; // ... when dashing

/**
 * Main player controller class
 */
::PlayerController <- function () {

    local inst = {

        baseVelocity = Vector(0, 0, 0), // base velocity for movement
        airVelocity = Vector(0, 0, 0), // velocity applied throughout the air
        gravityVelocity = 0, // gravity velocity for z coordinate
        slowdownMovement = Vector(0, 0, 0), // movement vector for slowdown

        onGround = false,
        isCrouched = false,
        wasCrouched = false,
        wasOnGround = false,
        prevZ = 0,
        prevVelZ = 0,

        stamina = Stamina(),
        dash = DashController(),
        grapple = GrappleController(),
        wallrun = WallrunController(),
        footsteps = Footsteps(),

        // methods
        tick = null,
        jump = null

    };

    /**
     * Tick the player controller
     */
    inst.tick = function ():(inst) {
        // check if player left the ground
        local onGround = ::player.GetVelocity().z == 0 && prevVelZ < 0 && prevZ - ::player.GetOrigin().z < 0.1;
        inst.onGround = onGround;
        if (onGround && !wasOnGround)
            ::player.EmitSound("Ghostrunner.Land");
        inst.wasOnGround = onGround;

        // check if player was crouching
        if (!wasCrouched && isCrouched)
            ::player.EmitSound("Ghostrunner.Crouch_Down");
        else if (wasCrouched && !isCrouched)
            ::player.EmitSound("Ghostrunner.Crouch_Up");
        wasCrouched = isCrouched;

        // calculate movement velocity
        local forward = ::forwardVec();
        local left = ::leftVec();
        local movement = ::movementVec();

        if (inst.dash.isSlowdown) {
            if (movement.Length() > 0)
                inst.slowdownMovement = movement;
            inst.baseVelocity = left * inst.slowdownMovement.y * SLOWDOWN_ACCEL;
        } else if (onGround && inst.isCrouched)
            inst.baseVelocity = (inst.baseVelocity + forward * movement.x * GROUND_ACCEL + left * movement.y * GROUND_ACCEL) * 0.97;
        else
            inst.baseVelocity = (inst.baseVelocity + forward * movement.x * (onGround ? GROUND_ACCEL : AIR_ACCEL) + left * movement.y * (onGround ? GROUND_ACCEL : AIR_ACCEL)) * 0.85;

        local velocity = ::clamp_len(baseVelocity, MAX_SPEED);

        // calculate air velocity
        if (onGround) {
            inst.airVelocity = (forward * movement.x * GROUND_ACCEL * 0.85) + (left * movement.y * GROUND_ACCEL * 0.85) + (inst.isCrouched ? dash.dashVelocity * 0.5 : Vector(0, 0, 0));
        } else {
            velocity += inst.airVelocity;

            // check if player hit a wall
            if (::check(velocity))
                inst.airVelocity = Vector(0, 0, 0);
        }

        // apply gravity
        if (onGround) {
            if (gravityVelocity < 0)
                gravityVelocity = -1;
        } else if (inst.dash.isSlowdown)
            gravityVelocity -= GRAVITY * SLOWDOWN_FACTOR / 60.0;
        else
            gravityVelocity -= GRAVITY;

        velocity.z = gravityVelocity;

        // tick modules
        inst.stamina.tick();
        velocity = inst.dash.tick(velocity);
        inst.footsteps.tick(movement, onGround);
        velocity = inst.grapple.tick(velocity);
        local wall = inst.wallrun.tick(movement, gravityVelocity, onGround);
        if (wall) {
            velocity = wall;
            gravityVelocity = 0;
        }

        // set velocity
        prevZ = ::player.GetOrigin().z;
        prevVelZ = velocity.z;
        ::player.SetVelocity(velocity);
    }

    /**
     * Jump the player (called from +jump alias)
     */
    inst.jump = function():(inst) {
        if (inst.onGround && !inst.dash.isSlowdown) {
            inst.gravityVelocity = JUMP_FORCE;
            ::player.EmitSound("Ghostrunner.Jump");
        }

        if (inst.wallrun.wall) {
            inst.gravityVelocity = JUMP_FORCE;
            inst.airVelocity = ::forwardVec() * 125;
            inst.wallrun.timeoutPoint = ::player.GetOrigin();
            inst.wallrun.timeoutDirection = inst.wallrun.wall;
            inst.wallrun.timeout = 90;
            inst.wallrun.wall = null;
            ::player.EmitSound("Ghostrunner.Jump");
        }
    }

    return inst;
}
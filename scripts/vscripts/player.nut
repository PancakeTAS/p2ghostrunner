IncludeScript("player/stamina");
IncludeScript("player/dash");
IncludeScript("player/inputs");

const JUMP_FORCE = 300; // force applied to the player on jump
const MAX_SPEED = 275; // max speed for raw movement not including special modifiers such as dashing
const SLOWDOWN_FACTOR = 0.01; // factor to slow down the game by when dashing
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

        isCrouched = false,

        stamina = Stamina(),
        inputs = Inputs(),
        dash = DashController()

        // methods
        init = null,
        tick = null,
        jump = null

    }

    /**
     * Initialize the player controller after ppmod.player is ready
     */
    inst.init = function ():(inst) {
        // disable built-in movement
        SendToConsole("cl_forwardspeed 0");
        SendToConsole("cl_sidespeed 0");
        SendToConsole("cl_backspeed 0");
        ::pplayer.gravity(0);

        // initialize modules
        inst.dash.init();
        inst.inputs.init();
        inst.stamina.init();

        // bind jump and crouch
        SendToConsole("alias +jump \"script ::contr.jump();\"");
        SendToConsole("alias +alt2 \"script ::contr.isCrouched = true;\"");
        SendToConsole("alias -alt2 \"script ::contr.isCrouched = false;\"");
        SendToConsole("bind ctrl +alt2");
    }

    /**
     * Tick the player controller
     */
    inst.tick = function ():(inst) {
        // check if player left the ground
        local onGround = ::player.GetGroundEntity();

        // calculate movement velocity
        local forward = ::forwardVec();
        local left = ::leftVec();
        local movement = inst.inputs.getMovementVector();

        if (inst.dash.isSlowdown) {
            inst.baseVelocity = left * movement.y * SLOWDOWN_ACCEL;
        } else if (onGround && inst.isCrouched) {
            inst.baseVelocity = (inst.baseVelocity + forward * movement.x * GROUND_ACCEL + left * movement.y * GROUND_ACCEL) * 0.97;
        } else {
            inst.baseVelocity = (inst.baseVelocity + forward * movement.x * (onGround ? GROUND_ACCEL : AIR_ACCEL) + left * movement.y * (onGround ? GROUND_ACCEL : AIR_ACCEL)) * 0.85;
        }

        local velocity = ::clamp_len(baseVelocity, MAX_SPEED);

        // calculate air velocity
        if (onGround) {
            inst.airVelocity = (forward * movement.x * GROUND_ACCEL * 0.85) + (left * movement.y * GROUND_ACCEL * 0.85) + (inst.isCrouched ? dash.dashVelocity * 0.5 : Vector(0, 0, 0));
        } else {
            velocity += inst.airVelocity;

            // check if player hit a wall
            if (::check(velocity)) {
                inst.airVelocity = Vector(0, 0, 0);
            }
        }

        // apply gravity
        if (onGround) {
            if (gravityVelocity < 0) {
                gravityVelocity = 0;
            }
        } else if (inst.dash.isSlowdown) {
            gravityVelocity -= (GRAVITY * SLOWDOWN_FACTOR);
        } else {
            gravityVelocity -= GRAVITY;
        }

        velocity.z = gravityVelocity;

        // tick modules
        inst.stamina.tick();
        velocity = inst.dash.tick(velocity);

        // set velocity
        inst.player.SetVelocity(velocity);
    }

    /**
     * Jump the player (called from +jump alias)
     */
    inst.jump = function():(inst) {
        if (::player.GetGroundEntity() && !inst.dash.isSlowdown) {
            gravityVelocity = JUMP_FORCE;
        }
    }

    return inst;
}
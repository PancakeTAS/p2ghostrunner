IncludeScript("player/inputs");
IncludeScript("player/physics");

const JUMP_FORCE = 300;
const MAX_SPEED = 275;

const GRAVITY = 15;
const GROUND_ACCEL = 100;
const AIR_ACCEL = 75;

::PlayerController <- function () {

    local inst = {

        pplayer = null,
        player = null,
        onGround = false,

        baseVelocity = Vector(0, 0, 0),
        airVelocity = Vector(0, 0, 0),

        inputs = Inputs(),
        physics = Physics(),

        isCrouched = false,

        // methods
        init = null,
        tick = null,
        jump = null

    }

    inst.init = function (pplayer, player):(inst) {
        inst.pplayer = pplayer;
        inst.player = player;

        SendToConsole("cl_forwardspeed 0");
        SendToConsole("cl_sidespeed 0");
        SendToConsole("cl_backspeed 0");
        inst.pplayer.gravity(0);

        inst.inputs.init(inst);
        inst.physics.init(inst);

        SendToConsole("alias +jump \"script ::playerController.jump();\"");
        SendToConsole("alias +alt2 \"script ::playerController.isCrouched = true;\"");
        SendToConsole("alias -alt2 \"script ::playerController.isCrouched = false;\"");
        SendToConsole("bind ctrl +alt2");
    }

    inst.tick = function ():(inst) {
        local zSpeed = inst .player.GetVelocity().z;
        if (zSpeed > GRAVITY || zSpeed < -GRAVITY) {
            inst.onGround = false;
        }

        local forward = inst.physics.getForwardVector();
        local left = inst.physics.getLeftVector();
        local movement = inst.inputs.getMovementVector();

        // calculate movement velocity
        if (inst.onGround && inst.isCrouched) {
            inst.baseVelocity = (inst.baseVelocity + forward * movement.x * GROUND_ACCEL + left * movement.y * GROUND_ACCEL) * 0.97;
        } else {
            inst.baseVelocity = (inst.baseVelocity + forward * movement.x * (inst.onGround ? GROUND_ACCEL : AIR_ACCEL) + left * movement.y * (inst.onGround ? GROUND_ACCEL : AIR_ACCEL)) * 0.85;
        }

        local velocity = inst.physics.clampVector(baseVelocity, MAX_SPEED);

        // update ground movement for jumps
        if (inst.onGround) {
            inst.airVelocity = (forward * movement.x * GROUND_ACCEL * 0.85) + (left * movement.y * GROUND_ACCEL * 0.85);
        } else {
            velocity += inst.airVelocity;
        }

        // gravity
        velocity.z = zSpeed - GRAVITY;

        // set velocity
        inst.player.SetVelocity(velocity);
    }

    inst.jump = function():(inst) {
        if (inst.onGround) {
            local player = GetPlayer();
            player.SetVelocity(player.GetVelocity() + Vector(0, 0, JUMP_FORCE));
        }
    }

    return inst;
}
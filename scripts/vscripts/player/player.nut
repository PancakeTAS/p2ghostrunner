IncludeScript("player/inputs");
IncludeScript("player/physics");

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

        inputs = Inputs(),
        physics = Physics(),

        // methods
        init = null,
        tick = null

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
        inst.baseVelocity = (inst.baseVelocity + forward * movement.x * (inst.onGround ? GROUND_ACCEL : AIR_ACCEL) + left * movement.y * (inst.onGround ? GROUND_ACCEL : AIR_ACCEL)) * 0.85;
        local velocity = inst.physics.clampVector(baseVelocity, MAX_SPEED);

        // gravity
        velocity.z = zSpeed - GRAVITY;

        // set velocity
        inst.player.SetVelocity(velocity);
    }

    return inst;
}
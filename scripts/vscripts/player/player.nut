IncludeScript("player/inputs");
IncludeScript("player/physics");

const GRAVITY = 15;

::PlayerController <- function () {

    local inst = {

        pplayer = null,
        player = null,
        onGround = false,

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
    }

    return inst;
}
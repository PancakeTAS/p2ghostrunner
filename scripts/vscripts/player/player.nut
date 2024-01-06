IncludeScript("player/inputs");

::PlayerController <- function () {

    local inst = {

        pplayer = null,
        player = null,

        inputs = Inputs(),

        // methods
        init = null

    }

    inst.init = function (pplayer, player):(inst) {
        inst.pplayer = pplayer;
        inst.player = player;

        SendToConsole("cl_forwardspeed 0");
        SendToConsole("cl_sidespeed 0");
        SendToConsole("cl_backspeed 0");
        inst.pplayer.gravity(0);

        inst.inputs.init(inst);
    }

    return inst;
}
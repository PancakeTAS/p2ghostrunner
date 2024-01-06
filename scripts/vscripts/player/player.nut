
::PlayerController <- function () {

    local inst = {

        pplayer = null,
        player = null,

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
    }

    return inst;
}
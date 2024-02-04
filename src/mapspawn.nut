if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player/player");
IncludeScript("world/world");
IncludeScript("util");

::contr <- null;
::wcontr <- null;

/**
 * Called when the player is initialized
 */
local init_player = function(pplayer) {

    // set global player variables
    ::pplayer <- pplayer;
    ::player <- pplayer.ent;
    ::eyes <- pplayer.eyes;
    ::init_fakecam();

    // initialize controllers
    ::wasNoclipping <- !player.IsNoclipping();
    ::contr = PlayerController();
    ::contr.init();
    ::wcontr.player_init();

}

/*
 * Called when the server is initialized
 */
local init = function():(init_player) {

    // fix stuff
    SendToConsole("sv_cheats 1");
    SendToConsole("hud_saytext_time 0");

    // initialize world controller
    ::wcontr = WorldController();
    ::wcontr.init();

    // initialize player later
    ppmod.player(GetPlayer()).then(init_player);

};

/**
 * Called every tick at 60 tps
 */
local tick = function() {
    // update player
    if (::contr) {
        // update fake cam
        ::update_fakecam();

        // check noclipping
        local isNoclipping = ::player.IsNoclipping();
        if (isNoclipping && !::wasNoclipping)
            ::set_speed(175);
        else if (!isNoclipping && ::wasNoclipping)
            ::set_speed(0);
        ::wasNoclipping = isNoclipping;

        // update player
        if (!isNoclipping)
            ::contr.tick();
    }

    // update world
    if (::wcontr) {
        ::wcontr.tick();
    }
};

// setup main and tick
ppmod.onauto(init);
ppmod.interval(tick);
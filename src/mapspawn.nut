if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player/player");
IncludeScript("world/world");

::contr <- null;
::wcontr <- null;

/**
 * Called on mapspawn including loads
 */
local reload = function() {
    if (!::player)
        return;

    local name = ::player.GetName();
    local newName = UniqueString("grplayer");
    ::player.targetname = newName;
    ::eyes.SetMeasureTarget(newName);

    ppmod.wait(function ():(name) {
        ::player.targetname = name;
    }, FrameTime());
};

/**
 * Called when the server is initialized
 */
local init = function():(reload) {

    // fix stuff
    SendToConsole("sv_cheats 1");
    SendToConsole("hud_saytext_time 0");

    // initialize player
    local name = UniqueString("grplayer_eyes");
    ::player <- GetPlayer();
    ::eyes <- Entities.CreateByClassname("logic_measure_movement");
    ::eyes.measureType = 1;
    ::eyes.targetname = name;
    ::eyes.targetReference = name;
    ::eyes.target = name;
    ::eyes.SetAngles(0, 0, 90);
    ::eyes.SetMeasureReference(name);
    ::eyes.Enable();
    reload();

    // initialize controllers
    ::wasNoclipping <- !::player.IsNoclipping();
    ::contr = PlayerController();
    ::contr.init();
    ::wcontr = WorldController();
    ::wcontr.init();

};

/**
 * Called every tick at 60 tps
 */
local tick = function() {
    // update player
    if (::contr) {
        // check noclipping
        local isNoclipping = ::player.IsNoclipping();
        if (isNoclipping && !::wasNoclipping) {
            SendToConsole("cl_forwardspeed 175");
            SendToConsole("cl_sidespeed 175");
            SendToConsole("cl_backspeed 175");
        } else if (!isNoclipping && ::wasNoclipping) {
            SendToConsole("cl_forwardspeed 0");
            SendToConsole("cl_sidespeed 0");
            SendToConsole("cl_backspeed 0");

        }
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
local auto = ppmod.onauto(init);
ppmod.addscript(auto, "OnMapSpawn", reload);
ppmod.interval(tick, 0.0, "p2ghostrunner-tick");
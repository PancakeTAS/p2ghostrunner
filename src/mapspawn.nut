if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player/player");
IncludeScript("world/world");
IncludeScript("util");

function removePortalGun() {
    local names = [
        "weapon_portalgun",
        "viewmodel",
        "portalgun_button",
        "portalgun",
        "knockout-portalgun-spawn",
        "player_near_portalgun"
    ];

    // remove portal gun entities
    foreach (name in names) {
        local ent = ppmod.get(name);
        if (ent)
            ent.Destroy();
    }

    // remove portal gun trigger on portal gun
    local portalgun_trigger = ppmod.get(Vector(25.230, 1958.720, -299.0), 1.0, "trigger_once");
    if (portalgun_trigger)
        portalgun_trigger.Destroy();
}

ppmod.onauto(function() {

    // remove portal gun
    SendToConsole("sv_cheats 1");
    removePortalGun();

    // fix stuff
    SendToConsole("bind shift +alt1");
    SendToConsole("bind e +alt2");
    SendToConsole("hud_saytext_time 0");

    // initialize player controller with ppmod.player
    ppmod.player(player).then(function (pplayer) {

        // set global player variables
        ::pplayer = pplayer;
        ::player = pplayer.ent;
        ::eyes = pplayer.eyes;

        // initialize world controller
        ::wcontr = WorldController();

        // register inputs
        foreach(_, global in ["forward", "moveleft", "back", "moveright"]) {
            getroottable()[global] <- false;
            ::pplayer.input("+" + global, function():(global) {
                getroottable()[global] = true
            });
            ::pplayer.input("-" + global, function():(global) {
                getroottable()[global] = false
            });
        }

        // initialize player controller
        ::init_fakecam();
        ::contr = PlayerController();

        // create intervals for player and world controller
        ::wasNoclipping <- true;
        ppmod.interval(function () {

            // update world controller
            ::wcontr.tick();

            // check noclipping
            local isNoclipping = ::player.IsNoclipping();
            if (isNoclipping && !::wasNoclipping) {
                ::set_speed(175);
            } else if (!isNoclipping && ::wasNoclipping) {
                ::set_speed(0);
            }
            ::wasNoclipping = isNoclipping;

            // update player controller
            if (!isNoclipping)
                ::contr.tick();

        });

        ::wcontr.init();

    });

});

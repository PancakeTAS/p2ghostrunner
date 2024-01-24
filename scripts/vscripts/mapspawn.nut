if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player/player");
IncludeScript("world/world");
IncludeScript("util");

function removePortalGun() {
    // remove portal gun
    SendToConsole("ent_remove weapon_portalgun");
    SendToConsole("ent_remove viewmodel");

    // remove portal gun prop
    SendToConsole("ent_remove portalgun_button");
    SendToConsole("ent_remove portalgun");

    // remove portal gun on underground
    SendToConsole("ent_remove knockout-portalgun-spawn");

    // remove portal gun on portal gun
    local portalgun_trigger = Entities.FindByClassnameNearest("trigger_once", Vector(25.230, 1958.720, -299.0), 1.0)
    if (portalgun_trigger)
        portalgun_trigger.Destroy();

    // remove portal gun on incinerator
    SendToConsole("ent_remove player_near_portalgun");
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

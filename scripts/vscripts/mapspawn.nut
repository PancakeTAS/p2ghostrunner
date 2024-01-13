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
    SendToConsole("snd_setmixer Player VOL 2");
    SendToConsole("hud_saytext_time 0");

    // initialize player controller with ppmod.player
    ppmod.player(player).then(function (pplayer) {

        // set global player variables
        ::pplayer = pplayer;
        ::player = pplayer.ent;
        ::eyes = pplayer.eyes;

        // initialize world controller
        ::wcontr = WorldController();
        ppmod.interval(function () {
            ::wcontr.tick();
        });

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

        ::contr = PlayerController();
        ppmod.interval(function () {

            // update player controller if player is not noclipping
            if (::player.IsNoclipping()) {
                ::set_speed(175);
            } else {
                ::set_speed(0);
                ::contr.tick();
            }

        });

        ::wcontr.init();

    });

});

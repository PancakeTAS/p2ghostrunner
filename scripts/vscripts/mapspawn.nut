if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player");
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
    removePortalGun();

    // fix binds
    SendToConsole("bind shift +alt1");

    // initialize player controller with ppmod.player
    ppmod.player(player).then(function (pplayer) {

        // set global player variables
        ::pplayer = pplayer;
        ::player = pplayer.ent;
        ::eyes = pplayer.eyes;

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

    });

});

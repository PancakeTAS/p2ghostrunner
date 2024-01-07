if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player");
IncludeScript("util");

ppmod.onauto(function() {

    // remove portal gun
    SendToConsole("ent_remove weapon_portalgun");
    SendToConsole("ent_remove viewmodel");

    // fix binds
    SendToConsole("bind shift +alt1");

    // initialize player controller with ppmod.player
    ppmod.player(player).then(function (pplayer) {

        ::pplayer = pplayer;
        ::player = pplayer.ent;
        ::eyes = pplayer.eyes;

        ::contr = PlayerController();
        ::contr.init();
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

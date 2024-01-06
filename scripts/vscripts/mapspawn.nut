if (!("Entities" in this)) return;
IncludeScript("ppmod4");
IncludeScript("player/player");

::playerController <- null;

ppmod.onauto(function() {
    SendToConsole("sv_cheats 1");
    SendToConsole("developer 1");
    SendToConsole("ent_remove weapon_portalgun");
    SendToConsole("ent_remove viewmodel");
    SendToConsole("crosshair 0");
    SendToConsole("sv_alternateticks 0");

    ppmod.player(player).then(function (pplayer) {

        ::playerController = PlayerController();
        ::playerController.init(pplayer, pplayer.ent);
        ppmod.interval(function () {
            ::playerController.tick();
        });

    });
});

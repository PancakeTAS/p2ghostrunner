/**
 * Map specific controller
 */
class MapController {

    skipText = null;

    /**
     * Initialize specific map
     */
    constructor() {
        ::fakecam_enable = false;
        
        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 0, 0);
            e.SetOrigin(Vector(393, 0, 1408));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.fire(e, "Open");
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -180, -4);
            e.SetOrigin(Vector(-318, -702, 1297));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.fire(e, "Open");
        });

        // trigger on exit portal
        local ent = ppmod.trigger(Vector(-418, -702, 1297), Vector(10, 100, 100));
        ppmod.addscript(ent, "OnStartTouch", function () {
            ppmod.fire(ppmod.get("door_0-testchamber_door"), "Close");

            // don't show stamina bar
            ::renderStamina = false;
            local stamina = ::contr.stamina._staminaText;
            if (stamina) {
                if (stamina.ent)
                    stamina.ent.Destroy();
                ::contr.stamina._staminaText = null;
            }

            // display skip text
            SendToConsole("bind e \"script ::wcontr.controller.skip();\"");
            local text = ppmod.text("Press E to skip the cutscene", -1, 0.7);
            text.SetFade(1, 1, false);
            text.SetColor("255 255 255");
            text.Display(30);

            ::wcontr.controller.skipText = text;
            ppmod.wait(function():(text) {
                text.SetFade(0, 1, false);
                text.Display(1);
                SendToConsole("bind e +alt2");
            }, 5);
        });
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        // remove skip text
        this.skipText.SetFade(0, 0, false);
        this.skipText.Display(0.1);

        // skip the cutscene
        ppmod.fire(ppmod.get("bts_panel_door-lr_heavydoor_open"), "trigger");
        ppmod.fire(ppmod.get("airlock_door-open_door"), "trigger");
        ppmod.get("@sphere").Destroy();
        SendToConsole("snd_setmixer wheatleyVO mute 1");
        SendToConsole("bind e +alt2");

        // manually start the game
        ppmod.wait(function () {
            SendToConsole("snd_setmixer wheatleyVO mute 0");
            ::renderStamina = true;
        }, 1.0);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
/**
 * Intro map controller
 */
class MapController {

    /**
     * Initialize intro map
     */
    constructor() {
        // move camera
        ppmod.fire(ppmod.get("ghostAnim"), "Kill");
        ::player.SetOrigin(Vector(-1234, 4401, 2769));

        // break intro cutscene (thank you maxwell mod)
        ppmod.fire("good_morning_vcd", "Kill");
        ppmod.fire("@glados", "RunScriptCode", "GladosPlayVcd(\"PreHub01RelaxationVaultIntro01\")");
        ppmod.fire(ppmod.get(Vector(-1232, 4400, 2856.5), 16), "Kill");
        ppmod.fire("glass_break", "Kill");

        // fix some more stuff
        SendToConsole("map_wants_save_disable 0");
        SendToConsole("fadein 5");

        // move portal
        ppmod.get("portal_blue_0_emitter").SetOrigin(Vector(5000, 5000, 5000));
        ppmod.get("portal_blue_0").SetOrigin(Vector(5000, 5000, 5000));
        SendToConsole("ent_remove_all mmc_clock_flash_12");
        SendToConsole("ent_remove_all mmc_clock_flash_blank");
        SendToConsole("ent_remove 160");
        SendToConsole("ent_remove 39");
    }

    /**
     * Tick intro map
     */
    function tick() {

    }

}
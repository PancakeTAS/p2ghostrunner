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
        SendToConsole("ent_fire door_1-testchamber_door open");
        SendToConsole("ent_remove door_1-door_player_clip");

        // fix some more stuff
        SendToConsole("map_wants_save_disable 0");
        SendToConsole("fadein 5");
    }

    /**
     * Tick intro map
     */
    function tick() {

    }

}
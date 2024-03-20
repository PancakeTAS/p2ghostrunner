/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // trigger glass
        ppmod.fire("glass_pane_1_door_1", "Open");
        ppmod.fire("glass_pane_fractured_model", "Enable");
        ppmod.fire("glass_shard", "Break");
        ppmod.fire("glass_pane_intact_model", "Kill");
        ppmod.fire("glass_pane_1_door_1_blocker", "Kill");
        ppmod.get(Vector(878, -528, 137), 1, "trigger_once").Destroy();
        ppmod.fire("section_2_trigger_portal_spawn_a2_rm3a", "Kill");
        ppmod.get(Vector(884, -528, 4), 1, "trigger_once").Destroy();
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
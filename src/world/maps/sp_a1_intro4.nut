/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // move cube in second room
        ppmod.get(Vector(261.750, -236.750, 146.219), 15, "prop_weighted_cube").SetOrigin(Vector(312.5, -314.0, 146.0));
    
        // trigger glass
        ppmod.fire("glass_pane_1_door_1", "Open");
        ppmod.fire("glass_pane_fractured_model", "Enable");
        ppmod.fire("glass_shard", "Break");
        ppmod.get("glass_pane_intact_model").Destroy();
        ppmod.get("glass_pane_1_door_1_blocker").Destroy();
        ppmod.get(Vector(878, -528, 137), 1, "trigger_once").Destroy();
        ppmod.get("section_2_trigger_portal_spawn_a2_rm3a").Destroy();
        ppmod.get(Vector(884, -528, 4), 1, "trigger_once").Destroy();
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
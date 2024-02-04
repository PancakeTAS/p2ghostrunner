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
        ppmod.get("glass_pane_intact_model").Destroy();
        ppmod.get("glass_pane_1_door_1_blocker").Destroy();
        ppmod.get(Vector(878, -528, 137), 1, "trigger_once").Destroy();
        ppmod.get("section_2_trigger_portal_spawn_a2_rm3a").Destroy();
        ppmod.get(Vector(884, -528, 4), 1, "trigger_once").Destroy();

        // move cube in second room (cube spawns late)
        ppmod.wait(function() {
            ppmod.get(Vector(261.748, -236.784, 146.256), 5, "prop_weighted_cube").SetOrigin(Vector(312.5, -314.0, 146.0));
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
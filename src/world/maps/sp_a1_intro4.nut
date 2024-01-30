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
        ppmod.fire(ppmod.get("glass_pane_1_door_1"), "Open");
        ppmod.fire(ppmod.get("glass_pane_fractured_model"), "Enable");
        ppmod.fire(ppmod.get("glass_pane_intact_model"), "Kill");
        ppmod.fire(ppmod.get("glass_pane_1_door_1_blocker"), "Kill");
        ppmod.fire(ppmod.get("glass_shard"), "Break");
        ppmod.get(54).Destroy();
        ppmod.get(69).Destroy();
        ppmod.get(56).Destroy();
        ppmod.get(84).Destroy();
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
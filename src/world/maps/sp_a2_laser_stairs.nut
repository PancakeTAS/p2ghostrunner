/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // move cube to a reachable location
        ppmod.wait(function() {
            ppmod.get("cube_dropper_01-cube_dropper_box").SetOrigin(Vector(-392, 249, -69));
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
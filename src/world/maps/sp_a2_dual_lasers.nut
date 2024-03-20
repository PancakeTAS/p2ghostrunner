/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // trigger first laser
        // TODO: implement shurikens to trigger laser
        ppmod.get("laser_02").SetAngles(-15, -139, 0);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
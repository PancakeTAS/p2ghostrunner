/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // TODO: fix with shurikens
        local laser = ppmod.get("env_portal_laser");
        laser.SetOrigin(Vector(550, -928, 32));
        laser.SetAngles(1.3, 116.6, 0);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
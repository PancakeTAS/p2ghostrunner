/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // move cube
        /*
        NOTE: reimplement in another mode
        ppmod.get(Vector(256, 191.938, 18.188), 1, "prop_weighted_cube").SetOrigin(Vector(28.5 -67, -365.781));
        */
       ppmod.get(Vector(256, 191.938, 18.188), 1, "prop_weighted_cube").SetOrigin(Vector(-19.031, -493.625, 286.281));
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
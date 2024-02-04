/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // move cube
        ppmod.get(Vector(256, 191.938, 18.188), 1, "prop_weighted_cube").SetOrigin(Vector(28.5, -67, -365.781));
    }

    /**
     * Late initialization once the player is loaded
     */
    function player_init() {
        
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
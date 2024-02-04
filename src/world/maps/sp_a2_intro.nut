/**
 * Map specific controller
 */
class MapController {

    grapple = GrapplePoint(Vector(-769, 451, -10481.8), 1500);

    /**
     * Initialize specific map
     */
    constructor() {
        
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
        this.grapple.tick();
    }

}
/**
 * Map specific controller
 */
class MapController {

    grapple = null;

    /**
     * Initialize specific map
     */
    constructor() {
        
    }

    /**
     * Late initialization once the player is loaded
     */
    function player_init() {
        this.grapple = GrapplePoint(Vector(-769, 451, -10481.8), 1500);
    }

    /**
     * Tick specific map
     */
    function tick() {
        if (this.grapple) this.grapple.tick();
    }

}
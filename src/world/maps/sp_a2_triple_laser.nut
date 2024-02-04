/**
 * Triple laser controller
 */
class MapController {

    grapple = GrapplePoint(Vector(7831, -5619, 273), 500);

    /**
     * Initialize triple laser
     */
    constructor() {
        printl("========== TRIPLE LASER INIT ==========");

    }

    /**
     * Late initialization once the player is loaded
     */
    function player_init() {
    
    }

    /**
     * Tick triple laser
     */
    function tick() {
        this.grapple.tick();
    }

}
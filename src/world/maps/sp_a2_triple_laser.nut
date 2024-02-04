/**
 * Triple laser controller
 */
class MapController {

    grapple = null;

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
        this.grapple = GrapplePoint(Vector(7831, -5619, 273), 500);
    }

    /**
     * Tick triple laser
     */
    function tick() {
        if (this.grapple) this.grapple.tick();
    }

}
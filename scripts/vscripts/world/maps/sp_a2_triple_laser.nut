/**
 * Triple laser controller
 */
class MapController {

    grapple = Grapple(Vector(7831, -5619, 273), 500);

    /**
     * Initialize triple laser
     */
    constructor() {
        printl("========== TRIPLE LASER INIT ==========");

    }

    /**
     * Tick triple laser
     */
    function tick() {
        this.grapple.tick();
    }

}
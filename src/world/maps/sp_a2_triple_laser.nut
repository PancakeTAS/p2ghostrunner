/**
 * Triple laser controller
 */
class MapController {

    grapple = GrapplePoint(Vector(7831, -5619, 273), 500);
    pistol = PistolNPC(Vector(7983, -5849, 0));

    /**
     * Initialize triple laser
     */
    constructor() {
        printl("========== TRIPLE LASER INIT ==========");
    
        ppmod.wait(function ():(pistol) {
            pistol.kill();
        }, 10.0);
    }

    /**
     * Tick triple laser
     */
    function tick() {
        this.grapple.tick();
        this.pistol.tick();
    }

}
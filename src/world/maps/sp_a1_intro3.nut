/**
 * Map specific controller
 */
class MapController {

    grapple = Grapple(Vector(-1004.156, 2608.428, 62.562), 450);

    /**
     * Initialize specific map
     */
    constructor() {
        // remove existing hints
        SendToConsole("ent_remove_all env_instructor_hint");

        // prepare hints
        ppmod.wait(function() {
            local dashHint = Hint("Press shift to dash");
            dashHint.setBinding("alt1");
            dashHint.createTrigger(Vector(92, 1942, -251), Vector(128, 128, 128));
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {
        this.grapple.tick();
    }

}
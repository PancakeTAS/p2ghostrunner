/**
 * Map specific controller
 */
class MapController {

    grapple = Grapple(Vector(-1004.156, 2558.428, 56), 450, Vector(0, 0, 15));

    /**
     * Initialize specific map
     */
    constructor() {
        // remove existing hints
        SendToConsole("ent_remove_all env_instructor_hint");

        // prepare hints
        ppmod.wait(function():(grapple) {
            local dashHint = Hint("Press shift to dash");
            dashHint.setBinding("alt1");
            dashHint.createTrigger(Vector(92, 1942, -251), Vector(128, 128, 128));

            local grappleHint = Hint("Press e to grapple");
            grappleHint.setBinding("alt2");
            grappleHint.createLookTrigger(Vector(-1004.156, 2558.428, 56), Vector(450, 100, 200), grapple.sphere.GetName());
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {
        this.grapple.tick();
    }

}
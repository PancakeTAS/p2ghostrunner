/**
 * Map specific controller
 */
class MapController {

    // at the end
    grapple = GrapplePoint(Vector(4839, 4648, 554), 1500);

    /**
     * Initialize specific map
     */
    constructor() {
        // remove existing hints
        SendToConsole("ent_remove_all env_instructor_hint");

        // prepare hints
        local inst = this;
        ppmod.wait(function():(inst) {
            local grappleHint = Hint("Look at the grapplepoint and tap grapple");
            grappleHint.setBinding("alt2");
            grappleHint.createLookTrigger(Vector(3625, 4468, -344), Vector(500, 500, 500), inst.grapple.sphere.GetName());
        }, 1);
    }

    /**
     * Reload specific map
     */
    function reload() {

    }

    /**
     * Tick specific map
     */
    function tick() {
        this.grapple.tick();
    }

}
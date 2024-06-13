/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // remove existing hints
        SendToConsole("ent_remove_all env_instructor_hint");

        // prepare hints
        local inst = this;
        ppmod.wait(function():(inst) {
            local dashHint = Hint("Hold to enable sensory boost. Let go to dash");
            dashHint.setBinding("alt1");
            dashHint.createTrigger(Vector(92, 1942, -251), Vector(128, 128, 128));

            local wallrunHint = Hint("Jump towards the wall to wallrun");
            wallrunHint.setBinding("jump");
            wallrunHint.createTrigger(Vector(-1341, 2861, -128), Vector(150, 75, 10));
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
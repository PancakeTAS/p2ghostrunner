/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // add skip to trigger
        local inst = this;
        ppmod.addscript(ppmod.get("do_not_touch_anything_trigger"), "OnStartTouch", function ():(inst) {
            Skip(5, inst.skip, null);
        });
    }

    /**
     * Late initialization once the player is loaded
     */
    function player_init() {
        ::fakecam_enable = false;
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        ::player.SetOrigin(Vector(6156, 3465, 904));
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
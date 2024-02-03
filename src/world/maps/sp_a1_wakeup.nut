/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        ::fakecam_enable = false;

        // add skip to trigger
        local skip = this.skip;
        ppmod.addscript(ppmod.get("do_not_touch_anything_trigger"), "OnStartTouch", function ():(skip) {
            Skip(5, skip, null);
        });
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
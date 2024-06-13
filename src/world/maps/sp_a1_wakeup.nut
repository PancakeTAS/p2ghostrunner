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
        ppmod.addscript("do_not_touch_anything_trigger", "OnStartTouch", function ():(inst) {
            Skip(5, inst.skip, null);
        });

        // fix wheatley by disabling custom camera
        ::contr.camera.enabled = false;
    }

    /**
     * Skip the intro cutscene
     */
    function skip() {
        ::player.SetOrigin(Vector(6156, 3465, 904));
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

    }

}
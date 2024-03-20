/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        local ent = ppmod.trigger(Vector(-1479, 248, -536), Vector(50, 50, 20));
        local inst = this;
        ent.AddScript("OnStartTouch", function ():(inst) {
            Skip(5, inst.skip, null);
        });
    }

    /**
     * Skip the elevator cutscene
     */
    function skip() {
        ::player.SetOrigin(Vector(-1472, 256, -3007.750));
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
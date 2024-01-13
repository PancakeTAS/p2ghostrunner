/**
 * Main world controller class
 */
::WorldController <- function () {

    local inst = {

        controller = null, // specific map controller

        // methods
        init = null,
        tick = null

    };

    /**
     * Initialize the world controller
     */
    inst.init = function ():(inst) {
        // include map specific code
        switch (GetMapName()) {
            case "sp_a2_triple_laser":
                IncludeScript("world/maps/sp_a2_triple_laser");
                break;
            default:
                IncludeScript("world/maps/default");
                break;
        }

        // initialize map specific controller
        inst.controller = MapController();
    }

    /**
     * Tick the world controller
     */
    inst.tick = function ():(inst) {
        // tick map specific controller
        inst.controller.tick();
    }

    return inst;
}
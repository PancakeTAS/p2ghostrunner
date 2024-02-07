IncludeScript("world/behavior/entitymgmt");
IncludeScript("world/behavior/freeze");
IncludeScript("world/components/grapplepoint");
IncludeScript("world/components/hint");
IncludeScript("world/components/skip");

/**
 * Main world controller class
 */
::WorldController <- function () {

    local inst = {

        controller = null, // specific map controller
        freeze = null,
        entitymgmt = null,

        // methods
        init = null,
        tick = null

    };

    /**
     * Initialize the world controller
     */
    inst.init = function ():(inst) {
        IncludeScript("world/maps/epochtal");
        inst.controller = MapController();

        // initialize modules
        inst.freeze = Freeze();
        inst.entitymgmt = EntityManagement();
    }

    /**
     * Tick the world controller
     */
    inst.tick = function ():(inst) {
        // tick modules
        if (inst.controller) inst.controller.tick();
        if (inst.entitymgmt) inst.entitymgmt.tick();
    }

    return inst;
}
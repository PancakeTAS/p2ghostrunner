IncludeScript("world/grapplepoint");

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

        // disable prop collision
        local collidables = [
            "prop_weighted_cube",
            "prop_physics",
            "npc_security_camera",
            "npc_portal_floor_turret"
        ];
        for (local i = 0; i < 4; i++) {
            local ent = null;
            while (ent = ppmod.get(collidables[i], ent))
                ppmod.keyval(ent, "collisiongroup", 2);
        }
    }

    return inst;
}
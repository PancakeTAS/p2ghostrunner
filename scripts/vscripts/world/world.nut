IncludeScript("world/grapplepoint");
IncludeScript("world/freeze");

/**
 * Main world controller class
 */
::WorldController <- function () {

    local inst = {

        controller = null, // specific map controller
        freeze = Freeze(), // freeze time

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
            case "sp_a1_intro1":
                IncludeScript("world/maps/sp_a1_intro1");
                break;
            case "sp_a2_triple_laser":
                IncludeScript("world/maps/sp_a2_triple_laser");
                break;
            // tournament maps
            case "workshop/2287332779813957889/1704848596":
                IncludeScript("world/maps/tournament/week108");
                break;
            default:
                IncludeScript("world/maps/default");
                break;
        }

        // initialize map specific controller
        inst.controller = MapController();

        // create lazy prop collision updater
        ppmod.interval(function () {
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
        }, 1.0);
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
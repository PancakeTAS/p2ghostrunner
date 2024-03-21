IncludeScript("world/behavior/entitymgmt");
IncludeScript("world/components/grapplepoint");
IncludeScript("world/components/hint");
IncludeScript("world/components/skip");
IncludeScript("world/entities/npc_pistol");

/**
 * Main world controller class
 */
::WorldController <- function () {

    local inst = {

        controller = null, // specific map controller
        entitymgmt = null,

        // methods
        init = null,
        tick = null

    };

    /**
     * Initialize the world controller
     */
    inst.init = function ():(inst) {
        // include custom controller
        local maps = [
            "sp_a1_intro1", "sp_a1_intro3", "sp_a1_intro4", "sp_a1_intro5", "sp_a1_intro6", "sp_a1_intro7",
            "sp_a1_wakeup", "sp_a2_intro", "sp_a2_laser_stairs", "sp_a2_laser_relays", "sp_a2_column_blocker",
            "sp_a2_triple_laser"
        ];

        // load current map module
        local map = GetMapName();
        foreach (m in maps) {
            if (map == m) {
                IncludeScript("world/maps/" + map);
                inst.controller = MapController();
                break;
            }
        }

        // initialize modules
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
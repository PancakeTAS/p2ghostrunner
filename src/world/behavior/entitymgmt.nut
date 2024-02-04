/**
 * Entity management
 */
class EntityManagement {

    collidableTicks = 0; // tick counter for updating collision groups

    /**
     * Initialize entity management
     */
    constructor() {
        // remove portal gun entities
        local names = [
            "weapon_portalgun",
            "viewmodel",
            "portalgun_button",
            "portalgun",
            "knockout-portalgun-spawn",
            "player_near_portalgun"
        ];

        foreach (name in names) {
            local ent = ppmod.get(name);
            if (ent)
                ent.Destroy();
        }

        // remove portal gun trigger on portal gun
        local portalgun_trigger = ppmod.get(Vector(25.230, 1958.720, -299.0), 1.0, "trigger_once");
        if (portalgun_trigger)
            portalgun_trigger.Destroy();
    }

    /**
     * Tick entity management
     */
    function tick() {
        // tick collision group updater
        if (this.collidableTicks++ >= 60) {
            this.collidableTicks = 0;

            // remove player collision with entities
            local collidables = [
                "prop_weighted_cube",
                "prop_physics",
                "npc_security_camera",
                "npc_portal_floor_turret"
            ];
            
            for (local i = 0; i < 4; i++) {
                local ent = null;
                while (ent = ppmod.get(collidables[i], ent))
                    ent.collisionGroup = 2;
            }
        }
    }

}
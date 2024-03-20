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
        foreach (name in [
            "weapon_portalgun",
            "viewmodel",
            "portalgun_button",
            "portalgun",
            "knockout-portalgun-spawn",
            "player_near_portalgun"
        ])
            ppmod.fire(name, "Kill");

        // remove portal gun trigger on portal gun
        local portalgun_trigger = ppmod.get(Vector(25.230, 1958.720, -299.0), 1.0, "trigger_once");
        if (portalgun_trigger)
            portalgun_trigger.Destroy();

        // disable faith plates
        ppmod.fire("trigger_catapult", "Disable");
    }

    /**
     * Tick entity management
     */
    function tick() {
        // tick collision group updater
        if (this.collidableTicks++ >= 60) {
            this.collidableTicks = 0;

            // remove player collision with entities
            foreach (prop in [
                "prop_weighted_cube",
                "prop_physics",
                "npc_security_camera",
                "npc_portal_floor_turret"
            ])
                ppmod.keyval(prop, "CollisionGroup", 2);
        }
    }

}
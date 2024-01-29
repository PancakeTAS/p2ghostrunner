/**
 * Freeze instance
 */
class Freeze {

    frozen = array(0);

    /**
     * Unfreeze all entities
     */
    function unfreeze() {
        for (local i = 0; i < this.frozen.len(); i++) {
            local ent = this.frozen[i].entity;
            if (ent && typeof ent == "instance" && ent instanceof CBaseEntity && ent.IsValid())
                ppmod.keyval(ent, "MoveType", 6);
        }
        
        // love vphysics
        ppmod.wait(function ():(frozen) {
            for (local i = 0; i < frozen.len(); i++) {
                local ent = frozen[i].entity;
                if (ent && typeof ent == "instance" && ent instanceof CBaseEntity && ent.IsValid() && frozen[i].position && frozen[i].rotation && frozen[i].velocity) {
                    ent.SetOrigin(frozen[i].position);
                    ent.SetAngles(frozen[i].rotation.x, frozen[i].rotation.y, frozen[i].rotation.z);
                    ent.SetVelocity(frozen[i].velocity);
                }
            }
            ::wcontr.freeze.frozen.clear();
        }, 0.02);

    }

    /**
     * Freeze all entities
     */
    function freeze() {
        local freezables = [
            "prop_weighted_cube",
            "prop_physics",
            "npc_security_camera",
            "npc_portal_floor_turret"
        ];

        for (local i = 0; i < 4; i++) {
            local ent = null;
            while (ent = ppmod.get(freezables[i], ent)) {
                if (ent.GetName() == "grapple")
                    continue;

                ppmod.keyval(ent, "MoveType", 4);
                this.frozen.append({
                    entity = ent,
                    velocity = ent.GetVelocity() + Vector(0, 0, 0)
                    position = ent.GetOrigin() + Vector(0, 0, 0),
                    rotation = ent.GetAngles() + Vector(0, 0, 0)
                });
                ent.SetVelocity(ent.GetVelocity() * SLOWDOWN_FACTOR * 60);
            }
        }
    }

}
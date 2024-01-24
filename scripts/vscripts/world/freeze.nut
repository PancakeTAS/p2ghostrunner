/**
 * Freeze instance
 */
class Freeze {

    frozen = array(0);

    /**
     * Unfreeze all entities
     */
    function unfreeze() {
        for (local i = 0; i < this.frozen.len(); i++)
            ppmod.keyval(this.frozen[i].entity, "MoveType", 6);
        
        // love vphysics
        ppmod.wait(function ():(frozen) {
            for (local i = 0; i < frozen.len(); i++) {
                frozen[i].entity.SetOrigin(frozen[i].position);
                frozen[i].entity.SetAngles(frozen[i].rotation.x, frozen[i].rotation.y, frozen[i].rotation.z);
                frozen[i].entity.SetVelocity(frozen[i].velocity);
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
                ppmod.keyval(ent, "MoveType", 4);
                this.frozen.append({
                    entity = ent,
                    velocity = ent.GetVelocity(),
                    position = ent.GetOrigin(),
                    rotation = ent.GetAngles()
                });
                ent.SetVelocity(ent.GetVelocity() * SLOWDOWN_FACTOR * 60);
            }
        }
    }

}
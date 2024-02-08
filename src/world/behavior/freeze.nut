/**
 * Freeze
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
                ent.moveType = 6;
        }
        
        // love vphysics
        local inst = this;
        ppmod.wait(function ():(inst) {
            foreach (entry in inst.frozen) {
                local ent = entry.entity;
                if (ent && typeof ent == "instance" && ent instanceof CBaseEntity && ent.IsValid() && entry.position && entry.rotation && entry.velocity) {
                    ent.SetOrigin(entry.position);
                    ent.SetAngles(entry.rotation.x, entry.rotation.y, entry.rotation.z);
                    ent.SetVelocity(entry.velocity);
                }
            }
            inst.frozen.clear();
        }, 0.05);

    }

    /**
     * Freeze all entities
     */
    function freeze() {
        local inst = this;
        foreach (prop in [
            "prop_weighted_cube",
            "prop_physics",
            "npc_security_camera",
            "npc_portal_floor_turret"
        ]) {
            ppmod.getall(prop, function (ent):(inst) {
                if (ent.GetName().find("rapple")) // (grapple) i love squirrel
                    return;

                ent.moveType = 4;
                inst.frozen.append({
                    entity = ent,
                    velocity = ent.GetVelocity() + Vector(0, 0, 0)
                    position = ent.GetOrigin() + Vector(0, 0, 0),
                    rotation = ent.GetAngles() + Vector(0, 0, 0)
                });
                ent.SetVelocity(ent.GetVelocity() * SENSORY_BOOST_FACTOR * 60);
            });
        }
    }

}
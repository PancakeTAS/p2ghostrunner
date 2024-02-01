::grapples <- array(0);

/**
 * Grapple instance
 */
class Grapple {

    position = null;
    range = null;
    sphere = null;
    canGrapple = false;

    /**
     * Initialize a grapple point
     */
    constructor(position, range, rotation = Vector(0, 0, 0)) {
        this.position = position;
        this.range = range;

        local inst = this;
        ppmod.create("ent_create_portal_weighted_sphere").then(function (ent):(inst, position, rotation) {
            inst.sphere = ent;
            ppmod.keyval(ent, "targetname", "grapple" + ::grapples.len());
            ppmod.keyval(ent, "MoveType", 0);
            ppmod.keyval(ent, "collisiongroup", 1);
            ent.SetOrigin(position);
            ent.SetAngles(rotation.x, rotation.y, rotation.z);
        });

        ::grapples.append(this);
    }

    /**
     * Tick the grapple point
     */
    function tick() {
        for (;;) {
            // check if user is in range
            local distance = (::player.GetOrigin() - this.position).Length();
            if (distance > this.range)
                break;

            // check if user is looking at the grapple point
            local forward = ::eyes.GetForwardVector();
            local direction = this.position - ::player.GetOrigin();
            direction.Norm();
            local dot = forward.Dot(direction);
            if (dot < 0.9)
                break;

            // check if any objects obstruct the grapple point
            local trace = ppmod.ray(::player.GetOrigin(), this.position - Vector(0, 0, 20.25));
            if (trace.fraction < 0.9)
                break;

            if (!this.canGrapple)
                ppmod.fire(this.sphere, "Skin", 1);
            this.canGrapple = true;
            return;
        }
        if (this.canGrapple)
            ppmod.fire(this.sphere, "Skin", 0);
        this.canGrapple = false;
    }

    /**
     * Grapple to the point
     */
    function use() {
        return this.position - ::player.GetOrigin();
    }

}
::grapples <- array(0);

/**
 * Grapple point instance
 */
class GrapplePoint {

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
        ppmod.create("ent_create_portal_weighted_sphere").then(function (ent):(inst, rotation) {
            inst.sphere = ent;
            ent.targetname = "grapple" + ::grapples.len();
            ent.moveType = 0;
            ent.collisionGroup = 1;
            ent.SetOrigin(inst.position);
            ent.SetAngles(rotation.x, rotation.y, rotation.z);
        });

        ::grapples.append(this);
    }

    /**
     * Tick the grapple point. Player must be initialized
     */
    function tick() {

        for (;;) {
            // check if user is in range
            local distance = (::contr.physics.origin - this.position).Length();
            if (distance > this.range)
                break;

            // check if user is looking at the grapple point
            local forward = ::eyes.GetForwardVector();
            local direction = (this.position - ::contr.physics.origin).Normalize();
            local dot = forward.Dot(direction);
            if (dot < 0.9)
                break;

            // check if any objects obstruct the grapple point
            local trace = ppmod.ray(::contr.physics.origin, this.position - Vector(0, 0, 20.25));
            if (trace.fraction < 0.9)
                break;

            if (!this.canGrapple)
                this.sphere.Skin(1);
            this.canGrapple = true;
            return;
        }

        if (this.canGrapple)
            this.sphere.Skin(0);
        this.canGrapple = false;
    }

    /**
     * Grapple to the point
     */
    function use() {
        return this.position - ::contr.physics.origin;
    }

}
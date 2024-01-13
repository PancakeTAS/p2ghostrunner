::grapples <- array(0);

/**
 * Grapple instance
 */
class Grapple {

    position = null;
    range = null;
    spheres = {
        active = null,
        inactive = null
    };
    canGrapple = false;

    /**
     * Initialize a grapple point
     */
    constructor(position, range) {
        this.position = position;
        this.range = range;

        // create an activate sphere
        ppmod.create("prop_floor_button").then(function (ent):(position, spheres) {
            ent.SetOrigin(position + Vector(0, 0, 64));
            ppmod.addscript(ent, "OnPressed", function ():(position, spheres) {
                ppmod.keyval(spheres.active, "MoveType", 0);
                ppmod.keyval(spheres.active, "collisiongroup", 1);
            });
        });
        ppmod.create("ent_create_portal_weighted_sphere").then(function (ent):(position, spheres) {
            ent.SetOrigin(position + Vector(0, 0, 64));
            spheres.active = ent;
        });

        // create an inactive sphere
        ppmod.create("ent_create_portal_weighted_sphere").then(function (ent):(position, spheres) {
            ppmod.keyval(ent, "MoveType", 0);
            ppmod.keyval(ent, "collisiongroup", 1);
            ent.SetOrigin(position);
            spheres.inactive = ent;
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
            local trace = ppmod.ray(::player.GetOrigin(), this.position);
            if (trace.fraction < 0.9)
                break;

                this.spheres.active.SetOrigin(this.position);
            this.spheres.inactive.SetOrigin(this.position + Vector(0, 0, 64));
            this.canGrapple = true;
            return;
        }
        this.spheres.inactive.SetOrigin(this.position);
        this.spheres.active.SetOrigin(this.position + Vector(0, 0, 64));
        this.canGrapple = false;
    }

    /**
     * Grapple to the point
     */
    function use() {
        return this.position - ::player.GetOrigin();
    }


}
const GRAPPLE_COOLDOWN = 60;

// FIXME: this all needs a rewrite, it's a mess

/**
 * Grapple class
 */
class Grapple {

    /** Current velocity applied by the grapple controller */
    velocity = Vector(0, 0, 0);
    /** Internal cooldown in ticks for the grapple hook */
    _cooldown = 0;

    /**
     * Tick the grapple controller
     */
    function tick() {
        // apply grapple velocity
        // FIXME: wtf is this mess -> understand this again
        // FIXME2: maybe insert a check() here?
        if (::contr.movement.sensoryBoost && this.velocity.Length() / SENSORY_BOOST_FACTOR > 50.0) {
            ::contr.movement.finalVelocity += this.velocity;
            this.velocity *= 0.95 + (0.95 * SENSORY_BOOST_FACTOR);
            // FIXME: i really don't want to do this
            ::contr.movement._gravity += (GRAVITY * SENSORY_BOOST_FACTOR / 60.0) / 2; // compensate for gravity
        } else if (this.velocity.Length() > 50.0) {
            ::contr.movement.finalVelocity += this.velocity;
            this.velocity *= 0.95;
            ::contr.movement._gravity += GRAVITY / 2; // compensate for gravity
        }

        // update grapple cooldown
        if (this._cooldown > 0)
            this._cooldown -= ::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1.0;
    }

    /**
     * Grapple an available grapple point
     */
    function grapple() {
        // FIXME: foreach, scopes, pointless ifs, too tired to do this now
        for (local i = 0; i < ::grapples.len(); i++) {
            if (::grapples[i].canGrapple && this._cooldown <= 0) {
                this._cooldown = GRAPPLE_COOLDOWN;
                ::player.EmitSound("Ghostrunner.Grapple");

                ppmod.wait(function ():(i) {
                    ::player.EmitSound("Ghostrunner.Hook");
                }, 0.2);

                ppmod.wait(function ():(i) {
                    ::contr.grapple.velocity = ::grapples[i].use() * Vector(1, 1, 0.7) * 3 * (::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1);
                    // FIXME: bruh
                    ::contr.movement._gravity = 0;
                }, 0.3);
                return false;
            }
        }

        return true;
    }

}
/**
 * Grapple class
 */
class Grapple {

    /** Whether the player is currently grappling */
    grappled = false;
    /** Current velocity applied by the grapple controller */
    velocity = Vector(0, 0, 0);
    /** Internal cooldown in ticks for the grapple hook */
    _cooldown = 0;

    /**
     * Tick the grapple controller
     */
    function tick() {
        this.grappled = (this.velocity.Length() / (::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1)) > 50.0;

        // apply grapple velocity
        if (this.grappled) {
            ::contr.movement.finalVelocity += this.velocity;
            this.velocity *= 0.95 + (::contr.movement.sensoryBoost ? (SENSORY_BOOST_FACTOR * 0.95) : 0);
        }

        // update grapple cooldown
        if (this._cooldown > 0)
            this._cooldown -= ::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1.0;
    }

    /**
     * Grapple an available grapple point
     */
    function grapple() {
        // return engine use if grapple is on cooldown
        if (this._cooldown > 0)
            return true;

        // find first grappleable point
        foreach (grapple in ::grapples) {
            if (!grapple.canGrapple)
                continue;

            this._cooldown = GRAPPLE_COOLDOWN;
            ::player.EmitSound("Ghostrunner.Grapple");

            ppmod.wait(function () {
                ::player.EmitSound("Ghostrunner.Hook");
            }, 0.2);

            local inst = this;
            ppmod.wait(function ():(inst, grapple) {
                inst.velocity = grapple.use() * Vector(1, 1, 0.7) * 3 * (::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1);
                ::contr.movement.overrideGravity(0);
            }, 0.3);
            return false;
        }

        return true;
    }

}
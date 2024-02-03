const GRAPPLE_COOLDOWN = 60;

/**
 * Grapple controller class
 */
class GrappleController {

    velocity = Vector(0, 0, 0);
    cooldown = 0;

    /**
     * Tick the grapple controller
     */
    function tick(pVelocity) {
        if (this.cooldown > 0)
            this.cooldown -= 1 * (::contr.dash.isSlowdown ? SLOWDOWN_FACTOR : 1.0);

        // append fling velocity
        if (this.velocity.Length() / SLOWDOWN_FACTOR > 50.0 && ::contr.dash.isSlowdown) {
            pVelocity += this.velocity;
            this.velocity *= 0.95 + (0.95 * SLOWDOWN_FACTOR);
            ::contr.gravityVelocity += (GRAVITY * SLOWDOWN_FACTOR / 60.0) / 2; // compensate for gravity
        } else if (this.velocity.Length() > 50.0) {
            pVelocity += this.velocity;
            this.velocity *= 0.95;
            ::contr.gravityVelocity += GRAVITY / 2; // compensate for gravity
        }

        return pVelocity;
    }

    /**
     * Called when the player presses use
     */
    function onUsePress() {
        for (local i = 0; i < ::grapples.len(); i++) {
            if (::grapples[i].canGrapple && this.cooldown == 0) {
                this.cooldown = GRAPPLE_COOLDOWN;
                ::player.EmitSound("Ghostrunner.Grapple");

                ppmod.wait(function ():(i) {
                    ::player.EmitSound("Ghostrunner.Hook");
                }, 0.2);

                ppmod.wait(function ():(i) {
                    ::contr.grapple.velocity = ::grapples[i].use() * Vector(1, 1, 0.7) * 3 * (::contr.dash.isSlowdown ? SLOWDOWN_FACTOR : 1);
                    ::contr.gravityVelocity = 0;
                }, 0.3);
                return;
            }
        }

        SendToConsole("+use");
    }

    /**
     * Called when the player releases use
     */
    function onUseRelease() {
        SendToConsole("-use");
    }

}
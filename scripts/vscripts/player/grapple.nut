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
            this.cooldown--;

        // append fling velocity
        if (this.velocity.Length() > 50.0) {
            pVelocity += this.velocity;
            this.velocity *= 0.95;
            ::contr.gravityVelocity += GRAVITY / 2; // compensate for gravity
        }

        return pVelocity;
    }

    /**
     * Try to use a grapple
     */
    function use() {
        if (this.cooldown != 0)
            return;

        for (local i = 0; i < ::grapples.len(); i++) {
            if (::grapples[i].canGrapple) {
                this.velocity = ::grapples[i].use() * Vector(1, 1, 0.7) * 3;
                this.cooldown = GRAPPLE_COOLDOWN;
                ::contr.gravityVelocity = 0;
                break;
            }
        }
    }

}
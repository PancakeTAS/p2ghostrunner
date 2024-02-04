/**
 * Player physics class
 */
class Physics {

    /** Directional forward player vector in 2d space */
    forward2d = null;
    /** Directional left player vector in 2d space */
    left2d = null;

    /** Player origin */
    origin = null;
    /** Player angles */
    angles = null;

    /** Player grounded state */
    grounded = false;
    /** Event function for when the player touches the ground */
    onLand = null;
    /** Event function for when the player loses contact with the ground */
    onAir = null;
    /** Internal previous grounded state */
    _prevGrounded = false;
    /** Internal previous velocity */
    prevVelocity = Vector(0, 0, 0);
    /** Internal previous origin */
    prevOrigin = Vector(0, 0, 0);

    /**
     * Tick player physics
     */
    function tick() {
        // update directional vectors
        this.forward2d = ::eyes.GetForwardVector() * Vector(1, 1, 0);
        this.forward2d.Norm();
        this.left2d = ::eyes.GetLeftVector() * Vector(1, 1, 0);
        this.left2d.Norm();

        // update player origin and angles
        this.origin = ::player.GetOrigin();
        this.angles = ::player.GetAngles();

        // check ground state
        local engineVelocity = ::player.GetVelocity();
        this.grounded = engineVelocity.z == 0 && this.prevVelocity.z < 0 && this.prevOrigin.z - this.origin.z < 0.1;

        // check for ground state change
        if (this.grounded != this._prevGrounded) {
            if (this.grounded)
                if (this.onLand) this.onLand();
            else
                if (this.onAir) this.onAir();
            this._prevGrounded = this.grounded;
        }
    }

    /**
     * Late tick player physics
     */
    function tick_end() {
        // update previous states
        this.prevVelocity = ::contr.movement.finalVelocity;
        this.prevOrigin = this.origin;
    }

}
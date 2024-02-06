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
        this.angles = ::eyes.GetAngles();

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


    /**
    * Check for collisions with a wall
    */
    function getWall(groundLength = 50) {
        local origin = this.origin + Vector(0, 0, 16);
        local forward = this.forward2d * 8;
        local left = this.left2d * 32;

        // check right wall
        local r1 = ppmod.ray(origin - forward, origin - forward + left);
        local r2 = ppmod.ray(origin + forward, origin + forward + left);
        if (r1.fraction < 1 && r2.fraction < 1) {
            local delta = r2.point - r1.point;
            delta.Norm();
            return {
                point = r1.point,
                up = delta,
                side = 1,
                ground = ppmod.ray(r1.point, r1.point - Vector(0, 0, groundLength)).fraction < 1
            };
        }

        // check left wall
        r1 = ppmod.ray(origin - forward, origin - forward - left);
        r2 = ppmod.ray(origin + forward, origin + forward - left);
        if (r1.fraction < 1 && r2.fraction < 1) {
            local delta = r2.point - r1.point;
            delta.Norm();
            return {
                point = r1.point,
                up = delta,
                side = -1,
                ground = ppmod.ray(r1.point, r1.point - Vector(0, 0, groundLength)).fraction < 1
            };
        }

        return null;
    }

    /**
    * Check for collisions at a given velocity
    */
    function checkCollision(velocity) {
        local squareVelocity = Vector((velocity.x > 0 ? 1 : (velocity.x < 0 ? -1 : 0)), (velocity.y > 0 ? 1 : (velocity.y < 0 ? -1 : 0)), 0);
        local origin = this.origin + squareVelocity * 8;
        local newOrigin = origin + (velocity / 60.0);
        local result = ppmod.ray(origin + Vector(0, 0, 8), newOrigin + Vector(0, 0, 8));
        if (result.fraction < 1)
            return true;
        result = ppmod.ray(origin + Vector(0, 0, 36), newOrigin + Vector(0, 0, 36));
        if (result.fraction < 1)
            return true;
        result = ppmod.ray(origin + Vector(0, 0, 72), newOrigin + Vector(0, 0, 72));
        if (result.fraction < 1)
            return true;
        return false;
    }


}
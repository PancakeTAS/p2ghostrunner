/**
 * Main movement controller class
 */
class Movement {

    /** Whether the sensory boost is active */
    sensoryBoost = false;
    /** Velocity to be applied to the player at the end of this tick */
    finalVelocity = Vector(0, 0, 0);

    /** Internal value for tracking the previous 2d base velocity */
    _prevBaseVelocity = Vector(0, 0);
    /** Internal value for tracking the previous 2d air strafing velocity */
    _prevAirStrafeVelocity = Vector(0, 0);
    /** Internal value for tracking sensory boost direction */
    _sensoryBoostDirection = 0;
    /** Internal value for tracking the gravity */
    _gravity = 0;

    /**
     * Tick player movement
     */
    function tick() {
        // calculate base velocity
        local baseVelocity = null;
        if (this.sensoryBoost) {
            // sensory boost movement
            if (::contr.inputs.movement.y != 0)
                this._sensoryBoostDirection = (::contr.inputs.movement.y > 0) ? SENSORY_BOOST_ACCELERATION : -SENSORY_BOOST_ACCELERATION; // not technically acceleration, but called this for consistency in naming
        
            baseVelocity = ::contr.physics.left2d * this._sensoryBoostDirection;
        } else if (::contr.physics.grounded && ::contr.inputs.crouched && this._prevBaseVelocity.Length() > 100) {
            // sliding movement
            baseVelocity = this._prevBaseVelocity * SLIDE_FRICTION;
        } else if (::contr.physics.grounded &&
         ::contr.inputs.crouched) {
            // crouched movement
            SendToConsole("snd_setmixer SlideLoop MUTE 1");
            baseVelocity = (
                  ::contr.physics.forward2d * ::contr.inputs.movement.x * CROUCH_ACCELERATION
                + ::contr.physics.left2d * ::contr.inputs.movement.y * CROUCH_ACCELERATION
            );
        } else if (::contr.physics.grounded) {
            // grounded movement
            baseVelocity = (
                this._prevBaseVelocity
                + ::contr.physics.forward2d * ::contr.inputs.movement.x * GROUND_ACCELERATION
                + ::contr.physics.left2d * ::contr.inputs.movement.y * GROUND_ACCELERATION
            ) * NORMAL_FRICTION;
        } else {
            // air movement
            baseVelocity = (
                this._prevBaseVelocity
                + ::contr.physics.forward2d * ::contr.inputs.movement.x * AIR_ACCELERATION
                + ::contr.physics.left2d * ::contr.inputs.movement.y * AIR_ACCELERATION
            ) * NORMAL_FRICTION; // technically air has it's own friction, but we use the same friction for the sake of making gameplay smoothness
        }

        // clamp base velocity to actual velocity
        local velocity = ::clamp_len(baseVelocity, BASE_VELOCITY_MAX);
        this._prevBaseVelocity = baseVelocity;
        
        // calculate air strafing velocity
        if (::contr.physics.grounded) {
            this._prevAirStrafeVelocity = (
                ::contr.physics.forward2d * ::contr.inputs.movement.x * GROUND_ACCELERATION
                + ::contr.physics.left2d * ::contr.inputs.movement.y * GROUND_ACCELERATION
                + (::contr.inputs.crouched ? ::contr.dash.velocity * 0.5 : Vector(0, 0))
            );
        } else {
            velocity += this._prevAirStrafeVelocity;

            // check if player hit a wall
            if (::check(velocity))
                this._prevAirStrafeVelocity = Vector(0, 0);
        }

        // apply gravity including jump
        if (::contr.inputs.jumped && !this.sensoryBoost && (::contr.physics.grounded || ::contr.wallrun.walljump())) {
            this._gravity = JUMP_FORCE;
            ::player.EmitSound("Ghostrunner.Jump");
        } else if (::contr.physics.grounded) {
            this._gravity = -1;
        } else if (::contr.grapple.grappled && this.sensoryBoost) {
            this._gravity -= GRAVITY * (SENSORY_BOOST_FACTOR / 60.0) / 2
        } else if (::contr.grapple.grappled) {
            this._gravity -= GRAVITY / 2;
        } else if (this.sensoryBoost) {
            this._gravity -= GRAVITY * (SENSORY_BOOST_FACTOR / 60.0); 
        } else {
            this._gravity -= GRAVITY;
        }
        velocity.z = this._gravity;

        // set the velocity
        this.finalVelocity = velocity;
    }

    /**
     * Late tick player movement
     */
    function tick_end() {
        // apply the final velocity
        ::player.SetVelocity(this.finalVelocity);
    }

    /**
     * Enable the sensory boost
     */
    function enableSensoryBoost() {
        if (this.sensoryBoost)
            return;

        // apply sensory boost to velocities
        this.sensoryBoost = true;
        this._prevAirStrafeVelocity *= SENSORY_BOOST_FACTOR;
        this._gravity *= SENSORY_BOOST_FACTOR;
        this._sensoryBoostDirection = 0;
        ::contr.grapple.velocity *= SENSORY_BOOST_FACTOR;

        // apply player effects
        SendToConsole("mat_vignette_enable 1");
        ::player.EmitSound("Ghostrunner.SensoryBoost");
        ::contr.stamina.canRegen = false;

        // apply world effects
        ::wcontr.freeze.freeze();
    }

    /**
     * Disable the sensory boost
     */
    function disableSensoryBoost() {
        if (!this.sensoryBoost)
            return;

        // apply sensory boost to velocities
        this.sensoryBoost = false;
        this._prevAirStrafeVelocity /= SENSORY_BOOST_FACTOR;
        ::contr.grapple.velocity /= SENSORY_BOOST_FACTOR

        // apply player effects
        SendToConsole("mat_vignette_enable 0");
        SendToConsole("snd_setmixer SensoryBoost MUTE 1");
        ppmod.wait(function() {
            SendToConsole("snd_setmixer SensoryBoost MUTE 0");
        }, 0.5);

        // apply world effects
        ::wcontr.freeze.unfreeze();
    }

    /**
     * Override the player gravity
     */
    function overrideGravity(gravity) {
        this._gravity = gravity;
    }

    /**
     * Override the player air strafe velocity
     */
    function overrideAirStrafeVelocity(velocity) {
        this._prevAirStrafeVelocity = velocity;
    }

}
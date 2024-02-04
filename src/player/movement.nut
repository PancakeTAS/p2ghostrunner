// acceleration values
const GROUND_ACCELERATION = 100;
const AIR_ACCELERATION = 75;
const SENSORY_BOOST_ACCELERATION = 175;
// friction values
const NORMAL_FRICTION = 0.85;
const SLIDE_FRICTION = 0.97;
// max velocity
const BASE_VELOCITY_MAX = 275;
// gravity
const GRAVITY = 15;
const JUMP_FORCE = 300;
// multipliers
const SENSORY_BOOST_FACTOR = 0.05;

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
        } else if (::contr.physics.grounded && ::contr.inputs.crouched) {
            // sliding movement

            // FIXME: this code doesn't make any sense, because
            // from the pre-refactor code movement.x + movement.y
            // are always 0 when crouched, so they shouldn't
            // be used here. That said, you are supposed to be able to
            // walk while being crouched, as long as you're not sliding.
            // For now I'll hotfix this with comments

            baseVelocity = (
                this._prevBaseVelocity
                //+ ::contr.physics.forward2d * ::contr.inputs.movement.x * GROUND_ACCELERATION
                //+ ::contr.physics.left2d * ::contr.inputs.movement.y * GROUND_ACCELERATION
            ) * SLIDE_FRICTION;
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

        // FIXME: should base velocity have a wall check here?
        
        // calculate air strafing velocity
        if (::contr.physics.grounded) {

            // FIXME: the last statement here needs to be double checked
            // i'm not sure if dashVelocity can be anything other than 0
            // note, if it can't, then dashVelocity should be private

            this._prevAirStrafeVelocity = (
                ::contr.physics.forward2d * ::contr.inputs.movement.x * GROUND_ACCELERATION
                + ::contr.physics.left2d * ::contr.inputs.movement.y * GROUND_ACCELERATION
                + (::contr.inputs.crouched ? ::contr.dash.velocity * 0.5 : Vector(0, 0))
            )
        } else {
            velocity += this._prevAirStrafeVelocity;

            // check if player hit a wall
            // FIXME: should this be reset entirely, or multiplied by the walls forward vector?
            if (::check(velocity))
                this._prevAirStrafeVelocity = Vector(0, 0);
        }

        // apply gravity
        if (::contr.physics.grounded) {
            // FIXME: if the player is grounded how can gravity be above 0?
            // ... i figured it out, it's because of jump(). even with the new input stuff
            // that is still being called before this, so I need to delay it to here
            if (this._gravity < 0)
                this._gravity = -1;
        } else if (this.sensoryBoost) {
            // FIXME: shouldn't there be parentheses around the latter
            this._gravity -= GRAVITY * SENSORY_BOOST_FACTOR / 60.0; 
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
        // FIXME: can this be done in the tick function?
        // or maybe even in wallrun.nut?
        if (::contr.wallrun.wall) {
            this.finalVelocity = ::contr.wallrun.wallVec;
            this._gravity = 0;
        }

        // apply the final velocity
        ::player.SetVelocity(this.finalVelocity);
    }

    /**
     * Jump the player
     */
    function jump() {
        // handle normal jump
        if (::contr.physics.grounded && !this.sensoryBoost) {
            this._gravity = JUMP_FORCE;
            ::player.EmitSound("Ghostrunner.Jump");
        }

        if (::contr.wallrun.wall && !this.sensoryBoost) {
            // FIXME: perhaps this should be a separate function
            this._gravity = JUMP_FORCE;
            this._prevAirStrafeVelocity = ::contr.physics.forward2d * 125;
            ::contr.wallrun._cooldownPoint = ::contr.physics.origin;
            ::contr.wallrun._cooldownDirection = ::contr.wallrun.wall;
            ::contr.wallrun._cooldown = 90;
            ::set_roll(0.0);
            ::contr.wallrun.wall = null;
            ::player.EmitSound("Ghostrunner.Jump");
        }

        // FIXME: implement jump event (outside of this)
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
        // FIXME: reapply the previous velocities (?)
        this.sensoryBoost = false;
        this._prevAirStrafeVelocity = Vector(0, 0, 0);

        // apply player effects
        SendToConsole("mat_vignette_enable 0");
        SendToConsole("snd_setmixer SensoryBoost MUTE 1");
        ppmod.wait(function() {
            SendToConsole("snd_setmixer SensoryBoost MUTE 0");
        }, 0.5);

        // apply world effects
        ::wcontr.freeze.unfreeze();
    }

}
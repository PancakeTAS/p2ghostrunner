// dash values
const DASH_SPEED = 1000;
const DASH_COOLDOWN = 30.0; // 0.5 * 60

/**
 * Dash class
 */
class Dash {

    /** Current velocity applied by the dash controller */
    velocity = Vector(0, 0, 0);
    /** Internal cooldown in ticks for dash */
    _cooldown = 0;

    /**
     * Start the sensory boost
     */
    function startSensory() {
        // check if dash can be used
        if (this._cooldown > 0 || ::contr.stamina.stamina < DASH_COST)
            return;

        // dash immediately if player is grounded
        if (::contr.physics.grounded) {
            local m = ::contr.inputs.movement;
            if (m.Length() < 0.1)
                return;
            
            // offset the raw movement input by the camera angle and dash
            local f = ::contr.physics.forward2d;
            local angle = atan2(m.y * -1, m.x);
            local cosAngle = cos(angle);
            local sinAngle = sin(angle);
            this.dash(Vector(f.x * cosAngle - f.y * sinAngle, f.x * sinAngle + f.y * cosAngle, 0));
            ::player.EmitSound("Ghostrunner.Dash");
            return;
        }

        // enable sensory boost
        ::contr.movement.enableSensoryBoost();
    }

    /**
     * End the sensory boost
     */
    function endSensory() {
        // ignore if sensory boost is not active
        if (!::contr.movement.sensoryBoost)
            return;

        // dash the player
        // FIXME: move to tick()?
        this.dash(::contr.physics.forward2d);
        ::player.EmitSound("Ghostrunner.Dash_Air_Charge");
    }

    /**
     * Tick the dash controller
     */
    function tick() {
        // apply dash velocity
        if (this.velocity.Length() > 1) {
            ::contr.movement.finalVelocity += this.velocity;
            this.velocity *= ::contr.inputs.crouched ? 0.95 : 0.9;

            // check if player hit a wall
            if (::check(this.velocity))
                this.velocity = Vector(0, 0, 0);
        } else {
            // reset player effects if dash is not active
            SendToConsole("mat_motion_blur_strength 1");
        }

        // update dash cooldown
        if (this._cooldown > 0)
            this._cooldown--; // it's not possible to be in sensory boost and dash at the same time, so no need to decrease this timer

        // FIXME: debate whether this should go to movement
        // consume stamina and check if player should dash
        if (::contr.movement.sensoryBoost) {
            ::contr.stamina.consume(SENSORY_BOOST_COST);

            if (::contr.stamina.stamina <= 0) {
                this.dash(::contr.physics.forward2d);
                ::player.EmitSound("Ghostrunner.Dash_Air_Charge");
            }
        }
    }

    /**
     * Dash the player
     */
    function dash(dir) {
        // set dash velocity
        this.velocity = dir * DASH_SPEED;
        this._cooldown = DASH_COOLDOWN;

        // disable sensory boost
        ::contr.movement.disableSensoryBoost();

        // consume stamina
        ::contr.stamina.consume(DASH_COST);
        ::contr.stamina.canRegen = true;

        // apply player effects
        SendToConsole("mat_motion_blur_enabled 1");
        SendToConsole("mat_motion_blur_strength 5");
    }

}
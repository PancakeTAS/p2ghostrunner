const DASH_SPEED = 1000; // speed applied to player when dashing
const DASH_COOLDOWN = 30.0; // 0.5 * 60; cooldown between dashes in ticks

/**
 * Dash controller class
 */
class DashController {

    dashVelocity = Vector(0, 0, 0); // velocity applied to player after dashing
    isSlowdown = false;
    _cooldown = 0;

    /**
     * Called when the player presses shift
     */
    function onShiftPress() {
        // check if dash can be used
        if (this._cooldown > 0 || ::contr.stamina.stamina < DASH_COST)
            return;

        // check if player should dash immediately
        if (::player.GetGroundEntity()) {
            this.dash();
            ::player.EmitSound("Ghostrunner.Dash");
            return;
        }

        // slow down player
        ::contr.airVelocity *= SLOWDOWN_FACTOR;
        ::contr.gravityVelocity *= SLOWDOWN_FACTOR;
        ::contr.grapple.velocity *= SLOWDOWN_FACTOR;
        this.isSlowdown = true;
        ::contr.stamina.canRegen = false;

        // add player effects
        SendToConsole("mat_vignette_enable 1");
        ::player.EmitSound("Ghostrunner.Slowdown");
    }

    /**
     * Called when the player releases shift
     */
    function onShiftRelease() {
        // check if player is dashing
        if (!this.isSlowdown)
            return;

        // dash player
        this.dash();
        ::player.EmitSound("Ghostrunner.Dash_Air_Charge");
    }

    /**
     * Tick the dash controller
     */
    function tick(velocity) {
        // apply dash velocity
        if (dashVelocity.Length() > 1) {
            velocity += dashVelocity;
            dashVelocity *= ::contr.isCrouched ? 0.95 : 0.9;

            // check if player hit a wall
            if (::check(velocity))
                dashVelocity = Vector(0, 0, 0);
        } else {
            SendToConsole("mat_motion_blur_strength 1");
        }

        // update cooldown
        if (this._cooldown > 0)
            this._cooldown--;

        if (this.isSlowdown) {
            // consume stamina and check if player should dash
            ::contr.stamina.consume(SLOWDOWN_COST);

            if (::contr.stamina.stamina <= 0) {
                this.dash();
                ::player.EmitSound("Ghostrunner.Dash_Air_Charge");
            }
        }

        return velocity;
    }

    /**
     * Dash the player
     */
    function dash() {
        dashVelocity = ::forwardVec() * DASH_SPEED;

        // reset dash variables
        this.isSlowdown = false;
        this._cooldown = DASH_COOLDOWN;
        ::contr.stamina.consume(DASH_COST);
        ::contr.stamina.canRegen = true;

        // apply player effects
        SendToConsole("mat_vignette_enable 0");
        SendToConsole("mat_motion_blur_enabled 1");
        SendToConsole("mat_motion_blur_strength 5");
        SendToConsole("snd_setmixer SensoryBoost MUTE 1");
        ppmod.wait(function() {
            SendToConsole("snd_setmixer SensoryBoost MUTE 0");
        }, (DASH_COOLDOWN - 1) / 60.0);

        // reset air velocity to prevent player from flying off
        ::contr.airVelocity = Vector(0, 0, 0);
    }

}
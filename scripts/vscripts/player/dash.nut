const DASH_SPEED = 1400; // speed applied to player when dashing
const DASH_COOLDOWN = 30.0; // 0.5 * 60; cooldown between dashes in ticks

/**
 * Dash controller class
 */
class DashController {
    _player = null;

    dashVelocity = Vector(0, 0, 0); // velocity applied to player after dashing
    isSlowdown = false;
    _cooldown = 0;

    /**
     * Initialize the dash controller
     */
    function init(player) {
        _player = player;

        // bind shift to dash
        SendToConsole("alias +alt1 \"script ::playerController.dash.onShiftPress();\"");
        SendToConsole("alias -alt1 \"script ::playerController.dash.onShiftRelease();\"");
        SendToConsole("bind shift +alt1");
    }

    /**
     * Called when the player presses shift
     */
    function onShiftPress() {
        // check if dash can be used
        if (this._cooldown > 0 || this._player.stamina.stamina < DASH_COST) {
            return;
        }

        // check if player should dash immediately
        if (this._player.player.GetGroundEntity()) {
            this.dash();
            return;
        }

        // slow down player
        this._player.player.SetVelocity(this._player.player.GetVelocity() * SLOWDOWN_FACTOR);
        this.isSlowdown = true;
        this._player.stamina.canRegen = false;
    }

    /**
     * Called when the player releases shift
     */
    function onShiftRelease() {
        // check if player is dashing
        if (!this.isSlowdown) {
            return;
        }

        // dash player
        this.dash();
    }

    /**
     * Tick the dash controller
     */
    function tick(velocity) {
        // apply dash velocity
        if (dashVelocity.Length() > 1) {
            velocity += dashVelocity;
            dashVelocity *= _player.isCrouched ? 0.95 : 0.9;
        }

        // update cooldown
        if (this._cooldown > 0) {
            this._cooldown--;
        }

        if (this.isSlowdown) {
            // consume stamina and check if player should dash
            this._player.stamina.consume(SLOWDOWN_COST);

            if (this._player.stamina.stamina <= 0) {
                this.dash();
            }
        }

        return velocity;
    }

    /**
     * Dash the player
     */
    function dash() {
        // update dash velocity
        dashVelocity = this._player.pplayer.eyes.GetForwardVector() * Vector(1, 1, 0);
        dashVelocity.Norm();
        dashVelocity *= DASH_SPEED;

        // reset dash variables
        this.isSlowdown = false;
        this._cooldown = DASH_COOLDOWN;
        this._player.stamina.consume(DASH_COST);
        this._player.stamina.canRegen = true;

        // reset air velocity to prevent player from flying off
        this._player.airVelocity = Vector(0, 0, 0);
    }

}
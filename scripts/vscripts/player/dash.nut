const DASH_SPEED = 1400;
const DASH_COOLDOWN = 30.0; // 0.5 * 60

class DashController {
    _player = null;

    dashVelocity = Vector(0, 0, 0);
    isSlowdown = false;
    _cooldown = 0;

    function init(player) {
        _player = player;
        SendToConsole("alias +alt1 \"script ::playerController.dash.onShiftPress();\"");
        SendToConsole("alias -alt1 \"script ::playerController.dash.onShiftRelease();\"");
        SendToConsole("bind shift +alt1");
    }

    function onShiftPress() {
        if (this._cooldown > 0 || this._player.stamina.stamina < DASH_COST) {
            return;
        }

        if (this._player.onGround) {
            this.dash();
            return;
        }

        this._player.player.SetVelocity(this._player.player.GetVelocity() * SLOWDOWN_FACTOR);
        this.isSlowdown = true;
        this._player.stamina.canRegen = false;
    }

    function onShiftRelease() {
        if (!this.isSlowdown) {
            return;
        }

        this.dash();
    }

    function tick(velocity) {
        if (dashVelocity.Length() > 1) {
            velocity += dashVelocity;
            dashVelocity *= _player.isCrouched ? 0.95 : 0.9;
        }

        if (this._cooldown > 0) {
            this._cooldown--;
        }

        if (this.isSlowdown) {
            this._player.stamina.consume(SLOWDOWN_COST);

            if (this._player.stamina.stamina <= 0) {
                this.dash();
            }
        }

        return velocity;
    }

    function dash() {
        dashVelocity = this._player.pplayer.eyes.GetForwardVector() * Vector(1, 1, 0);
        dashVelocity.Norm();
        dashVelocity *= DASH_SPEED;

        this.isSlowdown = false;
        this._cooldown = DASH_COOLDOWN;
        this._player.stamina.consume(DASH_COST);
        this._player.stamina.canRegen = true;

        this._player.airVelocity = Vector(0, 0, 0);
    }

}
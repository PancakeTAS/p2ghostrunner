const MAX_STAMINA = 100;
const REGEN_STAMINA = 0.416666; // 25 / 60.0
const FULL_REGENERATION_TIMEOUT = 60.0; // 1 * 60.0
const DASH_COST = 30;
const SLOWDOWN_COST = 0.66666; // 40 / 60.0;

class Stamina {

    stamina = MAX_STAMINA;
    canRegen = true;
    _regenTimeout = 0;
    _staminaText = null;

    function init() {
        this._staminaText = ppmod.text("STAMINA", 0, 0);
    }

    function tick() {
        local text = "";
        if (stamina < MAX_STAMINA) {
            for (local i = 0; i < (this.stamina / 5); i++) {
                text += "x";
            }
        }
        this._staminaText.SetText(text);
        this._staminaText.Display();

        if (this._regenTimeout > 0) {
            this._regenTimeout--;
            return;
        }

        if (!this.canRegen) {
            return;
        }

        this.stamina = min(MAX_STAMINA, this.stamina + REGEN_STAMINA);
    }

    function consume(cost) {
        this.stamina -= cost;
        if (this.stamina <= 0) {
            this.stamina = 0;
            this._regenTimeout = FULL_REGENERATION_TIMEOUT;
        }
    }

}
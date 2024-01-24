const MAX_STAMINA = 100; // max stamina a player can have
const REGEN_STAMINA = 0.416666; // 25 / 60.0; amount of stamina regenerated per tick
const FULL_REGENERATION_TIMEOUT = 60.0; // 1 * 60.0; amount of ticks to wait before regenerating stamina after it has been fully depleted
const DASH_COST = 30; // stamina cost of dashing
const SLOWDOWN_COST = 0.66666; // 40 / 60.0; stamina cost of slowdown

/**
 * Stamina management class
 */
class Stamina {

    stamina = MAX_STAMINA;
    canRegen = true;
    _regenTimeout = 0;
    _staminaText = null; // ppmod.text object

    /**
     * Tick the stamina management class
     */
    function tick() {
        // update the stamina text
        local text = " ";
        if (stamina < MAX_STAMINA)
            for (local i = 0; i < this.stamina / 2.5; i++)
                text += "_";

        if (!this._staminaText)
            this._staminaText = ppmod.text("STAMINA", -1, 0);

        this._staminaText.SetText(text);
        this._staminaText.SetColor("64 255 255")
        this._staminaText.Display();

        // update the regen timeout
        if (this._regenTimeout-- > 0)
            return;

        // check if regeneration is disabled
        if (!this.canRegen)
            return;

        // regen stamina
        this.stamina = min(MAX_STAMINA, this.stamina + REGEN_STAMINA);
    }

    /**
     * Consume stamina
     */
    function consume(cost) {
        this.stamina -= cost;

        // set the regen timeout if necessary
        if (this.stamina <= 0) {
            this.stamina = 0;
            this._regenTimeout = FULL_REGENERATION_TIMEOUT;
        }
    }

}
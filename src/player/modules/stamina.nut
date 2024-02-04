// stamina values
const MAX_STAMINA = 100;
const DASH_COST = 30;
const SENSORY_BOOST_COST = 0.66666; // 40.0 / 60.0
// regen values
const REGEN_STAMINA = 0.416666; // 25 / 60.0;
const FULL_REGENERATION_TIMEOUT = 60.0; // 1 * 60.0

::renderStamina <- true; // whether the stamina bar should be rendered
// FIXME: this is a hack to make hints, etc. render properly

/**
 * Stamina management class
 */
class Stamina {
    
    /** Amount of stamina the player currently has */
    stamina = MAX_STAMINA;
    /** Whether the player can regenerate stamina */
    canRegen = true;
    /** Internal timeout in ticks until stamina regeneration applies again */
    _regenTimeout = 0;
    /** Internal text object for the stamina bar */
    _staminaText = null;

    /**
     * Tick the stamina management class
     */
    function tick() {
        // update the stamina text
        if (::renderStamina) {
            local text = " ";
            if (this.stamina < MAX_STAMINA)
                for (local i = 0; i < this.stamina / 2.5; i++)
                    text += "_";

            if (!this._staminaText)
                this._staminaText = ppmod.text("STAMINA", -1, 0.99);

            this._staminaText.SetText(text);
            this._staminaText.SetColor("64 255 255")
            this._staminaText.Display();
        }

        // regenerate stamina
        if (this._regenTimeout-- > 0)
            return;

        if (!this.canRegen)
            return;

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
/**
 * Stamina management class
 */
class Stamina {
    
    /** Amount of stamina the player currently has */
    stamina = STAMINA_MAX;
    /** Whether the player can regenerate stamina */
    canRegen = true;
    /** Internal timeout in ticks until stamina regeneration applies again */
    _regenTimeout = 0;
    /** Internal text object for the stamina bar */
    _staminaText = null;
    /** Internal variable for storing the previous text */
    _prevText = "";
    /** Internal variable for the stamina bar visibility */
    _visibility = true;

    /**
     * Tick the stamina management class
     */
    function tick() {
        // update the stamina text
        if (this._visibility) {
            local text = " ";
            if (this.stamina < STAMINA_MAX)
                for (local i = 0; i < this.stamina / 2.5; i++)
                    text += "_";

            if (text != this._prevText) {
                if (!this._staminaText) {
                    this._staminaText = ppmod.text("STAMINA", -1, 0.99);
                    this._staminaText.ent.targetname = "p2ghostrunner-stamina";
                }

                this._staminaText.SetText(text);
                this._staminaText.SetFade(0, 0, false);
                this._staminaText.SetColor("64 255 255")
                this._staminaText.Display(FrameTime() * 6);
                this._prevText = text;
            }

        }

        // regenerate stamina
        if (this._regenTimeout-- > 0)
            return;

        if (!this.canRegen)
            return;

        this.stamina = min(STAMINA_MAX, this.stamina + STAMINA_REGEN);
    }

    /**
     * Consume stamina
     */
    function consume(cost) {
        this.stamina -= cost;

        // set the regen timeout if necessary
        if (this.stamina <= 0) {
            this.stamina = 0;
            this._regenTimeout = STAMINA_FULL_REGEN_TIMEOUT;
        }
    }

    /**
     * Toggle stamina text
     */
    function toggleVisibility(visibility) {
        this._visibility = visibility;
        if (!visibility && this._staminaText) {
            if (this._staminaText.ent.IsValid()) this._staminaText.ent.Destroy();
            this._staminaText = null;
        }
    }

}
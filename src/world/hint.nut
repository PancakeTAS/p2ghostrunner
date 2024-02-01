/**
 * Hint instance
 */
class Hint {

    ent = null;

    /**
     * Initialize a hint
     */
    constructor(text) {
        this.ent = Entities.CreateByClassname("env_instructor_hint");
        ppmod.keyval(this.ent, "hint_static", 1);
        ppmod.keyval(this.ent, "hint_caption", text);
        ppmod.keyval(this.ent, "hint_color", "255 255 255");
    }

    /**
     * Set the target of the hint
     */
    function setTarget(target) {
        ppmod.keyval(this.ent, "hint_target", target);
        ppmod.keyval(this.ent, "hint_static", 0);
        ppmod.keyval(this.ent, "hint_nooffscreen", 1);
    }

    /**
     * Set the binding of the hint
     */
    function setBinding(binding) {
        ppmod.keyval(this.ent, "hint_binding", binding);
        ppmod.keyval(this.ent, "hint_icon_onscreen", "use_binding");    
    }

    /**
     * Create a trigger for the hint
     */
    function createTrigger(position, size) {
        local e = this.ent;

        local trigger = ppmod.trigger(position, size);
        ppmod.addscript(trigger, "OnStartTouch", function ():(e) {
            // disable stamina
            ::renderStamina = false;
            ::contr.stamina._staminaText.ent.Destroy();
            ::contr.stamina._staminaText = null;

            // enable instructor
            SendToConsole("gameinstructor_enable 1");

            // show hint later
            ppmod.wait(function():(e) {
                ppmod.fire(e, "ShowHint");

                // hide hint later
                ppmod.wait(function():(e) {
                    ppmod.fire(e, "HideHint");

                    // disable instructor and enable stamina later
                    ppmod.wait(function() {
                        SendToConsole("gameinstructor_enable 0");
                        ::renderStamina = true;
                    }, 0.5);

                }, 3);

            }, 0.1);

        });
    }

}
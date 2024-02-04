/**
 * Hint instance
 */
class Hint {

    ent = null;
    visible = false;

    /**
     * Initialize a hint
     */
    constructor(text) {
        this.ent = Entities.CreateByClassname("env_instructor_hint");
        this.ent.hint_static = 1;
        this.ent.hint_caption = text;
        this.ent.hint_color = "255 255 255";

        SendToConsole("gameinstructor_enable 1");
    }

    /**
     * Set the target of the hint
     */
    function setTarget(target) {
        this.ent.hint_target = target;
        this.ent.hint_static = 0;
        this.ent.hint_nooffscreen = 1;
    }

    /**
     * Set the binding of the hint
     */
    function setBinding(binding) {
        this.ent.hint_binding = binding;
        this.ent.hint_icon_onscreen = "use_binding";
    }

    /**
     * Create a trigger for the hint
     */
    function createTrigger(position, size) {
        local inst = this;

        local trigger = ppmod.trigger(position, size);
        ppmod.addscript(trigger, "OnStartTouch", function ():(inst) {
            inst.show();
        });
    }

    /**
     * Create a look trigger for the hint
     */
    function createLookTrigger(position, size, target) {
        local inst = this;

        local trigger = ppmod.trigger(position, size, "trigger_look");
        trigger.target = target;
        trigger.lookTime = 0.5;
        trigger.fieldOfView = 20;
        ppmod.addscript(trigger, "OnStartTouch", function ():(inst) {
            inst.show();
        });
    }

    /**
     * Trigger the hint
     */
    function show() {
        local e = this.ent;
        if (!e.IsValid() || this.visible)
            return;
        
        this.visible = true;
        SendToConsole("gameinstructor_enable 1");

        // don't show stamina bar
        ::renderStamina = false;
        local stamina = ::contr.stamina._staminaText;
        if (stamina) {
            if (stamina.ent)
                stamina.ent.Destroy();
            ::contr.stamina._staminaText = null;
        }

        // show hint now
        ppmod.wait(function():(e) {
            e.ShowHint();
        }, 0.1);

        // hide hint later
        ppmod.wait(function():(e) {
            e.HideHint();
            SendToConsole("gameinstructor_enable 0");
            ::renderStamina = true;
            e.Destroy();
        }, 3);

    }

}
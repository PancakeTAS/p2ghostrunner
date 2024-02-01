/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // remove existing hints
        SendToConsole("ent_remove_all env_instructor_hint");

        // create dash hint
        ppmod.wait(function() {
            local pgunHint = Entities.CreateByClassname("env_instructor_hint");
            ppmod.keyval(pgunHint, "targetname", "pgunHint");
            ppmod.keyval(pgunHint, "hint_target", "pgunTarget");
            ppmod.keyval(pgunHint, "hint_static", 1);
            ppmod.keyval(pgunHint, "hint_caption", "Press shift to dash");
            ppmod.keyval(pgunHint, "hint_binding", "alt1");
            ppmod.keyval(pgunHint, "hint_color", "255 255 255");
            ppmod.keyval(pgunHint, "hint_icon_onscreen", "use_binding");

            // trigger dash hint
            local pgunTrigger = ppmod.trigger(Vector(92, 1942, -251), Vector(128, 128, 128));
            ppmod.addscript(pgunTrigger, "OnStartTouch", function ():(pgunHint) {
                // remove pptext
                ::renderStamina = false;
                ::contr.stamina._staminaText.ent.Destroy();
                ::contr.stamina._staminaText = null;

                ppmod.fire(pgunHint, "ShowHint");

                ppmod.wait(function ():(pgunHint) {
                    ppmod.fire(pgunHint, "EndHint");
                    ::renderStamina = true;
                }, 5);
            });
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
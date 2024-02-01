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
                // prepare show hint
                ::renderStamina = false;
                ::contr.stamina._staminaText.ent.Destroy();
                ::contr.stamina._staminaText = null;
                SendToConsole("gameinstructor_enable 1");

                // show hint
                ppmod.wait(function():(pgunHint) {
                    ppmod.fire(pgunHint, "ShowHint");

                    ppmod.wait(function ():(pgunHint) {
                        // prepare hide hint
                        ppmod.fire(pgunHint, "EndHint");

                        // hide hint
                        ppmod.wait(function() {
                            SendToConsole("gameinstructor_enable 0");
                            ::renderStamina = true;
                        }, 0.5);
                    }, 5);
                }, 0.2);
                
            });
        }, 1);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
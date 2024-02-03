/**
 * Map specific controller
 */
class MapController {

    skipText = null;

    /**
     * Initialize specific map
     */
    constructor() {
        ::fakecam_enable = false;

        ppmod.get(256).Destroy();

        // add skip to trigger
        ppmod.addscript(ppmod.get("do_not_touch_anything_trigger"), "OnStartTouch", function () {
            // don't show stamina bar
            ::renderStamina = false;
            local stamina = ::contr.stamina._staminaText;
            if (stamina) {
                if (stamina.ent)
                    stamina.ent.Destroy();
                ::contr.stamina._staminaText = null;
            }

            // display skip text
            SendToConsole("bind e \"script ::wcontr.controller.skip();\"");
            local text = ppmod.text("Press E to skip the cutscene", -1, 0.7);
            text.SetFade(1, 1, false);
            text.SetColor("255 255 255");
            text.Display(30);

            ::wcontr.controller.skipText = text;
            ppmod.wait(function():(text) {
                text.SetFade(0, 1, false);
                text.Display(1);
                SendToConsole("bind e +alt2");
            }, 5);
        });
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        // remove skip text
        this.skipText.SetFade(0, 0, false);
        this.skipText.Display(0.1);

        // skip the cutscene
        ::player.SetOrigin(Vector(6156, 3465, 904));
        SendToConsole("bind e +alt2");

        ::renderStamina = true;
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
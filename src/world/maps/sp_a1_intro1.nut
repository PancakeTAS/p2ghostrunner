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

        // apple
        ::on_jump = function () {
            ppmod.fire("thats_the_spirit_relay", "Trigger");
            local ent;
            if (ent = ppmod.get("sphere_player_has_pressed_space_first"))
                ppmod.fire(ent, "Trigger");
            
            if (ent = ppmod.get("sphere_player_has_pressed_space_second"))
                ppmod.fire(ent, "Trigger");
        }

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
        text.SetFade(8, 1, false);
        text.SetColor("255 255 255");
        text.Display(30);

        this.skipText = text;
        ppmod.addscript("bend_at_the_knees_vcd", "OnStart", function ():(text) {
            text.SetFade(0, 1, false);
            text.Display(1);
            SendToConsole("bind e +alt2");
        });
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        // stop intro cutscene
        ppmod.fire(ppmod.get("camera_intro"), "teleporttoview");
        ppmod.fire(ppmod.get("camera_intro"), "disable");
        ppmod.get("relay_intro_camera").Destroy();
        ppmod.get("good_morning_vcd").Destroy();
        ppmod.get("bend_at_the_knees_vcd").Destroy();
        ppmod.get("look_at_ceiling_target").Destroy();
        ppmod.get("stare_at_ceiling_aisc").Destroy();
        ppmod.get("hint_press_to_crouch").Destroy();
        SendToConsole("bind e +alt2");
        SendToConsole("fadeout 0");
        SendToConsole("stopsound");
        SendToConsole("stopsoundscape");

        // remove skip text
        this.skipText.SetFade(0, 0, false);
        this.skipText.Display(0.1);

        ppmod.wait(function () {
            // prevent vault cutscene
            ppmod.get("enter_chamber_trigger").Destroy();

            // prepare player
            SendToConsole("fadein 5");
            ::player.SetOrigin(Vector(-1213, 4405, 2705));
            ::player.SetAngles(0, 0, 0);

            // fix valve moments
            ppmod.get("camera_1").Destroy();
            ppmod.get("camera_proxy").Destroy();
            ppmod.get("camera_intro").Destroy();

            // manually start the game
            ppmod.wait(function () {
                local relay = ppmod.get("open_portal_relay");
                ppmod.fire(relay, "trigger");
                relay.Destroy();
                ::renderStamina = true;
            }, 5);


        }, 0.1);

    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // setup cutscene skip
        Skip(12, skip, skip_late);
    }

    /**
     * Late initialization once the player is loaded
     */
    function player_init() {
        ::fakecam_enable = false;
        ::contr.inputs.jumpStart = function () {
            ppmod.fire("thats_the_spirit_relay", "Trigger");
            local ent;
            if (ent = ppmod.get("sphere_player_has_pressed_space_first"))
                ent.Trigger();
            
            if (ent = ppmod.get("sphere_player_has_pressed_space_second"))
                ent.Trigger();
        }
    }


    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        // stop intro cutscene
        ppmod.fire("camera_intro", "teleporttoview");
        ppmod.fire("camera_intro", "disable");
        ppmod.get("relay_intro_camera").Destroy();
        ppmod.get("good_morning_vcd").Destroy();
        ppmod.get("bend_at_the_knees_vcd").Destroy();
        ppmod.get("look_at_ceiling_target").Destroy();
        ppmod.get("stare_at_ceiling_aisc").Destroy();
        ppmod.get("hint_press_to_crouch").Destroy();
        SendToConsole("fadeout 0");
        SendToConsole("stopsound");
        SendToConsole("stopsoundscape");
    }


    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip_late() {
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
        local relay = ppmod.get("open_portal_relay");
        ppmod.fire(relay, "trigger", "", 5.0);
        ppmod.fire(relay, "kill", "", 6.0);
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
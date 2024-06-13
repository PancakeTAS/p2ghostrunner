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

        // fix intro cutscene breaking with custom camera
        ::contr.camera.enabled = false;

        // apple
        ::contr.inputs.jumpStart = function () {
            ppmod.fire("thats_the_spirit_relay", "Trigger");
            ppmod.fire("sphere_player_has_pressed_space_first", "Trigger");
            ppmod.fire("sphere_player_has_pressed_space_second", "Trigger");
        }
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        // stop intro cutscene
        ppmod.fire("camera_intro", "teleporttoview");
        ppmod.fire("camera_intro", "disable");
        ppmod.fire("relay_intro_camera", "Kill");
        ppmod.fire("good_morning_vcd", "Kill");
        ppmod.fire("bend_at_the_knees_vcd", "Kill");
        ppmod.fire("look_at_ceiling_target", "Kill");
        ppmod.fire("stare_at_ceiling_aisc", "Kill");
        ppmod.fire("hint_press_to_crouch", "Kill");
        SendToConsole("fadeout 0");
        SendToConsole("stopsound");
        SendToConsole("stopsoundscape");
    }


    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip_late() {
        // prevent vault cutscene
        ppmod.fire("enter_chamber_trigger", "Kill");

        // prepare player
        SendToConsole("fadein 5");
        ::player.SetOrigin(Vector(-1213, 4405, 2705));
        ::player.SetAngles(0, 0, 0);

        // fix valve moments
        ppmod.fire("camera_1", "Kill");
        ppmod.fire("camera_proxy", "Kill");
        ppmod.fire("camera_intro", "Kill");

        // manually start the game
        local relay = ppmod.get("open_portal_relay");
        ppmod.fire(relay, "trigger", "", 5.0);
        ppmod.fire(relay, "kill", "", 6.0);
    }

    /**
     * Reload specific map
     */
    function reload() {

    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
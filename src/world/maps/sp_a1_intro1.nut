/**
 * Map specific controller
 */
class MapController {

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
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
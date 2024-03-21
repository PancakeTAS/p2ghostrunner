/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        ppmod.addscript("laser_emitter_door", "OnOpen", function () {
            local hint = Hint("Aim at laser catcher and shoot shuriken");
            hint.setBinding("q");
            hint.show();
        });
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
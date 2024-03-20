/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // TODO: fix with shurikens
        ppmod.create("ent_create_portal_reflector_cube").then(function (e) {
            e.SetOrigin(Vector(-428, -422, 18.5));
        });
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
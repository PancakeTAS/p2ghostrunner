/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        ppmod.create("ent_create_portal_reflector_cube").then(function (e) {
            e.SetOrigin(Vector(-428, -422, 18.5));
        });
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
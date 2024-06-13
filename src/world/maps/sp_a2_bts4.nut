/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {

        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 0, 0);
            e.SetOrigin(Vector(2962, -4928, 6719));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -90, 0);
            e.SetOrigin(Vector(2188, -5241, 6720));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
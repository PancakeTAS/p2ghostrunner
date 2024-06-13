/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // remove entrance door
        ppmod.get("entry_airlock_door-door_1").Destroy();

        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -90, 0);
            e.SetOrigin(Vector(9300, 5391, -191));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 90, 0);
            e.SetOrigin(Vector(9260, 5670, -127));
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
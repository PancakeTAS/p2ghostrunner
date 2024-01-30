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
            e.SetAngles(0, -90, 0);
            e.SetOrigin(Vector(0, -765, 128));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.fire(e, "Open");
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 90, 0);
            e.SetOrigin(Vector(-384, -320, 128));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.fire(e, "Open");
        });

        // remove vphys clipbrush
        ppmod.get(51).Destroy();
    }

    /**
     * Tick specific map
     */
    function tick() {
        
    }

}
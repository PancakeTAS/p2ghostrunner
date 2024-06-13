/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        reload();

        // remove vphys clipbrush
        /*
        NOTE: reimplement in another mode
        ppmod.get(Vector(688, -396, 210), 1, "func_clip_vphysics").Destroy();
        */
    }

    /**
     * Reload specific map
     */
    function reload() {
        // remove previous portals
        local ent = ppmod.get(Vector(0, -765, 128), 1, "linked_portal_door");
        if (ent) ent.Destroy();
        ent = ppmod.get(Vector(-384, -320, 128), 1, "linked_portal_door");
        if (ent) ent.Destroy();

        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -90, 0);
            e.SetOrigin(Vector(0, -765, 128));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 90, 0);
            e.SetOrigin(Vector(-384, -320, 128));
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
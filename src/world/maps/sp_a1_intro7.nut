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
            e.SetOrigin(Vector(393, 0, 1408));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.fire(e, "Open");
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -180, -4);
            e.SetOrigin(Vector(-318, -702, 1297));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.fire(e, "Open");
        });

        // trigger on exit portal
        local ent = ppmod.trigger(Vector(-418, -702, 1297), Vector(10, 100, 100));
        ppmod.addscript(ent, "OnStartTouch", function () {
            ppmod.fire(ppmod.get("door_0-testchamber_door"), "Close");
        });
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // remove func_button to trigger door
        ppmod.get("rv_trap_fake_door").RenderMode = 10;

        reload();
    }

    /**
     * Reload specific map
     */
    function reload() {
        // remove previous portals
        local ent = ppmod.get(Vector(-326, 2444, -59), 1, "linked_portal_door");
        if (ent) ent.Destroy();
        ent = ppmod.get(Vector(-1638, 3, 340), 1, "linked_portal_door");
        if (ent) ent.Destroy();

        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 0, 0);
            e.SetOrigin(Vector(-326, 2444, -59));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 180, 0);
            e.SetOrigin(Vector(-1638, 3, 340));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();

            e.AddScript("OnPlayerTeleportToMe", function ():(e) {
                e.Close();
                ppmod.fire("func_button");
            }, 0.1);
        });
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
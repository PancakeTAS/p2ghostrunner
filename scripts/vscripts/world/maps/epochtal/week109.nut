/**
 * Tournament map controller
 */
class MapController {

    grapple1 = Grapple(Vector(577, 320, 718), 650);
    grapple2 = Grapple(Vector(200, 860, 885), 700);
    grapple3 = Grapple(Vector(195, 1729, 847), 600);
    grapple4 = Grapple(Vector(1121, 1315, 1423), 2000);
    grapple5 = Grapple(Vector(1342, 678, 1359), 1000);

    /**
     * Initialize tournament map
     */
    constructor() {
        // remove dropper enable trigger
        SendToConsole("ent_remove 190");

        // remove one of the stacked fizzlers and the exit fizzler
        SendToConsole("ent_remove 143");
        SendToConsole("ent_remove 580");

        // replace all fizzlers with lasers
        for (local ent; ent = Entities.FindByClassname(ent, "trigger_portal_cleanser");)
            ppmod.addscript(ent, "OnStartTouch", function (activator, caller) {
                if (activator == ::player)
                    SendToConsole("kill");
            }, 0, -1, true);

        // entry portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -180, 0);
            e.SetOrigin(Vector(3200 - 2, 1345, 192));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.keyval(e, "width", 4);
            ppmod.keyval(e, "height", 4);
            ppmod.fire(e, "Open");
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -90, 0);
            e.SetOrigin(Vector(1345, 2048 - 2, 192));
            ppmod.keyval(e, "targetname", "portal");
            ppmod.fire(e, "SetPartner", "portal");
            ppmod.keyval(e, "width", 4);
            ppmod.keyval(e, "height", 4);
            ppmod.fire(e, "Open");
        });

        // wall next to grapple
        ppmod.create("a4_destruction/wallpanel_256_cdest.mdl").then(function (e) {
            ::cole <- e; // there's no proper way to wallrun on entities yet
            e.SetOrigin(Vector(440, 1900, 540));
            e.SetAngles(0, -180, 0);
        });
        ppmod.create("a4_destruction/wallpanel_256_cdest.mdl").then(function (e) {
            // apparently the collision decided not to rotate
            e.SetOrigin(Vector(440 - 256, 1900, 540));
            e.SetAngles(0, -180, 0);
            ppmod.keyval(e, "RenderMode", 10);
        });

        // move cube button
        local exitButton = ppmod.get("bt976-btn");
        exitButton.SetOrigin(Vector(1471.5, 391, 961));
    }

    /**
     * Tick tournament map
     */
    function tick() {
        this.grapple1.tick();
        this.grapple2.tick();
        this.grapple3.tick();
        this.grapple4.tick();
        this.grapple5.tick();
    }

}

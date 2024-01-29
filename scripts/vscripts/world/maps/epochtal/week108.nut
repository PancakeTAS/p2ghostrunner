/**
 * Tournament map controller
 */
class MapController {

    grapple1 = Grapple(Vector(1273, 1332, 3215), 650);
    grapple2 = Grapple(Vector(2110, 2886, 3215), 800);

    /**
     * Initialize tournament map
     */
    constructor() {
        // block off right path
        ppmod.create("props_ingame/arm_8panel.mdl").then(function (e) {
            e.SetAngles(90, 0, 90);
            e.SetOrigin(Vector(2879, 1405, 2752));
        });
        ppmod.create("props_ingame/arm_8panel.mdl").then(function (e) {
            e.SetAngles(90, 0, 90);
            e.SetOrigin(Vector(3006, 1405, 2752));
        });
        ppmod.create("props_ingame/arm_8panel.mdl").then(function (e) {
            e.SetAngles(90, 0, 90);
            e.SetOrigin(Vector(3133, 1405, 2752));
        });
        ppmod.create("props_ingame/arm_8panel.mdl").then(function (e) {
            e.SetAngles(90, 0, 90);
            e.SetOrigin(Vector(2879, 1405, 3007));
        });
        ppmod.create("props_ingame/arm_8panel.mdl").then(function (e) {
            e.SetAngles(90, 0, 90);
            e.SetOrigin(Vector(3006, 1405, 3007));
        });
        ppmod.create("props_ingame/arm_8panel.mdl").then(function (e) {
            e.SetAngles(90, 0, 90);
            e.SetOrigin(Vector(3133, 1405, 3007));
        });

        // create new button
        ppmod.create("prop_button").then(function (e) {
            e.SetOrigin(Vector(2496, 1984, 2720));
            e.SetAngles(0, 180, 0);
        });
    }

    /**
     * Tick tournament map
     */
    function tick() {
        this.grapple1.tick();
        this.grapple2.tick();
    }

}

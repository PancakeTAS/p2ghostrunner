/**
 * Tournament map controller
 */
class MapController {

    /**
     * Initialize tournament map
     */
    constructor() {
        // remove dropper enable trigger
        SendToConsole("ent_remove 190");

        // replace all fizzlers with lasers
        for (local ent; ent = Entities.FindByClassname(ent, "trigger_portal_cleanser");) {
            ppmod.brush(ent.GetOrigin(), Vector(abs(ent.GetBoundingMaxs().x), abs(ent.GetBoundingMaxs().y), abs(ent.GetBoundingMaxs().z)), "func_brush", ent.GetAngles(), false).then(function (e) {
                ppmod.keyval(e, "RenderFX", 14);

                ppmod.project("effects/laserplane", e.GetOrigin() + Vector(6, 0, 0), Vector(0, -180, 0));
            });
        }
    }

    /**
     * Tick tournament map
     */
    function tick() {

    }

}

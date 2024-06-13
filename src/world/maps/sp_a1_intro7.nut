/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        // entry portal
        /*
        NOTE: reimplement in another mode
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, 0, 0);
            e.SetOrigin(Vector(393, 0, 1408));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });

        // exit portal
        ppmod.create("linked_portal_door").then(function (e) {
            e.SetAngles(0, -180, -4);
            e.SetOrigin(Vector(-318, -702, 1297));
            e.targetname = "portal";
            e.SetPartner("portal");
            e.Open();
        });*/

        // fix wheatley by disabling custom camera
        ::contr.camera.enabled = false;

        // trigger on exit portal
        /*
        NOTE: reimplement in another mode
        local ent = ppmod.trigger(Vector(-418, -702, 1297), Vector(10, 100, 100));
        */
        local ent = ppmod.trigger(Vector(-800, -702, 1297), Vector(400, 200, 20));
        local inst = this;
        ent.AddScript("OnStartTouch", function ():(inst) {
            ppmod.fire("door_0-testchamber_door", "Close");

            Skip(5, inst.skip, inst.skip_late);
        });
    }

    /**
     * Skip the cutscene
     */
    function skip() {
        ppmod.fire("bts_panel_door-lr_heavydoor_open", "trigger");
        ppmod.fire("airlock_door-open_door", "trigger");
        ppmod.fire("@sphere", "Kill");
        SendToConsole("snd_setmixer wheatleyVO mute 1");
    }

    /**
     * Skip the cutscene
     */
    function skip_late() {
        SendToConsole("snd_setmixer wheatleyVO mute 0");
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
/**
 * Map specific controller
 */
class MapController {

    /**
     * Initialize specific map
     */
    constructor() {
        ::fakecam_enable = false;
        
        // entry portal
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
        });

        // trigger on exit portal
        local ent = ppmod.trigger(Vector(-418, -702, 1297), Vector(10, 100, 100));
        local skip = this.skip;
        local skip_late = this.skip_late;
        ppmod.addscript(ent, "OnStartTouch", function ():(skip, skip_late) {
            ppmod.fire("door_0-testchamber_door", "Close");

            Skip(5, skip, skip_late);
        });
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip() {
        ppmod.fire("bts_panel_door-lr_heavydoor_open", "trigger");
        ppmod.fire("airlock_door-open_door", "trigger");
        ppmod.get("@sphere").Destroy();
        SendToConsole("snd_setmixer wheatleyVO mute 1");
    }

    /**
     * Skip the intro cutscene (only works after ghost animation and before looking at the ceiling)
     */
    function skip_late() {
        SendToConsole("snd_setmixer wheatleyVO mute 0");
    }

    /**
     * Tick specific map
     */
    function tick() {

    }

}
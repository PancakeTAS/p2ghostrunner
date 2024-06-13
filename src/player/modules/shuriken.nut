/**
 * Shuriken class
 */
class Shuriken {

    /** Internal cooldown in ticks for shuriken */
    _cooldown = 0;
    /** Internal state for keeping track of currently activated shuriken */
    _active = null;

    /**
     * Shuriken constructor
     */
    constructor() {
        // mute portalgun
        SendToConsole("snd_setmixer Portalgun MUTE 1");
    }

    /**
     * Tick the shuriken controller
     */
    function tick() {
        // update shuriken cooldown
        if (this._cooldown > 0)
            this._cooldown -= ::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1.0;
    }

    /**
     * Use the shuriken
     */
    function shuriken() {
        // check if shuriken is force-disabled
        if (GetMapName().find("_a1_"))
            return;

        // return engine use if cooldown is active
        if (this._cooldown > 0)
            return;

        // disable previous shuriken
        if (this._active && this._active.IsValid()) {
            this._active.Destroy();
            this._active = null;
        }

        // throw shuriken
        ::player.EmitSound("Ghostrunner.ShurikenThrow");
        this._cooldown = SHURIKEN_COOLDOWN;

        // shoot portal
        local result = ppmod.ray(::eyes.GetOrigin(), ::eyes.GetOrigin() + ::eyes.GetForwardVector() * SHURIKEN_RANGE, "prop_laser_catcher", false);
        ppmod.create("ent_create weapon_portalgun").then(function (e):(result) {
            e.SetOrigin(::eyes.GetOrigin() + ::eyes.GetForwardVector() * 16.0);
            e.SetForwardVector(::eyes.GetForwardVector());
            e.SetMoveParent(::player);
            e.RenderMode = 10;
            e.SpawnFlags = 2;
            e.CanFirePortal1 = false;
            e.CanFirePortal2 = false;

            if (result.fraction < 1.0)
                e.FirePortal2();
            else
                e.FirePortal1();

            // weird source jank
            ppmod.wait(function():(e) {
                SendToConsole("ent_remove_all weapon_portalgun");
            }, 0.2);
        });

        // remove all portals
        local inst = this;
        ppmod.wait(function():() {
            SendToConsole("ent_remove_all prop_portal");
        }, FrameTime());

        // continue shuriken later
        ppmod.wait(function ():(inst, result) {
            if (result.fraction >= 1.0) {
                ::player.EmitSound("Ghostrunner.ShurikenMiss");
                return;
            }

            ::player.EmitSound("Ghostrunner.ShurikenHit");
            ppmod.create("ent_create env_portal_laser").then(function (e):(result, inst) {
                local d = result.entity;
                e.LaserModel = "";
                e.SetOrigin(d.GetOrigin() + Vector(0, 0, 12) + d.GetForwardVector() * 64.0);
                e.SetForwardVector(d.GetForwardVector() * -1.0);
                e.RenderMode = 10;

                inst._active = e;

                // remove catcher after a while
                ppmod.wait(function():(e) {
                    if (e.IsValid()) e.Destroy();
                }, SHURIKEN_DURATION);
            });

        }, 0.2);

    }

}
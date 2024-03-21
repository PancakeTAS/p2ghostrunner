ppmod.create("prop_dynamic_create ghostrunner/npc_pistol.mdl").then(function (e) {
    e.Destroy();
});

const RANGE = 300;
const SHOOT_DELAY = 45;

/**
 * Pistol enemy
 */
class PistolNPC {

    /** Entity instance */
    ent = null;
    /** Shoot timer */
    shootTimer = 0;

    /**
     * Create a new pistol enemy
     */
    constructor (origin) {
        local inst = this;
        ppmod.create("prop_dynamic_create ghostrunner/npc_pistol.mdl").then(function (e):(inst, origin) {
            inst.ent = e;

            e.SetOrigin(origin);
            e.SetAngles(90, 0, 0);
            e.SetDefaultAnimation("idle");
            e.SetAnimation("idle");
        });
    }

    /**
     * Tick the pistol enemy
     */
    function tick() {
        if (!this.ent)
            return;

        // check if the player is in range
        local distance = (::contr.physics.origin - this.ent.GetOrigin()).Length();
        if (distance < RANGE) {
            // face the player
            local dir = (::contr.physics.origin - this.ent.GetOrigin()).Normalize();
            this.ent.angles = Vector(90, 0, atan2(dir.x, dir.y) * 60 - 90).ToKVString();

            // update shoot timer
            if (this.shootTimer-- <= 0) {
                this.shootTimer = SHOOT_DELAY;

                // shoot the player
                this.ent.SetAnimation("attack");
            }
        }
    }

    /**
     * Kill the pistol enemy
     */
    function kill() {
        if (!this.ent)
            return;

        // kill entity
        local e = this.ent;
        e.SetAnimation("death" + RandomInt(1, 3));
        e.HoldAnimation = true;
        this.ent = null;
    }

}
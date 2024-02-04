const WALLRUN_SPEED = 350;

/**
 * Wallrun class
 */
class Wallrun {

    /** The wall the player is currently wallrunning on */
    wall = null;
    /** idek, FIXME, perhaps velocity? */
    wallVec = Vector(0, 0, 0);
    /** Internal cooldown in ticks for wallrunning on the same wall */
    _cooldown = 0;
    /** Internal cooldown direction for wallrunning on the same wall */
    _cooldownDirection = Vector(0, 0, 0);
    /** Internal cooldown point for wallrunning on the same wall */
    _cooldownPoint = null;
    /** Internal previous position of the player */
    _prevPos = null; // FIXME: replace with physics.nut maybe?

    /**
     * Tick the wallrun controller
     */
    function tick() {
        // update wallrun cooldown
        if (this._cooldown > 0)
            this._cooldown -= ::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1.0;

        // stop wallrun if obstructed
        if (this.wall && (this._prevPos - ::contr.physics.origin).Length() < 1.0) {
            this._cooldownDirection = this.wall;
            this._cooldownPoint = ::contr.physics.origin;
            this._cooldown = 60;
            this.wall = null;
            ::set_roll(0.0);
            this.wallVec = Vector(0, 0, 0);
            return;
        }
        this._prevPos = ::contr.physics.origin;

        // start wallrun if possible
        if (::contr.inputs.movement.x > 0 && !::contr.physics.grounded && !::contr.movement.sensoryBoost) {
            local ray = ::wall();
            if (ray) {
                local wallVec = ray.up * 350;

                // wallrun if cooldown is over
                if ((this._cooldown <= 0 || !((this._cooldownDirection - wallVec).Length() < 1.0 || (this._cooldownDirection + wallVec).Length() < 1.0) || (this._cooldownPoint - ray.point).Length() >= 400.0) && !ray.ground) {
                    ::set_roll(-10.0 * ray.side);
                    this.wall = wallVec;
                    this.wallVec = wallVec + ::contr.physics.left2d * ((ray.side == 1) ? 100 : -100);
                    return;
                }
            }

        }

        // cancel wallrun if not possible
        if (this.wall)
            ::set_roll(0.0);
        this.wall = null;
        this.wallVec = Vector(0, 0, 0);
    }

}
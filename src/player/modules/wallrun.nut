/**
 * Wallrun class
 */
class Wallrun {

    /** The wall the player is currently wallrunning on */
    wall = null;
    /** Internal cooldown in ticks for wallrunning on the same wall */
    _cooldown = 0;
    /** Internal cooldown direction for wallrunning on the same wall */
    _cooldownDirection = null;
    /** Internal cooldown point for wallrunning on the same wall */
    _cooldownPoint = null;

    /**
     * Tick the wallrun controller
     */
    function tick() {
        // update wallrun cooldown
        if (this._cooldown > 0)
            this._cooldown -= ::contr.movement.sensoryBoost ? SENSORY_BOOST_FACTOR : 1.0;
        
        // wallrun if possible
        for (;;) {

            // stop wallrun if path is obstructed
            if (this.wall && (::contr.physics.prevOrigin - ::contr.physics.origin).Length() < 1.0) {
                this._cooldownDirection = this.wall;
                this._cooldownPoint = ::contr.physics.origin;
                this._cooldown = WALLRUN_COOLDOWN;
                break;
            }

        
            // don't wallrun if player not moving normally in air
            if (::contr.inputs.movement.x <= 0 || ::contr.physics.grounded || ::contr.movement.sensoryBoost)
                break;

            // find nearby wall
            local ray = ::wall();
            if (!ray)
                break;
            
            // ignore if player is on ground
            if (ray.ground)
                break;

            local wallVelocity = ray.up * 350;
            
            // don't wallrun if current wall is on cooldown
            if (this._cooldown > 0) {
                if ((this._cooldownDirection - wallVelocity).Length() < 1.0 || (this._cooldownDirection + wallVelocity).Length() < 1.0)
                    break;
                
                if ((this._cooldownPoint - ray.point).Length() >= 400.0)
                    break;
            }

            // wallrun
            if (!this.wall || (this.wall - wallVelocity).Length() > 0.1) // update camera only if wall changes
                ::set_roll(-10.0 * ray.side);
            this.wall = wallVelocity;
            ::contr.movement.finalVelocity = wallVelocity + ::contr.physics.left2d * ((ray.side == 1) ? 100 : -100);
            ::contr.movement.overrideGravity(0);
            return;

        }

        // cancel wallrun if not possible
        if (this.wall)
            ::set_roll(0.0);
        this.wall = null;
    }

    /**
     * Walljump off the wall
     */
    function walljump() {
        // don't jump if not wallrunning
        if (!this.wall || !::contr.inputs.jumped)
            return false;
        
        // update velocities and wallrun
        ::contr.movement.overrideAirStrafeVelocity(::contr.physics.forward2d * 125);
        this._cooldownDirection = this.wall;
        this._cooldownPoint = ::contr.physics.origin;
        this._cooldown = WALLRUN_COOLDOWN;
        ::set_roll(0.0);
        this.wall = null;
        
        return true;
    }

}
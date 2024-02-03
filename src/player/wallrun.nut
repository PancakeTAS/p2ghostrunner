const WALLRUN_SPEED = 350;

/**
 * Wallrun controller class
 */
class WallrunController {

    wall = null; // wall the player is running on
    timeout = 0; // amount of ticks a player cannot wallrun on the same wall
    timeoutDirection = Vector(0, 0, 0); // direction the player cannot wallrun on within the area
    timeoutPoint = null; // last point touched by the player
    prevPos = null; // previous position of the player

    /**
     * Tick the wallrun controller
     */
    function tick(movement, grav, onGround) {
        // decrease timeout
        if (this.timeout > 0)
            this.timeout -= 1 * (::contr.dash.isSlowdown ? SLOWDOWN_FACTOR : 1.0);

        // check if wallrun failed
        local origin = ::player.GetOrigin();
        if (this.wall && (this.prevPos - origin).Length() < 1.0) {
            this.timeoutDirection = this.wall;
            this.timeoutPoint = origin;
            this.timeout = 60;
            this.wall = null;
            ::set_roll(0.0);
            return null;
        }
        this.prevPos = origin;

        // check wallrunning
        if (movement.x > 0 && !onGround && !::contr.dash.isSlowdown) {
            local ray = ::wall();
            if (ray) {
                local wallVec = ray.up * 350;

                // check if either the timeout is over or the player is not wallrunning on the same wall
                if ((this.timeout == 0 || !((this.timeoutDirection - wallVec).Length() < 1.0 || (this.timeoutDirection + wallVec).Length() < 1.0) || (this.timeoutPoint - ray.point).Length() >= 400.0) && !ray.ground) {
                    ::set_roll(-10.0 * ray.side);
                    this.wall = wallVec;
                    return wallVec + ::leftVec() * ((ray.side == 1) ? 100 : -100);
                }
            }

        }

        if (this.wall)
            ::set_roll(0.0);
        this.wall = null;
        return null;
    }

}
const WALLRUN_SPEED = 350;

/**
 * Wallrun controller class
 */
class WallrunController {

    wall = null; // wall the player is running on
    timeout = 0; // amount of ticks a player cannot wallrun on the same wall
    timeoutWall = null; // wall the player cannot wallrun on
    prevPos = null; // previous position of the player

    /**
     * Initialize the wallrun controller
     */
    constructor () {
        ppmod.interval(function () {
            if (::contr.wallrun.wall)
                ::player.EmitSound("Default.StepLeft");
        }, 0.25);
    }

    /**
     * Tick the wallrun controller
     */
    function tick(movement, grav, onGround) {
        // decrease timeout
        if (this.timeout > 0)
            this.timeout--;

        // check if wallrun failed
        local origin = ::player.GetOrigin();
        if (this.wall && (this.prevPos - origin).Length() < 1.0) {
            this.timeout = 60;
            this.timeoutWall = this.wall;
            this.wall = null;
            return null;
        }
        this.prevPos = origin;

        // check wallrunning
        if (movement.x > 0 && !onGround && grav < 20 && grav > -20) {
            local ray = ::wall();
            if (ray) {
                local wallVec = ray.up * 350;

                // check if wall is on time ut
                if (this.timeout > 0 && (this.timeoutWall - wallVec).Length() < 1.0) {
                    this.wall = null;
                    return null;
                } else {
                    // update wallrunning velocity
                    this.wall = wallVec;
                    return wallVec + ::leftVec() * ((ray.side == 1) ? 100 : -100);
                }
            } else {
                this.wall = null;
            }
        } else {
            this.wall = null;
        }

        return null;
    }

}
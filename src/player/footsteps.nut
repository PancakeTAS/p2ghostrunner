/**
 * Footsteps management class
 */
class Footsteps {

    step = 0; // step tick counter

    /**
     * Initialize footsteps
     */
    constructor() {
        // wallrunning footsteps
        // TODO: make more optimized
        ppmod.interval(function () {
            if (::contr.wallrun.wall)
                ::player.EmitSound("Ghostrunner.StepDefault");
        }, 0.26);
    }

    /**
     * Tick footsteps
     */
    function tick(movement, onGround) {
        // if player is not moving, reset step counter
        if (movement.Length() < 0.1 || !onGround) {
            this.step = 0;
            return;
        }

        // increment step counter
        if (this.step++ >= 17) {
            this.step = 0;

            // play footsteps
            ::player.EmitSound("Ghostrunner.StepDefault");
        }
    }

}
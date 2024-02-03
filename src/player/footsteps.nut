/**
 * Footsteps management class
 */
class Footsteps {

    step = 0; // step tick counter
    wallrunStep = 0; // wallrun step tick counter

    /**
     * Tick footsteps
     */
    function tick(movement, onGround, onWall) {
        if (onWall) {
            // increment wallrun step counter
            if (this.wallrunStep++ >= 16) {
                this.wallrunStep = 0;

                // play wallrun footsteps
                ::player.EmitSound("Ghostrunner.StepDefault");
            }
        } else {
            this.wallrunStep = 15;
        }

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
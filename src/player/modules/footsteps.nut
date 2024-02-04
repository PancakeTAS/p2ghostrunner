/**
 * Footsteps class
 */
class Footsteps {

    /** Internal footstep sound tick counter */
    _step = 0;
    /** Internal wallrun footstep sound tick counter */
    _wallrunStep = 0;

    /**
     * Tick footsteps
     */
    function tick() {
        if (::contr.wallrun.wall) {
            // increment wallrun step counter
            if (this._wallrunStep++ >= 16) {
                this._wallrunStep = 0;

                // play wallrun footsteps
                ::player.EmitSound("Ghostrunner.StepDefault");
            }
        } else {
            this._wallrunStep = 15;
        }

        // if player is not moving, reset step counter
        if (::contr.inputs.movement.Length() < 0.1 || !::contr.physics.grounded || ::contr.inputs.crouched) {
            this._step = 0;
            return;
        }

        // increment step counter
        if (this._step++ >= 17) {
            this._step = 0;

            // play footsteps
            ::player.EmitSound("Ghostrunner.StepDefault");
        }
    }

}
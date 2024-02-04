IncludeScript("player/interfaces/inputs");
IncludeScript("player/interfaces/physics");
// FIXME: order and constants
IncludeScript("player/modules/stamina");
IncludeScript("player/modules/dash");
IncludeScript("player/movement");
IncludeScript("player/modules/wallrun");
IncludeScript("player/modules/grapple");
IncludeScript("player/modules/footsteps");

::on_jump <- function() {};

/**
 * Main player controller class
 */
::PlayerController <- function () {

    local inst = {
        
        // interfaces
        inputs = null,
        physics = null,

        // movement
        movement = null,

        // modules
        stamina = null,
        dash = null,
        grapple = null,
        wallrun = null,
        footsteps = null,

        // methods
        init = null,
        tick = null

    };

    /**
     * Initialize the player controller
     */
    inst.init = function ():(inst) {
        // initialize interfaces
        inst.inputs = Inputs();
        inst.physics = Physics();

        // initialize movement
        inst.movement = Movement();

        // initialize modules
        inst.stamina = Stamina();
        inst.dash = Dash();
        inst.grapple = Grapple();
        inst.wallrun = Wallrun();
        inst.footsteps = Footsteps();

        // configure inputs
        inst.inputs.jumpStart = function ():(inst) {
            inst.movement.jump();
        };

        inst.inputs.dashStart = function ():(inst) {
            inst.dash.startSensory();
        };
        inst.inputs.dashEnd = function ():(inst) {
            inst.dash.endSensory();
        };

        inst.inputs.useStart = function ():(inst) {
            return inst.grapple.grapple();
        };

        inst.inputs.crouchStart = function ():(inst) {
            // FIXME: would be nice to actually scale the players hitbox
            ::player.EmitSound("Ghostrunner.Crouch_Down");
            ::set_offset(-16.0);
        };
        inst.inputs.crouchEnd = function ():(inst) {
            ::player.EmitSound("Ghostrunner.Crouch_Up");
            ::set_offset(0.0);
        };
    }

    /**
     * Tick the player controller
     */
    inst.tick = function ():(inst) {
        // tick interfaces
        inst.inputs.tick();
        inst.physics.tick();

        // tick movement
        inst.movement.tick();

        // tick modules
        inst.stamina.tick();
        inst.dash.tick();
        inst.grapple.tick();
        inst.wallrun.tick();
        inst.footsteps.tick();

        // end tick
        inst.movement.tick_end();
        inst.physics.tick_end();
    }

    return inst;
}
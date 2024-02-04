
// acceleration values
const GROUND_ACCELERATION = 100;
const AIR_ACCELERATION = 75;
// friction values
const NORMAL_FRICTION = 0.85;
const SLIDE_FRICTION = 0.97;
// max velocity
const BASE_VELOCITY_MAX = 275;
// gravity
const GRAVITY = 15;
const JUMP_FORCE = 300;
// sensory boost values
const SENSORY_BOOST_FACTOR = 0.05;
const SENSORY_BOOST_ACCELERATION = 175;
const SENSORY_BOOST_COST = 0.66666; // 40.0 / 60.0
// dash values
const DASH_SPEED = 1000;
const DASH_COST = 30;
const DASH_COOLDOWN = 30.0; // 0.5 * 60
// grapple values
const GRAPPLE_COOLDOWN = 60;
// wallrun values
const WALLRUN_SPEED = 350;
const WALLRUN_COOLDOWN = 60;
// stamina values
const STAMINA_MAX = 100;
const STAMINA_REGEN = 0.416666; // 25 / 60.0;
const STAMINA_FULL_REGEN_TIMEOUT = 60.0; // 1 * 60.0

IncludeScript("player/interfaces/inputs");
IncludeScript("player/interfaces/physics");
IncludeScript("player/modules/dash");
IncludeScript("player/modules/footsteps");
IncludeScript("player/modules/grapple");
IncludeScript("player/modules/stamina");
IncludeScript("player/modules/wallrun");
IncludeScript("player/movement");

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
        inst.physics = Physics();
        inst.inputs = Inputs();

        // initialize movement
        inst.movement = Movement();

        // initialize modules
        inst.stamina = Stamina();
        inst.dash = Dash();
        inst.grapple = Grapple();
        inst.wallrun = Wallrun();
        inst.footsteps = Footsteps();

        // configure inputs
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
            ::player.EmitSound("Ghostrunner.Crouch_Down");
            ::set_offset(-36.0);
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
        inst.physics.tick();
        inst.inputs.tick();

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
        inst.inputs.tick_end();
        inst.physics.tick_end();
    }

    return inst;
}
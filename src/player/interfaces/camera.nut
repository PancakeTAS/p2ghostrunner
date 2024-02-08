/**
 * Camera management class
 */
class Camera {

    /** Whether the fake camera is enabled */
    enabled = true;
    
    /** Internal value for the fake camera entity */
    _camera = null;
    /** Internal value for whether the fake camera is currently active */
    _camera_active = false;
    /** Internal value for keeping track of the camera roll */
    _roll = 0;
    /** Internal value for keeping track of the camera offset */
    _offset = 0;


    /**
     * Create the fake camera entity
     */
    constructor() {
        local inst = this;
        ppmod.create("prop_dynamic").then(function (e):(inst) {
            inst._camera = e;
            local angles = ::player.GetAngles();
            e.SetOrigin(::player.GetOrigin() + Vector(0, 0, 64));
            e.SetAngles(angles.x, angles.y, 0);
            e.renderMode = 10;
        })
    }

    /**
     * Tick the camera
     */
    function tick() {
        if (!this.enabled || !this._camera)
            return;

        this._camera.SetAbsOrigin(::contr.physics.origin + Vector(0, 0, 64 + this._offset));
        this._camera.angles = (::contr.physics.angles * Vector(1, 1, 0) + Vector(0, 0, this._roll)).ToKVString();
    }

    /**
     * Update the camera
     */
    function update() {
        if (!this.enabled || !this._camera)
            return;

        local active = this._roll != 0 || this._offset != 0;

        if (active && !this._camera_active)
            SendToConsole("cl_view " + this._camera.entindex());
        else if (!active && this._camera_active)
            SendToConsole("cl_view 1");

        this._camera_active = active;
    }

    /**
     * Set the camera roll
     */
    function setRoll(roll) {
        this._roll = roll;
        this.update();
    }
    
    /**
     * Set the camera offset
     */
    function setOffset(offset) {
        this._offset = offset;
        this.update();
    }

}
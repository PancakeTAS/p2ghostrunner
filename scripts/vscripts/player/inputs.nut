/**
 * Inputs util class
 */
class Inputs {

    /**
     * Initialize inputs
     */
    function init() {
        // register main inputs to ppmod.input
        foreach(_, global in ["forward", "moveleft", "back", "moveright"]) {
            getroottable()[global] <- false;
            ::pplayer.input("+" + global, function():(global) {
                getroottable()[global] = true
            });
            ::pplayer.input("-" + global, function():(global) {
                getroottable()[global] = false
            });
        }
    }

    /**
     * Get the normalized movement vector based on the players controls
     */
    function getMovementVector() {
        local movement = ::contr.isCrouched ? Vector(0, 0) : Vector(::forward ? 1 : (::back ? -1 : 0), ::moveleft ? -1 : (::moveright ? 1 : 0));
        movement.Norm();
        return movement;
    }

}
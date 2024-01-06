/**
 * Inputs util class
 */
class Inputs {
    _player = null;

    /**
     * Initialize inputs
     */
    function init(player) {
        this._player = player;

        // register main inputs to ppmod.input
        foreach(_, global in ["forward", "moveleft", "back", "moveright"]) {
            getroottable()[global] <- false;
            player.pplayer.input("+" + global, function():(global) {
                getroottable()[global] = true
            });
            player.pplayer.input("-" + global, function():(global) {
                getroottable()[global] = false
            });
        }
    }

    /**
     * Get the normalized movement vector based on the players controls
     */
    function getMovementVector() {
        local movement = this._player.isCrouched ? Vector(0, 0) : Vector(::forward ? 1 : (::back ? -1 : 0), ::moveleft ? -1 : (::moveright ? 1 : 0));
        movement.Norm();
        return movement;
    }

}
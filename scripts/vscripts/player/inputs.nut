class Inputs {

    _player = null;

    function init(player) {
        this._player = player;

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

    function getMovementVector() {
        local movement = this._player.isCrouched ? Vector(0, 0) : Vector(::forward ? 1 : (::back ? -1 : 0), ::moveleft ? -1 : (::moveright ? 1 : 0));
        movement.Norm();
        return movement;
    }

}
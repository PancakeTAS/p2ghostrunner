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

}
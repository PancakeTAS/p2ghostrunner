class Physics {
    _land_relay = null;

    _player = null;

    function init(player) {
        this._player = player;
        this._land_relay = Entities.CreateByClassname("logic_relay");

        ::playerSurfaceCheck <- function(ent = null):(_land_relay) {
            if (ent == null) {
                ppmod.fire("surface_check_trigger", "Kill");
                ppmod.create("env_player_surface_trigger").then(::playerSurfaceCheck);
            } else {
                EntFireByHandle(_land_relay, "Trigger", "", 0, null, null);
                ent.__KeyValueFromInt("GameMaterial", 0);
                ent.__KeyValueFromString("Targetname", "surface_check_trigger");
                ent.__KeyValueFromString("OnSurfaceChangedFromTarget", "!self\x001BRunScriptCode\x001BplayerSurfaceCheck()\x001B0\x001B-1");
            }
        }
        ::playerSurfaceCheck();

        ppmod.addscript(this._land_relay, "OnTrigger", function ():(player) {
            player.onGround = true;
        });
    }

    function getForwardVector() {
        local forward = _player.pplayer.eyes.GetForwardVector() * Vector(1, 1, 0);
        forward.Norm();
        return forward;
    }

    function getLeftVector() {
        local left = _player.pplayer.eyes.GetLeftVector() * Vector(1, 1, 0);
        left.Norm();
        return left;
    }

    function clampVector(vector, max) {
        local v = Vector(vector.x, vector.y, vector.z);
        if (v.Length() > MAX_SPEED) {
            v.Norm();
            v *= MAX_SPEED;
        }
        return v;
    }

}
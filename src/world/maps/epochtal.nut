
/**
 * Epochtal controller
 */
class MapController {

    pos1 = Vector(912, 16, 0); // relative positions for seamless teleportation
    pos2 = Vector(272, 1296, 0);

    /**
     * Initialize epochtal
     */
    constructor() {
        // add teleport to button
        ppmod.addscript("bt45-button", "OnPressed", function ():(pos1, pos2) {
            // try to get cube next to player
            local origin = ::player.GetOrigin();
            local cube = ppmod.get(origin, 256, "prop_weighted_cube");
            if (!cube) return;

            // make screen fade
            SendToConsole("fadein 2");

            // teleport player and cube
            ::player.SetOrigin(origin - pos1 + pos2);
            cube.SetOrigin(cube.GetOrigin() - pos1 + pos2);
        });
    }

    /**
     * Tick epochtal
     */
    function tick() {
        
    }

}
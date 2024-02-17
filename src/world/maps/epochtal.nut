
/**
 * Epochtal controller
 */
class MapController {

    grapple = GrapplePoint(Vector(575, 2225, 1060), 1000, Vector(0, 0, -90));
    grapple2 = GrapplePoint(Vector(831, 2945, 1550), 650);

    /**
     * Initialize epochtal
     */
    constructor() {
        
        // remove grid in last room
        local ent = null;
        while (ent = ppmod.get(Vector(448, 2432, 1279), 1, ent))
            ent.Destroy();

        // remove fizzler in last room
        ent = null;
        while (ent = ppmod.get(Vector(1088, 2816, 1216), 256, "info_particle_system", ent))
            ent.Destroy();
        ppmod.get("fiz207-br_fizz").Destroy();

    }

    /**
     * Tick epochtal
     */
    function tick() {
        this.grapple.tick();
        this.grapple2.tick();
    }

}

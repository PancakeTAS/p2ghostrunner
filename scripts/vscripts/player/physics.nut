/**
 * Physics util class
 */
class Physics {
    
    /**
     * Get a normalized x,y player forward vector
     */
    function normForwardVector(eyes) {
        local forward = eyes.GetForwardVector() * Vector(1, 1, 0);
        forward.Norm();
        return forward;
    }

    /**
     * Get a noramlized x,y player left vector
     */
    function normLeftVector(eyes) {
        local left = eyes.GetLeftVector() * Vector(1, 1, 0);
        left.Norm();
        return left;
    }

    /**
     * Clamp vector to max length
     */
    function clampVector(vector, max) {
        local v = Vector(vector.x, vector.y, vector.z);
        if (v.Length() > MAX_SPEED) {
            v.Norm();
            v *= MAX_SPEED;
        }
        return v;
    }

    /**
     * Check for collisions at a given velocity
     */
    function checkCollision(origin, velocity) {
        local squareVelocity = Vector((velocity.x > 0 ? 1 : (velocity.x < 0 ? -1 : 0)), (velocity.y > 0 ? 1 : (velocity.y < 0 ? -1 : 0)), 0);
        origin += squareVelocity * 8;
        local newOrigin = origin + (velocity / 60.0);
        local result = ppmod.ray(origin, newOrigin);
        if (result.fraction < 1)
            return true;
        result = ppmod.ray(origin + Vector(0, 0, 36), newOrigin + Vector(0, 0, 36));
        if (result.fraction < 1)
            return true;
        result = ppmod.ray(origin + Vector(0, 0, 72), newOrigin + Vector(0, 0, 72));
        if (result.fraction < 1)
            return true;
        return false;
    }

}
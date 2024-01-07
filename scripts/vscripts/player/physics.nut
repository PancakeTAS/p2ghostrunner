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

}
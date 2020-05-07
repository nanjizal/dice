package dice.view;
import trilateral2.Pen;
import trilateral2.Shaper;
import trilateral2.IndexRange;
import trilateral2.DieSpots;
import geom.matrix.Matrix4x3;
import geom.flat.f32.Float32FlatTriangle;
import trilateral2.Regular;
import trilateral2.RegularShape;
import dice.helpers.ViewGL;
import geom.obj.CubeTransforms;
class MouseSpot{
    var spots: DieSpots;
    var spotShape: RegularShape = { x: 0., y: 0., radius: 15., color: 0xff00ff00 }; // blue 
    public
    function new( pen: Pen ){
        this.spots = pen;
    }
    public inline
    function spot(): IndexRange {
        var s0 = spots.one( spotShape );
        return s0;
    }
    public function create( x: Float, y: Float ): IndexRange {
        spotShape.x = x;
        spotShape.y = y;
        return spot();
    }
}
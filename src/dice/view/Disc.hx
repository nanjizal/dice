package dice.view;
import trilateral2.Pen;
import trilateral2.Shaper;
import trilateral2.IndexRange;
import geom.matrix.Matrix4x3;
import geom.flat.f32.Float32FlatTriangle;
import dice.helpers.ViewGL;
@:structInit
class Disc {
    var theta:        Float;
    var dotRadius:    Float;
    var dieRadius:    Float;
    var dieColor:     Int;
    var hiLightColor: Int;
    var colorFront:   Int;
    var colorBack:    Int;
    var dz:           Float;
    public var circle: ( x: Float, y: Float, radius: Float, color: Int ) -> Int;
    public var roundedSquare: ( x: Float, y: Float, radius: Float, color: Int ) -> Int;
    public function new(  dotRadius:     Float, dieRadius: Float
                        , dieColor: Int, hiLightColor: Int
                        , colorFront: Int, colorBack: Int
                        , theta:      Float = 0.
                        , dz: Float = 0.01 ){
        this.dotRadius  = dotRadius;
        this.dieRadius  = dieRadius;
        this.dieColor   = dieColor;
        this.colorFront = colorFront;
        this.colorBack  = colorBack;
        this.theta      = theta;
        this.dz         = dz;
    }
}
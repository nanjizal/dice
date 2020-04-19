package dice.view;
import trilateral2.Pen;
import trilateral2.Shaper;
import geom.matrix.Matrix4x3;
import geom.flat.f32.Float32FlatTriangle;
@:structInit
class Disc {
    var theta:      Float;
    var radius:     Float;
    var dieColor:   Int;
    var colorFront: Int;
    var colorBack:  Int;
    var dz:         Float;
    public var circle: ( x: Float, y: Float, radius: Float, color: Int ) -> Int;
    public var roundedSquare: ( x: Float, y: Float, radius: Float, color: Int ) -> Int;
    public function new(  radius:     Float
                        , dieColor: Int, colorFront: Int, colorBack: Int
                        , theta:      Float = 0.
                        , dz: Float = 0.01 ){
        this.radius     = radius;
        this.dieColor   = dieColor;
        this.colorFront = colorFront;
        this.colorBack  = colorBack;
        this.theta      = theta;
        this.dz         = dz;
    }
}
typedef IndexRange = { start: Int, end: Int }

@:access( dice.view.Disc )
@:forward
abstract DiscDraw( Disc ) from Disc to Disc {
    public inline
    function new( disc: Disc ){
        this = disc;
    }
    public inline
    function create( verts: Float32FlatTriangle, x: Float, y: Float ): { start: Int, end: Int } {
        var range0 = drawDotSide( x, y, this.colorFront, verts );
        verts.transformRange( transFront(), range0.start, range0.end );
        /*var range1 = drawDotSide( x, y, this.colorBack, verts );
        verts.transformRange( transBack(), range1.start, range1.end );*/
        return { start: range0.start, end: range0.end };
    }
    inline
    function transFront(): Matrix4x3 {
        return Matrix4x3.unit.rotateX( this.theta );
    }
    inline
    function transBack(): Matrix4x3 {
        return Matrix4x3.unit.rotateX( Math.PI+this.theta ) * Matrix4x3.unit.translateX( this.dz );
    }
    inline 
    function drawDotSide( x: Float, y: Float, color: Int, verts: Float32FlatTriangle ): IndexRange {
        var start = verts.length;
        var len = this.circle( x, y, this.radius, color );
        return { start: start, end: verts.length - 1 };
    }
    public inline 
    function drawSide( x: Float, y: Float, verts: Float32FlatTriangle ): IndexRange {
        var len = 0;
        var start = verts.length;
        len = this.roundedSquare( x, y, this.radius*8, this.dieColor );
        var end = verts.length - 1;
        verts.transformRange(Matrix4x3.unit.translateZ( -this.dz/2 ) , start, end );
        /*var start2 = end + 1;
        len = this.roundedSquare( x, y, this.radius*8, this.dieColor );
        end = verts.length - 1;
        verts.transformRange( transBack(), start2, end );*/
        return { start: start, end: end };
    }
}
@:access( dice.view.Disc )
@:forward
abstract DieDraw( DiscDraw ) from DiscDraw to DiscDraw {
    public inline
    function new( discDraw: DiscDraw ){
        this = discDraw;
    }
    // TODO: implement left option!
    /**
    left
    5
    1 3 6 4
    2
    right
    4
    1 2 6 5
    3
    */
    public inline 
    function create( verts: Float32FlatTriangle, x: Float, y: Float ): IndexRange {
        var diceRadius = 0.1;
        var spacing = 25;
        var spacingY = 0;
        // six
        spacing = 25;
        spacingY = 35;
        var range150 = this.drawSide( x, y, verts );
        var range15 = this.create( verts, x - spacing, y - spacingY );
        var range16 = this.create( verts, x + spacing, y - spacingY );
        var range17 = this.create( verts, x - spacing, y + spacingY );
        var range18 = this.create( verts, x + spacing, y + spacingY );
        var range19 = this.create( verts, x - spacing, y );
        var range20 = this.create( verts, x + spacing, y );
        var trans180 = Matrix4x3.unit.rotateY( Math.PI )*Matrix4x3.unit.translateZ( diceRadius );
        verts.transformRange( trans180, range150.start, range20.end );
        // two
        spacing = 20;
        var range10 = this.drawSide( x, y, verts );
        var range1 = this.create( verts, x + spacing, y - spacing );
        var range2 = this.create( verts, x - spacing, y + spacing );
        var transRight = Matrix4x3.unit.rotateY( Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        verts.transformRange( transRight, range10.start, range2.end );
        // three
        spacing = 25;
        var range30 = this.drawSide( x, y, verts );
        var range3 = this.create( verts, x, y );
        var range4 = this.create( verts, x + spacing, y - spacing );
        var range5 = this.create( verts, x - spacing, y + spacing );
        var transDown = Matrix4x3.unit.rotateX( Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        verts.transformRange( transDown, range30.start, range5.end );
        // four
        spacing = 30;
        var range60 = this.drawSide( x, y, verts );
        var range6 = this.create( verts, x - spacing, y - spacing );
        var range7 = this.create( verts, x + spacing, y - spacing );
        var range8 = this.create( verts, x - spacing, y + spacing );
        var range9 = this.create( verts, x + spacing, y + spacing );
        var transUp = Matrix4x3.unit.rotateX( -Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        verts.transformRange( transUp, range60.start, range9.end );
        // five
        spacing = 30;
        var range100 = this.drawSide( x, y, verts );
        var range10 = this.create( verts, x - spacing, y - spacing );
        var range11 = this.create( verts, x + spacing, y - spacing );
        var range12 = this.create( verts, x - spacing, y + spacing );
        var range13 = this.create( verts, x + spacing, y + spacing );
        var range14 = this.create( verts, x, y );
        var transLeft =Matrix4x3.unit.rotateY( -Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        verts.transformRange( transLeft, range100.start, range14.end );
        
        // one 
        spacing = 25;
        var range00 = this.drawSide( x, y, verts );
        var range0 = this.create( verts, x, y );
        verts.transformRange( Matrix4x3.unit.translateZ( diceRadius ), range00.start, range0.end );
        
        //
        return { start: range150.start, end: range0.end };
    }
}
@:structInit
class Die{
    var pen: Pen;
    public var disc: Disc = { radius: 15, dieColor: 0xc0ff0000
                            , colorFront: 0xfff0ffff, colorBack: 0xc0f0ff00 };
    public
    function new( pen: Pen ){
        this.pen         = pen;
        disc.circle      = circle;
        disc.roundedSquare = roundedSquare;
    }
    public function create( verts: Float32FlatTriangle, x: Float, y: Float ): IndexRange {
        var dieDraw: DieDraw = disc;
        var startEnd = dieDraw.create( verts, x, y );
        verts.transformRange( Matrix4x3.unit.scale( .5 ), startEnd.start, startEnd.end );
        return startEnd;
    }
    public function circle( x: Float , y: Float, radius: Float, color: Int ): Int {
        var len = Shaper.circle( pen.drawType, x, y, radius );
        pen.colorTriangles( color, len );
        return len;
    }
    public function roundedSquare( x: Float, y: Float, dia: Float, color: Int  ): Int {
        var len = Shaper.roundedRectangle( pen.drawType, x - dia/2, y - dia/2, dia, dia, 30 );
        pen.colorTriangles( color, len );
        return len;
    }
}

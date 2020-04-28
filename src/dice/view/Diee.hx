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
@:structInit
class Diee{
    var right = false;
    var spots: DieSpots;
    var spotShape: RegularShape = { x: 0., y: 0., radius: 15., color: 0xfff0ffff };
    var dieShape:  RegularShape = { x: 0., y: 0., radius: 60., color: 0xc0ff0000 };
    public
    function new( pen: Pen ){
        this.spots = pen;
    }
    public inline
    function one( trans: Matrix4x3 ): IndexRange {
        var s0 = spots.roundedSquare( dieShape );
        spots.down( s0 );
        var s1 = spots.one( spotShape );
        var s2: IndexRange = { start: s0.start, end: s1.end };
        spots.transformRange( trans, s2 );
        return s2;
    }
    public inline
    function two( trans: Matrix4x3 ): IndexRange {
        var s0 = spots.roundedSquare( dieShape );
        spots.down( s0 );
        var s1 = spots.two( spotShape );
        var s2: IndexRange = { start: s0.start, end: s1.end };
        spots.transformRange( trans, s2 );
        return s2;
    }
    public inline
    function three( trans: Matrix4x3 ): IndexRange {
        var s0 = spots.roundedSquare( dieShape );
        spots.down( s0 );
        var s1 = spots.three( spotShape );
        var s2: IndexRange = { start: s0.start, end: s1.end };
        spots.transformRange( trans, s2 );
        return s2;
    }
    public inline
    function four( trans: Matrix4x3 ): IndexRange {
        var s0 = spots.roundedSquare( dieShape );
        spots.down( s0 );
        var s1 = spots.four( spotShape );
        var s2: IndexRange = { start: s0.start, end: s1.end };
        spots.transformRange( trans, s2 );
        return s2;
    }
    public inline
    function five( trans: Matrix4x3 ): IndexRange {
        var s0 = spots.roundedSquare( dieShape );
        spots.down( s0 );
        var s1 = spots.five( spotShape );
        var s2: IndexRange = { start: s0.start, end: s1.end };
        spots.transformRange( trans, s2 );
        return s2;
    }
    public inline 
    function six( trans: Matrix4x3 ): IndexRange {
        var s0 = spots.roundedSquare( dieShape );
        spots.down( s0 );
        var s1 = spots.six( spotShape );
        var s2: IndexRange = { start: s0.start, end: s1.end };
        spots.transformRange( trans, s2 );
        return s2;
    }
    public function create( x: Float, y: Float ): IndexRange {
        spotShape.x = x;
        spotShape.y = y;
        dieShape.x  = x;
        dieShape.y  = y;
        var diceRadius = dieShape.radius * 1/ViewGL.stageRadius;
        var t1 = Matrix4x3.unit.translateZ( diceRadius );
        var t2 = Matrix4x3.unit.rotateY( Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        var t3 = Matrix4x3.unit.rotateX( Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        var t4 = Matrix4x3.unit.rotateX( -Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        var t5 = Matrix4x3.unit.rotateY( -Math.PI/2 )*Matrix4x3.unit.translateZ( diceRadius );
        var t6 = Matrix4x3.unit.rotateY( Math.PI )*Matrix4x3.unit.translateZ( diceRadius );
        var s6 = six(   t6 );
        var s2 = two(   ( right )? t2: t3 );
        var s3 = three( ( right )? t3: t2 );
        var s4 = four(  ( right )? t4: t5 );
        var s5 = five(  ( right )? t5: t4 );
        var s1 = one(   t1 );
        var startEnd: IndexRange = { start: s6.start, end: s1.end };
        spots.transformRange( Matrix4x3.unit.scale( .5 ), startEnd );
        return startEnd;
    }
}
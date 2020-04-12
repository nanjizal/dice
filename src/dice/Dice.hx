package dice;

import haxe.io.UInt16Array;
import haxe.io.Float32Array;
import haxe.io.Int32Array;

import js.Browser;
import js.html.CanvasElement;
import dice.shaders.Shaders;
import dice.helpers.AxisKeys;
import dice.helpers.GridLines;
import dice.helpers.ViewGL;
import dice.helpers.LayoutPos;
import htmlHelper.tools.DivertTrace;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.canvas.Surface;

// Maths mostly matrix trasforms
import geom.matrix.Matrix4x3;
import geom.matrix.Matrix4x4;
import geom.matrix.Quaternion;
import geom.matrix.DualQuaternion;
import geom.matrix.Matrix1x4;
import geom.move.Axis3;
import geom.move.Trinary;
import geom.matrix.Projection;
import geom.matrix.Matrix1x2;
import geom.flat.f32.Float32FlatRGBA;
import geom.flat.f32.Float32FlatTriangle;
import geom.flat.f32.Float32FlatTriangleXY;
import geom.flat.ui16.UInt16Flat3;
import geom.flat.i32.Int32Flat3;

// Trilateral Contour Drawing Tools
import trilateral2.Algebra;
import trilateral2.Pen;
import trilateral2.DrawType;
import trilateral2.ColorType;
import trilateral2.Shaper;
import trilateral2.Contour;
import trilateral2.EndLineCurve;
import trilateral2.Sketch;
import trilateral2.SketchForm;
import trilateral2.Fill;
import trilateral2.ArrayTriple;

// WebGL / Canvas setup, basic browser util
import htmlHelper.webgl.WebGLSetup;
import htmlHelper.tools.CharacterInput;
import htmlHelper.tools.AnimateTimer;
import htmlHelper.tools.DivertTrace;
import pallette.QuickARGB;

using htmlHelper.webgl.WebGLSetup;
class Dice {
    var viewGL = new ViewGL();
    var size = 80;
    var len = 0;
    var s0 = 0;
    var e0 = 0;
    var s1 = 0;
    var e1 = 0;
    var angle = 0.;//(Math.PI/4);
    var layoutPos: LayoutPos;
    var pen: Pen;
    public static function main() new Dice();
    public function new(){
        new DivertTrace();
        instructions();
        layoutPos     = new LayoutPos( ViewGL.stageRadius );
        pen = viewGL.pen;
        var gridLines = new GridLines( pen, ViewGL.stageRadius );
        gridLines.draw( 10, 0x0396FB00, 0xF096FBF3 );
        viewGL.transform( Matrix4x3.unit.translateXYZ( 0., 0., -0.1 ) );
        var range0 = drawDotSide( 0xfff0ffff );
        s0 = range0.start;
        e0 = range0.end;
        viewGL.transformRange( Matrix4x3.unit.rotateX( angle ), s0, e0 );
        var range1 = drawDotSide( 0xfff0ff00 );
        s1 = range1.start;
        e1 = range1.end;
        viewGL.transformRange( Matrix4x3.unit.translateX( 0.01 ), s1, e1 );
        viewGL.transformRange( Matrix4x3.unit.rotateX( Math.PI+angle ), s1, e1 );
        viewGL.update = update;
        viewGL.upload();
        viewGL.start();
    }
    function drawDotSide( color: Int ):{start:Int,end:Int}{
        len = Shaper.circle( pen.drawType
                           , layoutPos.centre.x, layoutPos.centre.y
                           ,  size );
        pen.colorTriangles( color, len );
        return { start: viewGL.verts.length - len, end: viewGL.verts.length- 1 };
    }
    
    function update():Void{
        //angle = -Math.PI/100;
        var model = DualQuaternion.zero;
        model  = viewGL.itemModel.updateCalculate( model );
        var trans: Matrix4x3 = model;
        viewGL.transformRange( trans, s0, e1 );
        //viewGL.transformRange( trans, s1, e1 );
        viewGL.upload();
    }
    function instructions(){
        trace('swap between disc and scene: a');
        trace('use keys to transform scene');
        trace('rotate: arrow keys');
        trace('zoom: delete/return');
        trace('translate up/down: tab/shift');
        trace('translate left/right: ctrl/space');
        trace('spin: alt/cmd');
        trace('reset scene position: r');
    }
}
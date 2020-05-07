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
import geom.matrix.Matrix1x4;
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
import trilateral2.IndexRange;

// WebGL / Canvas setup, basic browser util
import htmlHelper.webgl.WebGLSetup;
import htmlHelper.tools.CharacterInput;
import htmlHelper.tools.AnimateTimer;
import htmlHelper.tools.DivertTrace;
import pallette.QuickARGB;
import dice.view.Die;
import geom.obj.CubeTransforms;
import trilateral2.DieSpots;
import trilateral2.VertexObject;
import dice.view.MouseSpot;
using htmlHelper.webgl.WebGLSetup;
class Dice {
    var viewGL = new ViewGL();
    var size = 80;
    var start = 0;
    var end = 0;
    var angle = 0.;//(Math.PI/4);
    var layoutPos: LayoutPos;
    var pen: Pen;
    var mouseSpot: MouseSpot;
    var mouseStartEnd: IndexRange;
    var vertexObject: VertexObject;
    var mouseStartPos: Int;
    var mouseStored: IndexRange;
    var modelPen:        Pen;
    public static function main() new Dice();
    public function new(){
        new DivertTrace();
        instructions();
        layoutPos     = new LayoutPos( ViewGL.stageRadius );
        pen = Pen.create( viewGL.verts, viewGL.cols );
        
        modelPen = Pen.create( viewGL.vertsModel, viewGL.colsModel );
        
        pen.transformMatrix = viewGL.scaleToGL();
        //modelPen.transformMatrix = viewGL.scaleToGL();
        Shaper.transformMatrix = viewGL.scaleToGL();
        //pen = viewGL.pen;
        var gridLines = new GridLines( pen, ViewGL.stageRadius );
        gridLines.draw( 10, 0x0396FB00, 0xF096FBF3 );
        viewGL.transform( Matrix4x3.unit.translateXYZ( 0., 0., -0.2 ) );
        var die     = new Die( pen );
        mouseSpot   = new MouseSpot( pen );

        
        //
        //var die2    = new Die( viewGL.pen );
        var startEnd  = die.create( layoutPos.centre.x, layoutPos.centre.y );
        var mousePos = new Matrix1x4( { x:layoutPos.centre.x, y: layoutPos.centre.y, z: 0, w: 1 } );
        mouseStartEnd = mouseSpot.create( layoutPos.centre.x, layoutPos.centre.y );
        viewGL.transformRange( Matrix4x3.unit.translateXYZ( 0., 0., 0.2 ), mouseStartEnd.start, mouseStartEnd.end );
        mouseStartPos = mouseStartEnd.start;
        
        var mouseZero: Matrix1x4 = { x: 0., y: 0., z: 0., w: 1. };
        
        /*
        var posCurr = pen.pos;
        mouseStored   = modelPen.copyRange( pen, mouseStartEnd, mouseZero );  // clone the mouse 
        pen.pos = posCurr;
        var matrixObject: MatrixObject = { name:'mousey', m: mousePos, startEnd: mouseStartEnd };
        vertexObject = matrixObject;
        */
        
        
        //var startEnd2 = die.create(layoutPos.centre.x - 200, layoutPos.centre.y );
        //var trans = CubeTransforms.getDieLayout({radius: 0, isLeft: LEFT } ); // rotate around to side 6.
        //var spots: DieSpots = pen;
        //spots.transformRange( trans[5], startEnd2 );
        //start         = mouseStartEnd.start;
        start         = startEnd.start;
        end           = mouseStartEnd.end;
        //end           = startEnd2.end;
        viewGL.update = update;
        viewGL.upload();
        viewGL.start();
    }
    function update():Void{
        //pen.pos = mouseStartPos;
        //var newPos = viewGL.mousePos;
        //var offPos: Matrix1x4 = { x: newPos.x - layoutPos.centre.x, y: newPos.y - layoutPos.centre.y, z: 0, w: 1 };
        //newPos.x -= layoutPos.centre.x;
        //newPos.y -= layoutPos.centre.y;
        //trace( newPos.x + ' ' + newPos.y );
        //pen.copyRange2( modelPen, mouseStored, viewGL.mousePos );
        var model = DualQuaternion.zero;
        model  = viewGL.itemModel.updateCalculate( model );
        var trans: Matrix4x3 = model;
        viewGL.transformRange( trans, start, end );
        viewGL.upload();
    }
    function instructions(){
        trace('use keys to transform');
        trace('to swap between disc and scene: a');
        trace('rotate: arrow keys');
        trace('zoom: delete/return');
        trace('translate up/down: tab/shift');
        trace('translate left/right: ctrl/space');
        trace('spin: alt/cmd');
        trace('reset scene position: r');
    }
}
package dice.helpers;
import haxe.io.UInt16Array;
import haxe.io.Float32Array;
import haxe.io.Int32Array;

import js.Browser;
import js.html.CanvasElement;
import dice.shaders.Shaders;
import dice.helpers.AxisKeys;
import dice.helpers.GridLines;
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

// WebGL / Canvas setup, basic browser utils
import htmlHelper.webgl.WebGLSetup;
import htmlHelper.tools.CharacterInput;
import htmlHelper.tools.AnimateTimer;
import htmlHelper.tools.DivertTrace;

using htmlHelper.webgl.WebGLSetup;
class ViewGL extends WebGLSetup {
    public inline static var stageRadius: Int = 600;
    var axisModel       = new Axis3();
    public var itemModel       = new Axis3();
    static final largeEnough    = 2000000;
    public var verts            = new Float32FlatTriangle( largeEnough );
    var textPos                 = new Float32FlatTriangleXY( largeEnough );
    var cols                    = new Float32FlatRGBA(largeEnough);
    var ind                     = new Int32Flat3(largeEnough);
    var scale:                  Float;
    var model                   = DualQuaternion.zero;
    public var pen:             Pen;
    var theta:                  Float = 0;
    var toDimensionsGL:         Matrix4x3;
    public var update: Void->Void;
    public function new(){
        super( stageRadius, stageRadius );
        canvas.tabIndex = -1;
        var axisKeys   = new AxisKeys( axisModel, itemModel );
        axisKeys.showTrace = false;
        axisKeys.reset = resetPosition;
        DEPTH_TEST = false;
        BACK       = false;
        darkBackground();
        setupProgram( Shaders.vertexColor, Shaders.fragmentColor );
        pen = Pen.create( verts, cols );
        pen.transformMatrix = scaleToGL();
        Shaper.transformMatrix = scaleToGL();
    }
    public inline
    function upload(){
        //transformVerticesToGL();
        uploadVectors();
    }
    public inline
    function start(){
        setAnimate();
    }
    public
    function transform( m: Matrix4x3 ){
        verts.transformAll( m );
    }
    public
    function transformRange( m: Matrix4x3, start: Int, end: Int ){
        verts.transformRange( m, start, end );
    }
    function transformVerticesToGL() verts.transformAll( scaleToGL() );
    function scaleToGL(){
        scale = 1/(stageRadius);
        var v = new Matrix1x4( { x: scale, y: -scale, z: scale, w: 1. } );
        return ( Matrix4x3.unit.translateXYZ( -1., 1., 0. ) ).scaleByVector( v );
    }
    function uploadVectors(){
        vertices =  cast verts.getArray();
        colors   =  cast cols.getArray();
        var texs = cast textPos.getArray();
        indices  =  createIndices();
        //clearTriangles();
        gl.passIndicesToShader( indices );
        gl.uploadDataToBuffers( program, vertices, colors );
    }
    public 
    function reloadVectors(){
        vertices =  cast verts.getArray();
        colors   =  cast cols.getArray();
        var texs = cast textPos.getArray();
        clearTriangles();
        gl.passIndicesToShader( indices );
        gl.uploadDataToBuffers( program, vertices, colors );
    }
    function resetPosition(): Void model =  DualQuaternion.zero;
    function darkBackground(){
        var dark = 0x18/256;
        bgRed   = dark;
        bgGreen = dark;
        bgBlue  = dark;
    }
    function createIndices(): UInt16Array{
        ind.pos = 0;
        for( i in 0...verts.size ) {
            ind[ 0 ] = i *3 + 0;
            ind[ 1 ] = i *3 + 1;
            ind[ 2 ] = i *3 + 2; 
            ind.next();
        }
        var arr = ind.getArray();
        return cast arr;
    }
    inline
    function clearTriangles(){
        verts = new Float32FlatTriangle(1000000);
        cols  = new Float32FlatRGBA(1000000);
    }
    inline
    function render_( i: Int ): Void {
        if( update != null ) update();
        model  = axisModel.updateCalculate( model );
        var trans: Matrix4x3 = (  offset * model ).normalize();
        ( Projection.perspective() * trans ).updateWebGL( untyped matrix32Array );
        render();
    }
    inline
    function setAnimate(){
        AnimateTimer.create();
        AnimateTimer.onFrame = render_;
    }
    inline
    public static 
    function getOffset(): DualQuaternion {
        var qReal = Quaternion.zRotate( 0 );
        var qDual = new Matrix1x4( { x: 0., y: 0., z: -1., w: 1. } );
        return DualQuaternion.create( qReal, qDual );
    }
    final offset = getOffset();
}
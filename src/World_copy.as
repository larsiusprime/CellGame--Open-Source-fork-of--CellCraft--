package  
{
	import bit101.display.BigAssCanvas;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Contains the entire level and play area. The world itself is invisible, but contains lots of interactive
	 * objects. 
	 * @author Lars A. Doucet
	 */
	public class World extends Sprite
	{
		//constants:
		
		private const OFFSET_X:Number = 120;//subtract 120 from right
		private const OFFSET_Y:Number = 40; //add 40 from top
		
		//
		
		private var scrollX:Number = 0;
		private var scrollY:Number = 0;
		private var scrollPoint:Point;
		private var old_scrollPoint:Point;
		private static var scale:Number = 1;
		public var _scale:Number = 1;
		
		//pointers:
		
		private var p_director:Director;
		private var p_engine:Engine;
		private var p_interface:Interface;
		
		//selectables:
		
		private var selectList:Vector.<Selectable>;
		
		//children:

		private var c_zoomShape:Shape;
		private var c_zoomShape2:Shape;
		private var c_selectShape:Shape;
		private var c_cross:Cross;
		
		//everything between this comment and c_objectLayer is a child of c_objectLayer
		private var c_cell:Cell;
		private var c_canvas:WorldCanvas;
		private var c_mask:WorldMask;
		private var c_maskBlur:WorldBlur;
		
		//everything below this comment is a direct child of world (this)

		private var c_objectLayer:Sprite;
		private var c_terrain:Terrain;
		
		private var lvlWidth:Number = 0;
		private var lvlHeight:Number = 0;
		
		private var startX:Number = 0;
		private var startY:Number = 0;
		
		private var animationOn:Boolean = true;
		private var doFollowCell:Boolean = true;
		
		private var bkgIndex:int = -1;
		
		public static var LENS_SIZE:Number = 100;
		public static var LENS_R2:Number = 100*100;
		
		public static var BOUNDARY_R2:Number = 1000;
		public static var BOUNDARY_W:Number = 1000;
		public static var BOUNDARY_H:Number = 1000;
		//public static var BOUNDARY_
		
		public function World() 
		{
			
		}

		//include all of our fast math calculations as local functions to avoid lookup times:
		include "inc_fastmath.as"
		
		public function init() {
			
			//testing:
			//c_cross = new LittleCross();

			
			scrollPoint = new Point(0, 0);
			old_scrollPoint = new Point(0, 0);
			y = Director.STAGEHEIGHT / 2; //put the "center of the world" at the center of the screen
			x = Director.STAGEWIDTH / 2;
				
			if (bkgIndex == -1) {
				throw new Error("Background index not set!");
			}
			makeTerrain(bkgIndex,lvlWidth,lvlHeight);
			makeObjectLayer();
			makeMask();
			makeCell();
			
			goStartPoint();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(RunFrameEvent.RUNFRAME, run);
			
			//testing:
			//c_objectLayer.addChild(c_cross);
		}

		public function goStartPoint() {
			c_cell.moveCellTo(startX*Terrain.SCALE_MULT, startY*Terrain.SCALE_MULT); //move to the start location
			centerOnCell();
		}
		
		public function setStartPoint(xx:Number, yy:Number) {
			startX = xx;
			startY = yy;
		}
		
		public function setLevel(s:String,w:Number,h:Number) {
			s.toLowerCase();
			if (s == "petridish") {
				bkgIndex = Terrain.PETRI_DISH;
			}else if (s == "monstermouth") {
				bkgIndex = Terrain.MONSTER_MOUTH;
			}else if (s == "petridish_silver") {
				bkgIndex = Terrain.PETRI_DISH_SILVER;
			}else if (s == "petridish_gold") {
				bkgIndex = Terrain.PETRI_DISH_GOLD;
			}
			lvlWidth = w;
			lvlHeight = h;
			trace("World.setLevel : size=(" + lvlWidth + "," + lvlHeight + ")");
		}
		
		private function run(e:RunFrameEvent) {
			c_cell.dispatchEvent(e);
			c_canvas.dispatchEvent(e);
		}
		

		public function mouseDown(m:MouseEvent) {
			
			p_engine.onWorldMouseDown();
		}
		
		public function destruct() {
			p_director = null;
			p_engine = null;
			p_interface = null;
			
			if(c_objectLayer){
				if(c_cell){
					c_cell.destruct();
					c_objectLayer.removeChild(c_cell);
					c_cell = null;
				}
				if (c_canvas) {
					c_canvas.destruct();
					c_objectLayer.removeChild(c_canvas);
					c_canvas = null;
				}
				removeChild(c_objectLayer);
				c_terrain.destruct();
				removeChild(c_terrain);
				c_terrain = null;
				c_objectLayer = null;
			}
		}
		
		public function setDirector(d:Director) {
			p_director = d;
		}
		
		public function setEngine(e:Engine) {
			p_engine = e;
		}
		
		public function setInterface(i:Interface) {
			p_interface = i;
		}
		

		
		private function makeTerrain(i:int,w:Number,h:Number) {

			c_terrain = new Terrain(i,OFFSET_X,OFFSET_Y,w,h);
			c_terrain.x = -x;	//PHYSICALLY offset the CANVAS so it takes up the entire window
			c_terrain.y = -y;
			
			c_terrain.center(0,0) //CENTER the drawing location by this
			addChild(c_terrain);
		}
		
		private function makeObjectLayer() {
			c_objectLayer = new Sprite();
			addChild(c_objectLayer);
			c_objectLayer.x = -OFFSET_X/2;
			c_objectLayer.y = OFFSET_Y / 2;
			
			//testing only:
			//c_selectShape = new Shape();
			/*c_zoomShape = new Shape();
			c_zoomShape2 = new Shape();
			addChild(c_zoomShape);
			c_objectLayer.addChild(c_zoomShape2);*/
			
		}
		
		private function makeMask() {
			c_mask = new WorldMask();
			c_maskBlur = new WorldBlur();
			addChild(c_mask);
			addChild(c_maskBlur);
			mask = c_mask;
		}
		
		
		
		public function updateMaskSize(r:Number) {
			LENS_SIZE = r;
			LENS_R2 = r*r;
			c_mask.setSize(r);
			c_maskBlur.setSize(r);
			if(p_engine){
				p_engine.onUpdateMaskSize(r);
			}
		}
		
		public function getMaskSize():Number {
			return c_mask.getSize();
		}
		
		/**
		 * When the cell moves, this function is called to keep the screen centered on it.
		 * @param	xx the x position of the centrosome
		 * @param	yy the y position of the centrosome
		 */
		
		public function onCellMove(xx:Number=0,yy:Number=0) { //please, please send me the centrosome's position
			if (doFollowCell) {
				//centerOnCell(), inlined for speed
				scrollPoint.x = -xx;
				scrollPoint.y = -yy;
				setScroll(scrollPoint.x * scale, scrollPoint.y * scale);
			}
			
			//updateMask2() - inlined for speed
			var p:Point = new Point(xx, yy);
			p = reverseTransformPoint(p);
			c_mask.x = p.x - x;
			c_mask.y = p.y - y;
		}
		
		private function updateMask2(xx:Number, yy:Number) {
			var p:Point = new Point(xx, yy);
			p = reverseTransformPoint(p);
			c_mask.x = p.x - x;
			c_mask.y = p.y - y;
		}
		
		private function updateMaskScale() {
			c_mask.scaleX = scale;
			c_mask.scaleY = scale;
		}
		
		private function updateMask() {
			var p:Point = new Point(c_cell.c_centrosome.x, c_cell.c_centrosome.y);
			p = reverseTransformPoint(p);
			c_mask.x = p.x - x;
			c_mask.y = p.y - y;
			
			/*c_maskBlur.x = p.x - x;
			c_maskBlur.y = p.y - y;
			c_maskBlur.x = scale;
			c_maskBlur.y = scale;*/
			
			//trace("World.updateMask() mask.pos = " + mask.x + "," + mask.y);
		}
		
		private function makeCanvas() {
			c_canvas = new WorldCanvas();
			
			c_objectLayer.addChild(c_canvas);
			
			c_canvas.setDirector(p_director);
			c_canvas.setCell(c_cell);
			
			c_cell.setCanvas(c_canvas);
			p_engine.receiveCanvas(c_canvas);
			
			//c_objectLayer.setChildIndex(c_cell, c_objectLayer.numChildren - 1); //put the cell back on top
			
			c_canvas.setEngine(p_engine);
			c_canvas.setWorld(this);
			c_canvas.init();
		}
		
		private function makeCell() {
			//IMPORTANT : the cell must ALWAYS remain at position 0,0. It's organelles and contents can move
			//wherever the heck they want, but the "bucket" containing all of its bits, c_cell, must as a data
			//object stay at 0,0. If this ever changes, that offset has to be taken into account when selecting, etc.
			c_cell = new Cell();
			
			c_objectLayer.addChild(c_cell);
			c_cell.setDirector(p_director);
			p_engine.receiveCell(c_cell); //set the engine's cell pointer
			
			c_cell.setEngine(p_engine);
			c_cell.setWorld(this);
			c_cell.setInterface(p_interface);
			
			makeCanvas(); //have to do this after the cell is made but before it's initialized
			
			c_cell.init();
			//get the selectables within the cell and add them to the selectList
			makeSelectList();
		}
		
		public static function getZoom():Number {
			return scale;
		}
		
		public function getScale():Number {
			return scale;
		}
		
		public function getCell():Cell {
			return c_cell;
		}
		
		public function updateSelectList() {
			makeSelectList();
		}
		
		private function makeSelectList() {
			selectList = c_cell.getSelectables().concat();
			//selectList = list.concat();
			
		}
		
		public function changeZoom(n:Number) {
			var old_scale:Number = scale;
			
			var xx:Number = scrollX;
			var yy:Number = scrollY;
			
			c_objectLayer.scaleX = n;
			c_objectLayer.scaleY = n;
			c_terrain.changeZoom(n);
			scale = n;
			_scale = n;
			c_cell.onZoomChange(n);
			c_canvas.onZoomChange(n);
			centerOnPoint( -scrollPoint.x, -scrollPoint.y);
			updateMaskScale();
		}
		
		public function updateScroll() {
			setScroll(scrollPoint.x*scale, scrollPoint.y*scale);
			updateMask();
		}
		
		//testing:
		/*public function updateCross() {
			c_cross.scaleX = 1/scale;
			c_cross.scaleY = 1/scale
			c_cross.x = -scrollPoint.x;
			c_cross.y = -scrollPoint.y;
		}*/
		
		public function getScroll():Point {
			return scrollPoint.clone();
		}
		
		public function setScroll(xx:Number, yy:Number) {
			var old_scrollX:Number = c_objectLayer.x;
			var old_scrollY:Number = c_objectLayer.y;
			
			c_objectLayer.x = xx - OFFSET_X / 2;
			c_objectLayer.y = yy + OFFSET_Y / 2;

			if (!checkBoundX()) {
				c_objectLayer.x = old_scrollX;
				scrollPoint.x = old_scrollPoint.x;
			}else {
				c_terrain.setScrollX(xx);
			}
			
			if (!checkBoundY()) {
				c_objectLayer.y = old_scrollY;
				scrollPoint.y = old_scrollPoint.y
			}else {
				c_terrain.setScrollY(yy);
			}
			
			scrollX = c_objectLayer.x + OFFSET_X / 2;
			scrollY = c_objectLayer.y - OFFSET_Y / 2;
		}
		
		public function doScroll(sx:Number, sy:Number) {
			old_scrollPoint.x = scrollPoint.x;
			old_scrollPoint.y = scrollPoint.y;
			scrollPoint.x -= sx/scale;
			scrollPoint.y -= sy / scale;
			
			setScroll(scrollPoint.x*scale, scrollPoint.y*scale);
			updateMask();
			//updateScroll();
		}
		
		public function setBoundaryCircle(r:Number) {
			r *= Terrain.SCALE_MULT;
			BOUNDARY_R2 = r * r;
			GameObject.setBoundaryRadius(r);
		}
		
		public function setBoundaryBox(w:Number, h:Number) {
			w *= Terrain.SCALE_MULT;
			h *= Terrain.SCALE_MULT;
			BOUNDARY_W = w;
			BOUNDARY_H = h;
			GameObject.setBoundaryBox(w,h);
			//throw new Error("Boundary box not implemented!");
		}
		
		public function checkBoundX():Boolean {
			var tw:Number = (c_terrain.getWidth()) * Terrain.SCALE_MULT;
			var wo:Number = (OFFSET_X) * Terrain.SCALE_MULT;
			//tw *= .75;
			var ssx:Number = scrollPoint.x;//(c_objectLayer.x + OFFSET_X / 2);
			if (ssx > (tw) / 2) { //Div by 4: divide by 2 for half the distance of the thing. divide by 2 again because you only need to scroll half to see the edge
				return false;
			}else if (ssx < -(tw) / 2) {
				return false;
			}
			return true;
		}
		
		public function checkBoundY():Boolean {
			var th:Number = (c_terrain.getHeight())*Terrain.SCALE_MULT;
			var ssy:Number = scrollPoint.y;// c_objectLayer.y - OFFSET_Y / 2;
			var ho:Number = (OFFSET_Y) * Terrain.SCALE_MULT;
			if (ssy > (th) / 2) {
				return false;
			}else if(ssy < -(th) /2){
				return false;
			}
			return true;
		}
		
		public function checkBounds(sx:Number,sy:Number):Boolean{
			
			var tw:Number = c_terrain.getWidth() * scale;
			var th:Number = c_terrain.getHeight() * scale;
			tw *= 17 / 14;
			
			tw /= scale;
			th /= scale;
			var ssx:Number = (c_objectLayer.x + OFFSET_X / 2) / scale;
			var ssy:Number = (c_objectLayer.y - OFFSET_Y / 2) / scale;
			
			if (ssx > tw/2) {
				return false;
			}else if (ssx < -tw/2) {
				return false;
			}
			
			if (ssy > th / 2) {
				return false;
			}else if (ssy < -th / 2) {
				return false;
			}
			return true;
		}

		public function getCenteredPoint():Point {
			//unpack setScroll(xx,yy);
			var xx:Number = scrollX;
			var yy:Number = scrollY;
			
			//unpack (scrollPoint.x * scale, scrollPoint.y * scale) = (xx,yy)
			xx /= scale;
			yy /= scale;
			
			//unpack scrollPoint.x = -xx, scrollPoint.y = -yy
			
			xx *= -1;
			yy *= -1;
			
			return new Point(xx, yy);
		}
		
		public function centerOnPoint(xx:Number,yy:Number) {
			scrollPoint.x = -xx;
			scrollPoint.y = -yy;
			
			setScroll(scrollPoint.x * scale, scrollPoint.y * scale);
			updateMask();
			//updateScroll();
		}

		public function followCell(yes:Boolean) {
			//needs to be optimized perhaps
			doFollowCell = yes;
		}
		
		public function centerOnCell() {
			centerOnPoint(c_cell.c_centrosome.x, c_cell.c_centrosome.y);			
		}
		
		public function pauseAnimate(yes:Boolean) {
			c_cell.pauseAnimate(yes);
			c_canvas.pauseAnimate(yes);
		}
		
		public function setAnimation(yes:Boolean) {
			if (yes) {
				c_cell.animateOn();
			}else {
				c_cell.animateOff();
			}
			animationOn = yes;
		}
		
		/**
		 * Takes a point in world space and transforms it into stage space
		 * @param	p the Point in world space
		 * @return the Point in stage space
		 */
		
		public function reverseTransformPoint(p:Point):Point {
			//do the opposite of transformPoint()
			p.x *= scale;
			p.y *= scale;
			
			p.x += c_objectLayer.x;
			p.y += c_objectLayer.y;
			
			p.x += x;
			p.y += y;
			return p;
		}
		
		/**
		 * Takes a point in stage space ( (0,0) to (640,480) ) and transforms it into world space
		 * @param	p the Point in stage space
		 * @return  the Point in world space
		 */
		
		public function transformPoint(p:Point):Point{
			//First, we have to line up the origins
			
			//Subtract the worlds own offset first
			p.x -= x;
			p.y -= y;
			
			//Subtract the objectLayer's own offset next
			p.x -= c_objectLayer.x;
			p.y -= c_objectLayer.y;
			
			//Now that origins are lined up, scale the point to the right location
			p.x /= scale;
			p.y /= scale;
			
			return p;
		}
		
		public function darkenAll() {
			for each(var item:Selectable in selectList) {
				if (!item.isSelected()) {
					item.darken();
				}
			}
		}
		
		public function undarkenAll() {
			for each(var item:Selectable in selectList) {
				item.undarken();
			}
		}
		
		
		
		public function selectStuff(p:Point, radius:Number) {
			p = transformPoint(p);
			radius /= scale;
			var radius2:Number = radius * radius;
			for each(var item:Selectable in selectList) {
				if(item.getCanSelect() && !item.getSingleSelect()){
					var r2:Number = item.getRadius();
					var dist2:Number = getDist2(p.x, p.y, item.x, item.y);
					
					if (dist2 < radius2+r2) {
						p_engine.selectMany(item);
					}
				}
			}
			p_engine.finishSelectMany();
		}
		
	}
	
}
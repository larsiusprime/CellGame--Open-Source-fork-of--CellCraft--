package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Cursor extends Sprite
	{
		public var action:int = Act.NOTHING;
		public var icon:MovieClip;
		public var reticle:MovieClip;
		public var text:TextField;
		public var text_2:TextField;
		public var cost:MiniCost;
		
		public var isArrow:Boolean = false;
		
		private var arrow_x:Number; //the starting point of the arrow
		private var arrow_y:Number;
		private var arrow_rotation:Number = 0;
		private var shape_arrow:Shape;
		private const ARROW_HEIGHT:Number = 15;
		
		private static const PPOD_RANGE:Number = Membrane.PPOD_ANGLE; //+- X degrees
		
		private var fancy:Boolean = false; //are we showing a context cursor
		//private var targetter:Targetter;
		
		private var p_engine:Engine;
		private var p_cell:Cell;
		private var p_world:World;
		
		public function Cursor() 
		{
			//addEventListener(Event.RENDER, followMouse);
			//addEventListener(Event.ENTER_FRAME, followMouse);
			//addEventListener(MouseEvent.MOUSE_MOVE, followMouse);
			//addEventListener(Event.EXIT_FRAME, followMouse);
			
			cost.setWhite();
			shape_arrow = new Shape();
			addChild(shape_arrow);
			setChildIndex(shape_arrow, 0);
			
		}
		public function setEngine(e:Engine) {
			p_engine = e;
		}
		
		public function setWorld(w:World) {
			p_world = w;
		}
		
		public function setCell(c:Cell) {
			p_cell = c;
		}
		
		/*public function initTargetter() {
			targetter = new Targetter();
			addChild(targetter);
			targetter.visible = false;
		}
		
		public function showTargetter(xx:Number, yy:Number) {
			targetter.x = xx;
			targetter.y = yy;
			targetter.visible = true;
		}
		
		public function hideTargetter() {
			targetter.visible = false;
		}*/
		
		public function followMouse(e:Event) {
			x = stage.mouseX;
			y = stage.mouseY;
			if (isArrow) {
				drawArrow();
			}
		}
		
		public function normal(yes:Boolean) {
			if(fancy){
				if (yes) {
					visible = false;
					Mouse.show();
				}else {
					visible = true;
					Mouse.hide();
				}
			}
		}
		
		/**
		 * Sets the icon to the appropriate action, and returns whether an icon is showing
		 * @param	i the icon numeric constant from Class Act.
		 * @return whether the icon is showing or not
		 */
		
		public function show(i:int = Act.NOTHING):Boolean{
			var s:String = Act.getS(i);
			//trace("Cursor.show : i = " + i + " s = " + s);
			var txt:String = Act.getTxt(i);
			action = i;
			if (s == "") {
				visible = false;
				Mouse.show();
				fancy = false;
				return false;
				action = Act.NOTHING;
			}else {
				fancy = true;
				text.text = txt.toUpperCase();
				visible = true;
				//text_2.text = "";
				
				icon.gotoAndStop(s);
				Mouse.hide();
				showContextAct(i);
				return true;
			}
			
		}
		
		private function showContextAct(i:int) {
			//trace("Cursor.showContextAct : i=" + i);
			switch(i) {
				case Act.MOVE: 
					showReticle("crosshairs");
					showMoveCost(); 
					break;
				case Act.BLEB:
					showReticle("triangles");
					showBlebCost();
					break;
				case Act.PSEUDOPOD_PREPARE:
					showReticle("triangles");
					hideCost();
					break;
				case Act.PSEUDOPOD:
					showReticle("arrowHead");
					startArrow();
					showPPodCost();
					break;
				default: 
					showReticle("crosshairs");
					hideCost(); 
					break;
			}
		}
		
		private function showReticle(s:String) {
			//trace("Cursor.showReticle : " + s);
			reticle.gotoAndStop(s);
			reticle.visible = true;
		}

		public function endArrow() {
			isArrow = false;
			shape_arrow.graphics.clear();
			arrow_rotation = 0;
			reticle.rotation = 0;
		}
		
		private function drawArrow() {
			
			
			//This block constrains the arrow to stay within the lens
			var p:Point = new Point(x, y);
			p = p_world.transformPoint(p);
			var dx:Number = p.x - GameObject.cent_x;
			var dy:Number = p.y - GameObject.cent_y;
			var d2:Number = (dx * dx) + (dy * dy);
			var r2:Number = World.LENS_R2;
			
			if (d2 >= r2) {
				
				var v:Vector2D = new Vector2D(arrow_x - x, arrow_y - y);
				v.normalize();
				v.multiply((World.LENS_SIZE * p_world._scale) -ARROW_HEIGHT);
				var pc:Point = new Point(GameObject.cent_x, GameObject.cent_y);
				pc = p_world.reverseTransformPoint(pc);
				x = pc.x - v.x;
				y = pc.y - v.y;
			}
			//World.LENS
			
			shape_arrow.graphics.clear();
			shape_arrow.graphics.lineStyle(9, 0);
			shape_arrow.graphics.moveTo(arrow_x - x, arrow_y - y); //draw the black line
			shape_arrow.graphics.lineTo(0, 0);
			
			var v1:Vector2D = new Vector2D(arrow_x-x, arrow_y-y);
			
			var ang:Number = v1.toRotation() * (180 / Math.PI);
			ang -= 90;
			
			//arrow_rotation is GUARANTEED to be between 0-360 as it is processed before it is set
			//make sure we do that with ang as well:
			if (ang < 0) {
				ang += 360;
			}else if (ang > 360) {
				ang -= 360;
			}
			
			reticle.rotation = ang;
			
			var angHigh:Number = arrow_rotation + PPOD_RANGE; //PPOD_RANGE -> 360+PPOD_RANGE
			var angLow:Number = arrow_rotation - PPOD_RANGE; //-PPOD_RANGE -> 360-PPOD_RANGE
					
			//check to see if we're within our range
			//if (ang < angHigh && ang > angLow) { //this is now reasonable, we know things will compare
				
				//if(Math.random() < (1/15))
				//	trace("Cursor.drawArrow() GOOD ang=" + ang + " arrow_rotation = " + arrow_rotation);
				
				showReticle("arrowHead");
				shape_arrow.graphics.lineStyle(7, 0xFFFFFF);
				shape_arrow.graphics.moveTo(arrow_x - x, arrow_y - y);
				shape_arrow.graphics.lineTo(0, 0);
				//reticle.visible = true;
			/*}else {
				//reticle.visible = false;
				if(Math.random() < (1/15))
					trace("Cursor.drawArrow() BAD ang=" + ang + " arrow_rotation = " + arrow_rotation);
				showReticle("redArrowHead");
				shape_arrow.graphics.lineStyle(7, 0xFF0000);
				shape_arrow.graphics.moveTo(arrow_x - x, arrow_y - y);
				shape_arrow.graphics.lineTo(0, 0);
			}*/
			
			cost.setAmount(p_cell.getPPodCost(stage.mouseX, stage.mouseY));

		}
		
		public function setArrowRotation(r:Number) {
			if (r < 0) {
				r += 360;
			}else if (r > 360) {
				r -= 360;
			}
			reticle.rotation = r;
			arrow_rotation = r;
		}
		
		public function setArrowPoint(xx:Number, yy:Number) {
			arrow_x = xx;
			arrow_y = yy;
		}
		
		private function startArrow() {
			isArrow = true;
		}
		
		private function hideCost() {
			cost.visible = false;
			text_2.text = "";
		}
		
		public function updateMoveCost(i:int = -1) {
			if(action == Act.MOVE){
				showMoveCost(i);
			}
		}
		
		private function showACost(s:String) {
			cost.visible = true;
			text_2.text = "Cost:";
			cost.setType(s);
		}
		
		
		
		private function showPPodCost() {
			showACost("atp");
			//var a:Array = Costs.PSEUDOPOD;
			//cost.setAmount(a[0]); //BE SURE TO INCORPORATE THE REST
			cost.setAmount(p_cell.getPPodCost(stage.mouseX, stage.mouseY));
		}
		
		private function showBlebCost() {
			
			showACost("atp");
			var a:Array = Costs.BLEB;
			cost.setAmount(a[0]);
			//trace("Cursor.showBlebCost " + a[0]);
		}
		
		private function showMoveCost(i:int = -1) {
			//text_2.visible = true;
			if(p_engine){
				showACost("atp");
				if(i == -1){
					cost.setAmount(p_engine.getMoveCost(stage.mouseX, stage.mouseY));
				}else {
					cost.setAmount(i);
				}
			}
		}
		
	}
	
}
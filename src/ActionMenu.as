package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ActionMenu extends Sprite
	{
		private var list_butt:Vector.<CircleButton>;
		private var list_points:Vector.<Number>;
		private var list_actions:Vector.<int>;
		
		
		private var radius:Number = 50;
		
		private var p_interface:Interface;
		
		private var shown:Boolean = false;
		private var shape:Shape;
		
		private var animateCount:Number = 0;
		private var animateAccel:Number = 0;
		
		public function ActionMenu() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.CLICK, click);
			shape = new Shape();
			addChild(shape);
		}
		
		include "inc_fastmath.as";
		
		public function destruct() {
			p_interface = null;
			for each(var butt:CircleButton in list_butt) {
				removeChild(butt);
				butt = null;
			}
			for each(var point:Point in list_points) {
				point = null;
			}
			list_butt = null;
			list_points = null;
			list_actions = null;
		}
		
		public function doShowActions() {
			if(list_actions){
				show();
			}
		}
		
		public function showCost(s:String) {
			//trace("ActionMenu.showCost(+" + s + ")");
			p_interface.p_engine.onShowActionCost(s);
			p_interface.showActionCost(s);
		}
		
		public function hideCost() {
			//trace("ActionMenu.hideCost()");
			p_interface.hideActionCost();
		}
		
		public function setInterface(i:Interface) {
			p_interface = i;
		}
		
		public function waitShowActions(list:Vector.<int>, xx:Number, yy:Number) {
			setActions(list);
			x = xx;
			y = yy;
		}
		
		public function setActions(list:Vector.<int>) {
			list_actions = list.concat();
		}
		
		private function click(m:MouseEvent) {
			m.stopPropagation();
		}
		
		private function mouseDown(m:MouseEvent) {
			m.stopPropagation();
		}
		
		private function show() {
			shown = true;
			clearButtons();
			list_points = new Vector.<Number>();
			if (list_actions) {
				var j:int = 0;
				for (var i:int = 0; i < list_actions.length; i++) {
					if(list_actions[i] != Act.NOTHING){
						list_points[j] = CircleButton.SIZE * i;
						list_points[j + 1] = 0;
						makeButton(list_actions[i]);
						j += 2;
					}
				}
			}
				
			animateCount = 0.1;
			animateAccel = 0.5;
			quickShow();
			//addEventListener(Event.ENTER_FRAME, animateRing);
			
		}
		
		private function quickShow() {
			var count:int = 0; 	
			for each(var c:CircleButton in list_butt) {
				c.x = list_points[count];
				c.y = list_points[count+1];
				count+=2;
			}
		}
		
		private function animateRing(e:Event) {
			animateCount *= (1 + animateAccel);
			animateAccel *= 0.9;
			if (animateAccel < 0.1)
				animateAccel = 0.1;
			var count:int = 0;
			for each(var c:CircleButton in list_butt) {
				c.x = list_points[count] * animateCount;
				c.y = list_points[count+1] * animateCount;
				count+=2;
			}
			if (animateCount > 1) {
				animateCount = 0;
				removeEventListener(Event.ENTER_FRAME, animateRing);
			}
		}
		
		private function drawCross() {
			shape.graphics.clear();
			shape.graphics.lineStyle(2, 0xFFFFFF);
			shape.graphics.moveTo( -10, 0);
			shape.graphics.lineTo(10, 0);
			shape.graphics.moveTo(0, -10);
			shape.graphics.lineTo(0, 10);
		}
		
		public function hide() {
			shown = false;
			clearButtons();
		}
		
		public function isShown():Boolean {
			return shown;
		}
		
		private function clearButtons() {
			if(list_butt){
				for each(var b:CircleButton in list_butt) {
					if (b) {
						removeChild(b);
						b = null;
					}
				}
			}
			list_butt = new Vector.<CircleButton>;
		}
		
		private function makeButton(action:int) {
			var c = new CircleButton();
			c.setAction(action);
			c.x = 0;
			c.y = 0;
			c.setMenu(this);
			addChild(c);
			list_butt.push(c);
		}
		
		private function makeButtonAt(action:int, xx:Number, yy:Number) {
			var c = new CircleButton();
			c.setAction(action);
			c.x = xx;
			c.y = yy;
			addChild(c);
			list_butt.push(c);
		}
		
		public function doAction(i:int, s:String) {
			//trace("ActionMenu.doAction(" + i + "," + s + ")");
			p_interface.doAction(i,s);
		}
		
	}
	
}
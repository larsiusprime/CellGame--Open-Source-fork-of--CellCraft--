package  
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class BasicUnit extends CellObject
	{
		public var isBusy:Boolean;
		public static var C_GRAV_R2:Number = 1;
		
		public static const RIBOSOME:int = 0;
		public static const LYSOSOME:int = 1;
		public static const PEROXISOME:int = 2;
		public static const SLICER:int = 3;
		public static const DNAREPAIR:int = 4;
		

		
		public function BasicUnit() 
		{
			is_basicUnit = true;
			might_collide = false;
		}
		
		public static function updateCGravR2(n:Number) {
			C_GRAV_R2 = n;
		}
		
		public override function externalMoveToPoint(p:Point, i:int) {
			if (!isBusy) {
				moveToPoint(p, i);
			}
		}

		/*
		public override function moveToObject(obj:GameObject, i:int, free:Boolean = false) {
			super.moveToObject(obj, i, free);
		}
		
		public override function moveToPoint(p:Point, i:int, free:Boolean = false) {
			super.moveToPoint(p, i, free);
		}*/
		
		protected override function doMoveToGobj(e:Event) {
			super.doMoveToGobj(e);
			updateCollide();
		}
		
		protected override function doMoveToPoint(e:Event) {
			super.doMoveToPoint(e);
			updateCollide();
		}
		
		protected function updateCollide() {
			var dx:Number = x - cent_x;
			var dy:Number = y - cent_y;
			var d2:Number = (dx*dx) + (dy * dy);
			if (d2 > C_GRAV_R2*0.5) {
				might_collide = true;
				//trace("BasicUnit.mightCollide() " + name + " might collide!");
				if(doesCollide){
					updateLoc();
				}
			}else {
				might_collide = false;
			}
		}
		
		/*public override function updateLoc() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			updateGridLoc(xx, yy);
		}*/
		
	}
	
}
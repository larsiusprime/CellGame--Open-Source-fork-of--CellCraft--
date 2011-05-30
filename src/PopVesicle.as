package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class PopVesicle extends BigVesicle
	{
		public var iteration:int = 1;
		
		public var popRadius:Number;
		
		private const SPEED:Number = 2;
		private const DIST:Number = 40;
		
		public function PopVesicle(size:Number,i:int) 
		{
			super(size);
			popRadius = size;
			setRadius(size);
			iteration = i;
			speed = SPEED * iteration;
			
		}
		
		public function startPopping(v:Vector2D) {
			var p:Point = new Point(x + (v.x * DIST * iteration), y + (v.y * DIST * iteration));
			//var p:Point = new Point(x + ((v.x) * (DIST)), y + ((v.y) * (DIST)));
			moveToPoint(p, FLOAT, true);
		}
		
		protected override function arrivePoint() {
			//trace("PopVesicle.arrivePoint() " + this.name);
			super.arrivePoint();
			p_cell.popVesicle(this);
			
		}
		
		
		
		
		
		
		
	}
	
}
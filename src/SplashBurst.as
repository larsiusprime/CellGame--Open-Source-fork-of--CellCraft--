package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class SplashBurst extends CellObject
	{
		public var iteration:int = 1;
		
		public var popRadius:Number;
		
		private const SPEED:Number = 2;
		private const DIST:Number = 40;
		

		
		public function SplashBurst() 
		{
		//speed = SPEED * iteration;
			
		}
		
		public function startPopping() {
			//var p:Point = new Point(x + (v.x * DIST * iteration), y + (v.y * DIST * iteration));
			//var p:Point = new Point(x + ((v.x) * (DIST)), y + ((v.y) * (DIST)));
			//moveToPoint(p, FLOAT, true);
			var i:int = Math.floor(Math.random() * 3);
			switch(i) {
				case 0: playAnim("pop"); break;
				case 1: playAnim("pop1"); break;
				case 2: playAnim("pop2"); break;
				default: playAnim("pop"); break;
			}
			//playAnim("pop");
		}
		
		public override function onAnimFinish(i:int, stop:Boolean = true) {
			switch(i) {
				case ANIM_POP: destroy();  break;
			}
		}
		
		private function destroy() {
			p_cell.killSplashBurst(this);
		}
		
		protected override function arrivePoint(wasCancel:Boolean=false) {
			//trace("PopVesicle.arrivePoint() " + this.name);
			super.arrivePoint(wasCancel);
			
			//p_cell.popVesicle(this);
			
		}
		
	}
	
}
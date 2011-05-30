package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class DockPoint extends Point
	{
		public var busy:Boolean = false;
		public var index:int = 0;
		public var BUSY_TIME:Number = 30*5; //5 seconds
		public var busy_count:Number = 0;
			
		public function DockPoint() 
		{
			
		}
		
		public function makeBusy() {
			busy = true;
			busy_count = 0;
		}
		
		public function unBusy() {
			busy = false;
			busy_count = 0;
		}
		
		public function setBusyTime(i:int) {
			BUSY_TIME = i;
		}
		
		public function busyCount() {
			if(busy){
				busy_count++;
				if (busy_count > BUSY_TIME) {
					busy = false;
					busy_count = 0;
				}
			}
		}
		
		public function copy():DockPoint {
			var d:DockPoint = new DockPoint();
			d.x = x;
			d.y = y;
			d.busy = busy;
			d.index = index;
			return d;
		}
		
	}
	
}
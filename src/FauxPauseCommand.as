package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class FauxPauseCommand 
	{
		public static const ZOOM:int = 0;
		public static const SCROLL_TO:int = 1;
		
		
		public var id:int;
		
		public var x:Number;
		public var y:Number;
		public var ox:Number;
		public var oy:Number;
		public var dx:Number;
		public var dy:Number;
		
		public var time:int;
		public var elapsed:int = 0;
		
		public var value:Number;
		public var ovalue:Number;
		public var dvalue:Number;
		
		public function FauxPauseCommand(i:int,param:*,t:int) 
		{
			id = i;
			time = t;
			switch(id) {
				case SCROLL_TO: 
							var p:Point = Point(param);
							x = p.x; y = p.y; break;
				case ZOOM: 	value = Number(param); break;
			}
		}
		
		public function calcZoom(currZoom:Number) {
			ovalue = currZoom;
			dvalue = (value - currZoom)/time;
		}
		
		public function calcScrollTo(currX:Number, currY:Number) {
			ox = currX;
			oy = currY;
			dx = (x - ox) / time;
			dy = (y - oy) / time;
		}
		
		
	}
	
}
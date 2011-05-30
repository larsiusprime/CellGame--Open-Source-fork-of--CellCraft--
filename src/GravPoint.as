package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class GravPoint extends Point
	{
		public var p_obj:CellObject; //the thing I represent
		public var radius:Number;    //no protection, do it right!
		public var radius2:Number; 
		
		public function GravPoint(p:Point=null,c:CellObject=null,r:Number=50) 
		{
			x = p.x;
			y = p.y;
			p_obj = c;
			radius = r;
			radius2 = r * r;
		}
			
		public function destruct() {
			p_obj = null;
		}
		
		public function copy():GravPoint {
			var g:GravPoint = new GravPoint(new Point(x, y), p_obj, radius);
			return g;
		}
		
		
	}
	
}
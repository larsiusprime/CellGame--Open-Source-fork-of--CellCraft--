package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class WorldMask extends Sprite
	{
		var shape:Shape;
		private var size:Number;
		
		public function WorldMask() 
		{
			shape = new Shape();
			addChild(shape);
			setSize(250);
		}
	
		public function setSize(n:Number) {
			size = n;
			//trace("WorldMask.setSize " + n);
			shape.graphics.clear();
			shape.graphics.lineStyle(1, 0);
			shape.graphics.beginFill(0,1);
			shape.graphics.drawCircle(0, 0, n);
			shape.graphics.endFill();
		}
		
		public function getSize():Number {
			return size;
		}
	}
	
}
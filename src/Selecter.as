package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Selecter extends Sprite
	{
		private var shape:Shape;
		private var size:Number = 1;
		public static const MIN_SIZE:Number = 10;
		
		//include our fast math functions locally
		include "inc_fastmath.as"
		
		public function Selecter() 
		{
			shape = new Shape();
			addChild(shape);
		}
		
		public function growAt(xx:Number, yy:Number) {
			x = xx;
			y = yy;
			size = MIN_SIZE/2;
			visible = true;
			draw();
		}
		
		public function growTo(xx:Number, yy:Number) {
			size = getDist(x, y, xx, yy);
			draw();
		}
		
		public function stopGrow() {
			visible = false;
		}
		
		public function reset() {
			size = 0;
			x = 0;
			y = 0;
		}
		
		public function getSize() {
			return size;
		}
		
		public function draw() {
			shape.graphics.clear();
			if(size > MIN_SIZE){
				shape.graphics.beginFill(0xFFFFFF, 0.5);
				shape.graphics.lineStyle(2, 0xFFFFFF);
				shape.graphics.drawCircle(0, 0, size);
			}
		}
		
	}
	
}
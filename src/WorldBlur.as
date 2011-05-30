package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class WorldBlur extends Sprite
	{
		var shape:Shape;
		
		public function WorldBlur() 
		{
			shape = new Shape();
			addChild(shape);
			setSize(250);
			var blur:BlurFilter = new BlurFilter(20, 20);
			this.filters.push(blur);
		}
		
		public function setSize(n:Number) {
			shape.graphics.clear();
			shape.graphics.lineStyle(50, 0);
			shape.graphics.drawCircle(0, 0, n*.9);
		}
		
	}
	
}
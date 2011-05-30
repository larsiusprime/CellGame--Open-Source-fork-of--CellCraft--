package   
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class StarMeter extends Sprite
	{
		public var star1:Star;
		public var star2:Star;
		public var star3:Star;
		public var star4:Star;
		public var star5:Star;
		
		public var list_star:Vector.<Star>;
		
		public function StarMeter() 
		{
			list_star = new Vector.<Star>;
			list_star = Vector.<Star>([star1, star2, star3, star4, star5]);
		}
		
		public function setLevel(l:int,max:int) {
			var i:int = 1;
			for each(var star:Star in list_star){
				if (max >= i) {
					star.visible = true;
					if (l >= i) {
						star.bit.visible = true;
					}else {
						star.bit.visible = false;
					}
				}else {
					star.visible = false;
				}
				i++;
			}
		}
		
		
	}
	
}
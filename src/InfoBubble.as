package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class InfoBubble extends Sprite
	{
		public var icon:MovieClip;
		
		public function InfoBubble() 
		{
			
		}
		
		public function setIcon(s:String) {
			icon.gotoAndStop(s);
		}
		
		public function matchZoom(z:Number) {
			scaleX = 1/z;
			scaleY = 1/z;
		}
		
	}
	
}
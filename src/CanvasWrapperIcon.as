package  
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CanvasWrapperIcon extends MovieClip
	{
		public var clip:MovieClip;
		
		public function CanvasWrapperIcon() 
		{
			
		}
		
		public function getRadius():Number {
			if (clip.width > clip.height) {
				return clip.width/2;
			}else {
				return clip.height/2;
			}
		}
		
	}
	
}
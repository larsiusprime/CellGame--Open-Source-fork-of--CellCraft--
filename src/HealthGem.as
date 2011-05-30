package  
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class HealthGem extends MovieClip
	{
		
		public var c_text:TextField;
		
		public function HealthGem() 
		{
			amount = 100;
		}
		
		public function set amount(i:int) {
			c_text.text = i.toString();
			gotoAndStop(i + 1);
		}
		
	}
	
}
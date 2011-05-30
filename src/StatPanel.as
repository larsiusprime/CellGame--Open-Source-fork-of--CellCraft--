package   
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class StatPanel extends MovieClip
	{
		public var c_health:MeterBar_health;
		public var c_infest:MeterBar_infest;
		//public var text_level:TextField;
		public var c_level:StarMeter;
		
		public function StatPanel() 
		{
			
		}
		
		public function setHealth(a:int,m:int) {
			c_health.setAmounts(a, m);
		}
		
		public function setInfest(a:int, m:int) {
			c_infest.setAmounts(a, m);
		}
		
		public function setLevel(n:int,max:int) {
			/*if(text_level)
				text_level.htmlText = "<b>" + String(n) + "</b>";*/
			if (c_level)
				c_level.setLevel(n, max);
			//debug for now
			c_level.visible = false;
		}
		
	}
	
}
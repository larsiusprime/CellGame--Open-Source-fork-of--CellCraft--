package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class TimeGem extends MovieClip
	{
		public var c_txt:TextField;
		//public var c_bkg:MovieClip;
		
		public var time:Number = 100;
		public var max_time:Number = 100;
		
		
		public function TimeGem() 
		{
			//c_bkg.gotoAndStop(1);
		}
		
		public function setMaxTime(i:int) {
			max_time = i;
		}
		
		public function setTime(i:int) {
			time = i;
			if(i > 0){
				visible = true;
				var n:Number = (time / max_time) * 100;
				//c_bkg.gotoAndStop(1 + int(n));
				c_txt.text = i.toString();
				
			}else {
				//trace("TimeGem.setTime(0) INVISIBLE!");
				visible = false;
			}
			
		}
		
		public function refresh() {
			setTime(time);
		}
		
	}
	
}
package  
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class TalkGlass extends MovieClip
	{
		public var c_talker:MovieClip;
		public var c_text:TextField;
		public var timer:Timer;
		public var theText:String = "";
		public var person:String = "";
		
		public function TalkGlass() 
		{
			timer = new Timer(1000 / 30, 30);
			stop();
			visible = false;
		}
		
		public function setTalk(talker:String="spike",emotion:String="normal") {
			alpha = 1;
			visible = true;
			gotoAndPlay(1);
			theText = talker.toUpperCase();
			//theText = "" + count + " " + typeToString(type) + " detected!";
			c_text.text = "";
			c_talker.gotoAndStop("none");
			person = talker + "_" + emotion;
		}
		
		public function onVisible() {
			c_text.htmlText = "<b>" + theText + "</b>";
			c_talker.gotoAndStop(person);
		}
		
		public function onFinish() {
			alpha = 1;
			
			timer.addEventListener(TimerEvent.TIMER, doFade);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, finishFade);
			timer.start();
		}
		
		private function doFade(t:TimerEvent) {
			alpha -= 1 / 30;
		}
		
		private function finishFade(t:TimerEvent) {
			visible = false;
			alpha = 1;
			gotoAndStop(1);
			
			timer.removeEventListener(TimerEvent.TIMER, doFade);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, finishFade);
		}
		
	}
	
}
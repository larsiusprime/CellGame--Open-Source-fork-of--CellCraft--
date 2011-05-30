package   
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MessageBar extends InterfaceElement
	{
		private var shown:Boolean = false;
		public var clip:MovieClip;
		public var c_timeGem:TimeGem;
		private var timer:Timer;
		private var waitTime:int = 5000; //5 seconds
		//public static var waitFrames:int = (waitTime / 1000) * 30;
		
		public static const NOTHING:int = -1;
		public static const NORMAL:int = 0;
		public static const ALERT:int = 1;
		public static const SPEECH:int = 2;
		public static const ENEMY_WARNING:int = 3;
		
		private var list_next:Vector.<int>;
		private var list_alert:Vector.<String>;
		private var list_message:Vector.<String>;
		private var list_speech:Vector.<String>;
		private var list_warning:Vector.<String>;
		
		public function MessageBar() 
		{
			//trace("MessageBar.MessageBar()!");
		
		}
		
		public function init() {
			timer = new Timer(waitTime, 0);
			timer.addEventListener(TimerEvent.TIMER, onTime, false, 0, true);
			list_alert = new Vector.<String>;
			list_message = new Vector.<String>;
			list_speech = new Vector.<String>;
			list_warning = new Vector.<String>;
			list_next = new Vector.<int>;
			forceHide();
			setTimeGemTime(0);
			setText("");
		}
		
		public function tetTimeGemMaxTime(i:int) {
			c_timeGem.setMaxTime(i);
		}
		
		public function setTimeGemTime(i:int) {
			c_timeGem.setTime(i);
		}
		
		public function changeTime(t:int) {
			waitTime = t;
			
			timer.delay = waitTime;
		}
		
		private function onTime(t:TimerEvent) {
			doHide();
			timer.reset();
		}
		
		private function setText(s:String) {
			clip.clip.c_text.text = s;
		}
		
		private function pushAlert(str:String) {
			list_alert.push(str);
			list_next.push(ALERT);
		}
		
		private function pushWarning(str:String) {
			list_warning.push(str);
			list_next.push(ENEMY_WARNING);
		}
		
		private function pushMessage(str:String) {
			list_message.push(str);
			list_next.push(NORMAL);
		}
		
		private function pushSpeech(str:String) {
			list_speech.push(str);
			list_next.push(SPEECH);
		}
		
		public function isShown():Boolean {
			return shown;
		}
		
		public function showText(str:String, state:int = NORMAL) {
			if(!shown){
				var s:String;
				switch(state) {
					case ENEMY_WARNING: s = "danger"; break;
					case ALERT: s = "alert";  break;
					case NORMAL: s = "normal"; break;
					case SPEECH: s = "speech"; break;
					default: s = "normal";
				}
				clip.gotoAndPlay("show");
				c_timeGem.gotoAndPlay("show");
				c_timeGem.refresh();
				clip.clip.gotoAndStop(s); 
				setText(str);
				timer.start();
				shown = true;
				p_master.onShowMessageBar(str);
			}else {
				switch(state) {
					case ENEMY_WARNING: pushWarning(str); break;
					case ALERT: pushAlert(str);  break;
					case NORMAL: pushMessage(str);  break;
					case SPEECH: pushSpeech(str);  break;
				}
			}
		}
		
		private function showNextText() {
			var nextThing:int = list_next[0];
			list_next.splice(0, 1);
			switch(nextThing) {
				case ALERT: showText(list_alert[0], ALERT); 
					list_alert.splice(0, 1);
					break;
				case NORMAL: showText(list_message[0], NORMAL); 
					list_message.splice(0, 1);
					break;
				case SPEECH: showText(list_speech[0], SPEECH); 
					list_speech.splice(0, 1);
					break;
				case ENEMY_WARNING: showText(list_warning[0], ENEMY_WARNING);
					list_warning.splice(0, 1);
					break;
			}
		}
		
		public function onHide() {
			shown = false;
			if (list_next.length > 0) {
				showNextText();
			}
		}
		
		private function doHide() {
			clip.gotoAndPlay("hide");
			c_timeGem.gotoAndPlay("hide");
			c_timeGem.refresh();
		}
		
		private function forceHide() {
			clip.gotoAndStop("hidden");
			c_timeGem.gotoAndStop("hidden");
			c_timeGem.refresh();
			shown = false;
		}
		
	}
	
}
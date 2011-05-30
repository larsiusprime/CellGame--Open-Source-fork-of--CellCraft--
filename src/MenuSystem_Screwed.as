package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_Screwed extends MenuSystem
	{
		public var butt_retry:SimpleButton;
		public var butt_play:SimpleButton;
		public var content:MovieClip;
		
		public static const NO_MITO:String = "no_mito";
		public static const NO_CHLORO:String = "no_chloro";
		
		public function MenuSystem_Screwed() 
		{
			butt_retry.addEventListener(MouseEvent.CLICK, onRetry, false, 0, true);
			butt_play.addEventListener(MouseEvent.CLICK, onPlay, false, 0, true);
		}
		
		public override function destruct() {
			butt_retry.removeEventListener(MouseEvent.CLICK, onRetry);
			butt_play.removeEventListener(MouseEvent.CLICK, onPlay);
			removeChild(butt_retry);
			removeChild(butt_play);
			removeChild(content);
			super.destruct();
		}
		
		public function setData(a:Array) {
			gotoAndStop(a[0]);
			content.gotoAndStop(a[1]);
		}
		
		private function onPlay(m:MouseEvent) {
			exit();
		}
		
		private function onRetry(m:MouseEvent) {
			p_director.resetGame();
			exit();
		}
		
	}
	
}
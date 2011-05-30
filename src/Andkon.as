package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Andkon extends MovieClip
	{
		
		public function Andkon() 
		{
			if (Director.SITE_LOCK_SITEB) {
				addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				buttonMode = true;
				useHandCursor = true;
			}
		}
		
		private function onClick(m:MouseEvent):void {
			if (Director.STATS_ON) { Log.CustomMetric("click_andkon_splash", "sponsor");}
			var url:String = "http://www.andkon.com/arcade/";
			openURL(url);
		}
		
		
		private function openURL(url:String) {
			var request:URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, '_blank'); // second argument is target
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
	}
	
}
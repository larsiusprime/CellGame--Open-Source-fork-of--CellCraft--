package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class SponsorLogoLive extends Sprite
	{
		//public var c_logo_a:MovieClip;
		//public var c_logo_b:MovieClip;
		public var btn:SimpleButton;
		public var id:String = "";
		
		public function SponsorLogoLive() 
		{
			if (Director.SITE_LOCK_SITEA) {
			/*
				c_logo_a.buttonMode = true;
				c_logo_a.useHandCursor = true;
				c_logo_a.visible = true;
				btn.visible = false;
				c_logo_a.addEventListener(MouseEvent.CLICK, onClickSiteA, false, 0, true);
				c_logo_b.visible = false;
			*/
			}else if (Director.SITE_LOCK_SITEB) {
			/*  c_logo_b.buttonMode = true;
				c_logo_b.useHandCursor = true;
				c_logo_b.visible = true;
				btn.visible = false;
				c_logo_b.addEventListener(MouseEvent.CLICK, onClickSiteB, false, 0 , true);
				c_logo_a.visible = false;
			*/
			}else {
				btn.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				btn.visible = true;
				//c_logo_a.visible = false;
				//c_logo_b.visible = false;
			}
		}
		
		public function onClickSiteB(m:MouseEvent) {
			if (Director.STATS_ON) { Log.CustomMetric("click_b_" + id, "sponsor");}
			var url:String = "http://www.example.com/";
			openURL(url);
		}
		
		public function onClickSiteA(m:MouseEvent) {
			if (Director.STATS_ON) { Log.CustomMetric("click_b_" + id, "sponsor");}
			var url:String = "http://www.example.com";
			openURL(url);
		}
		
		public function onClick(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("click_sponsor_" + id, "sponsor");}
			var url:String = "http://www.example.com/";
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
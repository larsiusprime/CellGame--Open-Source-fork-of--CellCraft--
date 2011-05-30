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
	public class SponsorLogo extends Sprite
	{
		public var c_logo_armor:MovieClip;
		public var btn:MovieClip;
		public var id:String = "";
		
		public function SponsorLogoLive() 
		{
			if (Director.SITE_LOCK_ARMOR_GAMES) {
				c_logo_armor.visible = true;
				btn.visible = false;
			}else {
				btn.visible = true;
				c_logo_armor.visible = false;
			}
		}
		

		
	}
	
}
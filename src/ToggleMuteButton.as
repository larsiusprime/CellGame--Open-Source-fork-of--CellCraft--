package  
{
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ToggleMuteButton extends ToggleButton
	{
		
		public function ToggleMuteButton() 
		{
			if (MenuSystem_InGame._muteMusic && MenuSystem_InGame._muteSound) {
				this.setIsUp(false);
			}else{
				this.setIsUp(true);
			}
			
		}
		
		protected override function onDown() {
			if(Director.STATS_ON){Log.CustomMetric("mute_all_true", "sound");}
			Director.setMusicMute(true);
			Director.setSFXMute(true);
			MenuSystem_InGame._muteMusic = true;
			MenuSystem_InGame._muteSound = true;
		}
		
		protected override function onUp() {
			if(Director.STATS_ON){Log.CustomMetric("mute_all_false", "sound");}
			Director.setSFXMute(false);
			Director.setMusicMute(false);
			MenuSystem_InGame._muteMusic = false;
			MenuSystem_InGame._muteSound = false;
		}
		
	}
	
}
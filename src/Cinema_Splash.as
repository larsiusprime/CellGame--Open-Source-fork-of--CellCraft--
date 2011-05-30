package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Cinema_Splash extends Cinema
	{
		import com.pecSound.*;
		
		public function Cinema_Splash() 
		{
			
		}
		
		public override function startCinema() {
			super.startCinema();
			//Director.startSFX(SoundLibrary.SFX_TITLE, false);
		}
		
		public override function finishCinema() {
			//Director.stopSFX(SoundLibrary.SFX_TITLE_OPENER);
			Director.stopAllSFX();
			super.finishCinema();
		}
		
		public function playTitleHit() {
			//
		}
		
		public function playTitleOpener() {
			Director.startSFX(SoundLibrary.SFX_TITLE_OPENER, false);
		}
		
	}
	
}
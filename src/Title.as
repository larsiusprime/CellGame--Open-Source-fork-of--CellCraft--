package 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import com.pecSound.SoundLibrary;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import SWFStats.*;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Title extends MovieClip 
	{
		public var director:Director;
		
		public var buttPlayGame:SimpleButton;
		public var buttCredits:SimpleButton;
		public var buttEncyclopedia:SimpleButton;
		public var buttCellcraft:SimpleButton;
		
		public var sponsor:SponsorLogoLive;
		public var c_butt_mute:ToggleMuteButton;
		public var version_txt:TextField;
		
		public function Title() {
			center();
			onTitleStart();
			version_txt.text = "Version " + Director.VERSION_STRING;
		}
		
		public function onTitleStart() {
			
			Director.startSFX(SoundLibrary.SFX_TITLE_HIT);
			Director.startMusic(SoundLibrary.MUS_TITLE, true);
			submitStats();
			if (Director.SITE_LOCK_SITEA || Director.SITE_LOCK_SITEB) {
				buttCellcraft.visible = false;
			}
		}
		
		private function submitStats() {
			var max_level:int = LevelProgress.getMaxLevelBeaten();
			for (var i:int = 0; i <= max_level; i++) {
				if (LevelProgress.getLevelBeaten(i)) {
					if(Director.KONG_ON){Director.kongregate.stats.submit("level_beaten_" + i, 1);}
					var time:int = LevelProgress.getLevelTime(i);
					var grade:int = LevelProgress.getLevelGrade(i);
					if (time != LevelProgress.FOREVER) { if(Director.KONG_ON){Director.kongregate.stats.submit("level_seconds_" + i, time);} }
					if (grade != -1) { if(Director.KONG_ON){Director.kongregate.stats.submit("level_grade_" + i, grade);} }
				}
			}
			if (LevelProgress.getGameBeaten()) {
				if(Director.KONG_ON){Director.kongregate.stats.submit("game_beaten", 1)};
			}
		}
		
		public function destruct() {
			Director.stopMusic();
		}
		
		public function setDirector(d:Director) {
			director = d;
		}
		
		public function onAnimFinish() { //when the animation finishes
			setupButtons();
		}
		
		private function setupButtons() {
			if(sponsor){
				sponsor.id = "title";
			}
			buttPlayGame.removeEventListener(MouseEvent.CLICK, goPlayGame);
			buttCredits.removeEventListener(MouseEvent.CLICK, goCredits);
			buttCellcraft.removeEventListener(MouseEvent.CLICK, goCellcraft);
			buttEncyclopedia.addEventListener(MouseEvent.CLICK, goEncyclopedia);
			
			buttPlayGame.addEventListener(MouseEvent.CLICK, goPlayGame,false,0,true);
			buttCredits.addEventListener(MouseEvent.CLICK, goCredits, false, 0, true);
			buttCellcraft.addEventListener(MouseEvent.CLICK, goCellcraft, false, 0, true);
			
			if (Director.SITE_LOCK_SITEA || Director.SITE_LOCK_SITEB) {
				buttCellcraft.visible = false;
			}
			
			buttEncyclopedia.addEventListener(MouseEvent.CLICK, goEncyclopedia, false, 0, true);
			
			if (MenuSystem_InGame._muteMusic && MenuSystem_InGame._muteSound) {
				c_butt_mute.setIsUp(false);
			}else {
				c_butt_mute.setIsUp(true);
			}
		}
		
		public function center() {
			/*var xoff:Number = 0;
			var yoff:Number = 0;
			xoff = -(width - Director.STAGEWIDTH) / 2;
			yoff = -(height - Director.STAGEHEIGHT) / 2;
			x += xoff;
			y += yoff;*/
		}
		
		/*private function goTutorial(m:MouseEvent) {
			trace("Title: goTutorial");
		}*/
		
		private function goOptions(m:MouseEvent) {
			trace("Title: goOptions");
		}
		
		private function goPlayGame(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("title_play_game", "title");}
			trace("Title: goPlayGame");
			director.goPlayGame();
		}
		
		private function goCredits(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("title_show_credits", "title");}
			trace("Title: goCredits");
			director.showCinema(Cinema.SCENE_CREDITS);
		}
		
		private function goEncyclopedia(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("title_show_encyclopedia", "title");}
			if(Director.STATS_ON){Log.CustomMetric("encyclopedia_open_title", "encyclopedia");}
			trace("Title: goEncyclopedia");
			director.showMenu(MenuSystem.ENCYCLOPEDIA,"root");
		}
		
		private function goCellcraft(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("click_cellcraft_site", "title");}
			var url:String = "http://www.cellcraftgame.com";
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
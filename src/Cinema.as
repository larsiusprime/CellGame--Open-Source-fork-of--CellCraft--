package  
{
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Cinema extends MovieClip
	{
		protected var p_director:Director;
		
		public static const NOTHING:int = -1;
		public static const SPLASH:int = 0;
		
		//open source test scene
		public static const SCENE_A:int = 1;
		
		
		//These are not used in the open source version
			public static const SCENE_LAB_INTRO:int = 1;
			public static const SCENE_LAB_BOARD:int = 2;
			public static const SCENE_LAUNCH:int = 3;
			public static const SCENE_CRASH:int = 4;
			public static const SCENE_LAND_CROC:int = 5;
		
		
		public static const SCENE_FINALE:int = 6;
		public static const SCENE_CREDITS:int = 9;
		
		
		public static const MITOSIS:int = 100;
		
		private var colorTrans:ColorTransform;
		private var fadeRate:Number = 0;
		private var fadeBlack:Boolean = true;
		private var navigation:CinemaNavigator;
		
		private var atHalt:Boolean = false;
		
		private var myIndex:int;
		protected var myMusic:int = SoundLibrary.NOTHING;
		
		public function Cinema() 
		{
			stop();
			navigation = new CinemaNavigator();
			addChild(navigation);
			colorTrans = this.transform.colorTransform;
		}
		
		public function destruct() {
			
		}
		
		public function setDirector(d:Director) {
			p_director = d;
		}
		
		public function setIndex(i:int) {
			myIndex = i;
		}
		
		public function startCinema() {
			Mouse.show();
			x = 0;
			y = 0;
			
			startMusic();
			play();
			if(Director.STATS_ON){Log.CustomMetric("cinema_start_" + getName(myIndex), "cinema");}
		}
		
		public function replay() {
			gotoAndPlay(1);
			startMusic();
		}
		
		
		public function readyCinema() {
			navigation.readyCinema();
			navigation.setIndex(myIndex);
		}
		
		private function startMusic() {
			if (myMusic != SoundLibrary.NOTHING) {
				if(myIndex != SCENE_FINALE){
					Director.startMusic(myMusic, true);
				}else {
					Director.startMusic(myMusic, false);
				}
			}
		}
		
		private function stopMusic() {
			if (myMusic != SoundLibrary.NOTHING) {
				Director.stopMusic();
			}
		}
	
		public function pause() {
			Director.pauseMusic(true);
			stop();
		}
		
		public function forFinalCinema() {
			navigation.forFinalCinema();
			//trace("Cinema.forFinalCinema() navigation = " + navigation);
			setChildIndex(navigation, numChildren - 1);
			
			navigation.visible = true;
		}
		
		public function haltForFinalCinema() {
			atHalt = true;
			stop();
			navigation.haltForFinalCinema();
		}
		
		public function halt() {
			atHalt = true;
			stop();
			navigation.halt();
		}
		
		public function showNext() {
			atHalt = false;
			navigation.showNext();
		}
		
		public function unPause() {
			//trace("unpause!");
			//Director.startMusicAt(
			Director.pauseMusic(false);
			if(!atHalt){
				play();
			}
		}
	
		public function finishCinema() {
			stop();
			atHalt = true;
			stopMusic();
			p_director.onFinishCinema();
			if(Director.STATS_ON){Log.CustomMetric("cinema_finish_" + getName(myIndex), "cinema");}
		}
		
		public function skipCinema() {
			finishCinema();
			if(Director.STATS_ON){Log.CustomMetric("cinema_skip_" + getName(myIndex), "cinema");}
		}
		
		public static function getName(i:int):String {
			switch(i) {
				case SCENE_A: return "a";
				case SCENE_CRASH: return "crash"; 
				case SCENE_CREDITS: return "credits";
				case SCENE_FINALE: return "finale";
				case SCENE_LAB_BOARD: return "lab_board";
				case SCENE_LAB_INTRO: return "lab_intro";
				case SCENE_LAND_CROC: return "land_croc";
				case SCENE_LAUNCH: return "launch";
				case SPLASH: return "splash";
				case MITOSIS: return "mitosis";
			}
			return "null";
		}
		
		public static function getByName(s:String):int {
			var i:int;
			
			if (s == "a") i = SCENE_A;
			else if (s == "lab_intro") i = SCENE_LAB_INTRO;
			else if (s == "lab_board") i = SCENE_LAB_BOARD;
			else if (s == "launch") i = SCENE_LAUNCH;
			else if (s == "crash") i = SCENE_CRASH;
			else if (s == "land_croc") i = SCENE_LAND_CROC;
			else if (s == "finale") i = SCENE_FINALE;
			else if (s == "credits") i = SCENE_CREDITS;
			else if (s == "mitosis") i = MITOSIS;
			else if (s == "splash") i = SPLASH;
			else i = -1;
			
			return i;
		}
		
		public function getIndex():int {
			return myIndex;
		}
		
	}
	
}
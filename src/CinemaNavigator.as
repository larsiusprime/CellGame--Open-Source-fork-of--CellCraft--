package 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import SWFStats.*;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CinemaNavigator extends Sprite implements IConfirmCaller
	{
		public var nextButt:SimpleButton;
		public var backButt:SimpleButton;
		public var replayButt:SimpleButton;
		public var skipButt:SimpleButton;
		public var pauseButt:SimpleButton;
		private var count:int = 1;
		private var atHalt:Boolean = false;
		private var doNext:Boolean = false;
		public var c_butt_mute:ToggleButton;
		
		private var paused:Boolean = false;
		public var myCinemaIndex:int = 0;
		
		public var c_confirm:Confirmation;
		
		public function CinemaNavigator() {
			
			if (backButt) {
				replayButt.addEventListener(MouseEvent.CLICK, replayCinema, false, 0, true);
				backButt.addEventListener(MouseEvent.CLICK, backCinema, false, 0, true);
				nextButt.addEventListener(MouseEvent.CLICK, nextCinema, false, 0, true);
				skipButt.addEventListener(MouseEvent.CLICK, skipCinema, false, 0, true);
				pauseButt.addEventListener(MouseEvent.CLICK, pauseCinema, false, 0, true);
				pauseButt.visible = false;
				replayButt.visible = false;
				nextButt.visible = false;	
				backButt.visible = false;
				skipButt.visible = false;
			}
			
			
			if(myCinemaIndex == Cinema.SCENE_CREDITS){
				pauseButt.visible = true;
				replayButt.visible = true;
				skipButt.visible = true;
				nextButt.visible = false;
				if (backButt) {
					backButt.visible = false;
				}
			}
		}
		
		public function setIndex(i:int) {
			myCinemaIndex = i;
		}
		
		public function confirm(s:String) {
			c_confirm.confirm(this, s);
			setChildIndex(c_confirm, numChildren - 1);
			doPause(true);
		}
		
		public function onConfirm(s:String, b:Boolean) {
			//trace("CinemaNavigator.onConfirm("+s + "," + b + ")");
			if (b) {
				if (s == "skip") {
					doSkip();
				}
			}else {
				doPause(false);
			}
		}

		
		public function showNext() {
			nextButt.visible = true;
		}
		
		public function replayCinema(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("cinema_replay_" + Cinema.getName(myCinemaIndex), "cinema");}
			Cinema(parent).replay();
		}
		
		public function readyCinema() {
			skipButt.visible = true;
		}
		
		public function forFinalCinema() {
			//trace("CinemaNavigator.forFinalCinema()!");
			skipButt.visible = true;
			nextButt.visible = false;
			replayButt.visible = true;
			c_butt_mute.visible = true;
			pauseButt.visible = true;
		}
		
		public function haltForFinalCinema() {
			//trace("CinemaNavigator.haltForFinalCinema()!");
			halt();
			backButt.visible = false;
			pauseButt.visible = false;
		}
		
		public function halt() {
			count++;
			if (doNext) {
				nextButt.visible = false;
				Cinema(parent).play();
				doNext = false;
			}else {
				atHalt = true;
				nextButt.visible = true;
				backButt.visible = true;
			}
			
		}
		
		private function doPause(b:Boolean) {
			paused = b;
			if (b) {
				Cinema(parent).pause();
			}else {
				Cinema(parent).unPause();
			}
		}
		
		private function pauseCinema(m:MouseEvent) {
			if (paused) {
				paused = false;
				Cinema(parent).pause();
			}else {
				paused = true;
				Cinema(parent).unPause();
			}
		}
		
		private function backCinema(m:MouseEvent) {
			backButt.visible = false;
			nextButt.visible = false;
			
			if (atHalt) { //halt advances count by 1. So if we're at a halt, we have to go back 2 counts!
				count-=2;
			}else{		  //if not at a halt, only go back 1.
				count--;
			}
			
			Cinema(parent).gotoAndStop("a" + count);	
			
			if (count == 0) { //if we went all the way back to the beginning
				count = 1;			   //the minimum value is 1
				Cinema(parent).play(); //to avoid getting stuck, there's no halt at the beginning!
			}
		}
		
		private function nextCinema(m:MouseEvent) {
			nextButt.visible = false;
			backButt.visible = false;

			if (atHalt) {
				Cinema(parent).play();
			}else {
				doNext = true;
				Cinema(parent).gotoAndPlay("a" + count);
			}
		}
		
		private function skipCinema(m:MouseEvent) {
			//trace("CinemaNavigator.skipCinema() index = " + myCinemaIndex);
			if (myCinemaIndex != Cinema.SPLASH) {
				//trace("CONFIRM SKIP");
				confirm("skip");
			}else {
				//trace(" DO SKIP");
				doSkip();
			}
		}
		
		private function doSkip() {
			Cinema(parent).finishCinema();
		}
	}
	
}
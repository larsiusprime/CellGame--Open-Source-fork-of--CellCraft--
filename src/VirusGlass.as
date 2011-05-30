package  
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class VirusGlass extends MovieClip
	{
		public var c_virusWarning:MovieClip;
		public var c_text:TextField;
		public var c_infest_text:TextField;
		public var timer:Timer;
		public var theText:String = "";
		public var alertType:String = "";
		public var wave_id:String = "";
		public var alertCount:int = 0;
		
		public var line_0:VirusLine;
		public var line_1:VirusLine;
		public var line_2:VirusLine;
		public var line_3:VirusLine;
		public var line_4:VirusLine;
		
		
		public function VirusGlass() 
		{
			timer = new Timer(1000 / 30, 30);
			stop();
			visible = false;
			hideVirusLines();
			c_infest_text.visible = false;
		}
		
		public function setWarning(type:String,count:int,w_id:String="null") {
			alpha = 1;
			visible = true;
			//gotoAndPlay(1);
			alertType = type;
			alertCount = count;
			wave_id = w_id;
			//theText = "" + count + " " + typeToString(type) + " detected!";
			//c_text.htmlText = "<b>"+theText+"</b>";
			//c_virusWarning.gotoAndStop(type);
			//if (c_virusWarning.icon) {
			//	c_virusWarning.icon.gotoAndPlay(1);
			//}
			//finishFade(null);
			//tryMakeVirusLine(type,w_id);
		}
		
		/**
		 * Called when a VirusLine shows the timer
		 * @param	v
		 */
		
		public function onVirusTime(v:VirusLine) {
			TutorialGlass(parent).onVirusTime(v.id,v.virus_count);
		}
		
		public function onFinishVirusLine(v:VirusLine) {
			var success:Boolean = true;
			for (var i:int = 0; i < 5; i++) {
				var v:VirusLine = VirusLine(this["line_" + i]);
				if (v.blank == false) {
					success = false;
				}
			}
			if (success) {
				tearDownOverview();
			}
		}
		
		private function getVirusLine(str:String):VirusLine {
			for (var i:int = 0; i < 5; i++) {
				var v:VirusLine = VirusLine(this["line_" + i]);
				if (v.id == str) {
					return v;
				}
			}
			
			return null;
		}
		
		private function hideVirusLines() {
			for (var i:int = 0; i < 5; i++) {
				var v:VirusLine = VirusLine(this["line_" + i]);
				v.visible = false;
			}
		}
		
		public function rnaKilled(w_id:String) {
			var v:VirusLine = getVirusLine(w_id)
			if (v) {
				v.oneLessRNA();
			}
		}
		
		public function nucleusInfest(yes:Boolean) {
			c_infest_text.visible = yes;
		}
		
		public function virusCreated(type:String,w_id:String, count:int) {
			//trace("VirusGlass.virusCreated(" + type + "," + w_id + "," + count);
			if (!visible) {
				setupOverview();
			}
			var v:VirusLine = getVirusLine(w_id);
			if (v) {
				//trace("VirusGlass.virusCreated, adding virus!");
				v.addVirus(count);
				v.visible = true;
				//v.visible = true;
			}else{
				v = tryMakeVirusLine(type, w_id);
				v.addVirus(count);
				v.visible = true;
				//v.visible = true;
			}
			//getVirusLine(w_id).addVirus(count);
		}
		
		public function rnaCreated(w_id:String, count:int) {
			if (!visible) {
				setupOverview();
			}
			var v:VirusLine = getVirusLine(w_id)
			if (v) {
				v.addRNA(count);
				v.visible = true;
			}
		}
		
		public function clearWave(w_id:String) {
			var v:VirusLine = getVirusLine(w_id);
			if (v) {
				v.clear();
			}
		}
		
		public function virusKilled(w_id:String) {
			var v:VirusLine = getVirusLine(w_id)
			if (v) {
				v.oneLessVirus();
			}
			
		}
		
		public function updateLineCounts(w_id:String,vc:int,rc:int,dc:int,t:int) {
			//trace("VirusGlass.updateLineCounts(" + w_id + "," + vc + "," + rc + "," + dc + "," + t + ")");
			var v:VirusLine = getVirusLine(w_id);
			if (v) {
				v.setCount(vc, rc, dc, t);
				//v.visible = true;
			}
		}
		
		private function tryMakeVirusLine(type:String,w_id:String="null"):VirusLine {
			//trace("VirusGlass.tryMakeVirusLine(type=" + type + "wave_id=" + w_id + ")");
			
			if (type.substr(0, 6) == "virus_") {
				var length = type.length;
				type = type.substr(6, length - 6);
			}
			var i:int = 0;
			for (i = 0; i < 5; i++) {
				var v:VirusLine = VirusLine(this["line_" + i]);
				if (v.blank) {
					v.setVirus(w_id,type, 0, 0, 0, 0);
					v.visible = true;
					i = 5; //end the loop
				}
			}
			return v;
		}
		
		public function onVisible() {
			c_text.htmlText = "<b>" + theText + "</b>";
		}
		
		public function onFinish() {
			//alpha = 1;
			//timer.addEventListener(TimerEvent.TIMER, doFade);
			//timer.addEventListener(TimerEvent.TIMER_COMPLETE, finishFade);
			//finishFade(null);
			timer.start();
		}
		
		private function doFade(t:TimerEvent) {
			alpha -= 1 / 30;
		}
		
		public function finishFade() {
			//visible = false;
			//alpha = 1;
			gotoAndStop(1);
			
			//timer.removeEventListener(TimerEvent.TIMER, doFade);
			//timer.removeEventListener(TimerEvent.TIMER_COMPLETE, finishFade);
			TutorialGlass(parent).onFinishEnemyAlert(alertType, alertCount, wave_id);
			setupOverview();
		}
		
		private function setupOverview() {
			visible = true;
			alpha = 100;
			gotoAndStop("overview");
			if (Nucleus.CHECK_INFEST) {
				c_infest_text.visible = true;
			}else {
				c_infest_text.visible = false;
			}
		}
		
		private function tearDownOverview() {
			gotoAndStop(1);
			visible = false;
		}
		
		public static function typeToString(type:String):String {
			if (type == "virus_injector")
				return "Injector viruses";
			else if (type == "virus_invader")
				return "Invader viruses";
			else if (type == "virus_infester")
				return "Infester viruses";
			else
				return "unknown entities";
	
		}
	}
	
}
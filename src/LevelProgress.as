package  
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	
	public class LevelProgress 
	{
		private static var lvl_beaten:Array = [false, false, false, false, false, false, false, false, false, false];
		private static var game_beaten:Boolean = false;
		public static const FOREVER:int = 9999999;
		private static var lvl_times:Array = [FOREVER, FOREVER, FOREVER, FOREVER, FOREVER, FOREVER, FOREVER, FOREVER, FOREVER, FOREVER];
		private static var lvl_grades:Array = [ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
		private static var max_level:int = 1;
		
		private static var mySo:SharedObject;
		
		public function LevelProgress(i:int) 
		{
			max_level = i;
			lvl_beaten = new Array();
			lvl_beaten.length = max_level + 1;
			for (var j:int = 0; j <= max_level; j++) {
				lvl_beaten[j] = false;
			}
		}
		
		public static function initProgress() {
			mySo = SharedObject.getLocal("CellCraftData");
		}
		
		public static function clearProgress() {
			trace("LevelProgress.clearProgress()!");
			mySo.data.max_level_beaten = -1;
			mySo.flush();
			getProgress();
			trace("...lvl_beaten = " + lvl_beaten);
		}
		
		public static function saveProgress() {
			trace("LevelProgress.saveProgress()!");
			mySo.data.max_level_beaten = getMaxLevelBeaten();
			mySo.data.game_beaten = getGameBeaten();
			for (var i:int = 0; i < max_level; i++) {
				mySo.data["level_" + i + "_seconds"] = lvl_times[i];
				mySo.data["level_" + i + "_grade"] = lvl_grades[i];
			}
			mySo.flush();
			trace("...level_beaten = " + lvl_beaten);
		}
		
		public static function getProgress() {
			trace("LevelProgress.getProgress()!");
			
			if (mySo.data.game_beaten == undefined) {
				
			}else {
				game_beaten = mySo.data.game_beaten;
			}
			
			
			
			if (mySo.data.max_level_beaten == undefined) {
				trace("LevelProgress.getProgress() UNDEFINED");
				mySo.data.max_level_beaten = -1;
				clearMaxLevelBeaten( -1);
			}else{
				clearMaxLevelBeaten(mySo.data.max_level_beaten);	
			}
			trace("...lvl_beaten = " + lvl_beaten);
			
			for (var i:int = 0; i < max_level; i++) {
				var time:int = mySo.data["level_" + i + "_seconds"];
				var grade:int = mySo.data["level_" + i + "_grade"];
				if (time) { lvl_times[i] = time; }
				if (grade) { lvl_grades[i] = grade; }
			}
		}
		
		
		public static function getLevelBeaten(i):Boolean {
			return lvl_beaten[i];
		}
		
		public static function setLevelBeaten(i, b:Boolean) {
			lvl_beaten[i] = b;
			saveProgress();
		}
		
		public static function setLevelTime(i:int,time:int) {
			if (lvl_times[i] > time) {
				lvl_times[i] = time;
			}
		}
		
		public static function getLevelTime(i:int):int {
			return lvl_times[i];
		}

		public static function setLevelGrade(i:int, grade:int) {
			if (lvl_grades[i] < grade) {
				lvl_grades[i] = grade;
			}
		}
		
		public static function getLevelGrade(i:int):int {
			return lvl_grades[i];
		}
		
		public static function setGameBeaten(b:Boolean):void {
			game_beaten = b;
		}
		
		public static function getGameBeaten():Boolean {
			return game_beaten;
		}
		
		private static function clearMaxLevelBeaten(i:int) {
			trace("LevelProgress.clearMaxLevelBeaten(" + i + ")");
			var j:int;
			for (j = 0; j <= max_level; j++) {
				lvl_beaten[j] = false;
			}
			if (i > max_level) {
				i = max_level;
			}
			if(i >= 0){
				for (j = 0; j <= i; j++) {
					lvl_beaten[j] = true;
				}
			}
			
		}
		
		public static function getMaxLevelBeaten():int {
			var i:int = 0;
			for (var j:int = 0; j <= max_level; j++) {
				if(lvl_beaten[j]){
					i = j;
				}else {
					break;
				}
			}
			return i;
		}
		
		public function maxLevelBeaten(i) {
			if (i > max_level) {
				i = max_level;
			}
			for (var j:int = 0; j <= i; j++) {
				lvl_beaten[j] = true;
			}
			saveProgress();
		}
		
	}
	
}
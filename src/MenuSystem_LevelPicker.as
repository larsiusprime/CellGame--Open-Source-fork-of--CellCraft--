package  
{
	import com.pecLevel.GameLevelInfo;
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_LevelPicker extends MenuSystem implements IConfirmCaller
	{
		public var lvl_0:LevelDot;
		public var lvl_1:LevelDot;
		public var lvl_2:LevelDot;
		public var lvl_3:LevelDot;
		public var lvl_4:LevelDot;
		public var lvl_5:LevelDot;
		public var lvl_6:LevelDot;
		public var lvl_7:LevelDot;
		
		public var selected_dot:LevelDot;
		
		public var cin_0:CameraButt;
		public var cin_1:CameraButt;
		public var cin_2:CameraButt;
		public var cin_3:CameraButt;
		public var cin_4:CameraButt;
		public var cin_5:CameraButt;
		public var cin_6:CameraButt;
		public var cin_7:CameraButt;
		
		public var c_lines:MovieClip;
		public var c_window:PickLevelWindow;
		/*public var c_window:PickLevelWindow;
		public var c_currentlevel:Sprite;
		public var c_title:TextField;*/
		
		//public var butt_okay:SimpleButton;
		
		public var d_lvlInfo:GameLevelInfo;
		public var d_lvlProgress:LevelProgress;
		
		private var level_pick:int = 0;
		private var maxBeaten:int = -1;
		
		private const MAX_LEVEL:int = 7;
		
		public var butt_title:SimpleButton;
		public var butt_clear:SimpleButton;
		public var c_clickhere:MovieClip;
		public var exitCode:int = EXIT_TITLE;
		
		public var c_confirm:Confirmation;
		
		public static var startImmediately:Boolean = true; //HACK

		
		public function MenuSystem_LevelPicker() 
		{
			butt_title.addEventListener(MouseEvent.CLICK, onTitle, false, 0, true);
			butt_clear.addEventListener(MouseEvent.CLICK, onClear, false, 0, true);
		}
		
	
		
		
		/**
		 * Only to be called after setData!
		 */
		
		public override function init() {
			super.init();
			c_window.visible = false;
			//butt_okay.visible = false;
			//c_currentlevel.visible = false;			
			//butt_okay.addEventListener(MouseEvent.CLICK, onClickOkay, false, 0, true);
			
			if (maxBeaten > MAX_LEVEL) {
				maxBeaten = MAX_LEVEL;
			}
			
			updateAll();
			showLevelLineFor(maxBeaten);
			if (maxBeaten == -1) {
				level_pick = 0;
				if(startImmediately){
					onClickOkay(null);
				}else {
					startImmediately = true;
				}
			}
		}
		
	
			
		public function confirm(s:String) {
			c_confirm.confirm(this, s);
		}
		
		public function onConfirm(s:String, b:Boolean) {
			if (b) {
				if (s == "clear") {
					doClear();
				}
			}
		}
		
		public function onClear(m:MouseEvent) {
			confirm("clear");
		}
			
		public function doClear(){
			LevelProgress.clearProgress();
			p_director.setExitMenuCode(EXIT_RESET, 0);
			startImmediately = false; //HACK 
									  //Normally, when you have 0 progress and start the levelpicker, it dumps you 
									  //straight into level 0. However, if you clear the data, you don't want that.
									  //so what this does, is ONLY if you have pressed clear do you get to see level 0 and
									  //only level 0
			exit();
		}
		
		public function onTitle(m:MouseEvent) {
			//exitCode = EXIT_TITLE;
			p_director.setExitMenuCode(EXIT_TITLE, 0);
			exit();
		}
		
		public function onClickCinema(id:int) {
			//trace("MenuSystem_LevelPicker.onClickCinema id=" + id + " cinema=" + d_lvlInfo.getLvlCinema(id));
			p_director.showCinema(d_lvlInfo.getLvlCinema(id));
		}
		
		private function setupButtons() {
			for (var i:int = 0; i <= d_lvlInfo.maxLevel; i++) {
				this["cin_" + i].id = i;
			}
		}
		
		public function setData(l:LevelProgress,g:GameLevelInfo) {
			d_lvlInfo = g;
			d_lvlProgress = l;
			setupButtons();
			maxBeaten = -1;
			for (var i:int = 0; i <= d_lvlInfo.maxLevel; i++) {
				if (LevelProgress.getLevelBeaten(i)) {
					//trace("MenuSystem_LevelPicker.levelBeaten : " + i);
					maxBeaten = i;
				}
			}
		}
		
		public function updateAll() {
			for (var i:int = 0; i <= d_lvlInfo.maxLevel; i++) {
				var l:LevelDot = this["lvl_" + i];
				l.setMaster(this);
				l.setup(i, d_lvlInfo.getLvlLabel(i), d_lvlInfo.getLvlDesignation(i), d_lvlInfo.getLvlName(i));
				
				if (LevelProgress.getLevelBeaten(i)) {
					l.checkMe();
				}else {
					l.checkMe(false);
				}
				
				showCinemas(false);
				//trace("MenuSystem_LevelPicker.cinema " + i + " : " + d_lvlInfo.getLvlCinema(i));
				
			}
		}

		
		/**
		 * Give me a level number, unlock that level
		 * @param	i
		 */
		
		public function showLevelLineFor(i:int) {
			showLevels(false);
			
			for (var j:int = 0; j <= i+1; j++) { //show all the levels & cinemas in between
				showLevel(j, true);
				var c:int = j - 2;
				if (c >= 0){
					if (d_lvlInfo.getLvlCinema(c) != Cinema.NOTHING) {
						//trace("MenuSystem_LevelPicker.showLevelLineFor() cinema SHOW " + (c) + " : " + d_lvlInfo.getLvlCinema(c));
						showCinema(c);
					}else {
						//trace("MenuSystem_LevelPicker.showLevelLineFor() cinema HIDE " + i + " : " + d_lvlInfo.getLvlCinema(c));
						showCinema(c, false);
					}
				}
				//showCinema(j, true);
			}
			
			if (i == -1) {
				lineAt(0);
			}else {
				Director.startSFX(SoundLibrary.SFX_BLIPSTEPS);
				lineAtAndPlay(i);
			}
		}
		
		private function tryShowCinema(i:int) {
			if(i >= 0){
				if (d_lvlInfo.getLvlCinema(i) != Cinema.NOTHING) {
					showCinema(i);
				}
			}
		}
		
		public function onEndLine() {
			//trace("MenuSystem_LevelPicker.onEndLine() level_pick = " + level_pick);
			if(level_pick <= MAX_LEVEL){
				onSelectLevel(this["lvl_" + level_pick]);
				tryShowCinema(level_pick - 1);
				
			}else if (level_pick >= MAX_LEVEL) {
				//trace("MenuSystem_LevelPicker.onEndLine() MAXED level_pick = " + level_pick);
				tryShowCinema(MAX_LEVEL);
			}
		}
		
		public function onSelectLevel(l:LevelDot) {
			unselectLevels();
			l.selectMe();
			if (level_pick == l.id) {
				c_clickhere.play();
			}
			level_pick = l.id;
			selected_dot = l;
			//trace("MenuSystem_LevelPicker.onSelectLevel() " + level_pick);
			c_window.visible = true;
			c_window.setTitle(l.title);
			/*c_window.x = l.x;
			c_window.y = l.y;*/
			//c_title.text = l.title;
			//butt_okay.visible = true;
			//c_currentlevel.visible = true;
		}
		
		public function onDoubleClickLevel(l:LevelDot) {
			onSelectLevel(l);
			onClickOkay(null);
		}
		
		public function getLevelPick():int {
			return level_pick;
		}
		
		public function onClickOkay(m:MouseEvent) {
			//p_director.pickLevel(
			//p_director.pickLevel(selected_dot.id);
			//exitCode = EXIT_PICK;
			p_director.setExitMenuCode(EXIT_PICK, level_pick);
			exit();
		}
		
		private function unselectLevels() {
			for (var i:int = 0; i <= d_lvlInfo.maxLevel; i++) {
				this["lvl_" + i].selectMe(false);
			}
		}
		
		private function showLevel(i:int,b:Boolean = true) {
			if(i <= MAX_LEVEL)
				this["lvl_" + i].visible = b;
		}
		
		private function showCinema(i:int, b:Boolean = true) {
			//trace("MenuSystem_LevelPicker.showCinema(" + i + ")");
			if(i <= MAX_LEVEL)
				this["cin_" + i].visible = b;
		}
		
		private function lineAt(i:int) {
			level_pick = i;
			c_lines.gotoAndStop("at_lvl_" + i);
			onEndLine();
		}
		
		private function lineAtAndPlay(i:int) {
			level_pick = i+1;
			c_lines.gotoAndStop("at_lvl_" + i);
			c_lines.play();
		}
		
		private function showLevels(b:Boolean=true) {
			lvl_0.visible = b;
			lvl_1.visible = b;
			lvl_2.visible = b;
			lvl_3.visible = b;
			lvl_4.visible = b;
			lvl_5.visible = b;
			lvl_6.visible = b;
			lvl_7.visible = b;
		}
		
		private function showCinemas(b:Boolean = true) {
			cin_0.visible = b;
			cin_1.visible = b;
			cin_2.visible = b;
			cin_3.visible = b;
			cin_4.visible = b;
			cin_5.visible = b;
			cin_6.visible = b;
			cin_7.visible = b;
		}
		
	}
	
}
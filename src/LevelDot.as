package  
{
	import com.pecLevel.GameLevelInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class LevelDot extends Sprite
	{
		public var c_text:TextField;
		public var c_check:Sprite;
		public var c_select:Sprite;
		//public var c_butt:SimpleButton;
		public var p_master:MenuSystem_LevelPicker;
		public var id:int = 0;
		public var designation:int = GameLevelInfo.LVL_INTRO;
		public var title:String = "";
		
		public function LevelDot() 
		{
			selectMe(false);
			checkMe(false);
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick, false, 0, true);
		}
		
		public function setup(i:int,label:int,des:int,ti:String) {
			id = i;
			designation = des;
			title = ti;
			var st:String = "";
			switch(designation) {
				case GameLevelInfo.LVL_INTRO:st += "Intro"; break;
				case GameLevelInfo.LVL_REAL:st += "Level"; break;
			}
			st += "\n" + label.toString();
			c_text.text = st;
		}
		
		private function onDoubleClick(m:MouseEvent) {
			p_master.onDoubleClickLevel(this);
		}
		
		private function onClick(m:MouseEvent) {
			//selectMe();
			p_master.onSelectLevel(this);
		}
		
		public function selectMe(b:Boolean = true) {
			c_select.visible = b;
		}
		
		public function checkMe(b:Boolean = true) {
			c_check.visible = b;
		}
		
		public function setMaster(m:MenuSystem_LevelPicker) {
			p_master = m;
		}
		
	}
	
}
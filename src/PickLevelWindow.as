package  
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class PickLevelWindow extends Sprite
	{
		public var c_head:TextField;
		public var c_title:TextField;
		public var butt_okay:SimpleButton;
		
		public function PickLevelWindow() 
		{
			butt_okay.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		private function onClick(m:MouseEvent) {
			MenuSystem_LevelPicker(parent).onClickOkay(m);
		}
		
		public function setTitle(t:String) {
			c_title.text = t;
		}
		
	}
	
}
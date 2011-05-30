package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ToggleButton extends MovieClip
	{
		public var butt:SimpleButton;
		private var isUp:Boolean = true;
		public var data:*;
		
		public function ToggleButton() 
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOverToggle);
			addEventListener(MouseEvent.ROLL_OUT, rollOutToggle);
			addEventListener(MouseEvent.MOUSE_DOWN, downToggle);
			addEventListener(MouseEvent.CLICK, toggle);
			buttonMode = true;
			mouseChildren = false;
			useHandCursor = true;
		}
		
		protected function onDown() {
			
		}
		
		protected function onUp() {
			
		}
		
		public function setIsUp(b:Boolean) {
			try{
				isUp = b;
			
				if (isUp) {
					gotoAndStop("up");
				}else {
					gotoAndStop("down");
				}
			}catch (e:Error) {
				//donothing, just catch it
			}
		}
		
		private function rollOverToggle(m:MouseEvent) {
			if (isUp) {
				gotoAndStop("over");
			}else {
				gotoAndStop("downOver");
			}
		}
		
		private function rollOutToggle(m:MouseEvent) {
			if (isUp) {
				gotoAndStop("up");
			}else {
				gotoAndStop("down");
			}
		}
		
		private function downToggle(m:MouseEvent) {
			if (isUp) {
				gotoAndStop("press");
			}else {
				gotoAndStop("downPress");
			}
		}
		
		private function toggle(m:MouseEvent) {
			var t:ToggleButtonEvent;
			if (isUp) {
				gotoAndStop("down");
				isUp = false;
				t = new ToggleButtonEvent(ToggleButtonEvent.TOGGLE_ON,m);
				dispatchEvent(t);
				onDown();
			}else {
				gotoAndStop("up");
				isUp = true;
				t = new ToggleButtonEvent(ToggleButtonEvent.TOGGLE_OFF,m);
				dispatchEvent(t);
				onUp();
			}
		}		
	}
	
}
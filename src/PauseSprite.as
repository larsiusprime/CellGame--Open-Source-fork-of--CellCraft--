package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class PauseSprite extends MovieClip
	{
		private var p_director:Director;
		
		public function PauseSprite() 
		{
			hide();
			addEventListener(MouseEvent.MOUSE_OVER, normalCursor,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, fancyCursor,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT, fancyCursor,false,0,true);
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
		}
		
		public function onClick(m:MouseEvent) {
			p_director.pauseSpriteUnPause();
		}
		
		public function setDirector(d:Director){
			p_director = d;
		}
		
		public function fancyCursor(e:MouseEvent) {
			p_director.fancyCursor();
		}
		
		public function normalCursor(e:MouseEvent) {
			p_director.normalCursor()
		}
		
		public function show(whichFrame:String="normal") {
			visible = true;
			gotoAndStop(whichFrame);
			addEventListener(MouseEvent.CLICK, doNothing);
		}
		
		public function hide() {
			visible = false;
			removeEventListener(MouseEvent.CLICK, doNothing);
		}
		
		private function doNothing(e:MouseEvent) {
			//gobbles up mouse events
		}
		
	}
	
}
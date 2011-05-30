package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CameraButt extends MovieClip
	{
		public var id:int = 0;
		
		
		public function CameraButt() 
		{
			buttonMode = true;
			mouseChildren = false;
			useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		private function onClick(m:MouseEvent) {
			MenuSystem_LevelPicker(parent).onClickCinema(id);
		}
		
	}
	
}
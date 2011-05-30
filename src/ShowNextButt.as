package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ShowNextButt extends MovieClip
	{
		public var c_butt:SimpleButton;
		
		public function ShowNextButt() 
		{
			c_butt.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		public function onClick(m:MouseEvent) {
			TutorialGlass(parent).getNextObj();
		}
		
		public function shine() {
			gotoAndPlay("shine");
		}
		
	}
	
}
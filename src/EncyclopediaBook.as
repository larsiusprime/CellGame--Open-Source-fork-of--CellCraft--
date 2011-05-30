package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.pecSound.SoundLibrary;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class EncyclopediaBook extends Sprite
	{
		public var c_butt:SimpleButton;
		public var anim:MovieClip;
		public var p_tutGlass:TutorialGlass;
		
		public function EncyclopediaBook() 
		{
			
		}
		
		public function init(p_tut:TutorialGlass) {
			c_butt.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			anim.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			p_tutGlass = p_tut;
		}
		
		public function destruct() {
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function newEntry() {
			anim.play();
			Director.startSFX(SoundLibrary.SFX_WRITING);
		}
		
		public function onClick(m:MouseEvent) {
			p_tutGlass.onBookClick();
		}
		
	}
	
}
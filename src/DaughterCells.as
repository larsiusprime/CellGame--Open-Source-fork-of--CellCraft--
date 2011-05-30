package  
{
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class DaughterCells extends InterfaceElement
	{
		public var c_cell:MovieClip;
		public var text:TextField;
		public var c_heading:MovieClip;
		
		private var amount:Number = 0;
		
		public function DaughterCells(amt:int=0) 
		{
			setAmount(amt);
		}
		
		public function setAmount(amt:int) {
			amount = amt;
			updateText();
		}
		
		private function updateText() {
			text.text = amount.toString();
		}
		
		public override function blackOut() {
			super.blackOut();
			c_cell.visible = false;
			c_heading.visible = false;
			text.visible = false;
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			c_cell.visible = true;
			c_heading.visible = true;
			text.visible = true;
		}
		
		public override function glow() {
			Director.startSFX(SoundLibrary.SFX_DISCOVERY_TWINKLE);
			c_cell.play();
			//star.play();
		}
		
	}
	
}
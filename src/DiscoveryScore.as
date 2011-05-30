package  
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.pecSound.SoundLibrary;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class DiscoveryScore extends InterfaceElement
	{
		public var star:Star;
		public var text:TextField;
		public var c_heading:MovieClip;
		
		private var max:int = 15;
		private var amount:int = 0;
		
		public function DiscoveryScore(amt:int=0,m:int=15) 
		{
			max = m;
			setAmount(amt);
		}
		
		public function setAmount(amt:int) {
			amount = amt;
			updateText();
		}
		
		public function setMax(m:int) {
			max = m;
			updateText();
		}
		
		private function updateText() {
			text.text = amount +"/" + max;
		}
		
		public override function blackOut() {
			super.blackOut();
			star.visible = false;
			c_heading.visible = false;
			text.visible = false;
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			star.visible = true;
			c_heading.visible = true;
			text.visible = true;
		}
		
		public override function glow() {
			Director.startSFX(SoundLibrary.SFX_DISCOVERY_TWINKLE);
			star.play();
		}
		
	}
	
}
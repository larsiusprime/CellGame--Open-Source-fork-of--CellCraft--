package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Sunlight extends InterfaceElement
	{
		private var amount:Number = 0.5;
		public var c_text:TextField;
		public var c_icon:MovieClip;
	
		
		public function Sunlight() 
		{
			
		}
		
		public function setAmount(n:Number) {
			if (n < 0) n = 0;
			if (n > 1) n = 1;
			amount = n;
			var percent:int = Math.round(amount * 100);
			c_text.htmlText = "<b>" + percent + "%</b>";
		}
		
		public override function blackOut() {
			super.blackOut();
			c_icon.visible = false;
			c_text.visible = false;
		
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			c_icon.visible = true;
			c_text.visible = true;
			
		}
	}
	
}
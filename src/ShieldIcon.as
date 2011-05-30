package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ShieldIcon extends Sprite
	{
		public var c_text:TextField;
		
		public function ShieldIcon() 
		{
			
		}
		
		public function setNum(n:Number) {
			c_text.htmlText = "<b>" + n + "</b>";
		}
	}
	
}
package  
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ShieldGem extends MovieClip
	{
		public var c_text:TextField;
		private var _amount:Number;
		
		public function ShieldGem() 
		{
			amount = 0;
		}
		
		public function set amount(n:Number) {
			_amount = n;
			var p:int = n * 100;
			c_text.htmlText = "<b>"+p.toString()+"</b>";
			
		}
		
		public function get amount():Number {
			return _amount;
		}
	}
	
}
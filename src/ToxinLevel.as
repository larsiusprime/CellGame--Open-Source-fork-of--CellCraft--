package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ToxinLevel extends InterfaceElement
	{
		private var amount:Number = 0;
		public var c_text:TextField;
		public var c_icon:MovieClip;
		public var thermometer:MovieClip;
		public var theTemp:Number = 0;
		public var tempText:TextField;
		public var thermoGlow:MovieClip;
		
		public static const MAX_TEMP:Number = 25;
		public static const MIN_TEMP:Number = 0;
		
		private var temp:Number = 0;
		
		public function ToxinLevel() 
		{
			setAmount(0);
		}
		
		public function setID(s:String) {
			if (s == "toxin") {
				gotoAndStop("toxin");
			}else if (s == "temperature") {
				gotoAndStop("temperature");
				setTemp(MAX_TEMP);
			}
		}
		
		public function setTemp(n:Number) {
			if (n > theTemp) {
				doGlow();
			}
			theTemp = n;
			tempText.htmlText = "<b>" + n.toFixed(1) + "</b>";
			var f:Number = (n - MIN_TEMP) / MAX_TEMP;
			f *= 100;
			f = Math.floor(f);			
			thermometer.gotoAndStop(f+1);
		}
		
		public function setAmount(n:Number) {
			if (n < 0) n = 0;
			if (n > 1) n = 1;
			
			amount = n;
			var percent:int = Math.round(amount * 100);
			c_text.htmlText = "<b>" + percent + "%</b>";
		}
		
		public function doGlow() {
			thermoGlow.gotoAndPlay("glow");
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
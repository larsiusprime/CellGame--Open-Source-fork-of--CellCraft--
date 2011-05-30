package {

	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import fl.motion.Color;
	import flash.geom.ColorTransform;
	import flash.events.Event;

	public class MeterBar_infest extends MeterBar{
		
		public var text_amount:TextField;
		public var text_shadow:TextField;
		private var amount:int = 0;
		private var maxAmount:int = 100;
		private var percent:Number;
		private var color_lo:uint = 0x0000DD;
		private var color_mid:uint = 0xAA00DD;
		private var color_hi:uint = 0xDD0000;
		private var color_curr:uint = color_hi;
		private const _demo:Boolean = false;
		
		public function MeterBar_infest(){
			setAmounts(50,100);
			if(_demo)
				addEventListener(Event.ENTER_FRAME, demo);
			//text_amount.filters.push(new GlowFilter(0x000000, 1, 1, 1, 2));
		}
		
		private function demo(e:Event){
			amount++;
			if(amount > maxAmount){
				amount = 0;
			}
			setAmount(amount);
		}
		
		public function setAmount(i:int){
			amount = i;
			updatePercent();
		}
		
		public function setMaxAmount(i:int){
			if(i != 0)
			maxAmount = i;
		}
		
		public function setAmounts(a:int,m:int){
			setMaxAmount(m);
			setAmount(a);
		}
		
		private function updatePercent(){
			
			setPercent(Number(amount)/Number(maxAmount));
			text_amount.htmlText = "<b>" + String(amount) + "</b>";
			if (amount == 0) {
				visible = false;
			}else {
				visible = true;
			}
			//text_shadow.htmlText = "<b>" + String(amount) + "</b>";
		}
		
		public function updateColor(n:Number){
			var inter:Number = 0;
			if(n > 0.5){
				inter = (n-0.5)/0.5;
				color_curr = Color.interpolateColor(color_mid,color_hi,inter);
			}else{
				inter = n/0.5;
				color_curr = Color.interpolateColor(color_lo,color_mid,inter);
			}
		}
		
		public override function setPercent(n:Number){
			if(n > 1) n = 1;
			if(n < 0) n = 0;
				
			updateColor(n);
			
			var c:ColorTransform = bar.transform.colorTransform;
			c.color = color_curr;
			bar.transform.colorTransform = c;
			
			bar.width = n*maxWidth;
			percent = n * 100;
			percent = Math.floor(percent);
			//text_percent.text = String(percent) + "%";
		}
	
	}
}
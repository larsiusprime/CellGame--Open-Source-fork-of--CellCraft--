package {

	import fl.motion.Color;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	public class ResourceMeter extends InterfaceElement{
	
		private var _amount:int = 0; //spin number
		private var amount:int; //how much of the stuff you've got
		
		private var maxAmount:int; //the max you're allowed to have
		
		private var _concentration:Number; //spin number
		private var concentration:Number; //number between 0 & 1 representing concentration
		
		private var color:uint;
		private var over_color:uint = 0x00CC00;

		public var meter:MeterBar_resource;
		public var text_amount:TextField;
		//public var text_amount_shadow:TextField;
		public var back:MovieClip;
		
		public var c_icon:MovieClip;
	
		public function ResourceMeter(){
			setMaxAmount(100);
			setAmount(0);
			tt_shove(0,-1);
			setTToff(15,100);
			back.alpha = 0; //watch this
		}
		
		public override function blackOut() {
			super.blackOut();
			c_icon.visible = false;
			text_amount.visible = false;
			if (meter) {
				meter.visible = false;
			}
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			c_icon.visible = true;
			text_amount.visible = true;
			if (meter) {
				meter.visible = true;
			}
		}
		
		public function setMaxAmount(i:int){
			maxAmount = i;
			updateMeter();
		}
		
		private function startSpin() {
			addEventListener(RunFrameEvent.RUNFRAME, spin);
		}

		private function spin(e:Event) {
			var spinSpeed:Number = 0.1;
			var diff:Number = amount - _amount;
			diff *= spinSpeed;
			if(diff < 0){
				if (diff > -1) diff = -1;
			}
			else{
				if (diff < 1) diff = 1;
			}
			_amount += (diff);
			//trace("amount = " + amount + " _a = " + _amount);
			/*if (amount > 0) {
				if (_amount > amount) {
					_amount = amount;
					removeEventListener(Event.ENTER_FRAME, spin);
				}
			}else if (amount < 0) {
				if (_amount < amount) {
					_amount = amount;
					removeEventListener(Event.ENTER_FRAME, spin);
				}
			}
			else{*/
			
			//trace("diff = " + diff);
			if (diff < 0) { diff *= -1; };
			if (diff <= 1) {
				_amount = amount;
				removeEventListener(RunFrameEvent.RUNFRAME, spin);
			}
			//}
			
			updateText();
			updateMeter();
		}
		
		public function setAmount(i:int){
			amount = i;
			
			startSpin();
			updateText();
			updateMeter();
		}
		
		public function setAmounts(a:int, m:int) {
			setAmount(a);
			setMaxAmount(m);
		}
		
		public function setOverColor(c:uint) {
			over_color = c;
			updateMeterColor();
		}
		
		public function setColor(c:uint){
			color = c;
			updateMeterColor();
		}
		
		
		private function updateText(){
			if (amount > maxAmount) {
				text_amount.textColor = over_color;
			}else {
				text_amount.textColor = 0xFFFFFF;
			}
			text_amount.text = String(_amount);
			//text_amount_shadow.text = String(amount);
		}
		
		private function updateMeter(){
			concentration = Number(amount) / Number(maxAmount);
			_concentration = Number(_amount) / Number(maxAmount);
			if(meter)
				meter.setPercent(_concentration);
		}
		
		private function updateMeterColor(){
			if(meter){
				meter.setColor(color);
				meter.setOverColor(over_color);
			}
		}
	}

}
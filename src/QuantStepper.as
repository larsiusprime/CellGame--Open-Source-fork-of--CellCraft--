package  
{
	import fl.controls.NumericStepper;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class QuantStepper extends InterfaceElement
	{
		public var icon:MovieClip;
		//public var stepper:NumericStepper;
		public var title:TextField;
		public var amount_text:TextField;
		public var max_text:TextField;
		
		public var myName:String;
		public var amount:Array;
		//public var myIndex:int;
		
		public var max:int = 100;
		
		//public var makeCost:Array;
		//public var sellCost:Array;
		
		//public var c_butt_book:SimpleButton;
		
		public function QuantStepper() 
		{
			amount = [0, 0];
		}
		
		public function init(){
			//super.init();
			//setMax(20);
			setTToff(-42, 54);
			tt_shove(1, 0);
			tt_onClick = true;
			
			setMax(24); //if you create 25 at once, it causes a bunch of RNA's to spawn uselessly next to the centrosome. We're working on it.

			setAmount(0);
			
			//setTargetAmount(0);
			//setRealAmount(0);
			//update();
			//stepper.addEventListener(Event.CHANGE, onChange, false, 0, true);
		}
		
		public function setMax(n:Number) {
			//stepper.maximum = n;
			max = n;
		}
		
		/**
		 * Sets the existant and ordered amounts and displays it. If ordered amount is not given, it's assumed to not exist.
		 * @param	n Existant amount
		 * @param	p Ordered amount
		 * @return whether we changed from 0 or not
		 */
		
		public function setAmount(n:int,p:int=-1):Boolean {
			//stepper.value = n;
			var isChange:Boolean = false;
			
			if(p != -1){							//if we track orders
				if (amount[1] == 0 && p != 0) {		//if we had nothing, and now we have something
					isChange = true;				
				}else if (amount[1] != 0 && p == 0) {	//if we had something, and now we have nothing
					isChange = true;
				}
			}else {									//if we don't track orders
				if (amount[0] == 0 && n != 0) {		//if we had nothing, and now we have something
					isChange = true;
				}else if (amount[0] != 0 && n == 0) { //if we had something, and now we have nothing
					isChange = true;	
				}
				
			}
			
			amount[0] = n;
			
			if (p != -1) {
				amount[1] = p;
				if (amount[1] == amount[0]) {
					amount_text.text = n.toString();
				}else{
					amount_text.text = (n + " / " + p);
				}
			}else {
				amount_text.text = n.toString();
			}
			
			if (n >= max || p >= max) {
				max_text.htmlText = ("<b>MAX</b>");
			}else {
				max_text.text = "";
			}
			
			return isChange;
		}
		
		public function getAmount():Array{
			//return stepper.value;
			return amount;
		}
		
		public function onChange(e:Event) {
			QuantPanel(parent).changeQuantTarget(this);
		}
		
		public function setType(n:String,g:String){
			myName = n;
			//myIndex = i;
			/*switch(myIndex){
				case BasicUnit.RIBOSOME: makeCost = Costs.MAKE_RIBOSOME; sellCost = Costs.SELL_RIBOSOME;break;
				case BasicUnit.LYSOSOME: makeCost = Costs.MAKE_LYSOSOME; sellCost = Costs.SELL_LYSOSOME;break;
				case BasicUnit.PEROXISOME:makeCost=Costs.MAKE_PEROXISOME;sellCost=Costs.SELL_PEROXISOME;break;
				case BasicUnit.SLICER: makeCost = Costs.MAKE_SLICER; sellCost = Costs.SELL_SLICER;break;
			}*/
			setTTString(myName);
			setGraphic(g);
			title.htmlText = "<b>" + myName + "</b>";
		}
		
		public function setGraphic(g:String) {
			icon.gotoAndStop(g);
		}
	}
	
}
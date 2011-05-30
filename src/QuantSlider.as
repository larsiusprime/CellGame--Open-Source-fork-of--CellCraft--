package {
	
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.*;
	import fl.motion.Animator;
	
	public class QuantSlider extends MySlider{
		public var c_shroud:MovieClip;
		public var valueText:TextField;
		public var targetText:TextField;
		public var icon:MovieClip;
		public var colorBar:MovieClip;
		public var orderBar:MovieClip;
		public var orderLine:MovieClip;
		public var ttBox:MovieClip;
		private var myName:String;
		private var myIndex:int;	//the sort of thing I am. QuantPanel.RIBOSOME, etc
		private var makeCost:Array; //are we buying or selling this thing?
		private var sellCost:Array;
		
		private var maxAmount:int;	//the maximum number of these things you can have
									// BUG WATCH : if this and max are not the same
		private var capAmount:int=1000000; 	//the cap above which you can't go because of current resources
									
		private var targetAmount:int = 0; //the FIXED target set by the slider
		//private var floatTargetAmount:int = 0; //the floating target set by the slider
		private var realAmount:int = 0; //the amount of these things that actually exist
		private var orderAmount:int = 0; //the amount that has been ordered
		public var back:MovieClip;
		public var ticking:Boolean = false; //are we currently trying to match values or not?

		//private var demo_going:Boolean = false; //is the demo allowed to proceed?

		private var demo:Boolean = false; //auto moves the amount to match the set amount
		private var demoSpeed:Number = 2;
		private var demoCount:Number = 0;
				
		public function QuantSlider(){

		}
		
		public override function init() {
			super.init();
			colorBar.scaleY = 0;
			orderBar.scaleY = 0;
			max = 100;
			min = 0;
			range = max-min;
			step = range/33;
			setMax(20);
			back.alpha = 0;	//WATCH THIS FOR PERFORMANCE LATER ON : consider bitmapcache
			setTToff(0, 20);
			
			tt_onClick = true;
			
			setTargetAmount(0);
			setRealAmount(0);
			update();
			
			targetText.mouseEnabled = false;
		}
		
		public function setResourceCap(a:Array){
			var cap:int = 10000000;
			var temp:int = 0;
			for(var i:int = 0; i < makeCost.length; i++){
				if(makeCost[i] != 0){			//avoid divide by zero
					temp = a[i]/makeCost[i];	//divide amount of stuff by cost of 1 thing
					if(temp < cap){				//is this the lowest cap?
						cap = temp + orderAmount;	//our new cap, not considering what we already have
					}
					
				}
			}
			if(cap < maxAmount)
				capAmount = cap;
				
		}

		public function fixTarget() {
			if (targetAmount < 1)
				orderLine.y = range; 
			else if (targetAmount == maxAmount) {
				orderLine.y = 0;
			}
			else
				orderLine.y = range - ((targetAmount / maxAmount ) * (range));
		}
		
		public function setTargetAmount(a:Number){
			
			if(a > capAmount){
				a = capAmount;
			}
			else if(a < 0){
				a = 0;
			}
			
			setValue(a/maxAmount);
		}
		
		private function hardSetTargetAmount(a:Number){
			if(a > capAmount)
				a = capAmount;
			else if(a < 0)
				a = 0;
			
			hardSetValue(a/maxAmount);
		}

		public function oneMoreTarget() {
			targetAmount++;
			if (targetAmount > maxAmount) {
				targetAmount = maxAmount;
			}
			fixTarget();
			hardSetValue(targetAmount);
			//onChangeValue();
		}
		
		public function oneLessTarget() {
			/*targetAmount--;
			if (targetAmount < 0) {
				targetAmount = 0;
			}
			
			fixTarget();
			onChangeValue();*/
		}
		
		/*public function adjustForCost(a:Array,isMake:Boolean){
			//we are ASSUMING that at least one of the indeces is negative
			var curr_cut:int = 0;	//how many we are considernig cutting
			var hi_cut:int = 0;
			var costA:Array;

			if(isMake) 
				costA = makeCost;
			else
				costA = sellCost;
			
			
			for(var i:int = 0; i < a.length; i++){	//consider ever index of the array
				if(a[i] < 0){						//if this resource has a defecit
					trace("can't afford " + i + " of " + a);
					trace("COST = " + costA[i] + " cost = " + (-a[i]));
					curr_cut = ((-a[i])/costA[i]);
					trace("let's cut #"+curr_cut);
					if(curr_cut > hi_cut){
						hi_cut = curr_cut;
					}
				}
			}
			hardSetTargetAmount(targetAmount-hi_cut);
		}*/

		public function setOrderAmount(a:int) {
			orderAmount = a;
			updateBar();
		}
		
		public function setRealAmount(a:int){
			realAmount = a;
			updateBar();
		}
		
		//set to a value between 0 and 1
		public override function setValue(v:Number){
			super.setValue(1 - v);
			update();
			
		}
		
		protected override function hardSetValue(v:Number){ //doesn't call the update function, just sets the handle manually
			super.hardSetValue(1 - v);
		}
		
		private function onChangeValue(){
			//QuantPanel(parent).changeQuantTarget(this);
		}
		
		public function setMax(i:int){
			maxAmount = i;
			if(capAmount > maxAmount){
				capAmount = maxAmount;
			}
		}
		
		public function setType(n:String,g:String,i:Number){
			myName = n;
			myIndex = i;
			switch(myIndex){
				case BasicUnit.RIBOSOME: makeCost = Costs.MAKE_RIBOSOME; sellCost = Costs.SELL_RIBOSOME;break;
				case BasicUnit.LYSOSOME: makeCost = Costs.MAKE_LYSOSOME; sellCost = Costs.SELL_LYSOSOME;break;
				case BasicUnit.PEROXISOME:makeCost=Costs.MAKE_PEROXISOME;sellCost=Costs.SELL_PEROXISOME;break;
				case BasicUnit.SLICER: makeCost = Costs.MAKE_SLICER; sellCost = Costs.SELL_SLICER;break;
			}
			setTTString(myName);
			setGraphic(g);
		}
		
		public function setColor(col:uint){
			var c:ColorTransform = colorBar.transform.colorTransform;
			c.color = col;
			colorBar.transform.colorTransform = c;
			orderBar.transform.colorTransform = c;
		}
		
		public function setGraphic(s:String){
			icon.gotoAndStop(s);
		}
		
		
		protected override function update(){
			super.update();
			
			targetAmount = int(((1-_value) * maxAmount));
			
			if (targetAmount > capAmount) {
				targetAmount = capAmount;
				hardSetTargetAmount(capAmount);
			}
			
			//floatTargetAmount = targetAmount;
			
			updateText();
		
			
			showTTBoxOrDont();
			onChangeValue();
		}
		
		private function updateText() {
			valueText.htmlText = "<b>" + String(realAmount) + "</b>";
		}
		
		private function showTTBoxOrDont(){
			
			ttBox.y = handle.y - handle.height/2 - ttBox.height + 3;
			targetText.y = handle.y-handle.height/2 - targetText.height + 3;
			
			if(dragging){
				targetText.text = String(targetAmount);
				ttBox.visible = true;
			}else{
				hideTTBox();
			}
		}
		
		private function hideTTBox(){
			targetText.text = "";
			ttBox.visible = false;
		}
		
		protected override function onHideTooltip(){
			hideTTBox();
		}

		private function updateBar(){
			//trace("realAmount = " + realAmount + " targetAmount = " + targetAmount);
			orderBar.scaleY = orderAmount / maxAmount;
			colorBar.scaleY = realAmount/maxAmount;
			updateText();
			//hardSetTargetAmount(orderAmount);
			//targetAmount = orderAmount;
			//fixTarget();
			onChangeValue();
		}
		
		public function setTargetToOrder() {
			setTargetAmount(orderAmount);
		}
		
		public function setTargetToReal(){
			setTargetAmount(realAmount);
		}
	
		public function getRealAmount():int{
			return realAmount;
		}
		
		public function getOrderAmount():int {
			return orderAmount;
		}
		
		public function getTargetAmount():int{
			return targetAmount;
		}
		
		public function getIndex():int{
			return myIndex;
		}
		
		public function isEq():Boolean{
			if(orderAmount == targetAmount){
				return true;
			}
			return false;
		}
		
		public override function glow() {
			c_shroud.play();

		}
		
		/*public function getOrderAmount():Number{
			return targetAmount-realAmount;
		}*/
	
	}
}
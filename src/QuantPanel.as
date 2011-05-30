package {

	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class QuantPanel extends InterfaceElement{
		
		/*public var quantLyso:QuantSlider;
		public var quantRibo:QuantSlider;
		public var quantPerox:QuantSlider;
		public var quantSlicer:QuantSlider;*/
		
		public var quantStepRibo:QuantStepper;
		public var quantStepDefensin:QuantStepper;
		public var quantStepLyso:QuantStepper;
		public var quantStepSlicer:QuantStepper;
		public var quantStepPerox:QuantStepper;
		public var quantStepMito:QuantStepper;
		public var quantStepChloro:QuantStepper;
		/*public var cost_aa:MiniCost;
		public var cost_fa:MiniCost;
		public var cost_atp:MiniCost;
		public var cost_na:MiniCost;
		public var backdrop:MovieClip;*/
		
		public var atpCost:int;
		public var naCost:int;
		public var faCost:int;
		public var aaCost:int;
		
		//public var c_heading:MovieClip;
		
		public var isEqual:Boolean = true;
		
		public var butt_yes:SimpleButton;
		//public var butt_no:SimpleButton;
		
		public var stuffHidden:Boolean = false;
		
		public function QuantPanel(){

		}
		
		public function init() {
			setup();
			//checkEq();
			
			//IT MUST BE DONE IN THIS ORDER!
			
			/*quantLyso.init();
			quantRibo.init();
			quantPerox.init();
			quantSlicer.init();*/
			
			quantStepRibo.init();
			quantStepLyso.init();
			quantStepPerox.init();
			quantStepSlicer.init();
			quantStepChloro.init();
			quantStepMito.init();
			quantStepDefensin.init();
			clearSteppers();
			setMaxes(Cell.MAX_MITO, Cell.MAX_CHLORO, Cell.MAX_RIBO, Cell.MAX_DEFENSIN, Cell.MAX_LYSO, Cell.MAX_PEROX,Cell.MAX_SLICER);
		}
		
		public function doCheckEq(){
			//checkEq();
		}
		
		private function hideStuff() {
			stuffHidden = true;
			/*cost_na.visible = false;
			cost_aa.visible = false;
			cost_fa.visible = false;
			cost_atp.visible = false;
			butt_yes.visible = false;
			//butt_no.visible = false;
			backdrop.gotoAndStop(2);*/
		}
		
		private function showStuff() {
			stuffHidden = false;
			/*cost_na.visible = true;
			cost_aa.visible = true;
			cost_fa.visible = true;
			cost_atp.visible = true;
			butt_yes.visible = true;
			//butt_no.visible = true;
			backdrop.gotoAndStop(1);*/
		}
		
		private function checkEq(){
			/*if(isEq()){
				hideStuff();
			}else{
				showStuff();
			}*/
		}
		
		private function isEq():Boolean{
			/*if(quantLyso.isEq() && quantRibo.isEq() && quantPerox.isEq() && quantSlicer.isEq()){
				isEqual = true;
			}else{
				isEqual = false;
			}*/
			return true;
		}
		
		private function setup(){
			setupCosts();			
			setupButtons();
			setupQuantSliders();
			arrangeSteppers();
		}
		
		private function setupCosts(){
			/*cost_na.setType("na");
			cost_aa.setType("aa");
			cost_fa.setType("fa");
			cost_atp.setType("atp");*/
		}
		
		private function setupButtons(){
			//butt_yes.addEventListener(MouseEvent.CLICK,confirm);
			//butt_no.addEventListener(MouseEvent.CLICK,cancel);
		}
		
		private function setupQuantSliders() {
			quantStepRibo.setMaster(p_master);
			quantStepLyso.setMaster(p_master);
			quantStepPerox.setMaster(p_master);
			quantStepSlicer.setMaster(p_master);
			quantStepChloro.setMaster(p_master);
			quantStepMito.setMaster(p_master);
			quantStepDefensin.setMaster(p_master);
			
			/*cost_na.setMaster(p_master);
			cost_aa.setMaster(p_master);
			cost_fa.setMaster(p_master);
			cost_atp.setMaster(p_master);*/
			
			
/*			quantLyso.setMaster(p_master);
			quantRibo.setMaster(p_master);
			quantPerox.setMaster(p_master);
			quantSlicer.setMaster(p_master);*/
			
			/*cost_atp.setTTString("ATP cost");
			cost_atp.setTToff(5,20);
			cost_aa.setTTString("Amino Acid cost");
			cost_aa.setTToff(5,20);
			cost_fa.setTTString("Fatty Acid cost");
			cost_fa.setTToff(5,20);
			cost_fa.tt_shove(1,1);
			cost_na.setTTString("Nucleic Acid cost");
			cost_na.setTToff(5, 20);
			cost_na.tt_shove(1, 1);*/
			
			quantStepRibo.setType("Ribosomes", "ribo");
			quantStepLyso.setType("Lysosomes", "lyso");
			quantStepSlicer.setType("Slicer Enzymes", "slicer");
			quantStepPerox.setType("Peroxisomes", "perox");
			quantStepMito.setType("Mitochondria", "mito");
			quantStepChloro.setType("Chloroplasts", "chloro");
			quantStepDefensin.setType("Defensins", "defensin");
			/*
			quantLyso.setType("Lysosomes","lyso",BasicUnit.LYSOSOME);
			quantLyso.setColor(0xEE9911);
			//quantLyso.setColor(0xFFCC32);
			quantRibo.setType("Ribosomes","ribo",BasicUnit.RIBOSOME);
			quantRibo.setColor(0x000000);
			quantPerox.setType("Peroxisomes","perox",BasicUnit.PEROXISOME);
			quantPerox.setColor(0x68999B);
			quantSlicer.setType("Slicer Enzymes","slicer",BasicUnit.SLICER);
			quantSlicer.setColor(0xff00DD);
			quantSlicer.tt_shove(1,1);*/
		}
		
		private function clearSteppers() {
			quantStepRibo.setAmount(0);
			quantStepLyso.setAmount(0);
			quantStepPerox.setAmount(0);
			quantStepSlicer.setAmount(0);
			quantStepDefensin.setAmount(0);
			quantStepMito.setAmount(0);
			quantStepChloro.setAmount(0);
			arrangeSteppers();
			//calcCosts();
		}
		
		private function arrangeSteppers() {
			var a:Vector.<QuantStepper> = new Vector.<QuantStepper>();
			var b:Vector.<QuantStepper> = Vector.<QuantStepper>([quantStepRibo, quantStepMito, quantStepChloro, quantStepLyso, quantStepPerox, quantStepSlicer, quantStepDefensin]);
			
			if (quantStepRibo.getAmount()[0] > 0) a.push(quantStepRibo);
			if (quantStepMito.getAmount()[0] > 0) a.push(quantStepMito);
			if (quantStepChloro.getAmount()[0] > 0) a.push(quantStepChloro);
			if (quantStepLyso.getAmount()[1] > 0) a.push(quantStepLyso);
			if (quantStepPerox.getAmount()[1] > 0) a.push(quantStepPerox);
			if (quantStepSlicer.getAmount()[1] > 0) a.push(quantStepSlicer);
			if (quantStepDefensin.getAmount()[1] > 0) a.push(quantStepDefensin);			
			
			var q:QuantStepper;
			
			for each(q in b) {
				q.visible = false;
			}
			
			var lasty:Number = -3; //magic number!
			
			for each(q in a) {
				q.visible = true;
				q.y = lasty;
				lasty += (Math.floor(q.height)-2);
			}
		}
		
		private function confirm(m:MouseEvent){
			/*var a:Array = [quantStepLyso.myIndex, quantStepLyso.getAmount(),
						   quantStepPerox.myIndex, quantStepPerox.getAmount(),
						   quantStepSlicer.myIndex, quantStepSlicer.getAmount()];
			if(canAfford(atpCost,naCost,aaCost,faCost)){
				p_master.orderBasicUnits(a);
				clearSteppers();
			}else {
				p_master.p_engine.showImmediateAlert(Messages.A_NO_AFFORD_BASICUNITS);
			}*/
			
			/*if(!isEq()){
				var a:Array =  [quantLyso.getIndex(),quantLyso.getTargetAmount(),
								quantRibo.getIndex(),quantRibo.getTargetAmount(),
								quantPerox.getIndex(),quantPerox.getTargetAmount(),
								quantSlicer.getIndex(),quantSlicer.getTargetAmount()];
				p_master.orderBasicUnits(a);
				if (!canAfford(atpCost, naCost, aaCost, faCost)) {
					p_master.p_engine.showImmediateAlert(Messages.A_NO_AFFORD_BASICUNITS);
				}
				quantLyso.fixTarget();
				quantRibo.fixTarget();
				quantPerox.fixTarget();
				quantSlicer.fixTarget();
			}*/
		}
		
		private function cancel(m:MouseEvent){
			/*if (!isEq()) {
				p_master.cancelBasicUnits();
				quantLyso.setTargetToOrder();
				quantRibo.setTargetToOrder();
				quantPerox.setTargetToOrder();
				quantSlicer.setTargetToOrder();
				quantLyso.fixTarget();
				quantRibo.fixTarget();
				quantPerox.fixTarget();
				quantSlicer.fixTarget();
			}*/
		}
		
		/********QuantSlider Callbacks********/
		
		public function changeQuantTarget(q:QuantStepper){
			if(p_master){
				//checkEq();
				//calcCosts();
				//master.orderBasicUnit(q.getIndex(),q.getTargetAmount());
			}
		}
		
		/*******************/
		
		private function calcCosts(){
			/*var rx:int = quantRibo.getTargetAmount() - quantRibo.getOrderAmount();
			var lx:int = quantLyso.getTargetAmount() - quantLyso.getOrderAmount();
			var px:int = quantPerox.getTargetAmount() - quantPerox.getOrderAmount();
			var sx:int = quantSlicer.getTargetAmount() - quantSlicer.getOrderAmount();*/
			
			/*var rx:int = 0;
			var lx:int = quantStepLyso.getAmount();
			var px:int = quantStepPerox.getAmount();
			var sx:int = quantStepSlicer.getAmount();
			
			if (rx < 0) rx = 0;
			if (lx < 0) lx = 0;
			if (px < 0) px = 0;
			if (sx < 0) sx = 0;
			
			if (rx == 0 && lx == 0 && px == 0 && sx == 0) {
				//trace("NUTTIN!");
				//We are ordering no units, show no cost
				cost_fa.setAmount(0);
				cost_na.setAmount(0);
				cost_aa.setAmount(0);
				cost_atp.setAmount(0);
				hideStuff();
			}else{
				showStuff();
				var ra:Array;
				var la:Array;
				var pa:Array;
				var sa:Array;
			
				if(rx > 0){ra = Costs.MAKE_RIBOSOME.concat();}else if(rx < 0){ra = Costs.SELL_RIBOSOME.concat();}else{ra=[0,0,0,0];};
			
				//use getMAKE_X() for everything else because they use RNA
				if(lx > 0){la = Costs.getMAKE_LYSOSOME().concat();}else if(lx < 0){la = Costs.SELL_LYSOSOME.concat();}else{la=[0,0,0,0];};
				if(px > 0){pa = Costs.getMAKE_PEROXISOME().concat();}else if(px < 0){pa = Costs.SELL_PEROXISOME.concat();}else{pa=[0,0,0,0];}
				if(sx > 0){sa = Costs.getMAKE_SLICER().concat();}else if(sx < 0){sa = Costs.SELL_SLICER.concat();}else{sa=[0,0,0,0];}
				
				var rxcost:Array = [rx*ra[0],rx*ra[1],rx*ra[2],rx*ra[3]];
				var lxcost:Array = [lx*la[0],lx*la[1],lx*la[2],lx*la[3]];
				var pxcost:Array = [px*pa[0],px*pa[1],px*pa[2],px*pa[3]];
				var sxcost:Array = [sx*sa[0],sx*sa[1],sx*sa[2],sx*sa[3]];
	
				//Math.ceil() because we have to make sure that we can afford this, so we round up to be safe
				//This is not the REAL cost, just the DISPLAYED cost, since we haven't room for decimals
	
				atpCost = Math.ceil(rxcost[0]+lxcost[0]+pxcost[0]+sxcost[0]);
				if(atpCost < 0) atpCost*=-1;
				naCost = Math.ceil(rxcost[1]+lxcost[1]+pxcost[1]+sxcost[1]);
				aaCost = Math.ceil(rxcost[2]+lxcost[2]+pxcost[2]+sxcost[2]);
				faCost = Math.ceil(rxcost[3]+lxcost[3]+pxcost[3]+sxcost[3]);
	
	//			var a:Array = master.getResources();
				
				//find the cost of purchasing everything BUT the stuff in this slider and tell me how much 
				//I've still got left to purchase this stuff
				//var a:Array = resourcesLeftFor(q.getIndex(),rxcost,lxcost,pxcost,sxcost);
				//trace("QuantPanel.capArray = " + a + "q="+q.getIndex());
				//That's the budget you have for that one thing
				//q.setResourceCap(a); 
				
				cost_atp.setAmount(atpCost);
				cost_na.setAmount(naCost);
				cost_aa.setAmount(aaCost);
				cost_fa.setAmount(faCost);
			}*/
		}
		
		//Calculates the cost buy everything in the order list EXCEPT a specific column
		//Then, returns the amount of resources left minus the cost of everything but that thing
		public function resourcesLeftFor(i:int, rc:Array,lc:Array,pc:Array,sc:Array):Array{
			return null;
			/*var a:Array = p_master.getResources(); //start with our master resource amount
			a[0] -= (rc[0]+lc[0]+pc[0]+sc[0]);	//subtract the ATP cost of each basic unit order
			a[1] -= (rc[1]+lc[1]+pc[1]+sc[1]);  //subtract the NA cost..
			a[2] -= (rc[2]+lc[2]+pc[2]+sc[2]);  //AA cost...
			a[3] -= (rc[3]+lc[3]+pc[3]+sc[3]);  //FA cost...
			var b:Array;							
			switch(i){
				case BasicUnit.RIBOSOME: b = rc;break;	//Figure out which basic unit order we wish to have ignored
				case BasicUnit.LYSOSOME: b = lc;break;
				case BasicUnit.PEROXISOME: b = pc;break;
				case BasicUnit.SLICER: b = sc; break;
			}
			a[0] += b[0];						//add his costs back to the list (unsubtracting them)
			a[1] += b[1];
			a[2] += b[2];
			a[3] += b[3];
			if (a[0] < 0) a[0] = 0;
			if (a[1] < 0) a[1] = 0;
			if (a[2] < 0) a[2] = 0;
			if (a[3] < 0) a[3] = 0;
			return a;*/
		}
		
		public function canAfford(atp:int, na:int, aa:int, fa:int):Boolean {
			return false;
			//return p_master.canAfford(atp,na,aa,fa,0);
		}
		
		public function getAffordArray(a):Array {
			return null;
			//return p_master.getAffordArray(a);
		}
		
		/********Unit changers****************/

		public function oneMoreSlicer() {
			
		}
		
		public function oneMoreRibosome() {
			//quantRibo.oneMoreTarget();
		}
		
		public function oneLessRibosome() {
			//quantRibo.oneLessTarget();
		}
		
		public function oneLessLysosome() {
			//quantLyso.oneLessTarget();
		}
		
		public function oneLessPeroxisome() {
			//quantPerox.oneLessTarget();
		}
		
		public function oneLessSlicer() {
			//quantSlicer.oneLessTarget();
		}
		
		public function setMaxes(mito:int, chloro:int, ribo:int, def:int, lyso:int, perox:int, slicer:int) {
			quantStepMito.setMax(mito);
			quantStepChloro.setMax(chloro);
			quantStepDefensin.setMax(def);
			quantStepLyso.setMax(lyso);
			quantStepPerox.setMax(perox);
			quantStepSlicer.setMax(slicer);
		}
		
		public function setMitochondria(i:int) {
			if (quantStepMito.setAmount(i)) {
				arrangeSteppers();
			}
		}
		
		public function setChloroplasts(i:int) {
			if (quantStepChloro.setAmount(i)) {
				arrangeSteppers();
			}
		}
		
		public function setRibosomes(i:int, p:int) {
			if (quantStepRibo.setAmount(i)) {
				arrangeSteppers();
			}
			//quantStepRibo.setAmount(i, p);
			//quantRibo.setRealAmount(i);
			//quantRibo.setOrderAmount(p);
		}
		
		public function setDefensins(i:int, p:int) {
			if (quantStepDefensin.setAmount(i, p)) {
				arrangeSteppers();
			}
		}
		
		public function setLysosomes(i:int, p:int) {
			if (quantStepLyso.setAmount(i, p)) {
				arrangeSteppers();
			}
			//quantLyso.setOrderAmount(i);
			//quantLyso.setRealAmount(p);
		}
		
		public function setPeroxisomes(i:int, p:int) {
			if (quantStepPerox.setAmount(i, p)) {
				arrangeSteppers();
			}
			//quantPerox.setOrderAmount(i);
			//quantPerox.setRealAmount(p);
		}
		
		public function setSlicers(i:int, p:int) {
			if (quantStepSlicer.setAmount(i, p)) {
				arrangeSteppers();
			}
			//quantSlicer.setOrderAmount(i);
			//quantSlicer.setRealAmount(p);
		}
		
		public function glowSomething(i:int) {
			/*switch(i) {
				case Interface.QUANT_LYSO: quantStepLyso.glow(); break;
				//case Interface.QUANT_RIBO: quantStepRibo.glow(); break;
				case Interface.QUANT_PEROX: quantStepPerox.glow(); break;
				case Interface.QUANT_SLICER: quantStepSlicer.glow(); break;
				case Interface.QUANT_MITO: quantStep
			}*/
		}
		
		public override function blackOut() {
			super.blackOut();
			//c_heading.visible = false;
			//quantRibo.visible = false;
			//quantLyso.visible = false;
			//quantSlicer.visible = false;
			//quantPerox.visible = false;
			quantStepRibo.visible = false;
			quantStepLyso.visible = false;
			quantStepSlicer.visible = false;
			quantStepPerox.visible = false;
			quantStepChloro.visible = false;
			quantStepDefensin.visible = false;
			quantStepMito.visible = false;
			/*backdrop.visible = false;
			cost_aa.visible = false;
			cost_na.visible = false;
			cost_fa.visible = false;
			cost_atp.visible = false;
			butt_yes.visible = false;*/
			//butt_no.visible = false;
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			arrangeSteppers();
			//c_heading.visible = true;
			/*&quantRibo.visible = true;
			quantLyso.visible = true;
			quantSlicer.visible = true;
			quantPerox.visible = true;*/
			/*quantStepLyso.visible = true;
			quantStepPerox.visible = true;
			quantStepSlicer.visible = true;*/
			/*backdrop.visible = true;
			if(!stuffHidden){
				showStuff();
			}else {
				hideStuff();
			}*/
		}
	}

}
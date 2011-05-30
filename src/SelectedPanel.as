package 
{
	import com.pecLevel.EngineEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import SWFStats.*;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class SelectedPanel extends InterfaceElement
	{
		
		public var text_title:TextField;
		public var text_description:TextField;
		
		public var c_picture:MovieClip;
		//public var c_health:MeterBar_health;
		
		public var c_statPanel:StatPanel;
		public var c_costPanel:CostPanel;
		public var c_butt_book:SimpleButton;
		public var c_butt_cancel:SimpleButton;
		public var c_butt_mute:ToggleButton;
		
		private var yCount:Number = 0;
		private var yAccel:Number = 0.5;
		private const IN_Y:Number = 320;
		private const OUT_Y:Number = 415;
		private const YSPEED:Number = 2;
		private const YACCEL:Number = 0.5;
		
		private var multiSelect:Boolean = true;
		private var hidden:Boolean = true;
		
		private var p_selected:Selectable;
		private var list_selected:Vector.<Selectable>;
		
		public function SelectedPanel() 
		{
			hideCostPanel();
			setupButtons();
		}
		
		public function destruct() {
			p_selected = null;
			list_selected = null;
			c_butt_book.removeEventListener(MouseEvent.CLICK, clickBook);
		}
		
		public function setupButtons() {
			c_butt_book.addEventListener(MouseEvent.CLICK, clickBook, false, 0, true);
			c_butt_cancel.addEventListener(MouseEvent.CLICK, clickCancel, false, 0, true);
		}
		

		public function updateMuteButton() {
			if (MenuSystem_InGame._muteMusic && MenuSystem_InGame._muteSound) {
				c_butt_mute.setIsUp(false);
			}else {
				c_butt_mute.setIsUp(true);
			}
		}
		
		public function clickCancel(m:MouseEvent) {
			p_master.p_engine.unselectAll();
		}
		
		public function clickBook(m:MouseEvent) {
			if(Director.STATS_ON){Log.CustomMetric("encyclopedia_open_selected_" + p_selected.getTextID(), "encyclopedia");}
			//trace("SelectedPanel.ClickBook! Launch Encyclopedia!");
			p_master.showEncyclopedia(p_selected.text_id);
		}
		
		/**
		 * This shows the selected thing in the panel, showing its info and picture.
		 * @param	s a Selectable item to be displayed
		 */ 
		
		public function showSelected(s:Selectable) {
			if(s){
				//trace("SelectedPanel.showSelected(" + s + ")");
				//trace("SelectedPanel.showSelected(" + s.text_id + ")");
			}else {
				//trace("SelectedPanel.showSelected(null)");
			}
			p_selected = s;
			if (s && s.getCanSelect()) {
				text_title.htmlText = "<b>" + s.getTextTitle() + "</b>";
				text_description.htmlText = s.getTextDescription();
				c_picture.gotoAndStop(s.getTextID());
				if (s.getTextDescription() != ""){
					show();
				}
				showStatPanel(s);
			}else {
				text_title.htmlText = "";
				text_description.htmlText = "";
				c_picture.gotoAndStop("unknown");
				hide();
				hideStatPanel();
			}
		}
		
		/**
		 * Same as showSelected(), but for more than 1 of 1 kind of thing
		 * @param	s a Selectable item to be displayed
		 * @param	i how many of them you've got
		 */
		public function showSelected2(s:Selectable, i:int) {
			showSelected(s);
			if(i > 1){
				//text_title.htmlText = "<b>" + s.getTextTitle() + " (" + String(i) +")" + "</b>";
				text_title.text = s.getTextTitle() + " (" + String(i) +")";
				hideStatPanel();
			}else{
				showStatPanel(s);
			}
			p_master.p_engine.notifyOHandler(EngineEvent.SELECT_THING, "null", s.text_id, i);
			
		}
		
		public function showManySelected(v:Vector.<Selectable>) {
		if (v.length > 0) {
			list_selected = v.concat();
			c_picture.gotoAndStop("multi");
			var counts:Array = Selectable.countSelectables(v);
			if (counts[0] == 1) { 	//we've only got 1 kind of thing
				showSelected2(v[0], v.length);
			}else {
				multiSelect = true;
				var clips:Array = new Array();
				var amounts:Array = new Array();
				var s:String = "";
				var s2:String = "";
				switch(counts[0]) {
					case 1: clips[0] = c_picture.clip3; 
							amounts[0] = c_picture.amount3;
							break;
					case 2: clips = [c_picture.clip2, c_picture.clip4]; 
							amounts = [c_picture.amount2, c_picture.amount4];
							break;
					case 3: clips = [c_picture.clip1, c_picture.clip3, c_picture.clip5]; 
							amounts = [c_picture.amount1, c_picture.amount3, c_picture.amount5];
							break;
					case 4: clips = [c_picture.clip1, c_picture.clip2, c_picture.clip3, c_picture.clip4]; 
							amounts = [c_picture.amount1, c_picture.amount2, c_picture.amount3, c_picture.amount4];
							break;
					case 5: clips = [c_picture.clip1, c_picture.clip2, c_picture.clip3, c_picture.clip4, c_picture.clip_5]; 
							amounts = [c_picture.amount1, c_picture.amount2, c_picture.amount3, c_picture.amount4, c_picture.amount5];
							break;
				}
				
				for (var i:int = 1; i < 6; i++) {
					c_picture["clip" + i].visible = false; //hide all the clips
					c_picture["amount" + i].text = "";
				}
				
				text_title.htmlText = "<b>";
				var thingCounter:int = 0;
				if (counts[1] > 0) { 
					s += "R:" + counts[1] + " ";
					s2 += "(" + counts[1] + " Ribosomes)";
					clips[thingCounter].visible = true;
					amounts[thingCounter].text = counts[1];
					clips[thingCounter++].gotoAndStop("ribo");
					
				}
				if (counts[2] > 0) { 
					s += "L:" + counts[2] + " ";
					s2 += " (" + counts[2] + " Lysosomes)";
					clips[thingCounter].visible = true;
					amounts[thingCounter].text = counts[2];
					clips[thingCounter++].gotoAndStop("lyso");
					p_master.p_engine.notifyOHandler(EngineEvent.SELECT_THING, "null", "lysosome", counts[2]);
					//notifyOHandler(EngineEvent.SELECT_THING, "lysosome", c.getTextID(), 1);
				}
				if (counts[3] > 0) {
					s += "P:" + counts[3] + " ";
					s2 += " (" + counts[3] + " Peroxisomes)";
					clips[thingCounter].visible = true;
					amounts[thingCounter].text = counts[3];
					clips[thingCounter++].gotoAndStop("perox");
					p_master.p_engine.notifyOHandler(EngineEvent.SELECT_THING, "null", "peroxisome", counts[3]);
				}
				if (counts[4] > 0) {
					s += "V:" + counts[4] + " ";
					s2 += " (" + counts[4] + " Vesicles)";
					clips[thingCounter].visible = true;
					amounts[thingCounter].text = counts[4];
					clips[thingCounter++].gotoAndStop("vesic");
				}
				if (counts[5] > 0) {
					s += "SE:" + counts[5] + " ";
					s2 += " (" + counts[5] + " Slicer Enzymes)";
					clips[thingCounter].visible = true;
					amounts[thingCounter].text = counts[5];
					clips[thingCounter++].gotoAndStop("slicer");
					p_master.p_engine.notifyOHandler(EngineEvent.SELECT_THING, "null", "slicer", counts[5]);
				}
				text_title.htmlText += s + "</b>";
				text_description.text = s2;
				hideStatPanel();
			}
			show();
		}else {
			hide();
		}
		}
		
		private function show() {
			if (hidden) {
				if (Engine.animationIsOn()) {
					animateOn();
				}else {
					animateOff();
				}
				y = IN_Y + height;
				yCount = YSPEED;
				yAccel = YACCEL;
				quickShow();
				//addEventListener(RunFrameEvent.RUNFRAME, doShow);
				hidden = false;
			}
		}
		
		private function hide() {
			p_selected = null;
			list_selected = null;
			if(!hidden){
				y = IN_Y;
				yCount = YSPEED;
				yAccel = YACCEL;
				quickHide();
				//addEventListener(RunFrameEvent.RUNFRAME, doHide);
				hidden = true;
				multiSelect = false;
			}
		}
	
		private function quickShow() {
			y = IN_Y;
			p_master.showActionMenu();
		}
		
		private function doShow(e:Event) {
			y -= yCount;
			yCount *= (1+yAccel);
			yAccel *= 0.95;
			if (y < IN_Y) {
				y = IN_Y;
				removeEventListener(RunFrameEvent.RUNFRAME, doShow);
				p_master.showActionMenu();
				
			}
		}
		
		private function quickHide() {
			y = OUT_Y;
		}
		
		private function doHide(e:Event) {
			y += yCount;
			yCount *= (1+yAccel);
			yAccel *= 0.95;
			if (y > OUT_Y) {
				y = OUT_Y;
				removeEventListener(RunFrameEvent.RUNFRAME, doHide);
			}
		}
		
		public function showCostPanelMOVE() {
			var cost:Number = Costs.getMoveCostByName(p_selected);
			if (cost) {
				c_costPanel.showMoveCost(cost);
			}
		}
		
		public function showCostPanelRECYCLE() {
			
			/*var a:Array = Costs.getRecycleCostByName(p_selected);
			if (a) {
				c_costPanel.showCost(a[0], -a[1], -a[2], -a[3], -a[4]);
			}*/
			var a:Array = p_master.p_engine.getRecycleCost();
			c_costPanel.showCost(a[0],-a[1],-a[2],-a[3],-a[4]); //display everything but ATP as a gain
		}
		
		
		public function showCostPanel(actionName:String) {
			//trace("SelectedPanel.showCostPanel() " + actionName);
			var a:Array;
			var length:int;
			var name:String;
			if (p_selected) {
				if (actionName == "move") { //move is a special case
					showCostPanelMOVE();				//These might not work for multiple units selected
				}else if (actionName == "recycle") {
					showCostPanelRECYCLE();
				}else if (actionName.substr(0, 4) == "buy_") { //buying basic units is a special case
					
					length = actionName.length;
					name = actionName.substr(4, length - 4);
					//trace("SelectedPanel.showCostPanel() buy_ name= " + name);
					var recycleNA:Boolean = true;
					if (name == "lysosome") {
						a = Costs.getMAKE_LYSOSOME(Act.LYSOSOME_X);
					}else if (name == "peroxisome") {
						a = Costs.getMAKE_PEROXISOME(Act.PEROXISOME_X);
					}else if (name == "slicer") {
						a = Costs.getMAKE_SLICER(Act.SLICER_X);
					}else if (name == "ribosome") {
						recycleNA = false;
						a = Costs.getMAKE_RIBOSOME(Act.RIBOSOME_X);
					}else if (name == "dnarepair") {
						a = Costs.getMAKE_DNAREPAIR(Act.DNAREPAIR_X);
					}
					
					if (a) {
						c_costPanel.showCost(a[0], a[1], a[2], a[3], a[4],recycleNA);
					}
				}else if (actionName.substr(0, 5) == "take_") {
					length = actionName.length;
					name = actionName.substr(5, length - 5);
					if (name == "membrane"){
						a = Costs.SELL_MEMBRANE;
					}else if (name == "defensin") {
						a = Costs.SELL_DEFENSIN;
					}
					
					if (a) {
						c_costPanel.showCost(a[0], -a[1], -a[2], -a[3], -a[4]);
					}
				}else if (actionName.substr(0,5) == "make_"){
					length = actionName.length;
					name = actionName.substr(5, length - 5);
					if (name == "membrane") {
						a = Costs.getMAKE_MEMBRANE(1);
					}else if (name == "defensin") {
						a = Costs.getMAKE_DEFENSIN(1);
					}else if (name == "toxin") {
						a = Costs.getMAKE_TOXIN(1);
					}
					
					if (a) {
						c_costPanel.showCost(a[0], a[1], a[2], a[3], a[4],true);
					}
				}else{
					a = Costs.getActionCostByName(p_selected, actionName);
					//trace("SelectedPanel.showCostPanel() name="+actionName + " actioncost = " + a);
					if(a){
						c_costPanel.showCost(a[0], a[1], a[2], a[3], a[4]);
					}
				}
			}
		}
		
		public function hideCostPanel() {
			c_costPanel.hide();
		}
		
		private function showStatPanel(s:Selectable) {
			if(s){
				if (s.hasIO()) {
					c_statPanel.gotoAndStop("io");
				}else {
					c_statPanel.gotoAndStop("normal");
					c_statPanel.setHealth(s.getHealth(), s.getMaxHealth());
					c_statPanel.setInfest(s.getInfest(), s.getMaxInfest());
					c_statPanel.setLevel(s.getLevel(),s.getMaxLevel());
				}
			}else {
				hideStatPanel();
			}
		}
		
		private function hideStatPanel() {
			c_statPanel.gotoAndStop("hide");
		}

		public function animateOn() {
			if (c_picture.clip) {
				if(!multiSelect){
					c_picture.clip.play();
				}else {
					if (c_picture.clip.clip1) {
						var i:int = 0;
						while (i < 5) {
							c_picture.clip["clip" + i].play();
						}
					}
				}
				c_picture.cacheAsBitmap = false;
			}
		}
		
		public function animateOff() {
			if(c_picture.clip){
				if(!multiSelect){
					c_picture.clip.stop();
					//gotoAndStop(1); //to avoid trouble with the multi select
				}else{
					if (c_picture.clip.clip1) {
						var i:int = 0;
						while (i < 5) {
							c_picture.clip["clip" + i].stop();
							//gotoAndStop(1);
						}
					}
				}
				//c_picture.clip.stop();
				c_picture.cacheAsBitmap = true;
			}
		}
		
	}
	
}
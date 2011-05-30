package {
	
	import com.pecLevel.EngineEvent;
	import com.pecSound.SoundLibrary;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import SWFStats.*;
	
	public class Interface extends Sprite{
		
		//pointers:
		public var p_engine:Engine;
		public var p_director:Director;
		
		//children:
		public var c_zoomer:Zoomer;
		
		public var c_quantPanel:QuantPanel;
		
		public var c_tt:Tooltip;
		
		public var c_tutorialGlass:TutorialGlass;
		//public var c_discovery:DiscoveryScore;
		public var c_membraneHealth:MembraneHealth;
		public var c_daughterCells:DaughterCells;
		public var c_ph:PH;
		public var c_sunlight:Sunlight;
		public var c_toxinLevel:ToxinLevel;
		
		public var c_resource_atp:Resource_atp;
		public var c_resource_na:Resource_na;
		public var c_resource_aa:Resource_aa;
		public var c_resource_fa:Resource_fa;
		public var c_resource_g:Resource_g;
		
		public var c_newThing:NewThingMenu;
		//public var c_centerButt:SimpleButton;
		public var c_followButt:ToggleButton;
		public var c_menuButt:SimpleButton;
		public var c_pauseButt:SimpleButton;
		
		public var c_selectedPanel:SelectedPanel;
		public var c_actionMenu:ActionMenu;
		public var c_messageBar:MessageBar;
		
		private static var exists:Boolean = false;
		
		private const ACTIONMENU_X:Number = 260;
		private const ACTIONMENU_Y:Number = 460;
		
		private var anim_on:Boolean = true;
		
		public static const QUANT_RIBO:int = 0;
		public static const QUANT_LYSO:int = 1;
		public static const QUANT_PEROX:int = 2;
		public static const QUANT_SLICER:int = 3;
		
		private const WHEEL_ZOOM_CLICKS:int = 2;
		
		
		
		
		public function Interface(){
			setEngine();
			checkSingleton();
			setupTooltip();
			setupButtons();
		}
		
		public function destruct() {
			exists = false;
		}
		
		public function init() {
			c_zoomer.init();
			c_quantPanel.init();
			c_messageBar.init();
			//addEventListener(MouseEvent.MOUSE_UP, engineNoSelect);
			addEventListener(MouseEvent.MOUSE_OVER, normalCursor);
			addEventListener(MouseEvent.MOUSE_OUT, fancyCursor);
			addEventListener(MouseEvent.ROLL_OUT, fancyCursor);
			addEventListener(MouseEvent.MOUSE_DOWN, engineNoSelect);
			addEventListener(MouseEvent.CLICK, engineNoSelect);
			addEventListener(RunFrameEvent.RUNFRAME, run);
			makeActionMenu();
			//showMessage(Messages.M_WELCOME);
			//showAlert(Messages.M_TEST);
			//showSpeech(Messages.M_GOODBYE);
		}
		
		public function takeOverZoomer(b:Boolean) {
			if(b)
				c_zoomer.takeOver();
			else	
				c_zoomer.unTakeOver();
		}
		
		public function setArrowShow() {
			c_tutorialGlass.setArrowShow(true);
		}
		
		private function normalCursor(m:MouseEvent) {
			p_director.normalCursor();
		}
		
		private function fancyCursor(m:MouseEvent) {
			p_director.fancyCursor();
		}
		
		private function run(r:RunFrameEvent) {
			c_resource_aa.dispatchEvent(r);
			c_resource_atp.dispatchEvent(r);
			c_resource_fa.dispatchEvent(r);
			c_resource_g.dispatchEvent(r);
			c_resource_na.dispatchEvent(r);
			c_selectedPanel.dispatchEvent(r);
		}
		
		public function setDirector(d:Director) {
			p_director = d;
		}
		
		private function setEngine(){
			p_engine = Engine(parent);
		}
		
		private function checkSingleton(){
			if(exists){
				throw new Error("Singleton Violation : " + this + " already exists!");
			}else{
				exists = true;
			}
		}
		
		private function engineNoSelect(m:MouseEvent) {
			m.stopPropagation();
		}
		
		private function setupButtons() {
			c_pauseButt.addEventListener(MouseEvent.CLICK, pauseButton);
			c_menuButt.addEventListener(MouseEvent.CLICK, menuButton);
			//c_centerButt.addEventListener(MouseEvent.CLICK, centerButton);
			c_followButt.addEventListener(ToggleButtonEvent.TOGGLE_OFF, endFollow);
			c_followButt.addEventListener(ToggleButtonEvent.TOGGLE_ON, startFollow);
			c_followButt.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//c_followButt.setFunctions(startFollow, endFollow);
		}
		
		private function setupTooltip(){
			c_tt = new Tooltip();
			addChild(c_tt);
		}

		public function showNewMenu(name:String, label:String) {
			c_newThing = new NewThingMenu();
			addChild(c_newThing);
			c_newThing.showMenu(name, label);
			c_newThing.setMaster(this);
			
		}
		
		public function onClickNewThingMenu(name:String) {
			removeChild(c_newThing);
			c_newThing = null;
			p_engine.onClickNewThing(name);
		}
		
		public function showTooltip(s:String,xx:Number,yy:Number,sh:int=0, sv:int=1){
			c_tt.showTextAt(s,xx,yy,sh,sv);
		}
		
		public function hideTooltip(s:String){
			c_tt.hideIfText(s);
		}
		
		/***MessageBar**********/
		
		public function showMessage(s:String) {
			c_messageBar.showText(s,MessageBar.NORMAL);
		}

		public function showEnemyWarning(s:String) {
			c_messageBar.showText(s, MessageBar.ENEMY_WARNING);
		}
		
		public function showAlert(s:String) {
			c_messageBar.showText(s, MessageBar.ALERT);
		}
		
		public function showSpeech(talker:String,emotion:String,msg:String) {
			c_tutorialGlass.setTalk(talker, emotion);
			c_messageBar.showText(msg, MessageBar.SPEECH);
		}
		
		public function onShowMessageBar(s:String) {
			if (s == Messages.A_NO_LYSO_R) {
				glowSomething(QUANT_LYSO);
			}else if (s == Messages.A_NO_RIBO_RNA) {
				glowSomething(QUANT_RIBO);
			}
		}
		
		public function glowSomething(i:int=-1,str:String=null) {
			if(i != -1){
				switch(i) {
					case QUANT_LYSO: 
					case QUANT_RIBO: 
					case QUANT_PEROX: 
					case QUANT_SLICER: 
						c_quantPanel.glowSomething(i);
					break;
				}
			}else {
				if (str == "discovery") {
					//c_discovery.unBlackOut();
					//c_discovery.glow();
				}else if (str == "daughtercell") {
					c_daughterCells.unBlackOut();
					c_daughterCells.glow();
				}else if (str == "membranehealth") {
					c_membraneHealth.unBlackOut();
					c_membraneHealth.glow();
				}
			}
		}
		
		/***Action Menu*********/
		
		private function makeActionMenu() {
			c_actionMenu = new ActionMenu();
			addChild(c_actionMenu);
			c_actionMenu.setInterface(this);
		}
		
		/**
		 * This sets up the action menu with the given actions. Remember, it won't be shown until the Interface
		 * calls showActionMenu(), which is triggered by the selectedPanel coming on screen
		 * @param	v
		 */
		
		public function showActionMenu() {
			//trace("Interface.showActionMenu()");
			c_actionMenu.doShowActions();
			//c_interface.showActionMenu();
		}

		public function showActionMenuCost(str:String) {
			c_actionMenu.showCost(str);
		}
		
		public function hideActionMenuCost() {
			c_actionMenu.hideCost();
		}
		
		public function setTimeGem(i:int) {
			c_messageBar.setTimeGemTime(i);
		}
		
		public function showActionCost(s:String) {
			//trace("Interface.showActionCost(" + s + ")");
			c_selectedPanel.showCostPanel(s);
		}
		
		public function hideActionCost() {
			//trace("Interface.hideActionCost()");
			c_selectedPanel.hideCostPanel();
		}
		
		public function doAction(i:int,s:String) {
			//trace("Interface.doAction(" + i + "," + s + ")");
			p_engine.doAction(i,s,false); 
		}
		
		public function prepareActionMenu(v:Vector.<int>) { 
			if(v){
				c_actionMenu.waitShowActions(v,ACTIONMENU_X, ACTIONMENU_Y);
				//c_interface.prepareActionMenu(v);
			}
		}
		
		public function hideActionMenu() {
			c_actionMenu.hide();
			//c_interface.hideActionMenu();
		}
		
		/***Selection functions*****/
		
		/*public function showActionMenu() {
			p_engine.showActionMenu();
		}*/
		
		public function showManySelected(v:Vector.<Selectable>) {
			c_selectedPanel.showManySelected(v);
		}
		
		public function showSelected(c:Selectable) {
			c_selectedPanel.showSelected(c);
		}
		
		public function wheelZoom(i:int) {
			c_zoomer.wheelZoom(i*WHEEL_ZOOM_CLICKS);
		}
		
		public function oldZoom() {
			c_zoomer.oldValue();
		}
		
		/****Respond to stuff******/
		
		public function changeZoom(n:Number) {
			p_engine.changeZoom(n);
		}
		
		private function pauseButton(m:MouseEvent) {
			p_engine.pause();
		}
		
		private function menuButton(m:MouseEvent) {
			p_engine.showInGameMenu();
		}
		
		public function centerOnCell() {
			p_engine.centerOnCell();
		}
		
		public function startFollow(t:ToggleButtonEvent) {
			//trace("Interface.startFollow()!");
			centerOnCell();
			p_engine.followCell(true);
		}
		
		public function endFollow(t:ToggleButtonEvent) {
			p_engine.followCell(false);
		}

		public function enemyAlert(type:String, count:int, wave_id:String="null") {
			c_tutorialGlass.enemyAlert(type, count, wave_id);
			var theThing:String = "";
			if (wave_id != "null") {
				theThing = wave_id;
			}else {
				theThing = type;
			}
			//trace("Interface.enemyAlert() theThing=" + theThing);
			p_engine.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "enemy_alert_start", theThing, count);
		}
		
		public function onFinishEnemyAlert(type:String, count:int, wave_id:String = "null") {
			var theThing:String = "";
			if (wave_id != "null") {
				theThing = wave_id;
			}else {
				theThing = type;
			}
			p_engine.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "enemy_alert_finish", theThing, count);
		}
		
		public function showButtNext() {
			c_tutorialGlass.showButtNext();
		}
		
		public function hideButtNext() {
			c_tutorialGlass.hideButtNext();
		}
		
		public function getNextObj() {
			hideButtNext();
			p_engine.doTheObjective();
		}
		
		public function hideTutorialText() {
			c_tutorialGlass.hideTutorialText();
		}
		
		public function happyGlowTutorial(txt:String=null,a:Array=null,soundLevel:int=0) {
			switch(soundLevel) {
				case 0: break;
				case 1: Director.startSFX(SoundLibrary.SFX_DISCOVERY_TWINKLE_LOW); break;
				case 2: Director.startSFX(SoundLibrary.SFX_DISCOVERY_TWINKLE); break;
			}
				
			c_tutorialGlass.happyGlow(txt,a);
		}

		public function onVirusTime(id:String,count:int) {
			p_engine.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_dormant", id, count);
		}
		
		public function review() {
			p_engine.reviewTutorialsAndStuff();
		}

		public function setSunlight(n:Number) {
			c_sunlight.setAmount(n);
		}
		
		public function setTemp(n:Number) {
			c_toxinLevel.setTemp(n);
		}
		
		public function setToxinLevel(n:Number) {
			c_toxinLevel.setAmount(n);
		}
		
		public function setDaughterCells(n:int,glow:Boolean=false) {
			c_daughterCells.setAmount(n);
			if (glow) {
				c_daughterCells.glow();
			}
		}
		
		public function setMembraneHealth(i:int) {
			c_membraneHealth.setHealth(i);
		}
		
		public function setMembraneShield(n:Number) {
			c_membraneHealth.setShield(n);
		}
		
		public function setDiscovery(n:int) {
			//c_discovery.setAmount(n);
		}
		
		public function setDiscoveryMax(m:int) {
			//c_discovery.setMax(m);
		}
		
		public function setPH(n:Number) {
			c_ph.setPH(n);
		}
		
		public function setZoomScale(z:Number) {
			c_zoomer.setZoomScale(z);
		}
		
		public function getZoomScale():Number {
			return c_zoomer.getZoomScale();
		}
		
		/*******************/
		
		public function hideInterfaceElement(id:String) {
			//trace("Interface.hideInterfaceElemtn(" + id + ")");
			if (id == "quantpanel") {
				c_quantPanel.blackOut();
			}else if (id == "discovery") {
				//c_discovery.blackOut();
			}else if (id == "ph") {
				c_ph.blackOut();
			}else if (id == "daughtercells") {
				//c_daughterCells.blackOut();
			}else if (id == "sunlight") {
				c_sunlight.blackOut();
			}else if (id == "toxinlevel") {
				c_toxinLevel.blackOut();
			}else if (id == "menu") {
				c_menuButt.visible = false;
			}else if (id == "pause") {
				c_pauseButt.visible = false;
			}else if (id == "tutorial_glass") {
				c_tutorialGlass.visible = false;
			}else if (id == "membranehealth") {
				c_membraneHealth.blackOut();
			}else if (id == "zoomer") {
				c_followButt.visible = false;
				c_zoomer.visible = false;
			}
		}
		
		public function showInterfaceElement(id:String) {
			if (id == "quantpanel") {
				c_quantPanel.unBlackOut();
			}else if (id == "discovery") {
				//c_discovery.unBlackOut();
			}else if (id == "daughtercells") {
				//c_daughterCells.unBlackOut();
			}else if (id == "ph") {
				c_ph.unBlackOut();
			}else if (id == "sunlight") {
				c_sunlight.unBlackOut();
			}else if (id == "toxinlevel") {
				c_toxinLevel.unBlackOut();
				c_toxinLevel.setID("toxin");
			}else if (id == "temperature") {
				c_toxinLevel.unBlackOut();
				c_toxinLevel.setID("temperature");
			}else if (id == "menu") {
				c_menuButt.visible = true;
			}else if (id == "pause") {
				c_pauseButt.visible = true;
			}else if (id == "tutorial_glass") {
				c_tutorialGlass.visible = true;
			}else if (id == "membranehealth") {
				c_membraneHealth.unBlackOut();
			}else if (id == "zoomer") {
				c_followButt.visible = true;
				c_zoomer.visible = true;
			}
		}
		
		public function hideResourceMeter(s:String) {
			var theMeter:ResourceMeter = this["c_resource_" + s];
			if (theMeter) {
				theMeter.blackOut();
			}else {
				throw new Error("Can't find : \"c_resource_" + s + "\" !");
			}
		}
		
		public function showResourceMeter(s:String) {
			var theMeter:ResourceMeter = this["c_resource_" + s];
			if (theMeter) {
				theMeter.unBlackOut();
			}else {
				throw new Error("Can't find : \"c_resource_" + s + "\" !");
			}
		}
		
		public function showEncyclopedia(s:String="root") {
			p_engine.showEncyclopedia(s);
		}
		
		public function newEncyclopediaEntry(s:String="root") {
			c_tutorialGlass.newEntry(s);
		}
		
		/*****Resource requesters*****/
		public function orderBasicUnit(index:int,target:int){
			p_engine.orderBasicUnit(index,target);
		}
		
		public function updateQuantSlider(){
			c_quantPanel.doCheckEq();
		}
		
		public function cancelBasicUnits() {
			p_engine.cancelBasicUnits();
		}
		
		public function orderBasicUnits(a:Array){
			if(a.length % 2 == 0 && a.length >= 2){
				for(var i = 0; i < a.length; i+=2){
					orderBasicUnit(a[i],a[i+1]);
				}
			}else{
				throw new Error("orderBasicUnits requires an array with an even number of at least 2 elements!");
			}
		}
		
		/*****Resource getters*********/
		
		public function getAffordArray(a:Array):Array{
			return p_engine.getAffordArray(a);
		}
		
		public function canAfford(atp:int,na:int,aa:int,fa:int,g:int):Boolean{
			return p_engine.canAfford(atp,na,aa,fa,g);
		}
		
		public function getResources():Array{
			return p_engine.getResources();
		}
		
		
		
		/*****Resource setters********/
		
		public function setResources(atp:Number,na:Number,aa:Number,fa:Number,g:Number,matp:Number,mna:Number,maa:Number,mfa:Number,mg:Number){
			c_resource_atp.setAmounts(atp,matp);
			c_resource_na.setAmounts(na,mna);
			c_resource_aa.setAmounts(aa,maa);
			c_resource_fa.setAmounts(fa,mfa);
			c_resource_g.setAmounts(g,mg);
		}

		public function oneMoreSlicer() {
			c_quantPanel.oneMoreSlicer();
		}
		
		public function oneMoreRibosome() {
			c_quantPanel.oneMoreRibosome();
		}
		
		public function oneLessRibosome() {
			c_quantPanel.oneLessRibosome();
		}
		
		public function oneLessLysosome() {
			c_quantPanel.oneLessLysosome();
		}
		
		public function oneLessPeroxisome() {
			c_quantPanel.oneLessPeroxisome();
		}
		
		public function oneLessSlicer() {
			c_quantPanel.oneLessSlicer();
		}

		public function setMaxes(mito:int,chloro:int,ribo:int,def:int,lyso:int,perox:int,slicer:int) {
			c_quantPanel.setMaxes(mito, chloro, ribo, def, lyso, perox, slicer);
		}
		
		public function setRibosomes(i:int,p:int){
			c_quantPanel.setRibosomes(i,p);
		}
		
		public function setDefensins(i:int, p:int, s:Number) {
			c_quantPanel.setDefensins(i, p);
			setMembraneShield(s);
		}
		
		public function setLysosomes(i:int,p:int){
			c_quantPanel.setLysosomes(i,p);
		}
		
		public function setPeroxisomes(i:int,p:int){
			c_quantPanel.setPeroxisomes(i,p);
		}
		
		public function setSlicers(i:int,p:int){
			c_quantPanel.setSlicers(i,p);
		}
		
		public function setMitochondria(i:int) {
			c_quantPanel.setMitochondria(i);
		}
		
		public function setChloroplasts(i:int) {
			c_quantPanel.setChloroplasts(i);
		}
		
		public function pauseAnimate(yes:Boolean) {
			if (!yes) { //we're unpausing
				if (anim_on) {
					animate(true);
				}
			}else {
				animate(false);
			}
		}
		
		private function animate(yes:Boolean) {
			if (yes) { 
				c_selectedPanel.animateOn(); 
			}else {
				c_selectedPanel.animateOff();
			}
			
		}
		
		public function animateOn() {
			anim_on = true;
			animate(true);
		}
		
		public function animateOff() {
			anim_on = false;
			animate(false);
		}
		
		
	}
}
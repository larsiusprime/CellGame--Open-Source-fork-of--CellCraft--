package 
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Slider;
	import fl.controls.NumericStepper;
	import fl.data.DataProvider;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.display.StageQuality;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_InGame extends MenuSystem implements IConfirmCaller
	{
		public var volMusic:Slider;
		public var volSound:Slider;
		
		public var buttRestart:SimpleButton;
		public var buttQuit:SimpleButton;
		public var buttAccept:SimpleButton;
		public var buttCancel:SimpleButton;
		public var buttDefault:SimpleButton;
		public var buttDebug:SimpleButton;
		
		public var quality:ComboBox;
		public var effects:ComboBox;
		public var membrane:ComboBox;
		public var animation:ComboBox;
		
		private var isDebug:Boolean = false;
		
		public static var _quality:String = StageQuality.MEDIUM; //high,*medium,low
		private const     __quality:int = 1; //selected index
		private static var _effects:int = 1; //fancy,*simple
		private const     __effects:int = 1;
		private static var _membrane:int = 0; //*high,low
		private const     __membrane:int = 0;
		private static var _animation:Boolean = true; //*on,off
		private const     __animation:Boolean = true;
		

		
		public static var _volMusic:Number = 25;
		private const     __volMusic:Number = 25;
		public static var _volSound:Number = 40;
		private const     __volSound:Number = 40;
		
		public var muteMusic:CheckBox;
		public var muteSound:CheckBox;
		public var hints:CheckBox;
		public var toolTips:CheckBox;
		public var alerts:CheckBox;
		
		public var autoZoom:CheckBox;
		
		public static var _autoZoom:Boolean = true;
		private const __autoZoom:Boolean = true;
		
		public static var _muteMusic:Boolean = false;
		private const     __muteMusic:Boolean = false;
		public static var _muteSound:Boolean = false;
		private const     __muteSound:Boolean = false;
		
		private static var _hints:Boolean = false;
		private const 	  __hints:Boolean = false;
		private static var _toolTips:Boolean = true;
		private const	  __toolTips:Boolean = true;
		private static var _alerts:Boolean = true;
		private const     __alerts:Boolean = true;
		
		public var gameSpeed:Slider;
		
		private static var _gameSpeed:Number = 50;
		private const	  __gameSpeed:Number = 50;
		
		public var gravPoints:CheckBox;
		//public var stepCloseEnough:NumericStepper;
		public var stepNodePush:NumericStepper;
		public var stepNodePull:NumericStepper;
		
		public var stepCentPull:NumericStepper;
		public var stepMinStretch:NumericStepper;
		public var stepFriction:NumericStepper;
		public var showGrid:CheckBox;
		public var showNodes:CheckBox;
		//public var stepBlebMult:NumericStepper;
		//public var stepBlebFrict:NumericStepper;
		
		
		private const __minStretch:Number = Membrane.MIN_STRETCH;
		private const __nodePush:Number = MembraneNode.NODE_PUSH;
		private const __nodePull:Number = MembraneNode.NODE_PULL;
		private const __centPull:Number = MembraneNode.CENT_PULL;
		//private const __closeEnough:Number = MembraneNode.CLOSE_ENOUGH;
		private const __friction:Number = MembraneNode.FRICT;
//		private const __blebFrict:Number = MembraneNode.BLEB_FRICT;
//		private const __blebMult:Number  = MembraneNode.BLEB_MULT;

		public var c_confirm:Confirmation;

		private var myTimer:Timer;
		
		public function MenuSystem_InGame() {
			
		}
		
		public override function init() {
			trace("MenuSystem_InGame.init()!");
			super.init();
			buttAccept.addEventListener(MouseEvent.CLICK, accept,false,0,true);
			buttCancel.addEventListener(MouseEvent.CLICK, cancel,false,0,true);
			buttDefault.addEventListener(MouseEvent.CLICK, defaults,false,0,true);
			buttQuit.addEventListener(MouseEvent.CLICK, quit,false,0,true);
			buttRestart.addEventListener(MouseEvent.CLICK, restart,false,0,true);
			if(buttDebug)
				buttDebug.addEventListener(MouseEvent.CLICK, debugMenu,false,0,true);	
			
			quality = new ComboBox();
			quality.x = 138;
			quality.y = 104;
			var xml:XML = 
			<items>
				<item label="High" value="high"/>
				<item label="Medium" value="medium"/>
				<item label="Low" value="low"/>
			</items>;

			quality.dataProvider = new DataProvider(xml);
			addChild(quality);
			
			membrane = new ComboBox();
			membrane.x = 138;
			membrane.y = 134;
			xml =
			<items>
				<item label="Curves" value="0"/>
				<item label="Lines" value="1"/>
			</items>;
			
			membrane.dataProvider = new DataProvider(xml);
			addChild(membrane);
			
			animation = new ComboBox();
			animation.x = 138;
			animation.y = 164;
			
			xml = 
			<items>
				<item label="On" value="true"/>
				<item label="Off" value="false"/>
			</items>;
			
			animation.dataProvider = new DataProvider(xml);
			addChild(animation);
			
			if (_animation)
				animation.selectedIndex = 0;
			else
				animation.selectedIndex = 1;
			
			if (_quality == "low") {
				quality.selectedIndex = 2;
			}else if (_quality == "medium") {
				quality.selectedIndex = 1;
			}else if (_quality == "high") {
				quality.selectedIndex = 0;
			}

			if (_membrane == 0) {
				membrane.selectedIndex = 0; //Curves
			}else if (_membrane == 1) {
				membrane.selectedIndex = 1; //Lines
			}
			
			//effects.selectedIndex = _effects;
			//membrane.selectedIndex = _membrane;
			//quality.selectedIndex = _quality;
			
			volMusic = new Slider();
			addChild(volMusic);
			volMusic.x = 331;
			volMusic.y = 118;
			volSound = new Slider();
			addChild(volSound);
			volSound.x = 331;
			volSound.y = 153;
			volMusic.minimum = 0;
			volMusic.maximum = 100;
			volMusic.value = _volMusic;
			volSound.minimum = 0;
			volSound.maximum = 100;
			volSound.value = _volSound;
			
			trace("MenuSystem_InGame.init() volMusic.value = " + volMusic.value + " volMusic = " + volMusic);
			
			muteMusic = new CheckBox();
			addChild(muteMusic);
			muteMusic.x = 417;
			muteMusic.y = 109;
			muteMusic.label = "Mute";
			
			muteSound = new CheckBox();
			addChild(muteSound);
			muteSound.x = 417;
			muteSound.y = 144;
			muteSound.label = "Mute";
			
			muteMusic.selected = _muteMusic;
			muteSound.selected = _muteSound;
			
			autoZoom = new CheckBox();
			addChild(autoZoom);
			autoZoom.x = 265;
			autoZoom.y = 272;
			autoZoom.label = "Yes";
			
			autoZoom.selected = _autoZoom;
			//gameSpeed.value = _gameSpeed;
			
			//hints.selected = _hints;
			//toolTips.selected = _toolTips;
			/*
			alerts = new CheckBox();
			addChild(alerts);
			alerts.x = 277;
			alerts.y = 264;
			alerts.label = "Enable Alerts";
			alerts.selected = _alerts;*/
		}
	
		public function showDebug() {
			stepMinStretch.value = Membrane.MIN_STRETCH;
			stepCentPull.value = MembraneNode.CENT_PULL;
			stepNodePull.value = MembraneNode.NODE_PULL;
			stepNodePush.value = MembraneNode.NODE_PUSH;
			//stepCloseEnough.value = MembraneNode.CLOSE_ENOUGH;
			gravPoints.selected = Membrane.SHOW_GRAVPOINTS;
			
			showGrid.selected = Cell.SHOW_GRID;
			
			showNodes.selected = Membrane.SHOW_NODES;
			stepFriction.value = MembraneNode.FRICT;
			//stepBlebFrict.value = MembraneNode.BLEB_FRICT;
			//stepBlebMult.value = MembraneNode.BLEB_MULT;
			
			
		}
		
		public function accept(m:MouseEvent) {
			if(!isDebug){
				updateGraphics();
			}
			else {
				updateDebug();
			}
			exit();
		}
		
		public function cancel(m:MouseEvent) {
			exit();
		}
		
		public function defaults(m:MouseEvent) {
			if (!isDebug) {
				animation.selectedIndex = __animation ? 0 : 1;
				membrane.selectedIndex = __membrane;
				//effects.selectedIndex = __effects;
				quality.selectedIndex = __quality;
				
				
				muteMusic.selected = __muteMusic;
				muteSound.selected = __muteSound;
				volMusic.value = __volMusic;
				volSound.value = __volSound;
				
				
				autoZoom.selected = __autoZoom;
				//gameSpeed.value = __gameSpeed;
				
				
				//hints.selected = __hints;
				//toolTips.selected = __toolTips;
				//alerts.selected = __alerts;
			}else{
				stepCentPull.value = __centPull;
				stepNodePull.value = __nodePull;
				stepNodePush.value = __nodePush;
				//stepCloseEnough.value = __closeEnough;
				gravPoints.selected = false;
				showNodes.selected = false;
				stepMinStretch.value = __minStretch;
				showGrid.selected = false;
				stepFriction.value = __friction;
				//stepBlebFrict.value = __blebFrict;
				//stepBlebMult.value = __blebMult;
			}
		}
		
		public function updateDebug() {
			MembraneNode.CENT_PULL = stepCentPull.value;
			MembraneNode.NODE_PULL = stepNodePull.value;
			MembraneNode.NODE_PUSH = stepNodePush.value;
			//MembraneNode.CLOSE_ENOUGH = stepCloseEnough.value;
			Membrane.SHOW_GRAVPOINTS = gravPoints.selected;
			Membrane.SHOW_NODES = showNodes.selected;
			Membrane.MIN_STRETCH = stepMinStretch.value;
			MembraneNode.FRICT = stepFriction.value;
			//MembraneNode.BLEB_FRICT = stepBlebFrict.value;
			//MembraneNode.BLEB_MULT = stepBlebMult.value;
			Cell.SHOW_GRID = showGrid.selected;
			if (showGrid.selected == true) {
				p_engine.p_cell.showGrid();
			}else {
				p_engine.p_cell.hideGrid();
			}
		}
		
		public function updateGraphics() {
			_animation = animation.selectedItem.value == "true" ? true : false;
			_membrane = membrane.selectedItem.value;
			//_effects = effects.selectedItem.data;
			_quality = quality.selectedItem.value;
			
			_muteMusic = muteMusic.selected;
			_muteSound = muteSound.selected;
			
			_volMusic = volMusic.value;
			_volSound = volSound.value;
			
			_autoZoom = autoZoom.selected;
			
			trace("MenuSystem_InGame.updateGraphics() _animation=" + _animation + " _membrane=" + _membrane + " _quality=" + _quality);
			
			//trace("MenuSystem_InGame.updateGraphics() volm=" + _volMusic + " vols=" + _volSound + " mutem=" + _muteMusic + " mutes=" + _muteSound);
			
			Director.setMusicVolume(_volMusic/100);
			Director.setSFXVolume(_volSound/100);
			
			if(Director.STATS_ON){Log.LevelRangedMetric("music_volume_menu", Director.level, _volMusic);}
			if(Director.STATS_ON){Log.LevelRangedMetric("music_volume_sound", Director.level, _volSound);}
			/*Log.CustomMetric("music_volume_menu_" + _volMusic, "sound");
			Log.CustomMetric("music_volume_sound_" + _volSound, "sound");*/
			
			if(Director.STATS_ON){Log.CustomMetric("music_mute_menu_" + _muteMusic, "sound");}
			if(Director.STATS_ON){Log.CustomMetric("music_mute_menu_" + _muteSound, "sound");}
			Director.setMusicMute(_muteMusic);
			Director.setSFXMute(_muteSound);
			//_gameSpeed = gameSpeed.value;
			
			if (_animation == true) { //if animation is ON
				trace("MenuSystem_InGame.Animation ON!");
				p_engine.setAnimation(true);
			}else {
				p_engine.setAnimation(false);
				trace("MenuSystem_InGame.Animation OFF!");
			}
			
			p_engine.setQuality(_quality);
			/*switch(_quality) {
				case 0: p_engine.setQuality(StageQuality.HIGH); break;
				case 1: p_engine.setQuality(StageQuality.MEDIUM); break;
				case 2: p_engine.setQuality(StageQuality.LOW); break;
			}*/
			
			trace("MenuSystem_inGame() _membrane = " + _membrane);
			Membrane.DRAW_QUALITY = _membrane;
			
			
			p_engine.setAutoZoom(_autoZoom);
			
			
			
		}
		
		public function debugMenu(m:MouseEvent) {
			/*if (!isDebug) {
				isDebug = true;
				gotoAndStop("debug");
				showDebug();
			}else {
				isDebug = false;
				gotoAndStop("root");
			}*/
		}
		
		public function restart(m:MouseEvent) {
			confirm("reset");
		}
			
		private function doRestart() {			
			exit();
			p_director.resetGame();
		}
		
		
		public function confirm(s:String) {
			c_confirm.confirm(this, s);
		}
		
		public function onConfirm(s:String, b:Boolean) {
			if (b) {
				if (s == "quit") {
					doQuit();
				}else if (s == "reset") {
					doRestart();
				}
			}
		}
		
		public function quit(m:MouseEvent) {
			confirm("quit");
		}
		
		private function doQuit(){
			exit();
			p_director.quitGame();
		}
		
	}
	
}
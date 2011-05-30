package{

	import com.cheezeworld.math.Vector2D;
	import com.woz.WizardOfOz;
	import fl.controls.Slider;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import com.pecSound.*;
	import com.pecLevel.*;
	import flash.utils.Timer;
	import SWFStats.Log;
	
	
	public class Engine extends Sprite{
		
		//pointers:
		public var p_director:Director;
		public var p_cell:Cell;
		public var p_cursor:Cursor;
		public var p_canvas:WorldCanvas;
		
		//organelle action lists:
		public var listact_nucleus:Vector.<int>;
		public var listact_centrosome:Vector.<int>;
		public var listact_mitochondrion:Vector.<int>;
		public var listact_chloroplast:Vector.<int>;
		public var listact_ribosome:Vector.<int>;
		public var listact_slicer:Vector.<int>;
		public var listact_dnarepair:Vector.<int>;
		public var listact_peroxisome:Vector.<int>;
		public var listact_golgi:Vector.<int>;
		public var listact_er:Vector.<int>;
		public var listact_lyso:Vector.<int>;
		//public var listact_
		
		public var list_fp_comm:Vector.<FauxPauseCommand>;
		
		//private var p_sound:SoundManager;
		
		private var p_selected:Selectable;
		private var point_selected:Point;
		//lists:
		private var list_selected:Vector.<Selectable>;
		private var list_lcd_actions:Vector.<int>;
		private var list_flags:Vector.<Flag>;
		
		private var dirty_wave_kill:Boolean = false; //we are not killchecking any waves
		
		private var list_wave_kills:Vector.<String>;
		private var wave_kill_count:int = 0;
		private var WAVE_KILL_TIME:int = 30;
		private var isVirusSafe:Boolean = true;
		
		private var movecost_precalc:Number; //precalculate the cost of moving 1 micron every time we seleect
		
		private var recyclecost_precalc:Array; //precalculate the cost of recycling every time we select
		
		private var selectType:int = -1;
		private var selectCode:int = SELECT_NONE;
		
		//data:
		public var lvl:BakedLevel;
		public var theLevelNum:int = 0;
		public var oHandler:ObjectiveHandler;
		
		//data objects:
		private var d_woz:WizardOfOz;
		private var d_tutArchive:TutorialArchive;
		
		//children:
		public var c_interface:Interface;
		private var c_world:World;
		private var c_mask:Shape;
		public var c_introMasker:MovieClip;
		
		public var p_virusGlass:VirusGlass;
		//
		//private var c_actionMenu:ActionMenu;
		
		//Basic resource amounts
		private var r_atp:Number = 0;
		private var r_na:Number = 0;
		private var r_aa:Number = 0;
		private var r_fa:Number = 0;
		private var r_g:Number = 0;

		private var r_max_atp:Number = 10000;
		private var r_max_na:Number = 1000;
		private var r_max_aa:Number = 1000;
		private var r_max_fa:Number = 1000;
		private var r_max_g:Number = 1000;

		private var dirty_resource:Boolean = true; //have we changed the resource amount since last flush?
		
		private var _defensins_ordered:int = 0;
		private var _defensins_produced:int = 0;
		private var _defensin_strength:Number = 0;
		
		private var _ribosomes_ordered:int = 0;
		private var _ribosomes_produced:int = 0;
		private var _lysosomes_ordered:int = 0;
		private var _lysosomes_produced:int = 0;
		private var _peroxisomes_ordered:int = 0;
		private var _peroxisomes_produced:int = 0;
		private var _slicers_ordered:int = 0;
		private var _slicers_produced:int = 0;
		private var _dnarepair_ordered:int = 0;
		private var _dnarepair_produced:int = 0;
		private var _count_chloro:int = 0;
		private var _count_mito:int = 0;
		
		private var dirty_basicUnit:Boolean = true; //have we changed a basic unit amount since last flush?
		
		private var buy_ribosomes:int = 0;
		private var buy_lysosomes:int = 0;
		private var buy_peroxisomes:int = 0;
		private var buy_slicers:int = 0;
		private var buy_dnarepair:int = 0;
		
		private var scrollX:int = 0;
		private var scrollY:int = 0;
		private var scrolling:Boolean = false;
		
		private var scrollSpeed:Number = 4;
		
		//are we processing any transactions this frame?
		private var transact:Boolean = false;
			
		private var c_cross:Cross;
		
		private var mouseIsDown:Boolean; //is the mouse down on the engine?
		private var c_selecter:Selecter;
		private var selectMode:Boolean = true;
		private var multiSelectMode:Boolean = false;
		
		private var didMouseDownCell:Boolean = false; //did we mouse down on the cell before this release?
		
		private var nextClickAct:int = Act.NOTHING;
		
		//private var objectiveCounter:int = 0;
		private var list_objectives:Vector.<Objective>;
		private var storedObjective:Objective;
		private var tutorialObjective:Objective; //this it the objective we're showing a tutorial about
		private var nextObjective:Objective;
		private var nextObjectiveText:String = "";
		//constants
		
		private static var MESSAGE_TIME:int = 30 * 30; //30 seconds
		private static var ANIMATION_ON:Boolean = true;
		
		public static const SELECT_ONE:int = 1;
		public static const SELECT_MANY:int = 2;
		public static const SELECT_NONE:int = 0;
		
		/*private var list_alert:Vector.<String>;
		private var list_message:Vector.<String>;
		private var list_speech:Vector.<String>;*/
		private var alert_last:String = "";
		private var message_last:String = "";
		private var speech_last:String = "";
		
		private var alert_counter:int = 0;
		private var message_counter:int = 0;
		private var speech_counter:int = 0;
		
		private var list_cursor:Vector.<int>;
		
		private var hist_tut:TutorialEntry;
		private var hist_msg:MessageEntry;
		private var hist_alert:String;
		
		private var introMaskerShown:Boolean = false;
		
		private var isGameOver:Boolean = false;
		
		private var extraLives:Number = 0;
		
		private var spend_checker:Array = [true,true,true,true,true];
		
				
		private var waitRecycleCount:int = 0;
		private var WAIT_RECYCLE_TIME:int = 5;
		
		private var manyRecycleCount:int = 0;
		private var manyRecyclePoint:Point;
		private var manyRecycleCost:Array = [0, 0, 0, 0, 0];
		
		private var count_down_count:int = 0; //to track the frames
		private var COUNT_DOWN_TIME:int = 30; //30 fps
		private var count_down_ticks:int = 0; //1 tick per 30 count
				
		include "inc_fastmath.as";
		
		
		private var doesHeatChange:Boolean = false;
		private var heat_change_amount:Number = 0;
		private var heat_change_time:int = 0;
		private var heat_change_count:int = 0;
		private var current_temperature:Number = 0;
		private var round_temperature:int = 0;
		
		private var hackTimer:Timer;		//used to get some clever tutorial interface things to show up correctly
		private const HACK_TIME:int = 25; //milliseconds
		
		private static var DIFFICULTY:int = DIFF_NORMAL;
		
		public static const DIFF_EASY:int = 0;
		public static const DIFF_NORMAL:int = 1;
		public static const DIFF_HARD:int = 2;
		
		
		private var load_timer:Timer;
		private var auto_build_perox:Boolean = false;
		
		private var auto_zoom_on_virus_attack:Boolean = true;
		
		private static var gpa_score_list:Array;
		private static var gpa_weight_list:Array;
		
		private static var level_timer:Timer;
		private static var time_seconds:int = 0;
		
		public function Engine() {
			manyRecyclePoint = new Point(0, 0);
			level_timer = new Timer(1000);
			level_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			level_timer.start();
			time_seconds = 0;
			makeMask();
		}
		
		private function onTimer(t:TimerEvent):void {
			time_seconds++;
		}
		
		public static function getTimeSeconds():int {
			return time_seconds;
		}
		
		private function makeMask() {
			c_mask = new Shape();
			c_mask.graphics.beginFill(0);
			c_mask.graphics.lineStyle(1, 0);
			c_mask.graphics.drawRect(0, 0, Director.STAGEWIDTH, Director.STAGEHEIGHT);
			c_mask.graphics.endFill();
			addChild(c_mask);
			mask = c_mask;
		}
		
		public static function setDifficulty(i:int) {
			var valid:Boolean = false;
			switch(i) {
				case DIFF_EASY: DIFFICULTY = DIFF_EASY; valid = true;
					
				
					break;
				case DIFF_NORMAL: DIFFICULTY = DIFF_NORMAL; valid = true;
				
				
					break;
				case DIFF_HARD: DIFFICULTY = DIFF_HARD; valid = true;
				
				
					break;
			}
		}
		
		public function setAutoZoom(b:Boolean) {
			auto_zoom_on_virus_attack = b;
		}
		
		public function destruct() {
			if (level_timer) {
				level_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				level_timer = null;
				time_seconds = 0;
			}
			Director.stopMusic();
			if(c_interface){
				c_interface.destruct();
				removeChild(c_interface);
				c_interface = null;
			}
			
			if(c_world){
				c_world.destruct();
				removeChild(c_world);
				c_world = null;
			}
			
			p_canvas = null;
			p_cell = null;
			p_director = null;
		}
		
		public function init(theLevel:int) {
			//c_introMasker = new IntroMasker();
			//addChild(c_introMasker);
			if(Director.STATS_ON){Log.LevelCounterMetric("begin_level", theLevel);}
			setupFlags();
			setupLists();
			setupObjectiveHandler();
			
			loadLevel(theLevel);

			c_interface.init();
			c_interface.setDirector(p_director);
			p_virusGlass = c_interface.c_tutorialGlass.c_virusGlass;
			
			flushInterface();
			makeListeners();
			makeSelecter();
			makeActionMenu();
			setChildIndex(c_interface, numChildren - 1);
			setChildIndex(c_introMasker, numChildren -1);
			//setChildIndex(c_actionMenu, numChildren - 1);
			point_selected = new Point();
			setupCursor();
			initMessaging();
			
			hackTimer = new Timer(HACK_TIME,3);
			

			//p_sound = new SoundManager();
		}
		
		private function loadLevel(num:int) {
			var c:Class;
			switch(num) {
				case 0: c = Level_00; break;
				case 1: c = Level_01; break;
				case 2: c = Level_02; break;
				case 3: c = Level_03; break;
				case 4: c = Level_04; break;
				case 5: c = Level_05; break;
				case 6: c = Level_06; break;
				case 7: c = Level_07; break;
				default: c = Level_Garden; break;
			}
			if (c == null) {
				throw new Error("Invalid Level Num :" + num);
			}
			lvl = new c(this);
			theLevelNum = num;
		}
		
		public function onLevelLoadWait(bl:BakedLevel) {
			lvl = bl;
			load_timer = new Timer(10, 0);
			load_timer.addEventListener(TimerEvent.TIMER, onLoadTime, false, 0, true);
			load_timer.start();
		}
		
		private function onLoadTime(t:TimerEvent) {
			load_timer.removeEventListener(TimerEvent.TIMER, onLoadTime);
			onLevelLoad();
		}
		
		public function onLevelLoad() {
			stage.quality = MenuSystem_InGame._quality;
			
			lvl.levelData.level_index = theLevelNum;
			
			getStartResources(); //set the beginning resources defined in the level
			Director.startMusic(SoundLibrary.MUS_CALM,true); //start the background music
			makeWorld();									 //setup the world, including the cell
			makeWOZ();										 //setup the WizardOfOz to control things
			makeTutArchive();								 //make the tutorial archive
			setChildIndex(c_introMasker, numChildren -1);	 //make sure the intro masker object is on top
			
			c_interface.setZoomScale(0.05); 				 //Set the zoom
			c_interface.setDiscovery(0);					 //Set discoveries to zero
			c_interface.setDiscoveryMax(lvl.levelData.levelDiscoveries.length); //set max discoveries to what's in the level
			
			
			loadObjectives();				//setup objectives, also:
											//accomplish the "load" objective so we can set initial conditions												
			if (!introMaskerShown) {		//probably don't need this if statement anymore, but oh well
				c_introMasker.play();
				introMaskerShown = true;
			}
			
			p_cell.setCytoProcess(true); //set this true by default
		}
		
		public function onIntroMaskerFinish() {
			//testTutorial();
			firstObjective();
		
			}
		
		
		
		private function getStartResources() {
			r_atp = lvl.levelData.start_atp;
			r_na = lvl.levelData.start_na;
			r_aa = lvl.levelData.start_aa;
			r_fa = lvl.levelData.start_fa;
			r_g = lvl.levelData.start_g;
			dirty_resource = true;
		}
		
		public function updateMaxResources() {
			r_max_aa = Cell.MAX_AA;
			r_max_fa = Cell.MAX_FA;
			r_max_g = Cell.MAX_G;
			r_max_na = Cell.MAX_NA;
			/*var area:Number = p_cell.getCircleVolume();
			r_max_aa = area * Cell.AA_CONCENTRATION;
			r_max_fa = area * Cell.FA_CONCENTRATION;
			r_max_g = area * Cell.G_CONCENTRATION;
			r_max_na = area * Cell.NA_CONCENTRATION;*/
			//p_cell.setMaxResources(r_max_atp, r_max_na, r_max_aa, r_max_fa, r_max_g);
			
			dirty_resource = true;
		}
		
		public static function logFinalTime(seconds:Number):void {
			if(Director.STATS_ON){Log.LevelAverageMetric("level_seconds",Director.level, seconds);}
			if(Director.KONG_ON){Director.kongregate.stats.submit("level_seconds_" + Director.level, seconds);}
			LevelProgress.setLevelTime(Director.level, seconds);
		}
		
		public static function logFinalGPA(score:Number, letterNum:int, performance:String) {
			if(Director.STATS_ON){Log.LevelAverageMetric("level_final_grade", Director.level, score);}
			if(Director.STATS_ON){Log.LevelRangedMetric("level_final_grade", Director.level, score);}
			if(Director.KONG_ON){Director.kongregate.stats.submit("level_grade_" + Director.level, letterNum);}
			LevelProgress.setLevelGrade(Director.level, letterNum);
		}
		
		public static function logGPA(score:Number, weight:Number) {
			gpa_score_list.push(score);
			gpa_weight_list.push(weight);
			
			if(Director.STATS_ON){Log.LevelAverageMetric("survived_virus_wave", Director.level,1);}
			if(Director.STATS_ON){Log.LevelCounterMetric("survived_virus_wave", Director.level);}
		}
		
		private function setupLists() {
		
			gpa_score_list = new Array();
			gpa_weight_list = new Array();
			
			listact_centrosome = new Vector.<int>();
			
			listact_chloroplast = new Vector.<int>();
			listact_chloroplast.push(Act.MOVE, Act.TOGGLE, Act.RECYCLE, Act.DIVIDE);
			
			listact_er = new Vector.<int>(); 
			listact_er.push(Act.MAKE_MEMBRANE, Act.TAKE_MEMBRANE, Act.BUY_PEROXISOME, Act.TOGGLE_AUTO_PEROXISOME); //Act.TAKE_MEMBRANE );
			
			listact_golgi = new Vector.<int>();
			listact_golgi.push(Act.BUY_LYSOSOME, Act.MAKE_DEFENSIN, Act.TAKE_DEFENSIN );
			
			listact_lyso = new Vector.<int>();
			listact_lyso.push(Act.MOVE, Act.RECYCLE);
			
			listact_mitochondrion = new Vector.<int>();
			listact_mitochondrion.push(Act.MOVE, Act.TOGGLE, Act.RECYCLE, Act.DIVIDE);
			
			listact_nucleus = new Vector.<int>();
			listact_nucleus.push(Act.BUY_RIBOSOME, Act.BUY_SLICER, Act.BUY_DNAREPAIR); //Act.MITOSIS, Act.APOPTOSIS,Act.NECROSIS);
			
			listact_peroxisome = new Vector.<int>();
			listact_peroxisome.push(Act.MOVE, Act.RECYCLE);
			
			listact_ribosome = new Vector.<int>(); 
			//listact_ribosome.push(Act.MOVE);
			
			listact_slicer = new Vector.<int>(); 
			listact_slicer.push(Act.RECYCLE); 
			
			listact_dnarepair = new Vector.<int>();
			listact_dnarepair.push(Act.RECYCLE);
			
			list_wave_kills = new Vector.<String>();
			list_fp_comm = new Vector.<FauxPauseCommand>();
		}
		
		public function getInfestWaveCount(s:String):int {
			var w:WaveEntry = d_woz.getWave(s);
			return w.original_count;
			//return d_woz.get
		}
		
		public function getWave(s:String):WaveEntry {
			return d_woz.getWave(s);
		}
		
		public function lookupActionList(i:int):Vector.<int> {
			switch(i) {
				case Selectable.CENTROSOME: return listact_centrosome; break;
				case Selectable.CHLOROPLAST: return listact_chloroplast; break;
				case Selectable._ER: return listact_er; break;
				case Selectable.GOLGI: return listact_golgi; break;
				case Selectable.LYSOSOME: return listact_lyso; break;
				case Selectable.MITOCHONDRION: return listact_mitochondrion; break;
				case Selectable.NUCLEUS: return listact_nucleus; break;
				case Selectable.PEROXISOME: return listact_peroxisome; break;
				case Selectable.RIBOSOME: return listact_ribosome; break;
				case Selectable.SLICER_ENZYME: return listact_slicer; break;
				case Selectable.DNAREPAIR: return listact_dnarepair; break;
				default: return null; break;
			}
		}
		
		private function setupFlags() {
			list_flags = new Vector.<Flag>;
		}
		
		private function setupCursor() {
			list_cursor = new Vector.<int>;
			list_cursor.push(Act.NOTHING);
		}
		
		private function makeSelecter() {
			c_selecter = new Selecter();			
			addChild(c_selecter);
			list_selected = new Vector.<Selectable>;
		}
		
		private function makeListeners() {
			addEventListener(MouseEvent.CLICK, this.click);
			addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
			
			addEventListener(Event.MOUSE_LEAVE, this.mouseKill);
		}
	
		public function getSelectCode():int{
			return selectCode;
		}
		
		public function getSelectMode():Boolean {
			return selectMode;
		}
		
		public function getMultiSelectMode():Boolean {
			return multiSelectMode;
		}
		
		public function setMultiSelectMode(yes:Boolean) {
			multiSelectMode = yes;
		}
		
		public function setSelectMode(yes:Boolean) {
			selectMode = yes;
			//trace("selectMode = " + selectMode);
		}
		
		private function click(m:MouseEvent) {
			
			if (selectMode) {
				
			}else {
				var o:Object = new Object();
				o.x = m.stageX;
				o.y = m.stageY;
				doAction(nextClickAct,Act.getS(nextClickAct),true,o);
				//trace("CLICK!");
			}
		}
		
		public function onWorldMouseDown() {
			//c_selecter.reset();
		}
		
		public function mouseDown(m:MouseEvent) {
			
			if(selectMode){
				unselectAll();
			}
			
			mouseIsDown = true;
		}
		
		public function cellMouseDown(m:MouseEvent) {
			
			didMouseDownCell = true;
			if(selectMode){
				unselectAll();
				if (multiSelectMode) {
					
					c_selecter.growAt(m.stageX, m.stageY);
				}
			}
			mouseIsDown = true;
		}
		
		public function mouseMove(m:MouseEvent) {
			
			if(selectMode){
				if (mouseIsDown && multiSelectMode && didMouseDownCell) {
					c_selecter.growTo(m.stageX, m.stageY);
				}
			}
		}
		
		private function mouseKill(e:Event) {
			
			c_selecter.reset();
			mouseIsDown = false;
			unselectAll();
		}
		
		public function mouseWheel(i:int) {
			c_interface.wheelZoom(i);
		}
		
		public function mouseUp(m:MouseEvent) {
			
			if(multiSelectMode && didMouseDownCell){
				if(!p_selected){
					c_selecter.stopGrow();
					selectStuff();
					//c_selecter.reset();
				}
			}
			didMouseDownCell = false;
			mouseIsDown = false;
		}
		
		private function selectStuff() {
			
			if(c_selecter.getSize() >= Selecter.MIN_SIZE){
				c_world.selectStuff(new Point(c_selecter.x, c_selecter.y), c_selecter.getSize());
			}
		}
		
		public function show() {
			visible = true;
		}
		
		public function hide() {
			visible = false;
		}
		
		public function setDirector(d:Director) {
			p_director = d;
		}
		
		public function setChloroCount(i:int) {
			_count_chloro = i;
			dirty_basicUnit = true;
		}
		
		public function setMitoCount(i:int) {
			_count_mito = i;
			dirty_basicUnit = true;
		}
		
		private function flushInterface(){
			
			if (dirty_resource) {
				c_interface.setResources(r_atp,r_na,r_aa,r_fa,r_g,
										 r_max_atp, r_max_na, r_max_aa, r_max_fa, r_max_g);
								
				if(p_cell){
					p_cell.setResources(r_atp, r_na, r_aa, r_fa, r_g, 
								    r_max_atp, r_max_na, r_max_aa, r_max_fa, r_max_g);
				}
				dirty_resource = false;
			}
			
			if (dirty_basicUnit) {
				c_interface.setRibosomes(_ribosomes_produced,_ribosomes_ordered);
				c_interface.setLysosomes(_lysosomes_produced,_lysosomes_ordered);
				c_interface.setPeroxisomes(_peroxisomes_produced,_peroxisomes_ordered);
				c_interface.setSlicers(_slicers_produced, _slicers_ordered);
				c_interface.setRibosomes(_ribosomes_produced, _ribosomes_ordered);
				c_interface.setDefensins(_defensins_produced, _defensins_ordered, _defensin_strength);
				c_interface.setMitochondria(_count_mito);
				c_interface.setChloroplasts(_count_chloro);
				c_interface.updateQuantSlider();
				
				dirty_basicUnit= false;
			}
		}
		
		public function fauxRun(e:RunFrameEvent) {
			//c_world.dispatchEvent(e);
			//c_interface.dispatchEvent(e);
			var length:int = list_fp_comm.length;
			var endZoom:Boolean = false;
			for (var i:int = 0; i < length; i++) {
				var f:FauxPauseCommand = list_fp_comm[i];
				doFauxPauseCommand(f);
				f.elapsed++;
				if (f.id == FauxPauseCommand.ZOOM) {
					endZoom = true;
				}
				if (f.elapsed >= f.time) {
					list_fp_comm[i] = null;	   //delete it
					list_fp_comm.splice(i, 1); //get rid of that one
					i--;	 //the next one slides into its place
					length--;//there is one less thing in this array
				}
			}
			if (length <= 0) { //if there's nothing left because we killed them all
				
				p_director.endFauxPause(); //end the faux pause
				if(endZoom){ //we ended them ALL And one was a zoom, we ended a zoom!
					onEndFauxPauseZoom();
				}
			}
			if (p_cell) {
				p_cell.fauxRun();
			}
		}
		
		/**
		 * For the love of pants, do NOT do multiple instances of a single fauxpause command! You can mix types, but only 1 of each!
		 * @param	f
		 */
		
		private function doFauxPauseCommand(f:FauxPauseCommand) {
			switch(f.id) {
				case FauxPauseCommand.ZOOM: c_interface.setZoomScale(f.ovalue + (f.dvalue * f.elapsed)); 
											break;
				case FauxPauseCommand.SCROLL_TO: c_world.centerOnPoint(f.ox + (f.dx * f.elapsed), f.oy + (f.dy * f.elapsed)); 			
											break;
			}
		}
		
		public function run(e:RunFrameEvent){
			tick();
			c_world.dispatchEvent(e);
			c_interface.dispatchEvent(e);
			d_woz.dispatchEvent(e);
			oHandler.dispatchEvent(e);
		}
		
		private function tick() {
			if(transact){
				doTransactions();
			}
			checkKeys();
			checkScroll();
			tickMessaging();
			flushInterface();
		}
		
		
		private function growSelectCircle() {
			//c_selecter.grow();
		}
		
		/*
		 * 
		 */
		
		public function pauseAnimate(yes:Boolean) {
			
			if (yes) {
				level_timer.stop();
			}else {
				level_timer.start();
			}
			
			if(yes == false){
				stage.quality = MenuSystem_InGame._quality;
			}
			if(c_world){
				c_world.pauseAnimate(yes);
			}
			if(c_interface){
				c_interface.pauseAnimate(yes);
			}
		}
		 
		public function setAnimation(yes:Boolean) {
			c_world.setAnimation(yes);
			ANIMATION_ON = yes;
			if(yes){
				c_interface.animateOn();
			}else{
				c_interface.animateOff();
			}
		}
		
		public static function animationIsOn():Boolean {
			return ANIMATION_ON;
		}
		
		public function setQuality(s:String) {
			stage.quality = s;
		}
		
		
		
		public function doCheckKeys() {
			checkKeys();
		}
		
		public function testMembrane() {
			p_cell.makeMembrane();
		}
		
		public function testMembrane2() {
			p_cell.takeMembrane();
		}
		
		public function cheat(i:int) {
			trace("Engine.Cheat(" + i+")");
			switch(i) {
				case Director.CHEAT_0: nextLevel(); break;
				case Director.CHEAT_1: testMembrane(); break;
				case Director.CHEAT_2: testMembrane2(); break;
				case Director.CHEAT_3:
				case Director.CHEAT_4:
				case Director.CHEAT_5:
				case Director.CHEAT_6:
				case Director.CHEAT_7:
				case Director.CHEAT_8:
				case Director.CHEAT_9:
			}
		}
		
		/**
		 * checkKeys() does not check ANY keycodes directly - that is all abstractly handled by the director. The only
		 * thing that checkKeys() checks for is if the "up" "down" "left" or "right" keys - whatever they are - are up 
		 * or down right now. The director handles all of that, and the actual key values for those can be changed through
		 * the director.
		 * 
		 * checkKeys checks what keys are down, and sets up scrolling in that direction
		 */
		 
		public function checkKeys() {
			scrollX = 0;
			scrollY = 0;
			scrolling = false;
			
			if (p_director.getArrow(0)){
				scrollY = -1;
				scrolling = true;
			}else if (p_director.getArrow(1)) {
				scrollY = 1;
				scrolling = true;
			}
			
			if (p_director.getArrow(2)) {
				scrollX = -1;
				scrolling = true;
			}else if(p_director.getArrow(3)){
				scrollX = 1;
				scrolling = true;
			}
		}
		
		private function checkScroll() {
			if (scrolling) {
				c_world.doScroll(scrollX * scrollSpeed, scrollY * scrollSpeed);
			}
		}
	
		public function changeZoom(n:Number) {
			if(c_world)
				c_world.changeZoom(n);
		}

		public function followCell(yes:Boolean) {
			if (c_world) {
				c_world.followCell(yes);
			}
		}
		
		//public function 
		
		
		public function centerOnOrganelle(c:CellObject) {
			if (c_world){
				c_world.centerOnPoint(p_cell.c_centrosome.x+c.x,p_cell.c_centrosome.y+c.y);
			}
		}
		
		public function centerOnCell() {
			if (c_world)
				c_world.centerOnCell();
		}
		
		/*private function setCell(c:Cell) {
			p_cell = c;
			p_cell.setEngine(this);
		}*/
		
		public function receiveCanvas(c:WorldCanvas) {
			p_canvas = c;
		}
		
		public function receiveCursor(c:Cursor) {
			p_cursor = c;
			
		}
		
		public function receiveCell(c:Cell) { //called by World when the cell has its engine set
			p_cell = c;
			p_cursor.setCell(p_cell);
		}
		
		private function makeWorld() {
			c_world = new World();
			addChild(c_world);
			c_world.setDirector(p_director);
			c_world.setEngine(this);
			c_world.setInterface(c_interface);
			c_world.setLevel(lvl.levelData.background_name,lvl.levelData.size_height,lvl.levelData.size_width);
			c_world.setStartPoint(lvl.levelData.start_x, lvl.levelData.start_y);
			if (lvl.levelData.boundary_circle) {
				c_world.setBoundaryCircle(lvl.levelData.boundary_circle_r);
			}else if (lvl.levelData.boundary_box) {
				c_world.setBoundaryBox(lvl.levelData.boundary_box_w,lvl.levelData.boundary_box_h);
			}
			c_world.init();
			//setCell(c_world.getCell());
			
			setChildIndex(c_selecter, numChildren - 1);  //put the selecter back on top
			setChildIndex(c_interface, numChildren - 1); //put the interface back on top
				
			addEventListener(RunFrameEvent.RUNFRAME, run);
			addEventListener(RunFrameEvent.FAUXFRAME, fauxRun);
			
			//c_cross = new Cross();
			//addChild(c_cross);	
			p_cursor.setWorld(c_world);
		}
		
		private function makeTutArchive() {
			d_tutArchive = new TutorialArchive();
			d_tutArchive.setEngine(this);
			
		}
		
		private function makeWOZ() {
			d_woz = new WizardOfOz();
			d_woz.setEngine(this);
			d_woz.setCell(p_cell);
			
			d_woz.setCanvas(p_canvas);
			p_cell.receiveWoz(d_woz);
			p_canvas.receiveWoz(d_woz);
			d_woz.init(lvl.levelData,c_world.getMaskSize());
		}

		public function onUpdateMaskSize(r:Number) {
			if(d_woz){
				d_woz.updateLensSize(r);
			}
		}
		
		public function getWorldScale():Number {
			return c_world.getScale();
		}
		
		/*****************************************/
		

		
		
		
		
		
		
		/******************************************/
		
		public function doAction(i:int, s:String, click:Boolean, params:Object = null) {
			//trace("Engine.doAction() : #" + i + " s=" + s +" click?=" + click);
			//trace("action = " + i + " s = " + s + " click = " + click + " params = " + params);
			var doIt:Boolean = false; //do the action yet?
			var params:Object;
			var failCode:int =  FailCode.SUCCESS;
			if(!click){	//if this action was not called by clicking on the map
				switch(i) {
					case Act.MOVE:					//Move TO this position
						showCursor(i);
						nextClickAct = i;	//store the action for the next click
						doIt = false; 		//don't do it yet
						notifyOHandler(EngineEvent.EXECUTE_ACTION, "null", "prepare_move", 1);
						break;
					case Act.MAKE_TOXIN:
						failCode = buyToxin();
						break;
					case Act.MAKE_DEFENSIN:
						failCode = buyDefensin();
						break;
					case Act.TAKE_DEFENSIN:
						failCode = sellDefensin();
						break;
					case Act.MAKE_MEMBRANE:
						failCode = buyMembrane();
						break;
					case Act.TAKE_MEMBRANE:
						failCode = sellMembrane();
						break;
					default:
						doIt = true;
						nextClickAct = Act.NOTHING;
						break;
						
				}
				if (failCode != FailCode.SUCCESS) {
					showImmediateAlertCode(failCode);
				}
			}else {
				switch(i) {
					case Act.MOVE:
						lastCursor();
						nextClickAct = Act.NOTHING;
						doIt = true;
						break;
					default:
						doIt = false;
						nextClickAct = Act.NOTHING;
						break;
				}
			}
			if(doIt){
				switch(selectCode) {
					case SELECT_ONE: 
						if (executeAction_single(i, s, params)) {
							notifyOHandler(EngineEvent.EXECUTE_ACTION, "null", s, 1);
						}else {
							notifyOHandler(EngineEvent.FAIL_ACTION, "null", s, 1);
						}
						break;
					case SELECT_MANY: 
						var successes:int = executeAction_many(i, s, params);
						if(successes > 0){
							notifyOHandler(EngineEvent.EXECUTE_ACTION, "null", s, successes);
						}
						break;
				}
			}
		}
		
		public function setCursorArrowRotation(r:Number) {
			p_director.c_cursor.setArrowRotation(r);
		}
		
		public function setCursorArrowPoint(xx:Number, yy:Number) {
			var p:Point = new Point(xx, yy);
			p = c_world.reverseTransformPoint(p);
			p_director.c_cursor.setArrowPoint(p.x, p.y);
		}
		
		public function endCursorArrow() {
			p_director.c_cursor.endArrow();
		}
		
		public function showCursor(i:int) {
			var length:int = list_cursor.length;
			var last:int = list_cursor[length - 1];
			if (last != i) {
				list_cursor.push(i);
				p_director.showCursor(i);	
			}
			
		}
		
		public function lastCursor() {
			var length:int = list_cursor.length;
			if(length > 0){
				var last:int = list_cursor[length - 1];
				if (last != Act.NOTHING) {
					list_cursor.pop();
					last = list_cursor[length - 2];
					p_director.showCursor(last);
				}else {
					p_director.showCursor(Act.NOTHING);
				}
			}else { //if we somehow arrive at an empty list
				p_director.showCursor(Act.NOTHING);
			}
			
		}
		
		private function executeMOVE_single(params:Object):Boolean {
			var cost = Costs.getMoveCostByName(p_selected);
			var p:Point = new Point(params.x, params.y);
			p = c_world.transformPoint(p);
			var dist:Number = getDist(p.x, p.y, p_selected.x, p_selected.y);
			dist /= Costs.MOVE_DISTANCE;
			cost *= dist;
			//if(spendATP(cost)){
				p_selected.moveToPoint(p, GameObject.FLOAT);
			//}
			return true;
		}
		

		/**
		 * Assuming you have a list of units selected, this will return the cost of moving them to that point
		 * @param	xx yy
		 * @return cost of movement
		 */
		
		public function getMoveCost(xx:Number, yy:Number):Number {
			
			var p:Point = new Point(xx,yy);
			p = c_world.transformPoint(p);
			var dist:Number = getDist(p.x, p.y, p_selected.x, p_selected.y);
			dist /= Costs.MOVE_DISTANCE;
			var cost:Number = (movecost_precalc * dist);
			return cost;
		}
		
		public function getRecycleCost():Array {
			return recyclecost_precalc;
		}
		
		private function precalcRecycleCost() {
			var a:Array = [0, 0, 0, 0, 0];
			
			if (list_selected.length > 0) {
				for each(var s:Selectable in list_selected) {
					var a1:Array = Costs.getRecycleCostByName(s);
					a[0] += a1[0];
					a[1] += a1[1];
					a[2] += a1[2];
					a[3] += a1[3];
					a[4] += a1[4];
				}
			}else {
				if (p_selected) {
					a = Costs.getRecycleCostByName(p_selected);
				}
			}
			recyclecost_precalc = a;
		}
		
		/**
		 * This is done every time a group of units is selected, in case we want to move them
		 * It stores the cost of moving all of them by 1 micron in movecost_precalc
		 */
		
		private function precalcMoveCost() { 
			var cost:Number = 0;
			if(list_selected.length > 0){
				for each (var s:Selectable in list_selected) {
					var c:Number = Costs.getMoveCostByName(s);
					cost += c;
				}
			}else {
				if(p_selected)
					cost = Costs.getMoveCostByName(p_selected);
				
			}
			movecost_precalc = cost;
		}
		
		public function finishMitosis() {
			extraLives++;
			c_interface.setDaughterCells(extraLives,true);
		}

		public function setSunlight(n:Number) {
			c_interface.setSunlight(n);
			p_cell.setSunlight(n);
		}
		
		public function setToxinLevel(n:Number) {
			c_interface.setToxinLevel(n);
			p_cell.setToxinLevel(n);
		}
		
		private function executeMITOSIS() {
			unselectAll();
			p_director.showCinema(Cinema.MITOSIS);
		}
		
		private function executeNECROSIS() {
			p_cell.startNecrosis();
			unselectAll();
			selectMode = false;
			multiSelectMode = false;
		}
		
		private function executeCANCEL_RECYCLE_single() {
			if(p_selected is CellObject){
				p_cell.cancelRecycle(CellObject(p_selected)); //ONLY works for things that recycle in a vesicle!
			}
		}
		
		private function executeRECYCLE_single() {
			//NEED an ATP Check
			
			var success:Boolean = p_cell.startRecycle(p_selected);
			if(success){
				refreshActionList();
			}
			//unselectAll();
		}
		
		private function executeRECYCLE_many():int {
			
			var successes:int = 0;
			//NEED an ATP check
			
			for each(var thing:Selectable in list_selected) {
				if (p_cell.startRecycle(thing,true)) {
					successes++;
				}
				//thing.startRecycle();
			}
			unselectAll();
			return successes;
		}
		
		private function executeMOVE_many(xx:Number,yy:Number) {
			var cost:Number = 0;
			cost = getMoveCost(xx,yy);
			var p:Point = new Point(xx, yy);
			p = c_world.transformPoint(p);
			//if (spendATP(cost)) {
				var list:Vector.<Number> = getMultiSelectPoints(p);
				var length:Number = list_selected.length;
				var j:int = 0;
				for (var i:int = 0; i < length; i++) {
					list_selected[i].externalMoveToPoint(new Point(list[(2*i)], list[(2*i)+1]), GameObject.FLOAT);
					
				}
			//}
		}
		
		public function getSpiralPoints(p:Point, length:Number, rad:Number):Vector.<Number> {
			var list:Vector.<Number> = new Vector.<Number>;
			list.push(p.x, p.y); //first, stick the first point in the center;
			if (length > 1) {
				var done:Boolean = false;
				var currCirc:Number = 1; //start on the 1st circle
				while (length > 0) {
					var r:Number = (rad * (currCirc * 2)) + rad; //one for the one in the middle, plus 2 for each ring
					var dots:int = int((TWOPI * r) / (2 * rad)); //how many can fit
				
					var circPoints:Vector.<Number> = circlePointsOffset(r, dots, p.x, p.y);
					for each(var n:Number in circPoints) {
						list.push(n);
					}
					//list.concat(circPoints);
					//list.concat(circlePointsOffset(rad, dots, p.x, p.y)); //get the new points and add them to the list of points
					currCirc++;
					length -= dots; //when this reaches 0 or less, we're done
				}
			}
			return list;
		}
		
		private function getMultiSelectPoints(p:Point):Vector.<Number> {
			var length:Number = list_selected.length;
			var rad:Number = (list_selected[0].getRadius());
			
			return getSpiralPoints(p, length, rad);
			
			/*var list:Vector.<Number> = new Vector.<Number>;
			list.push(p.x, p.y); //first, stick the first point in the center;
			if (length > 1) {
				var done:Boolean = false;
				var currCirc:Number = 1; //start on the 1st circle
				while (length > 0) {
					var r:Number = (rad * (currCirc * 2)) + rad; //one for the one in the middle, plus 2 for each ring
					var dots:int = int((TWOPI * r) / (2 * rad)); //how many can fit
				
					var circPoints:Vector.<Number> = circlePointsOffset(r, dots, p.x, p.y);
					for each(var n:Number in circPoints) {
						list.push(n);
					}
					//list.concat(circPoints);
					//list.concat(circlePointsOffset(rad, dots, p.x, p.y)); //get the new points and add them to the list of points
					currCirc++;
					length -= dots; //when this reaches 0 or less, we're done
				}
			}
			return list;*/
		}
		
		private function executeAction_single(i:int, s:String, params:Object=null):Boolean {
			//trace("Engine.executeAction_single() #:" + i + "s=" + s);
			var generic:Boolean = false;
			switch(i) {
				case Act.MOVE:
					return executeMOVE_single(new Point(params.x,params.y));
					break;
				case Act.MITOSIS:
					generic = false;
					return executeMITOSIS();
					break;
				//free actions
				case Act.NECROSIS:
					generic = false;
					return executeNECROSIS();
					break;
				case Act.RECYCLE:
					generic = false;
					return executeRECYCLE_single();
					break;
				case Act.CANCEL_RECYCLE:
					generic = false;
					return executeCANCEL_RECYCLE_single();
					break;
				/*case Act.TAKE_DEFENSIN:
					return trySellDefensin();
					break;
				case Act.TAKE_MEMBRANE:
					return trySellMembrane();
					break;*/
				case Act.BUY_LYSOSOME:
					return tryBuyBasicUnit(BasicUnit.LYSOSOME, Act.LYSOSOME_X);
					break;
				case Act.BUY_PEROXISOME:
					return tryBuyBasicUnit(BasicUnit.PEROXISOME, Act.PEROXISOME_X);
					break;
				case Act.BUY_SLICER:
					return tryBuyBasicUnit(BasicUnit.SLICER, Act.SLICER_X);
					break;
				case Act.BUY_RIBOSOME:
					return tryBuyBasicUnit(BasicUnit.RIBOSOME, Act.SLICER_X);
					break;
				case Act.BUY_DNAREPAIR:
					return tryBuyBasicUnit(BasicUnit.DNAREPAIR, Act.DNAREPAIR_X);
					break;
				case Act.MAKE_GOLGI:
					return false;
					//return tryMakeGolgi();
					break;
				case Act.DIVIDE:
					return tryDivideSelected() == FailCode.SUCCESS;
					break;
				case Act.DISABLE:
				case Act.ENABLE:
				case Act.DISABLE_BROWN_FAT:
				case Act.ENABLE_BROWN_FAT:
					generic = false;
					var yes:Boolean = p_selected.doAction(i);
					refreshActionList();
					return yes;
					break;
				case Act.DISABLE_AUTO_PEROXISOME:
					generic = false;
					auto_build_perox = false;
					refreshActionList();
					return true;
					break;
				case Act.ENABLE_AUTO_PEROXISOME:
					generic = false;
					auto_build_perox = true;
					refreshActionList();
					return true;
				default:
					generic = true;
					break;
			}
			if(generic){
				var cost:Array = Costs.getActionCostByName(p_selected, s);
				if (spend(cost)) {
					return p_selected.doAction(i);
				}else {
					notifyOHandler(EngineEvent.CANT_AFFORD_ACTION, "null", s, 1);
					showImmediateAlertCode(FailCode.CANT_AFFORD);
					//showImmediateAlert("Can't afford: ("+ s + " " + p_selected.text_id + " "+")");
					return false;
				}
			}
			return false;
		}
		
		private function tryDivideSelected():int {
			var type:int = p_selected.num_id;
			var max:int;
			var count:int;
			switch(type) {
				case Selectable.MITOCHONDRION: count = _count_mito;  max = Cell.MAX_MITO; break;
				case Selectable.CHLOROPLAST: count = _count_chloro;  max = Cell.MAX_CHLORO; break;
			}
			var code:int = FailCode.TOTAL_FAIL;
			if (count < max) {
				var cost:Array = Costs.getActionCostByName(p_selected, "divide");
				var c:CellObject = CellObject(p_selected);
				if(c.canDivide()){
					if (spend(cost)) {
						if (p_selected.doAction(Act.DIVIDE)) {
							code = FailCode.SUCCESS; //we did it!
						}else {
							code = FailCode.TOTAL_FAIL; //we tried but failed!
						}
					}else {
						code = FailCode.CANT_AFFORD;
					}
				}else {
					code = FailCode.ALREADY_DIVIDING;
					//code = FailCode.CANT_AFFORD;    //we can't afford it!
				}
			}else {
				code = FailCode.AT_MAX;			 //we have too many of those!
			}
			
			if (code != FailCode.SUCCESS) {
				showImmediateAlertCode(code);
			}
			return code;
		}
		
		
		private function executeAction_many(i:int, s:String, params:Object = null):int {
			//trace("Engine.executeAction_many() #:" + i + "s=" + s);
			var generic:Boolean;
			var successes:int = 0; //how many did it work on?
			switch(i) {
				case Act.MOVE:
					successes = list_selected.length;
					executeMOVE_many(params.x,params.y);
					generic = false;
					break;
				case Act.RECYCLE:
					successes = executeRECYCLE_many();
					generic = false;
					break;
				default:
					generic = true;
					break;
			}
			if (generic) {
				var thing:Selectable;
				var tempC:Array;
				var cost:Array;
				cost = new Array(0, 0, 0, 0, 0);
				for each(thing in list_selected) {
					tempC = Costs.getActionCostByName(thing, s);
					if(tempC){
						var length:int = tempC.length;
						for (var j:int = 0; j < length; j++){
							cost[j] += tempC[j];
						}
					} //otherwise cost is 0
				}
				if(spend(cost)){
					for each(thing in list_selected){
						if (thing.doAction(i, params)) {
							successes++;
						}
					}
				}
			}
			return successes;
		}
		
		/******************************************/
		
		public function unDoomCheck(c:Selectable) {
			if (p_selected == c && selectCode == SELECT_ONE) {
				refreshActionList();
				
			}
		}
		
		public function selectOne(c:Selectable,xx:Number,yy:Number) {
			//trace("Engine.selectOne : " + c);
			if (p_selected != c) {
				unselectAll();
				
				selectCode = SELECT_ONE;
				//c_world.darkenAll();
				p_selected = c;

				
				prepareActionMenu(p_selected.getActionList());
				precalcMoveCost();
				precalcRecycleCost();


				c_interface.showSelected(c);
				//c.undarken();
				c.makeSelected(true);
				point_selected.x = xx;
				point_selected.y = yy;

				notifyOHandler(EngineEvent.SELECT_THING, "null", c.getTextID(), 1);
				
			}else {
				unselectAll();
			}

		}
		
		public function updateMuteButton() {
			c_interface.c_selectedPanel.updateMuteButton();
		}
		
		public function updateSelected() {
			refreshActionList();
			if (selectCode == SELECT_ONE) {
				if(p_selected.dying == false){
					c_interface.showSelected(p_selected);
				}else {
					c_interface.showSelected(null);
				}
			}else if (selectCode == SELECT_MANY) { 
				if (list_selected.length == 1) {		//for now we only use this for HP, which only shows up when 1 thing is selected
					c_interface.showManySelected(list_selected);
				}
			}
		}
		
		public function refreshActionList() {
			if (selectCode == SELECT_ONE) {
				//if(!p_selected.isDoomed){
					prepareActionMenu(p_selected.getActionList());
				//}else {
				//	prepareActionMenu(p_selected.getDoomList());
				//}
			}else if (selectCode == SELECT_MANY) {
				list_lcd_actions = null;
				for each(var s:Selectable in list_selected) {
					lcdActionMenu(s.getActionList());
				}
				prepareActionMenu(list_lcd_actions);
			}
			c_interface.showActionMenu();
		}
		
		public function setSelectType(n:int) {
			if (n == Selectable.MEMBRANE){
				selectType = Selectable.NOTHING;
			}else{
				selectType = n;
			}
		}
		
		public function updateActionMenu() {
			/*trace("Engine.updateActionMenu() !");
			prepareActionMenu(p_selected.getActionList());
			precalcMoveCost();
			c_interface.showSelected(p_selected);*/
		}
		

		
		public function unselectAll() {
			selectCode = SELECT_NONE;
			list_lcd_actions = null;
			
			
			c_interface.showSelected(null);
			hideActionMenu();
			
			if (p_selected) {
				p_selected.makeSelected(false);
				p_selected = null;
			}
			
			if(list_selected){
				for each(var item:Selectable in list_selected) {
					item.makeSelected(false);
				}
				list_selected.splice(0, list_selected.length);
			}
			//c_world.undarkenAll();
		}
		
		public function selectMany(c:Selectable,finish:Boolean=false) {
			//trace("Engine.selectMany() " + c);
			selectCode = SELECT_MANY;
			//c_world.darkenAll();
			if (c.getCanSelect() && selectType == -1 || c.getNumID() == selectType ) {
				if(!c.isDoomed){
					if (p_selected == null)
						p_selected = c;//the first thing is the selected "thing";
					list_selected.push(c);
					c.makeSelected(true);
					lcdActionMenu(c.getActionList()); //least common denominator
					if (finish) {
						finishSelectMany();
					}
				}
			}
		}
		
		/**
		 * Given two lists of actions, return a vector containing the items they have in common
		 * @param	v
		 */

		public function lcdActionMenu(v:Vector.<int>) {
			var temp:Vector.<int>;
			if (list_lcd_actions == null) {
				list_lcd_actions = v.concat();
			}else {
				temp = new Vector.<int>;
				for each(var i:int in v) {
					for each(var j:int in list_lcd_actions) {
						if (i == j) {
							temp.push(i);
						}
					}
				}
				list_lcd_actions = temp;
			}
		}
		
		public function finishSelectMany() {
			
			prepareActionMenu(list_lcd_actions);
			c_interface.showManySelected(list_selected);
			precalcMoveCost();
			precalcRecycleCost();
			//trace("Cell.finishSelectMany() " + list_selected);
		}
		
		
		private function makeActionMenu() {
			/*c_actionMenu = new ActionMenu();
			addChild(c_actionMenu);
			c_actionMenu.setEngine(this);*/
		}
		
		/**
		 * This sets up the action menu with the given actions. Remember, it won't be shown until the Interface
		 * calls showActionMenu(), which is triggered by the selectedPanel coming on screen
		 * @param	v
		 */
		
		public function showActionMenu() {
			//c_actionMenu.doShowActions();
			//trace("Engine.showActionMenu()");
			c_interface.showActionMenu();
			
		}
		
		public function prepareActionMenu(v:Vector.<int>) { 
			if (v) {
				var length:int = v.length;
				for (var i:int = 0; i < length; i++) {
					if (v[i] == Act.TOGGLE) {
						v[i] = fixToggle(v[i]);
					}else if (v[i] == Act.TOGGLE_BROWN_FAT) {
						v[i] = fixBrownFatToggle(v[i]);
					}else if (v[i] == Act.TOGGLE_AUTO_PEROXISOME) {
						v[i] = fixAutoPeroxToggle(v[i]);
					}
				}
				c_interface.prepareActionMenu(v);
			}
		}
		
		private function fixToggle(i:int):int {
			if (selectCode == SELECT_ONE) {
				if (p_selected is ProducerObject) {
					if (ProducerObject(p_selected).getToggle()) {
						i = Act.DISABLE;
					}else {
						i = Act.ENABLE;
					}
				}
			}else if (selectCode == SELECT_MANY) {
				var onState:int = -1; //0 for all off, 1 for all on, 2 for mix
				for each(var s:Selectable in list_selected) { //go through the list
					if (s is ProducerObject) {
						if (ProducerObject(s).getToggle()) {   //find out the toggle states
							switch(onState) {
								case -1: onState = 1; break; //not set - set it to ALL ON
								case 0: onState = 2; break;  //OFF + ON = MIX
							}
						}else {
							switch(onState) {
								case -1: onState = 0; break; //not set - set it to ALL OFF
								case 1: onState = 2; break;  //OFF + ON = MIX
							}
						}
					}
				}
				switch(onState) {
					case -1: throw new Error("onState = -1 somehow!");
					case 0: i = Act.ENABLE; break;  //if all disabled, action is enable
					case 1: i = Act.DISABLE; break; //if all enabled, action is disable
					case 2: i = Act.MIX_DISABLE; break;
				}
			}
			return i;
		}
		
		private function fixBrownFatToggle(i:int):int {
			if (selectCode == SELECT_ONE) {
				if (p_selected is ProducerObject) {
					if (ProducerObject(p_selected).getBrownFatToggle()) {
						i = Act.DISABLE_BROWN_FAT;
					}else {
						i = Act.ENABLE_BROWN_FAT;
					}
				}
			}
			return i;
		}
		
		private function fixAutoPeroxToggle(i:int):int {
			if (selectCode == SELECT_ONE) {
				if (p_selected is ER) {
					if (auto_build_perox) {
						i = Act.DISABLE_AUTO_PEROXISOME;
					}else {
						i = Act.ENABLE_AUTO_PEROXISOME;
					}
				}
			}
			return i;
		}
		
		public function hideActionMenu() {
			//c_actionMenu.hide();
			c_interface.hideActionMenu();
		}
		
		
		
		
		
		
		/******************************************/
		
		/**
		 * This makes the DIRECTOR pause
		 */
		
		public function pause() {
			
			p_director.togglePause();
		}

		public function showScrewedMenu(state:String,cause:String) {
			p_director.showMenu(MenuSystem.SCREWED, [state,cause]);
		}
		
		public function showInGameMenu() {
			p_director.showMenu(MenuSystem.INGAME);
		}
		
		public function showEncyclopedia(s:String) {
			p_director.showMenu(MenuSystem.ENCYCLOPEDIA, s);
		}
		
		public function newEncyclopediaEntry(s:String="root") {
			c_interface.newEncyclopediaEntry(s);
		}
		
		private function setupObjectiveHandler() {
			oHandler = new ObjectiveHandler();
			oHandler.setEngine(this);
			addEventListener(ObjectiveEvent.COMPLETE, onObjectiveComplete, false, 0, true);
		}
		
		
		private function onObjectiveComplete(e:ObjectiveEvent) {
			var o:Objective = e.objective;
			completeObjective(o.id);		//complete the objective in the level data
			removeActiveObjective(o.id);	//remove the objective from the active list
			
			if (o.trigger) {
				tutorialObjective = o;
				doObjectivePreActions(o);
				showObjectiveTutorials(o);
			}else {
				storedObjective = o;
				c_interface.showButtNext();
			}
		}
		
		public function doTheObjective() {
			if(storedObjective){
				tutorialObjective = storedObjective;
				doObjectivePreActions(storedObjective); 		//do any pre actions associated with it
				showObjectiveTutorials(storedObjective);		//show the tutorials associated with it	
				storedObjective = null;
			}
		}
		
		private function waitForHacks(t:TimerEvent) {
			//trace("Engine.waitForHacks()!");
			doObjectiveHacksBeforeTutorial(tutorialObjective); //do any dirty hacks we need to do associated with this objective
			
		}
		
		private function endHacks(t:TimerEvent) {
			hackTimer.removeEventListener(TimerEvent.TIMER, waitForHacks);
		}
		
		/**
		 * Flag the objective with this id as complete in the leveldata so you don't draw it again
		 * @param	s the id of the objective just completed
		 */
		private function completeObjective(s:String) {
			for each(var lo:Objective in lvl.levelData.levelObjectives) {
				if (lo.id == s) {
					lo.objectiveComplete = true;
				}
			}
		}
		
		/**
		 * This will show any tutorials associated with the objective. 
		 * IF there are tutorials, the actions will not be executed until the tutorial is closed, calling onExitTutorial().
		 * IF there are no tutorials, the actions will be executed immediately
		 * @param	o
		 */
		
		private function showObjectiveTutorials(o:Objective) {
			if(o.tutorials.length > 0){
				var v:Vector.<Tutorial> = new Vector.<Tutorial>;
				for each(var oap:ObjectiveActionParam in o.tutorials) {
					var t:Tutorial = new Tutorial(oap.name,oap.val);
					v.push(t);
				}
				//trace("Engine.showObjectiveTutorials() id = " + o.tutorial_id);
				var te:TutorialEntry = new TutorialEntry(v, o.tutorial_id);
				hackTimer.addEventListener(TimerEvent.TIMER, waitForHacks, false, 0, true);
				hackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endHacks, false, 0, true);
				hackTimer.reset();
				hackTimer.start();
				newTutorialEntry(te);
				c_interface.hideTutorialText();
								/*switch(o.soundLevel) {
					case 0: break;
					case 1: Director.startSFX(SoundLibrary.SFX_DISCOVERY_TWINKLE_LOW); 
							o.soundLevel = 0;
							break;
					case 2: Director.startSFX(SoundLibrary.SFX_DISCOVERY_TWINKLE); 
							o.soundLevel = 0;
							break;
				}*/
			}else {
				var soundLevel:int = 0;
				doObjectiveActions(o);
				if (getNextObjectives()) {
					soundLevel = nextObjective.soundLevel;
				}//refresh the objective list
				c_interface.happyGlowTutorial(nextObjectiveText, d_tutArchive.getCounts(), soundLevel);	
			}
		}
		
		private function doObjectiveHacksBeforeTutorial(o:Objective) {
			//trace("Engine.doObjectiveeHacksBeforeTutorial() o = " + o.id);
			if (o.objectiveType == "show_action_cost") {
				//trace("Engine.doObjectiveHacksBeforeTutorial()! it worked!");
				c_interface.showActionMenuCost(o.targetType);
			}
		}
		
		private function doObjectiveHacksAfterTutorial(o:Objective) {
			if (o.objectiveType == "show_action_cost") {
				//trace("Engine.doObjectiveHacksAfterTutorial()! it worked!");
				c_interface.hideActionMenuCost();
			}
		}
		
		private function doObjectivePreActions(o:Objective) {
			if(o.pre_actions.length > 0){
				for each(var oa:ObjectiveAction in o.pre_actions) {
					doObjAction(oa);
				}
			}
		}
		
		private function doObjectiveActions(o:Objective) {
			if(o.actions.length > 0){
				for each(var oa:ObjectiveAction in o.actions) {
					doObjAction(oa);
				}
			}
		}
	
		private function removeActiveObjective(s:String) {
			var i:int = 0;
			for each(var ao:Objective in list_objectives) {
				if (ao.id == s) {
					list_objectives.splice(i, 1); //remove it from the list
					return;
				}
				i++;
			}
		}
		
		public function onShowActionCost(str:String) {
			//notifyOHandler(
			//notifyOHandler(
			notifyOHandler(EngineEvent.ENGINE_TRIGGER, "show_action_cost", str, 1);
			//fadupinator
		}
		
		private function doObjAction(o:ObjectiveAction) {
			var type:String = o.type.toLowerCase();
			//trace("Engine.doObjAction(" + type + ")");
			if (type == "activate_objective") {
				activateObjective(o.paramList);
			}else if (type == "deactivate_objective") {
				deactivateObjective(o.paramList);
			}else if (type == "speech") {
				doSpeech(o.paramList);
			}else if (type == "show_resource") {
				showResource(o.paramList);
			}else if (type == "hide_resource") {
				hideResource(o.paramList);
			}else if (type == "hide_interface") {
				hideInterfaceElement(o.paramList);
			}else if (type == "hide_organelle") {
				hideOrganelle(o.paramList,true);
			}else if (type == "show_organelle") {
				hideOrganelle(o.paramList, false);
			}else if (type == "plop_organelle") {
				plopOrganelle(o.paramList);
			}else if (type == "show_interface") {
				showInterfaceElement(o.paramList);
			}else if (type == "spawn_object") {
				spawnObject(o.paramList);
			}else if (type == "discovery") {
				makeDiscovery(o.paramList);
			}else if (type == "activate_stuff") {
				activateStuff(o.paramList);
			}else if (type == "set_cyto_process") {
				setCytoProcess(o.paramList);
			}else if (type == "set_fat_process") {
				setFatProcess(o.paramList);
			}else if (type == "send_wave") {
				sendWave(o.paramList);
			}else if (type == "show_newthing") {
				showNewThing(o.paramList);
			}else if (type == "finish_level") {
				finishLevel(o.paramList);
			}else if (type == "throw_flag") {
				throwFlag(o.paramList);
			}else if (type == "wipe_organelle_act") {
				wipeOrganelleAct(o.paramList);
			}else if (type == "add_organelle_act") {
				addOrganelleAct(o.paramList);
			}else if (type == "set_zoom") {
				fauxPauseZoom(o.paramList);
			}else if (type == "set_scroll_to") {
				fauxPauseScrollTo(o.paramList);
			}else if (type == "set_radicals") {
				setRadicals(o.paramList);
			}else if (type == "spawn_radicals") {
				spawnRadicals(o.paramList);
			}else if (type == "set_sunlight") {
				setTheSunlight(o.paramList);
			}else if (type == "set_toxinlevel") {
				setTheToxinLevel(o.paramList);
			}else if ( type == "start_countdown") {
				setupCountdown(o.paramList);
			}else if (type == "set_resource") {
				doSetResource(o.paramList);
			}else if (type == "set_arrow_show") {
				doSetArrowShow();
			}else if (type == "set_temperature") {
				doSetTemp(o.paramList);
			}else if (type == "set_heat_change") {
				doSetHeatChange(o.paramList);
			}else if (type == "stop_heat_change") {
				doStopHeatChange();
			}
			else {
				throw new Error("Unrecognized ObjectiveAction type \"" + type + "\" !");
			}
		}
		
		private function setTheSunlight(pList:Vector.<ObjectiveActionParam>) {
			var value:Number = Number(pList[0].val);
			setSunlight(value);
		}
		
		private function setupCountdown(pList:Vector.<ObjectiveActionParam>) {
			var value:int = int(pList[0].val);
			startCountdown(value);
		}
		
		private function setTheToxinLevel(pList:Vector.<ObjectiveActionParam>) {
			var value:Number = Number(pList[0].val);
			setToxinLevel(value);
		}
		
		private function doSetResource(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			var value:Number = Number(pList[1].val);
			hardSetResource(id, value);
		}
		
		private function doSetArrowShow() {
			c_interface.setArrowShow();
		}
		
		private function doSetTemp(pList:Vector.<ObjectiveActionParam>) {
			var value:Number = Number(pList[0].val);
			setTemperature(value);
		}
		
		private function doSetHeatChange(pList:Vector.<ObjectiveActionParam>) {
			var value:Number = Number(pList[0].val);
			var time:Number = Number(pList[1].val);
			if (!doesHeatChange) {
				doesHeatChange = true;
				addEventListener(RunFrameEvent.RUNFRAME, doHeatChange, false, 0, true);
			}
			heat_change_amount = value / time;
			if (Math.abs(heat_change_amount) < .1) {
				heat_change_time = .1 / Math.abs(heat_change_amount);
			}else {
				heat_change_time = 1;
				//heat_change_amount = 
			}
		}
		
		private function doStopHeatChange() {
			removeEventListener(RunFrameEvent.RUNFRAME, doHeatChange);
		}
		
		private function doHeatChange(r:RunFrameEvent) {
			heat_change_count++;
			if (heat_change_count > heat_change_time) {
				heat_change_count = 0;
				var t:Number = heat_change_amount * heat_change_time;
				changeTemperature(t);
			}
		}
		
		private function checkTemp() {
			if (current_temperature <= ToxinLevel.MIN_TEMP) {
				current_temperature = ToxinLevel.MIN_TEMP;
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "temperature_min", "null", ToxinLevel.MIN_TEMP);
			}else if (current_temperature >= ToxinLevel.MAX_TEMP) {
				current_temperature = ToxinLevel.MAX_TEMP;
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "temperature_max", "null", ToxinLevel.MAX_TEMP);
			}
			
			var t:int = Math.round(current_temperature);
			var dec:Number = t % (current_temperature);
			if (t > round_temperature) {
				round_temperature = current_temperature;
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "temperature_change", "hot", round_temperature);
			}else if (t < round_temperature && dec < 0.1) { //if the flat temp is now 26, don't fire on 26.4, but do fire on 26.04!
				round_temperature = current_temperature;
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "temperature_change", "cold", round_temperature);
			}
			c_interface.setTemp(current_temperature);
		}
		
		private function setTemperature(t:Number) {
			current_temperature = t;
			round_temperature = t;
			checkTemp();
		}
		
		public function changeTemperature(t:Number) {
			current_temperature += t;
			checkTemp();
		}
		
		private function makeDiscovery(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			var discoveries:int = 0;
			if (id != "null") {
				for each(var d:Discovery in lvl.levelData.levelDiscoveries) {
					if (d.id == id && d.discovered == false) {
						d.discovered = true;
					}
					if (d.discovered == true) {
						discoveries++;
					}
				}
				c_interface.glowSomething( -1, "discovery");
				c_interface.setDiscovery(discoveries);
				newEncyclopediaEntry(id);
				//doMakeDiscovery(id);
			}
		}
		
		private function spawnObject(pList:Vector.<ObjectiveActionParam>) {
			var id:String = "null";        //MUST be specified or errors will happen
			var loc_id:String = "null";    //MUST be specified or errors will happen
			var move_type:String = "null"; //defaults to null if not specified, which means doesn't move
			var value:Number = 0; //defaults to 0 if not specified
			var count:Number = 1; //defaults to 1 if not specified
			var distance:Number = 0;
			//Consider re-writing with dictionaries or generic object string keys
			for each(var oap:ObjectiveActionParam in pList) {
				if (oap.name == "id") {
					id = oap.val;
				}else if (oap.name == "loc_id") {
					loc_id = oap.val;
				}else if (oap.name == "move_type") {
					move_type = oap.val;
				}else if (oap.name == "count") {
					count = Number(oap.val);
				}else if (oap.name == "value") {
					value = Number(oap.val);
				}else if (oap.name == "distance") {
					distance = Number(oap.val);
				}
			}
			if (id != "null") {
				p_canvas.spawnObject(id, loc_id, move_type, count, value,distance);
				//doSpawnObject(id,loc_id,move_id);
			}
			
		}
		
		private function plopOrganelle(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				p_cell.plopOrganelle(id);
			}
			
		}
		
		private function hideOrganelle(pList:Vector.<ObjectiveActionParam>,bool:Boolean) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				p_cell.hideOrganelle(id,bool)
			}
		}
		
		private function hideInterfaceElement(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				c_interface.hideInterfaceElement(id);
			}
		}
		
		private function showInterfaceElement(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				c_interface.showInterfaceElement(id);
				//doActivateResource(id);
			}
		}
		
		private function hideResource(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				c_interface.hideResourceMeter(id);
			}
		}
		
		private function doSpeech(pList:Vector.<ObjectiveActionParam>) {
			//var id:String = getOAP_id(pList);
			var talker:String = pList[0].val;//getOAP_thing("talker", pList);
			var emotion:String = pList[1].val;//getOAP_thing("emotion", pList);
			var text:String = pList[2].val;//getOAP_thing("text", pList);
			showSpeech(talker, emotion, text);
		}
		
		private function showResource(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				c_interface.showResourceMeter(id);
				//doActivateResource(id);
			}
		}
		
		private function wipeActionList(id:String):Vector.<int> {
			if (id != "null") {
					var v:Vector.<int> = new Vector.<int>();
					if (id == "nucleus") listact_nucleus = v;
					else if (id == "golgi") listact_golgi = v;
					else if (id == "mitochondrion") listact_mitochondrion = v;
					else if (id == "chloroplast") listact_chloroplast = v;
					else if (id == "centrosome") listact_centrosome = v;
					else if (id == "lysosome") listact_lyso = v;
					else if (id == "peroxisome") listact_peroxisome = v;
					else if (id == "slicer") listact_slicer = v;
					else if (id == "er") listact_er = v;
					else if (id == "ribosome") listact_ribosome = v;
			}
			if (v) {
				return v;
			}
			return null;
		}
		
		private function getActionList(id:String):Vector.<int> {
			if (id != "null") {
					var v:Vector.<int>;
					if (id == "nucleus") v = listact_nucleus;
					else if (id == "golgi") v = listact_golgi;
					else if (id == "mitochondrion") v = listact_mitochondrion;
					else if (id == "chloroplast") v = listact_chloroplast;
					else if (id == "centrosome") v = listact_centrosome;
					else if (id == "lysosome") v = listact_lyso;
					else if (id == "peroxisome") v = listact_peroxisome;
					else if (id == "slicer") v = listact_slicer;
					else if (id == "er") v = listact_er;
					else if (id == "ribosome") v = listact_ribosome;
			}
			if (v) {
				return v;
			}
			return null;
		}
		
		private function wipeOrganelleAct(pList:Vector.<ObjectiveActionParam>) {
			//trace("Engine.wipeOrganelleAct(" + pList + ")");
			var id:String = getOAP_id(pList);
			var v:Vector.<int> = wipeActionList(id);
			if (v != null) {
				v = new Vector.<int>(); //clear it out
				p_cell.updateOrganelleAct(id, v); //update the organelles
			}
		}
		
		private function addOrganelleAct(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			var value:String = pList[1].val;
			var v:Vector.<int> = getActionList(id);
			if (v != null) {
				var a:int = Act.getI(value);
				v.push(a);	
				p_cell.updateOrganelleAct(id, v); //update the organelles
				if(p_selected || list_selected.length > 0){
					updateSelected();
				}
			}

		}

		public function autoZoomOut() {
			doFauxPauseZoom(0.05, 30, -1);
		}
		
		private function doFauxPauseZoom(value:Number, time:int, direction:int = 0) {
			var zoomScale:Number = c_interface.getZoomScale();
			var proceed:Boolean = false;
			if (direction == 0) {
				proceed = true;
			}else if (value < zoomScale && direction == -1) {
				proceed = true;
			}else if (value > zoomScale && direction == 1) {
				proceed = true;
			}
			if(proceed){
				var f:FauxPauseCommand = new FauxPauseCommand(FauxPauseCommand.ZOOM, value, time);
				f.calcZoom(zoomScale);
				list_fp_comm.push(f);
				p_director.startFauxPause();
			}
			c_interface.takeOverZoomer(true);
		}
		
		public function onEndFauxPauseZoom() {
			c_interface.takeOverZoomer(false);
		}
		
		private function fauxPauseZoom(pList:Vector.<ObjectiveActionParam>) {
			var value:Number = Number(pList[0].val);
			var time:int = int(pList[1].val);
			doFauxPauseZoom(value, time);
		}
		
		private function fauxPauseScrollTo(pList:Vector.<ObjectiveActionParam>) {
			var target:String = pList[0].val;
			var p:Point = getScrollToTarget(target);
			var time:int = int(pList[1].val);
			var f:FauxPauseCommand = new FauxPauseCommand(FauxPauseCommand.SCROLL_TO, p, time);
			var sp:Point = c_world.getCenteredPoint();
			f.calcScrollTo(sp.x, sp.y);
			list_fp_comm.push(f);
			p_director.startFauxPause();
		}
		
		private function getScrollToTarget(str:String):Point {
			var c:CellObject;
			if (str == "nucleus") c = p_cell.c_nucleus;
			if (str == "er") c = p_cell.c_er;
			if (str == "centrosome") c = p_cell.c_centrosome;
			if (str == "golgi") c = p_cell.c_golgi;
			if (str == "mitochondrion") c = p_cell.getRandomMito();
			if (str == "chloroplast") c = p_cell.getRandomChloro();
			if (str == "slicer") c = p_cell.getRandomSlicer();
			if (str == "peroxisome") c = p_cell.getRandomPerox();
			
			//var p:Point = new Point(p_cell.c_centrosome.x, p_cell.c_centrosome.y);
			/*if (c) {
				
				//p.x += c.x;
				//p.y += c.y;
			}*/
			var p:Point = new Point(c.x, c.y);
			return p;
		}
		
		private function throwFlag(pList:Vector.<ObjectiveActionParam>) {
			var value:String = getOAP_id(pList); //get the flag id
			var exists:Boolean = false;
			var thef:Flag;
			if (value != "null") {	//if it is set to something
				for each(var f:Flag in list_flags) {	//check all our flags
					if (f.label == value) {				//if it exists
						exists = true;		
						f.count++;						//increment the count
						thef = f;						//remember this flag
					}
				}
				if (!exists) {							//if it doesn't exist
					thef = new Flag(value);				//make a new flag
					list_flags.push(thef);				//shove it on the list
				}
				if (thef) {								//if we have a flag
					notifyOHandler(EngineEvent.THROW_FLAG, "", value, thef.count);	//"flag X has been thrown Y times"
				}
			}
		}
		
		private function finishLevel(pList:Vector.<ObjectiveActionParam>) {
			var value:String = pList[0].val;
			var cinema:String = "null";
			/*if (pList.length > 1) {
				cinema = pList[1].val;
			}*/
			if (value == "victory") {			//true victory
				nextLevel();// cinema);
			}else if (value == "consolation") { //we just let you by
				nextLevel();// cinema);
			}else if (value == "failure") {		//try again
				gameOver();
			}
		}
		
		private function showNewThing(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			var title:String;
			if (id != "null") {
				if (id == "nucleus") title = "Nucleus";
				else if (id == "centrosome") title = "Centrosome";
				else if (id == "er") title = "Endoplasmic Reticulum";
				else if (id == "golgi") title = "Golgi Body";
				else if (id == "mitochondrion") title = "Mitochondrion";
				else if (id == "chloroplast") title = "Chloroplast";
			}
			c_interface.showNewMenu(id, title);
		}
		
		public function onClickNewThing(name:String) {
			notifyOHandler(EngineEvent.ENGINE_TRIGGER, "click_newthing", name, 1);
		}
		
		private function sendWave(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			
			for each (var w:WaveEntry in lvl.levelData.levelThings.waves) {
				if (!w.active && w.id == id) {
					w.active = true;
					createWave(w);
				}
			}
		}
		
		public function onVirusInfest(wave:String, count:int = 0) {
			d_woz.onVirusInfest(wave, count);
		}
		
		public function onVirusEscape(wave:String, count:int = 0) {
			d_woz.onVirusEscape(wave, count);
		}
		
		public function onVirusSpawn(wave:String, count:int = 0) {
			d_woz.onVirusSpawn(wave, count);
		}
		
		public function onMakeEvilRNA(type:String,wave:String, count:int = 0) {
			//d_woz.onVirusBorn(type, wave, count);
			p_virusGlass.rnaCreated(wave, count);
		}
		
		public function makeVirus(type:String, wave:String, count:int = 0) {
			d_woz.onVirusBorn(type, wave, count);
			p_virusGlass.virusCreated(type,wave, count);
		}
		
		public function onKillVirus(wave:String,type:String="") {
			p_virusGlass.virusKilled(wave);
			preCheckWaveKill(wave);
			//checkWaveKill(wave);
		}
		
		public function onKillEvilRNA(wave:String,type:int=0) {
			p_virusGlass.rnaKilled(wave);
			preCheckWaveKill(wave);
			//checkWaveKill(wave);
		}
		
		public function onNucleusInfest(b:Boolean) {
			p_virusGlass.nucleusInfest(b);
		}
		
		public function preCheckWaveKill(wave:String) {
			if(dirty_wave_kill == false){					//if we're not checking anything
				for each(var s:String in list_wave_kills) {
					if (s == wave) {						//if this is one of our waves
						dirty_wave_kill = true;
						addEventListener(RunFrameEvent.RUNFRAME, doCheckWaveKills, false, 0, true); //start checking!
						return;
					}
				}
			}
		}
		
		public function doCheckWaveKills(r:RunFrameEvent) {
			//trace("Engine.doCheckWaveKills()");
			wave_kill_count++;		
			if(wave_kill_count > WAVE_KILL_TIME){			//once in a while, check every wave
				wave_kill_count = 0;						//reset the counter
				var i:int = 0;
				var j:int = 0;
				var length:int = list_wave_kills.length;
				/*for (i = 0; i < length; i++){				//check every wave
					if(checkWaveKill(list_wave_kills[i])){				//if it is dead
						//p_director.showMenu(MenuSystem.REWARD, d_woz.getWave(list_wave_kills[i]));
						list_wave_kills[i] = "";
					}
				}
				for (i = length-1; i < 0; i--) {
					if (list_wave_kills[i] == "") {
						list_wave_kills.splice(i, 1);
					}
				}*/
				if (checkWaveKill(list_wave_kills[0])) { //check only the first wave
														 //we do this so that we have a cascading frame effect, and multiple 
														 //reward menus don't spawn on the same frame
					list_wave_kills.splice(i, 1);
				}
				length = list_wave_kills.length;
				if (length <= 0) {							//if we're out of waves
					//trace("Engine.doCheckWaveKills() All Waves Survived!");
					isVirusSafe = true;
					checkStopBattleMusic();
					notifyOHandler(EngineEvent.ENEMY_SURVIVE, "null", "all", 1);
					removeEventListener(RunFrameEvent.RUNFRAME, doCheckWaveKills);
					dirty_wave_kill = false;
				}
			}
		}
		
		public function checkStartBattleMusic() {
			if (isVirusSafe) { //only start the music if we are currently "safe"
				Director.startMusic(SoundLibrary.MUS_BATTLE_INTRO,false);
			}
		}
		
		public function checkStopBattleMusic() {
			Director.startSFX(SoundLibrary.SFX_TITLE_HIT);     //play the title hit to disguise the transition
			Director.startMusic(SoundLibrary.MUS_CALM, true);  //switch to the calm music
		}
		
		
		public function checkWaveKill(wave:String):Boolean { //have we killed this wave?
			//trace("Engine.checkWaveKill(" + wave + ")");
			
			var we:WaveEntry = d_woz.getWave(wave);			//first, check the wave. If it's got anything in it, we fail
			if(we){
				if (we.active && we.count > 0) return false;
				
				if (p_cell.checkVirusCount(wave) > 0) return false;	//check if there are any viruses left in the cell
				if (p_cell.checkEvilRNACount(wave) > 0) return false;//check if there are any virus RNA's left in the cell
				
				if (we.type == "virus_infester") { //if it's an infester virus
					//trace("Engine.checkWaveKill INFESTER");
					//trace("Engine.checkWaveKill() " +  p_cell.c_nucleus.getInfester() + " VS " + we.id);
					//trace("Engine.checkWaveKill() " + p_cell.c_nucleus.getInfest());
					if (p_cell.c_nucleus.getInfester() == we.id) { //if the nucleus is infested by this wave
						if (p_cell.c_nucleus.getInfest() > 0) { //if the nucleus is infested
							return false;	//FAIL, wave is active
						}
					}
				}
				
				//trace("Engine.checkWaveKill("+wave+") SUCCESS!");
				//trace("Engine.checkWaveKill("+wave+") SUCCESS!");
				d_woz.defeatWave(wave);
				/*if (isSafe && !isVirusSafe) {
					checkStopBattleMusic();
				}
				isVirusSafe = isSafe;*/
				//p_virusGlass.clearWave(wave);
				//trace("Engine.checkWaveKill() we = " + we + " we.spawned_count = " + we.spawned_count);
				p_director.showMenu(MenuSystem.REWARD, we);
				wave_kill_count = WAVE_KILL_TIME; //check again immediately if we just killed a wave!
				notifyOHandler(EngineEvent.ENEMY_SURVIVE, "null", wave, 1);
				
				return true; //if we have nothing in the wave, no viruses of that type, and no rna of that type, we have killed that wave.
			}
			return false;
			
		}
		
		public function createWave(w:WaveEntry) {
			//alert the player that a wave is incoming
			
			c_interface.enemyAlert(w.type, w.count, w.id);
			var str:String = "DANGER! " + w.count + " " + VirusGlass.typeToString(w.type) + " incoming!"
			showImmediateWarning(str);
			
			var exists:Boolean = false;
			for each(var s:String in list_wave_kills) {
				if (s == w.id) {
					exists = true;
					break;
				}
			}
			
			if(!exists){					//if we haven't already created this wave
				list_wave_kills.push(w.id); //push its name onto a string so we can check when it dies
			}
			
			p_cell.makeVirusWave(w);  //make the actual viruses
			//checkStartBattleMusic();
			if (isVirusSafe) { //start the music only if we had just been safe 
				if(auto_zoom_on_virus_attack){
					autoZoomOut(); //auto zoom out ONLY if we had just been safe
				}
				Director.startMusic(SoundLibrary.MUS_BATTLE_INTRO, false);
			}
			d_woz.onCreateWave(w.id); //create a copy in the woz and let it know it's ready to be used
			isVirusSafe = false; //we are no longer safe
		}
		
		private function spawnRadicals(pList:Vector.<ObjectiveActionParam>) {
			var count:int = 0;
			var origin:String = "";
			var target:String = "";
			var delay:int = 0;
			if (pList[0].name == "count") {
				count = int(pList[0].val)
			}if (pList[1].name == "origin") {
				origin = String(pList[1].val);
			}if (pList[2].name == "target") {
				target = String(pList[2].val);
			}if (pList[3].name == "delay") {
				delay = int(pList[3].val);
			}
			p_cell.engineSpawnRadical(count, origin, target, delay);
		}
		
		private function setRadicals(pList:Vector.<ObjectiveActionParam>) {
			var value:String = getOAP_thing("value", pList);
			//trace("Engine.setRadicals() value = (" + value + ")");
			var isTrue:Boolean = (value == "true");
			//trace("Engine.setRadicals() (value==\"true\") = " + isTrue);
			p_cell.setRadicals(value == "true");
		}
		
		private function setFatProcess(pList:Vector.<ObjectiveActionParam>) {
			var value:String = getOAP_thing("value", pList);
			p_cell.setFatProcess(value == "true");
		}
		
		private function setCytoProcess(pList:Vector.<ObjectiveActionParam>) {
			var value:String = getOAP_thing("value", pList);
			p_cell.setCytoProcess(value=="true");
			
		}
		
		private function activateStuff(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			if (id != "null") {
				d_woz.activateStuff(id);
			}
		}
		
		private function deactivateObjective(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			var success:Boolean = false;
			if (id != "null") {
				for each(var o:Objective in lvl.levelData.levelObjectives) {
					if (o.active && o.id == id) {
						o.active = false;
						success = true;
					}
				}
				
				if (success) {
					//donothing
				}else {
					//also do nothing
				}
			}
			
		}
		
		private function activateObjective(pList:Vector.<ObjectiveActionParam>) {
			var id:String = getOAP_id(pList);
			var success:Boolean = false;
			//trace("Engine.activateObjective(" + id + ")");
			
			if (id != "null") {
				var length:int = lvl.levelData.levelObjectives.length;
				for (var i:int = 0; i < length; i++){
					var o:Objective = lvl.levelData.levelObjectives[i];
					if (!o.active && o.id == id) {
						lvl.levelData.levelObjectives[i].active = true;
						success = true;
					}			
				}
							
				if(success) {
					//trace("Engine.activateObjective()...success!");
				}else {
					throw new Error("Couldn't activate objective : " + id);
				}
			}else {
				throw new Error("Cannot find id of objective to activate in list : " + pList);
			}
		}
		
		private function instantCheckObjective(o:Objective) {
			//trace("Engine.instantCheckObjective : " + o);
			if (o.objectiveType == ObjectiveType.HAVE_RESOURCE) {
				checkResourceObjective(o.targetType);
			}else if (o.objectiveType == ObjectiveType.HAVE_THING) {
				checkHaveThingObjective(o.targetType);
			}
			
		}
		
		private function checkResourceObjective(type:String) {
			
			var amount:int = this["r_" + type];
			if (isNaN(amount)) amount = 0;
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", type, amount);			
		}
		
		private function checkHaveThingObjective(type:String) {
			
			var amount:int = p_cell.countThing(type);
			if (isNaN(amount)) amount = 0;
			notifyOHandler(EngineEvent.THING_CHANGE, "null", type, amount);
		}
		
		private function getOAP_thing(str:String,pList:Vector.<ObjectiveActionParam>):String {
			var thing:String = "null";
			for each(var oap:ObjectiveActionParam in pList) {
				if (oap.name == str) {
					thing = oap.val.toLowerCase();
				}
			}
			return thing;
		}
		
		private function getOAP_id(pList:Vector.<ObjectiveActionParam>):String {
			var id:String = "null";
			for each(var oap:ObjectiveActionParam in pList) {
				if (oap.name == "id") {
					id = oap.val.toLowerCase();
				}
			}
			return id;
		}
		
		private function loadObjectives() {
			list_objectives = new Vector.<Objective>(); //set up the vector
			getNextObjectives();						//get all the active objectives
			notifyOHandler(EngineEvent.ENGINE_TRIGGER, "game_load", "null", 1);
		}
		
		private function firstObjective() {
			

			//immediately send the begin level trigger
			notifyOHandler(EngineEvent.ENGINE_TRIGGER, "game_start", "null", 1);
			

		}

		//find all the objectives that 
		private function getNextObjectives():Boolean {
			nextObjectiveText = "";
			var success:Boolean = false;
			for each(var o:Objective in lvl.levelData.levelObjectives) {
				//trace("Engine.getNextObjectives :" + o);
				if (o.active && !o.objectiveComplete) {
					list_objectives.push(o);y
					oHandler.addObjective(o);
					
					
					if (o.hidden == false) {	
						if(nextObjectiveText == ""){
							nextObjectiveText = o.objectiveString;
						}else {
							nextObjectiveText += "\n" + o.objectiveString; //add em stacked!
						}
						nextObjective = o;
						instantCheckObjective(nextObjective);
						success = true;
						//trace("Engine.getNextObjectives() SUCCESS: " + o);
					}
				}
			}
			
			return success;
		}
		
		public function notifyOHandler(mainType:String, evType:String, targType:String, targNum:Number) {
			
			//e.
			var e:EngineEvent = new EngineEvent(mainType, evType,targType, targNum);
			oHandler.dispatchEvent(e);
		}
		
		
		public function onPseudopod() {
			notifyOHandler(EngineEvent.EXECUTE_ACTION, "null", "pseudopod", 1);
		}
		
		public function newTutorialEntry(t:TutorialEntry) {
			
			/*for each(var tt:Tutorial in t.list_tuts) {
				
				if (tt.tut.substr(0, 8) == "discover") {
					Director.startSFX(SoundLibrary.SFX_DISCOVERY);
				}
			}*/
			
			d_tutArchive.addTutorial(t);
			showTutorialEntry(t);
		}
		
		public function startCountdown(i:int) {
			count_down_count = 0;
			count_down_ticks = i;
			addEventListener(RunFrameEvent.RUNFRAME, countDownTick, false, 0, true);
			c_interface.setTimeGem(i);
		}
		
		private function countDownTick(r:RunFrameEvent) {
			count_down_count++;
			if (count_down_count > COUNT_DOWN_TIME) { //1 second or whatever the interval is
				count_down_count = 0;
				count_down_ticks--;
				c_interface.setTimeGem(count_down_ticks); //update the time
				if (count_down_ticks <= 0) {
					c_interface.setTimeGem(count_down_ticks);
					trace("Engine.countDownTick()! Count Down Finished!");
					removeEventListener(RunFrameEvent.RUNFRAME, countDownTick);
					notifyOHandler(EngineEvent.ENGINE_TRIGGER, "countdown", "null", 1);
				}
			}
		}
		
		public function onNecrosis(s:String) {
			var v:Vector.<Tutorial> = new Vector.<Tutorial>;
			/*var tt:Tutorial = new Tutorial("Try Again! You can do it!", "gameover_" + s);
			v.push(tt);
			var t:TutorialEntry = new TutorialEntry(v);
			showTutorialEntry(t);*/
			showScrewedMenu("gameover", s);
			isGameOver = true;
		}
		
		public function showTutorialEntry(t:TutorialEntry) {
			p_director.tempHighQuality();
			p_cell.clearMouse();
			p_director.showMenu(MenuSystem.TUTORIAL, t);
		}
		
		public function testTutorial() {
			var v:Vector.<Tutorial> = new Vector.<Tutorial>();
			v.push(new Tutorial("Welcome to CellCraft!", "welcome"));
			v.push(new Tutorial("Go and explore!", "welcome_explore"));
			v.push(new Tutorial("How to: Pseudopod", "howto_ppod"));
			var te:TutorialEntry = new TutorialEntry(v,"Welcome to CellCraft");
			newTutorialEntry(te);
		}
		
		public function reviewTutorialsAndStuff() {
			//var te:TutorialEntry = d_tutArchive.getTutorial(0);
			//showTutorialEntry(te);
			p_director.showMenu(MenuSystem.HISTORY, d_tutArchive);
		}
		
		public function getHistoryTut(t:TutorialEntry) {
			//showTutorialEntry(t);
			hist_tut = t;
		}
		
		public function getHistoryAlert(a:String) {
			//showAlert(a);
			hist_alert = a;
		}
		
		public function getHistoryMessage(m:MessageEntry) {
			//show a message
			hist_msg = m;
		}
		
		public function onExitHistory() {
			c_interface.happyGlowTutorial(null,d_tutArchive.getCounts());
			if (hist_tut) {
				showTutorialEntry(hist_tut);
				hist_tut = null;
			}else if (hist_alert) {
				//showAlert(hist_alert);
				hist_alert = null;
			}else if (hist_msg) {
				//showMessage(hist_msg);
				hist_msg = null;
			}
		}
		
		private function gameOver() {
			p_director.resetGame();
		}
		
		private function getFinalGPA() {
			var totalGPAWeight:Number = 0;
			var totalWeight:Number = 0;
			
			for (var i:int = 0; i < gpa_score_list.length; i++) {
				totalGPAWeight += (gpa_score_list[i] * gpa_weight_list[i]);
				totalWeight += gpa_weight_list[i];
			}
			
			var finalGPA:Number = totalGPAWeight / totalWeight;
			if (gpa_score_list.length == 0) {
				
				//finalGPA = -1; //if we didn't face any viruses, give me a "pass" score
				finalGPA = 5;
			}
			
			
			level_timer.stop();
			p_director.showMenu(MenuSystem.ENDLEVEL, finalGPA);
			
		}
		
		public function onEndLevelMenuClose():void {
			p_director.nextLevel();
		}
		
		private function nextLevel() {//cinema:String) {
			getFinalGPA();
			//p_director.nextLevel();// cinema);
		}
		
		public function onExitTutorial() {
			p_director.normalQuality();
			var soundLevel:int = 0;
			if (isGameOver) {
				gameOver();
			}else{
				if (tutorialObjective) {
					doObjectiveActions(tutorialObjective);		//do the actions associated with it
					if(getNextObjectives()){						//refresh the objective list
						soundLevel = nextObjective.soundLevel;
					}
					doObjectiveHacksAfterTutorial(tutorialObjective);
					tutorialObjective = null;					//null this out
					
				}
			}
			
			if(c_interface){ //this won't exist if our actions ended the game
				c_interface.happyGlowTutorial(nextObjectiveText, d_tutArchive.getCounts(),soundLevel);	
			}
		}
		
		/******************************************/
		
		private function doTransactions(){
			//trace("Engine.doTransactions()r:" + buy_ribosomes + " l:" + buy_lysosomes + " p:" + buy_peroxisomes + " s:" + buy_slicers + " d:" + buy_dnarepair);
			var r,l,p,s,d:Boolean;
			r = l = p = s = false;
						
			if(buy_ribosomes > 0){
				r = freeRibosome();
				if(r){
					buy_ribosomes--;
				}
			}if(buy_lysosomes > 0){
				l = freeLysosome();
				if (l) {
					buy_lysosomes--;
				}
			}if(buy_peroxisomes > 0){
				p = freePeroxisome();
				if(p){
					buy_peroxisomes--;
				}
			}if(buy_slicers > 0){
				s = freeSlicer();
				if (s) {
					//trace("Engine.doTransactions() slicer RNA success!");
					buy_slicers--;
				}
			}if (buy_dnarepair > 0) {
				d = freeDNARepair();
				if (d) {
					buy_dnarepair--;
				}
			}
			
			if(dirty_basicUnit == false){			//Only if we AREN'T already going to flush the interface
				dirty_basicUnit = r || l || p || s; //See if we should
				if (dirty_basicUnit) {
					dirty_resource = true;
				}
			}
			
			if (buy_dnarepair + buy_lysosomes + buy_peroxisomes + buy_ribosomes + buy_slicers <= 0) {
				transact = false;
			}
			
		}
		
		/************************************************/
		
		private function cancelRibosome() {
			_ribosomes_ordered--;
			dirty_basicUnit = true;
		}
		
		public function startAndFinishPeroxisome() {
			_peroxisomes_ordered++;
			_peroxisomes_produced++;
			dirty_basicUnit = true;
		}
		
		public function startAndFinishLysosome() {
			_lysosomes_ordered++;
			_lysosomes_produced++;
			dirty_basicUnit = true;
		}
		
		public function startAndFinishSlicer() {
			_slicers_ordered++;
			_slicers_produced++;
			dirty_basicUnit = true;
			//c_interface.oneMoreSlicer();
		}
		
		public function startAndFinishRibosome() {
			_ribosomes_ordered++;
			_ribosomes_produced++;
			dirty_basicUnit = true;
			//c_interface.oneMoreRibosome();
			//matchSlider(Selectable.RIBOSOME);
		}
		
		public function finishRibosome() {
			_ribosomes_produced++;
			dirty_basicUnit = true;
		}
		
		public function oneLessDefensin(n:Number) {
			_defensins_produced-=n;
			_defensins_ordered-=n;
			dirty_basicUnit = true;
		}
		
		public function setDefensinStrength(n:Number) {
			_defensin_strength = n;
			dirty_basicUnit = true;
		}
		
		public function finishDefensin() {
			_defensins_produced++;
			dirty_basicUnit = true;
		}
		
		public function finishLysosome() {
			_lysosomes_produced++;
			dirty_basicUnit = true;
		}
		
		
		
		public function finishPeroxisome() {
			_peroxisomes_produced++;
			dirty_basicUnit = true;
		}
		
		public function finishDNARepair() {
			_dnarepair_produced++;
			dirty_basicUnit = true;
		}
		
		public function finishSlicer() {
			_slicers_produced++;
			dirty_basicUnit = true;
		}
		
		private function cancelDefensin() {
			_defensins_ordered--;
			dirty_basicUnit = true;
		}
		
		private function cancelLysosome() {
			_lysosomes_ordered--;
			dirty_basicUnit = true;
		}
		
		private function cancelPeroxisome() {
			_peroxisomes_ordered--;
			dirty_basicUnit = true;
		}
		
		private function cancelSlicer() {
			_slicers_ordered--;
			dirty_basicUnit = true;
		}
		
		public function oneLessRibosome() {
			_ribosomes_ordered--;
			_ribosomes_produced--;
			dirty_basicUnit = true;
			//deleteRibosome();
			//cancelRibosome();
				
			
			//c_interface.oneLessRibosome();
			//c_interface.setRibosomes(_ribosomes_ordered, _ribosomes_produced, true);
		}

		/*
		public function oneLessDefensin() {
			_defensins_ordered--;
			_defensins_produced--;
			dirty_basicUnit = true;
			//c_interface.oneLessDefensin();
		}*/
		
		public function oneLessLysosome() {
			_lysosomes_ordered--;
			_lysosomes_produced--;
			dirty_basicUnit = true;
						
			//c_interface.oneLessLysosome();
			//c_interface.setLysosomes(_lysosomes_ordered, _lysosomes_produced, true);
		}
		
		public function oneLessPeroxisome() {
			_peroxisomes_ordered--;
			_peroxisomes_produced--;
			dirty_basicUnit = true;
	
			//c_interface.oneLessPeroxisome();
			//c_interface.setPeroxisomes(_peroxisomes_ordered, _peroxisomes_produced, true);
		}
		
		public function oneLessDNARepair() {
			_dnarepair_ordered--;
			_dnarepair_produced--;
			dirty_basicUnit = true;
		}
		
		public function oneLessSlicer() {
			_slicers_ordered--;
			_slicers_produced--;
			dirty_basicUnit = true;
			//c_interface.oneLessSlicer();
			//c_interface.setSlicers(_slicers_ordered, _slicers_produced, true);
		}
		
		private function deleteRibosome() {
			_ribosomes_produced--;
			dirty_basicUnit = true;
		}
		
		private function deleteDefensin() {
			_defensins_produced--;
			dirty_basicUnit = true;
		}
		
		private function deleteLysosome() {
			_lysosomes_produced--;
			dirty_basicUnit = true;
		}
		
		private function deletePeroxisome() {
			_peroxisomes_produced--;
			dirty_basicUnit = true;
		}
		
		private function deleteSlicer() {
			_slicers_produced--;
			dirty_basicUnit = true;
		}
		
		
		private function sellRibosome():Boolean{
			/*if(spendSell(Costs.SELL_RIBOSOME)){
				_ribosomes--;
				return true;
			}*/
			return p_cell.sellSomething(Selectable.RIBOSOME);
			//return false;
		}
		
		private function sellLysosome():Boolean {
			
			/*if(spendSell(Costs.SELL_LYSOSOME)){
				_lysosomes--;
				return true;
			}*/
			return p_cell.sellSomething(Selectable.LYSOSOME);
			//return false;
		}
		
		private function sellPeroxisome():Boolean{
			/*if(spendSell(Costs.SELL_PEROXISOME)){
				_peroxisomes--;
				return true;
			}*/
			return p_cell.sellSomething(Selectable.PEROXISOME);
			//return false;
		}
		
		private function sellSlicer():Boolean{
			/*if(spendSell(Costs.SELL_SLICER)){
				_slicers--;
				return true;
			}*/
			return p_cell.sellSomething(Selectable.SLICER_ENZYME);
			//return false;
		}
		
		private function freeRibosome():Boolean {
			return p_cell.generateRibosome();
		}
		
		private function buyRibosome():int {
			if(_ribosomes_ordered < Cell.MAX_RIBO){
				if(p_cell.freePore(1)){ //if there's a free nucleolus pore
					if(spend(Costs.MAKE_RIBOSOME)){ //spend the money now
						_ribosomes_ordered++;
						dirty_basicUnit = true;
						orderBasicUnit(BasicUnit.RIBOSOME, 1); //get it free later
						//p_cell.generateRibosome();
						return FailCode.SUCCESS; //success
					}return FailCode.CANT_AFFORD;
				}return FailCode.NO_NUCLEOLUS_PORE;
			}return FailCode.AT_MAX;
		}
		
		
		//These three following already figure in the cost of an RNA strand
		
		private function freeLysosome():Boolean {
			var cost:Array = Costs.getMAKE_LYSOSOME(1);
			return p_cell.generateLysosome(cost[1]); //even though its free the RNA needs to know how much it is worth
		}
		
		private function buyLysosome():int{
			if(_lysosomes_ordered < Cell.MAX_LYSO){
				//if(p_cell.freePore(0)){ //if there's a free nucleus pore
					if(spend(Costs.getMAKE_LYSOSOME())){
						_lysosomes_ordered++;
						dirty_basicUnit = true;
						orderBasicUnit(BasicUnit.LYSOSOME, 1);
						//p_cell.generateLysosome();
						return FailCode.SUCCESS;
					}return FailCode.CANT_AFFORD
				//}return FailCode.NO_NUCLEUS_PORE;
			}return FailCode.AT_MAX;
		}
		
		public function orderDefensin() {
			_defensins_ordered++;
			dirty_basicUnit = true;
		}
		
		public function orderLysosome(){
			_lysosomes_ordered++;
			dirty_basicUnit = true;
		}
		
		private function freePeroxisome():Boolean {
			var c:Array = Costs.getMAKE_PEROXISOME(1);
			return p_cell.generatePeroxisome(c[1]); //even though its free the RNA needs to know how much its worth
		}
		
		public function replacePerox() {
			if (auto_build_perox) {
				tryBuyBasicUnit(BasicUnit.PEROXISOME, 1);
			}
		}
		
		private function buyPeroxisome():int{
			if (_peroxisomes_ordered < Cell.MAX_PEROX) {
				//if(p_cell.freePore(0)){ //if there's a free nucleus pore
					if(spend(Costs.getMAKE_PEROXISOME())){
						_peroxisomes_ordered++;
						dirty_basicUnit = true;
						orderBasicUnit(BasicUnit.PEROXISOME, 1);
						//p_cell.generatePeroxisome();
						return FailCode.SUCCESS;
					}return FailCode.CANT_AFFORD;
				//}return FailCode.NO_NUCLEUS_PORE;
			}return FailCode.AT_MAX;
		}
		
		private function freeDNARepair():Boolean {
			var c:Array = Costs.getMAKE_DNAREPAIR(1);
			return p_cell.generateDNARepair(c[1]); //even though its free the RNA still needs to know how much its worth
		}
		
		private function freeSlicer():Boolean {
			var c:Array = Costs.getMAKE_SLICER(1);
			return p_cell.generateSlicer(c[1]); //even though its free the RNA still needs to know how much its worth
		}
		
		private function buyDNARepair():int {
			//if(p_cell.freePore(0)){
				if (spend(Costs.getMAKE_DNAREPAIR())) {
					_dnarepair_ordered++;
					dirty_basicUnit = true;
					orderBasicUnit(BasicUnit.DNAREPAIR, 1);
					return FailCode.SUCCESS;
				}return FailCode.CANT_AFFORD;
			//}return FailCode.NO_NUCLEUS_PORE;
		}
		
		private function buySlicer():int {
			if(_slicers_ordered < Cell.MAX_SLICER){
				//if(p_cell.freePore(0)){
					if(spend(Costs.getMAKE_SLICER())){
						_slicers_ordered++;
						dirty_basicUnit = true;
						orderBasicUnit(BasicUnit.SLICER, 1);
						return FailCode.SUCCESS;
					}return FailCode.CANT_AFFORD;
				//}return FailCode.NO_NUCLEUS_PORE;
			}return FailCode.AT_MAX;
		}
		
		public function buyToxin():int {
			if (p_cell.toxin_level < Cell.MAX_TOXIN) {
				//if (p_cell.freePore(0)) {
					var a:Array = Costs.getMAKE_TOXIN(1);
					if (canAfford(a[0], a[1], a[2], a[3], a[4])) {
						p_cell.buyToxin();
						return FailCode.SUCCESS;
					}return FailCode.CANT_AFFORD;
				//}return FailCode.NO_NUCLEOLUS_PORE;
			}return FailCode.AT_MAX;
		}
		
		public function buyDefensin():int{
			if (_defensins_ordered < Cell.MAX_DEFENSIN) {
				//if(p_cell.freePore(0)){
					var a:Array = Costs.getMAKE_DEFENSIN(1);
					if (canAfford(a[0], a[1], a[2], a[3], a[4])) {
						_defensins_ordered++;
						dirty_basicUnit = true;
						p_cell.buyDefensin();
						return FailCode.SUCCESS;
					}return FailCode.CANT_AFFORD;
				//}return FailCode.NO_NUCLEUS_PORE;
			}return FailCode.AT_MAX;
		}
		
		public function sellDefensin():int {
			return p_cell.sellDefensin();
			//return FailCode.TOTAL_FAIL;
		}
		
		public function sellMembrane():int {
			return p_cell.sellMembrane();
		}
		
		public function buyMembrane():int{
			//var a:Array = Costs.ER_MAKE_MEMBRANE;
			var a:Array = Costs.getMAKE_MEMBRANE(1);
			if (canAfford(a[0],a[1],a[2],a[3],a[4])) {
				p_cell.buyMembrane();
				return FailCode.SUCCESS;
			}else {
				return FailCode.CANT_AFFORD;
				//showImmediateAlertCode(FailCode.CANT_AFFORD);
				//showImmediateAlert(Messages.A_NO_AFFORD_MEMBRANE);
			}
			return FailCode.TOTAL_FAIL;
		}
		
		public function abortProduct(i:int) {
			switch(i) {
				case Selectable.LYSOSOME: cancelLysosome(); break;
				case Selectable.PEROXISOME: cancelPeroxisome(); break;
				case Selectable.SLICER_ENZYME: cancelSlicer(); break;
			}
		}
		
		private function waitRecycleMany(r:RunFrameEvent) {
			waitRecycleCount++;
			if (waitRecycleCount > WAIT_RECYCLE_TIME) {
				
				if (p_canvas) {
					Director.startSFX(SoundLibrary.SFX_COIN);
					var a:Array = manyRecycleCost.concat();
					manyRecyclePoint.x /= manyRecycleCount; //average the point
					manyRecyclePoint.y /= manyRecycleCount;
					p_canvas.justShowMeTheMoneyArray([0, a[1], a[2], a[3], a[4]], manyRecyclePoint.x, manyRecyclePoint.y); 
					manyRecycleCost = [0, 0, 0, 0, 0];
					//show the accumulated cost
				}
				removeEventListener(RunFrameEvent.RUNFRAME, waitRecycleMany); //end this listener
				waitRecycleCount = 0;   //reset the variables
				manyRecyclePoint.x = 0;
				manyRecyclePoint.y = 0;
				manyRecycleCount = 0;
			}
		}

		public function recycleSomethingOfMany(i:int, p:Point = null) {
			waitRecycleCount = 0; //so the timer doesn't trip
			if (manyRecycleCount == 0) {
				addEventListener(RunFrameEvent.RUNFRAME, waitRecycleMany, false, 0, true);
			}
			manyRecycleCount++; //add another entry
			
			manyRecyclePoint.x += p.x; //store the point
			manyRecyclePoint.y += p.y;
			recycleSomething(i,null,true); //recycle it and store the cost
		}
		
		public function recycleSomething(i:int, p:Point = null, ofMany:Boolean = false ) {
			var a:Array;
			switch(i) {
				case Selectable.LYSOSOME: a = Costs.SELL_LYSOSOME.concat(); break;
				case Selectable.RIBOSOME: a = Costs.SELL_RIBOSOME.concat(); break;
				case Selectable.PEROXISOME: a = Costs.SELL_PEROXISOME.concat(); break;
				case Selectable.SLICER_ENZYME: a = Costs.SELL_SLICER.concat(); break;
				case Selectable.DNAREPAIR: a = Costs.SELL_DNAREPAIR.concat(); break;
				case Selectable.PROTEIN_GLOB: a = Costs.SELL_PROTEIN_GLOB.concat(); break;
				case Selectable.MITOCHONDRION: a = Costs.SELL_MITOCHONDRION.concat(); break;
				case Selectable.CHLOROPLAST: a = Costs.SELL_CHLOROPLAST.concat(); break;
				case Selectable.MEMBRANE: a = Costs.SELL_MEMBRANE.concat(); break;
				//case Selectable.TOXIN: 
				case Selectable.DEFENSIN: a = Costs.SELL_DEFENSIN.concat(); break;
				case Selectable.VIRUS_INJECTOR: a = Costs.SELL_VIRUS_INJECTOR.concat(); 
												a[1] += (VirusInjector.RNA_COUNT * Costs.SELL_EVIL_RNA[1]);
												//the amount of NA needed to spawn RNA_COUNT rna's
												break;
				//case Selectable.MITOCHONDRION: a = Costs.
			}
			if (a) {
				if (ofMany) {
					//manyRecycleCost[0] += a[0];
					manyRecycleCost[1] += a[1];
					manyRecycleCost[2] += a[2];
					manyRecycleCost[3] += a[3];
					manyRecycleCost[4] += a[4];
				}
				a[0] = 0;		//set the ATP portion to zero
				income(a);	    //get the rest as income
				if(p){
					if (p_canvas) {
						//Director.startSFX(SoundLibrary.SFX_DRAIN);
						//p_canvas.justShowMeTheMoney("atp", -a[0], p.x, p.y, -1, -1);
						Director.startSFX(SoundLibrary.SFX_COIN);
						p_canvas.justShowMeTheMoneyArray([0, a[1], a[2], a[3], a[4]], p.x, p.y);
						
					}
				}
				
			}
			
		}

		public function showToxinSpot(amt:Number, x:Number, y:Number) {
			p_canvas.justShowMeTheMoney("toxin", amt, x, y);
		}
		
		public function showShieldBlock(x:Number, y:Number) {
			p_canvas.showShieldBlock(x, y);
		}
		
		public function showShieldSpot(amt:Number, x:Number, y:Number) {
			p_canvas.justShowMeTheMoney("shield", amt, x, y);
		}
		
		public function showHealSpot(amt:Number, x:Number, y:Number) {
			p_canvas.justShowMeTheMoney("health", amt, x, y);
		}
		
		//called when an RNA strand dies. Gives you back it's cost
		public function recycleRNA(amt:int) {
			income([0,amt,0,0,0]);
		}
		
		/*******************/

		public function getMaxResources():Array {
			return [r_max_atp, r_max_na, r_max_aa, r_max_fa, r_max_g];
		}
		
		public function getResource(type:String):Number {
			if (type == "g") {
				return r_g;
			}else if (type == "aa") {
				return r_aa;
			}else if (type == "fa") {
				return r_fa;
			}else if (type == "na") {
				return r_na;
			}else if (type == "atp") {
				return r_atp;
			}
			return 0;
		}
		
		public function getMaxResource(type:String):Number {
			if (type == "g") {
				return r_max_g;
			}else if (type == "aa") {
				return r_max_aa;
			}else if (type == "fa") {
				return r_max_fa;
			}else if (type == "na") {
				return r_max_na;
			}else if (type == "atp") {
				return r_max_atp;
			}
			return 0;
		}
		
		public function getResources():Array{
			return [r_atp,r_na,r_aa,r_fa,r_g];
		}
		public function getAffordArray(a:Array):Array{
			return [r_atp-a[0],r_na-a[1],r_aa-a[2],r_fa-a[3]];
		}
		
		public function canAfford(atp:int, na:int, aa:int, fa:int, g:int):Boolean {
			clearSpendCheck([atp, na, aa, fa, g]);
			if (r_atp >= atp) {
				spend_checker[0] = true;
			}
			if (r_na >= na) {
				spend_checker[1] = true;
			}
			if (r_aa >= aa) {
				spend_checker[2] = true;
			}
			if (r_fa >= fa) {
				spend_checker[3] = true;
			}
			if (r_g >= g) {
				spend_checker[4] = true;
			}
			if (spend_checker[0] && spend_checker[1] && spend_checker[2] && spend_checker[3] && spend_checker[4]) {
				return true;
			}
			return false;
		}
	
		/*******************/
		
		private function spendWithNA(a:Array):Boolean{
			if(r_na > 1){
				if(spend(a)){
					r_na --;
					notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
					return true;
				}
			}
			return false;
		}
		
		private function spendSell(a:Array):Boolean{
			if(r_atp > a[0]){
				r_atp -= a[0];
				r_na += a[1];
				r_aa += a[2]; 
				r_fa += a[3];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
				return true;
			}
			return false;
		}
		
		public function spendATP(i:Number):Boolean {
			clearSpendCheck([i,0,0,0,0]);
			if (r_atp >= i) {
				spend_checker[0] = true;
				spend_checker[1] = true;
				spend_checker[2] = true;
				spend_checker[3] = true;
				spend_checker[4] = true;
				r_atp -= i;
				dirty_resource = true;
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
				return true;
			}
			return false;
		}

		public function produce(a:Array):Boolean {
			r_atp += a[0];
			r_na += a[1];
			r_aa += a[2];
			r_fa += a[3];
			r_g += a[4];
			checkMaxResource();
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
			dirty_resource = true;
			return true;
		}
		
		public function zeroResources() {
			r_atp = 0;
			r_na = 0;
			r_aa = 0;
			r_fa = 0;
			r_g = 0;
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
			dirty_resource = true;
		}
		
		public function loseResources(a:Array):Boolean {
			r_atp -= a[0];
			r_na -= a[1];
			r_aa -= a[2];
			r_fa -= a[3];
			r_g -= a[4];
			if (r_atp < 0) r_atp = 0;
			if (r_na < 0) r_na = 0;
			if (r_aa < 0) r_aa = 0;
			if (r_fa < 0) r_fa = 0;
			if (r_g < 0) r_g = 0;
			
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
			dirty_resource = true;
			return true;
		}
		
		private function clearSpendCheck(a:Array = null) {
			if (a) {
				for (var i:int = 0; i < a.length; i++) {
					if (a[i] > 0) 
						spend_checker[i] = false;
					else 
						spend_checker[i] = true;
				}
			}else{
				spend_checker = [false, false, false, false, false];
			}
		}
		
		public function spend(a:Array):Boolean {
			clearSpendCheck(a);
			if (r_atp >= a[0]) {
				spend_checker[0] = true;
			}
			if (r_na >= a[1]) {
				spend_checker[1] = true;
			}
			if (r_aa >= a[2]) {
				spend_checker[2] = true;
			}
			if (r_fa >= a[3]) {
				spend_checker[3] = true;
			}
			if (r_g >= a[4]) {
				spend_checker[4] = true;
			}
			if(spend_checker[0] && spend_checker[1] && spend_checker[2] && spend_checker[3] && spend_checker[4]){
				r_atp -= a[0];
				r_na -= a[1];
				r_aa -= a[2];
				r_fa -= a[3];
				r_g -= a[4];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
				dirty_resource = true;
				return true;
			}
			return false;
		}
		
		public function getRewards(a:Array) {
			p_cell.rewardProduce(a, 1, new Point(p_cell.c_centrosome.x, p_cell.c_centrosome.y));
		}
		
		private function income(a:Array) {
			
			if(int(a[0]) > 0){
				r_atp += a[0];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
			}
			
			if(a[1] > 0){
				r_na += a[1];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
			}
			
			if(a[2] > 0){
				r_aa += a[2];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
			}
			
			if(a[3] > 0){
				r_fa += a[3];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
			}
			
			if(a[4] > 0){
				r_g += a[4];
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
			}
			checkMaxResource();
						
			dirty_resource = true;
		}
		
		private function checkMaxResource() {
			if (r_atp > r_max_atp) 
				r_atp = r_max_atp;
				
			if (r_aa > r_max_aa) 
				r_aa = r_aa;
				
			if (r_na > r_max_na) 
				r_na = r_na;
				
			if (r_fa > r_max_fa) 
				r_fa = r_fa;
				
			if (r_g > r_max_g * 2) 
				r_g = r_g;
		}
		
		public function hardSetResource(type:String, a:Number) {
			if (type == "atp") {
				r_atp = a;
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
			}else if (type == "aa") {
				r_aa = a;
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
			}else if (type == "na") {
				r_na = a;
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
			}else if (type == "fa") {
				r_fa = a;
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
			}else if (type == "g") {
				r_g = a;
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
			}
			checkMaxResource();
			var lowestAmount = getLowestAmount([r_atp, r_aa, r_na, r_fa, r_g]);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "all", lowestAmount);			
			dirty_resource = true;
		}
		
		public function setResource(type:String, a:Number) {

			if (type == "atp") {
				r_atp += a;
				
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "atp", r_atp);
			}else if (type == "aa") {
				r_aa += a;
				
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "aa", r_aa);
			}else if (type == "na") {
				r_na += a;
				
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "na", r_na);
			}else if (type == "fa") {
				r_fa += a;
				
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "fa", r_fa);
			}else if (type == "g") {
				r_g += a;
				
				notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "g", r_g);
			}
			checkMaxResource();
			var lowestAmount = getLowestAmount([r_atp, r_aa, r_na, r_fa, r_g]);
			notifyOHandler(EngineEvent.RESOURCE_CHANGE, "null", "all", lowestAmount);			
			
			dirty_resource = true;
		}
		
		public function getLowestAmount(a:Array):Number {
			var lowest:Number = Infinity;
			for each(var n:Number in a) {
				if (n < lowest) {
					lowest = n;
				}
			}
			return lowest;
		}
		
		public function cancelBasicUnits() {
			//transact = false;
			buy_ribosomes = 0;
			buy_lysosomes = 0;
			buy_peroxisomes = 0;
			buy_slicers = 0;
		}
		
		/*public function tryMakeMembrane():Boolean {
			if (spend(Costs.getMAKE_MEMBRANE(1))) {
				return true;
			}
			return false;
		}*/
		
		public function trySellDefensin():Boolean {
			return false;
		}
		
		public function trySellMembrane():Boolean {
			return false;
			//return false;
		}
		
		public function tryBuyBasicUnit(index:int, target:int):Boolean {
			
			var f:Function;
			var max:int;
			switch(index) {
				case BasicUnit.RIBOSOME: f = buyRibosome;   break;
				case BasicUnit.SLICER: f = buySlicer;  break;
				case BasicUnit.PEROXISOME: f = buyPeroxisome;  break;
				case BasicUnit.LYSOSOME: f = buyLysosome;   break;
				case BasicUnit.DNAREPAIR: f = buyDNARepair;   break;
				
			}
			var failCode:int = FailCode.TOTAL_FAIL;
			if (f != null) {
				for (var i:int = 0; i < target; i++) {
					failCode = f();
					if (failCode != FailCode.SUCCESS) {
						//showImmediateAlert("You can't afford that!");
						showImmediateAlertCode(failCode);
						return false; //stop right there
					}
				}
			}
			return true;
		}
		
		public function orderBasicUnit(index:int, target:int){
			if(target != 0){
				transact = true;
			}
			
			switch(index){
				case BasicUnit.RIBOSOME: 
					buy_ribosomes += target;
					//buy_ribosomes = (target-_ribosomes_ordered);
					break;
				case BasicUnit.LYSOSOME:	
					buy_lysosomes += target;
					//buy_lysosomes = (target - _lysosomes_ordered);
					break;
				case BasicUnit.PEROXISOME:
					buy_peroxisomes += target;
					//buy_peroxisomes = (target-_peroxisomes_ordered);
					break;
				case BasicUnit.SLICER:
					buy_slicers += target;
					//buy_slicers = (target-_slicers_ordered);
					break;
				case BasicUnit.DNAREPAIR:
					buy_dnarepair += target;
					break;
			}
		}
		
		//MESSAGING:
		private function initMessaging() {

		}
		
		private function tickMessaging() {
			//tick only if we've been set to 0 or higher
				alert_counter++;
				message_counter++;
				speech_counter++;

		}
		
		public function showImmediateWarning(s:String) {
			c_interface.showEnemyWarning(s);
		}
		
		public function showImmediateAlertCode(i:int) {
			var s:String = "";
			switch(i) {
				case FailCode.AT_MAX: s = ("You already have the maximum amount"); break;
				case FailCode.CANT_AFFORD: s = getFailAffordString(); break;
				case FailCode.NO_NUCLEOLUS_PORE: s = "";
				case FailCode.NO_NUCLEUS_PORE: s = "";
				
				default: s = "";
			}
			if (s != "") {
				showImmediateAlert(s);
			}
		}
		
		private function getFailAffordString():String {
			var s:String = "Not enough ";
			var list:Array = new Array();
			//trace("Engine.getFailAffordString() spend_checker = " + spend_checker);
			if (!spend_checker[0]) {
				list.push("ATP");
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "not_enough", "atp", r_atp);
			}
			if (!spend_checker[1]) {
				list.push("NA");
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "not_enough", "na", r_na);
			}
			if (!spend_checker[2]) {
				list.push("AA");
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "not_enough", "aa", r_aa);
			}
			if (!spend_checker[3]) {
				list.push("FA");
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "not_enough", "fa", r_fa);
			}
			if (!spend_checker[4]) {
				list.push("G");				
				notifyOHandler(EngineEvent.ENGINE_TRIGGER, "not_enough", "g", r_g);
			}
			for (var i:int = 0; i < list.length; i++ ) {
				s += list[i];
				if (i < list.length - 1) {
					s += ", ";
					if (i == list.length - 2) {
						s += "and ";
					}
				}else if (i == list.length -1) {
					s += "!";
				}
			}
			if (list.length == 1){
				if (list[0] == "NA") {
					if (p_cell.countThing("rna") > 0) {            //If there's RNA strands, tell the user to wait
						s += " Wait for RNA strands to dissolve!";
						//Not enough NA! Wait for RNA strands to dissolve!
					}else if (theLevelNum > 1) {					//If there's no RNA strands, & we've introduced recycling
						var mitoTrue:Boolean = false;
						var chloroTrue:Boolean = false;
						if (p_cell.countThing("mitochondrion") > 1) { 
							mitoTrue = true;
						}
						if (p_cell.countThing("chloroplast") > 1) {
							chloroTrue = true;
						}
						if (mitoTrue || chloroTrue) {  		//If there's more than 1 mito or chloro
							s += " Recycle a";				
							if (mitoTrue) {
								s += " mitochondrion";
							}
							if (chloroTrue) {
								if (mitoTrue) {s += " or ";}
								s += " chloroplast";
							}
							s += "!";
							//Not enough NA! Recycle a mitochondrion!
							//Not enough NA! Recycle a chloroplast!
							//Not enough NA! Recycle a mitochondrion or chloroplast!
						}
					}
				}else if (list[0] == "AA") {
					//lvl.levelData.
					var checkBatch:Boolean = false;
					var checkRecycle:Boolean = false;
					if (checkLevelBatch("aa")){						
						checkBatch = true;	
						s += " Go exploring";
					}
					
					
					if (theLevelNum > 1) { //if we're not in one of the intro levels before recycling is allowed
						checkRecycle = true;
						if (checkBatch) {
							s += ", or r";
						}else {
							s += " R"
						}
						s += "ecycle something";
					}
					
					if (checkBatch || checkRecycle) {
						s += "!";
					}
				}else if (list[0] == "FA") {
					s += " Recycle something or make more with G!";
				}
			}
			return s;
		}
		
		public function checkLevelBatch(s:String):Boolean {
			return d_woz.checkLevelBatch(s);
		}
		
		public function showImmediateAlert(s:String) {
			if (s == alert_last) {
				if (!c_interface.c_messageBar.isShown()) {
					c_interface.showAlert(s);
				}
			}else{
				alert_last = s;
				c_interface.showAlert(s); //just show it, don't store it or worry
			}
		}
		
		public function showMessage(m:MessageEntry) {
			//nothing yet
		}
		
		public function showSpeech(talker:String, emotion:String, msg:String) {
			c_interface.showSpeech(talker, emotion, msg);
		}
		
		public function showAlert(s:String) {
			if(s != alert_last){
				c_interface.showAlert(s);
				alert_last = s;
				alert_counter = 0;
			}else if (alert_counter > MESSAGE_TIME) {
				c_interface.showAlert(s);
				alert_counter = 0;
			}
		}
		
		
		//Sound functions:
		
		/*public function s() {
			p_sound.startMusic(
		}*/
	
	}

}
package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecLevel.EngineEvent;
	import com.pecSound.SoundLibrary;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.GridFitType;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Virus extends CellObject
	{
		public var type:String;
		public var atCell:Boolean = false; //at the membrane
		public var inCell:Boolean = false; //inside the cell
		
		public var tauntCount:int = 0;
		public const TAUNT_TIME:int = 15;
		
		public static const POS_OUTSIDE_CELL:int = 0;
		public static const POS_INSIDE_CELL:int = 1;
		public static const POS_TOUCHING_CELL:int = 2;
		
		public static const MOT_INVADING_CELL:int = 0;
		public static const MOT_INJECTING_CELL:int = 1;
		public static const MOT_ESCAPING_CELL:int = 2;
		public static const MOT_INFESTING_CELL:int = 3;
		
		public static const CON_MOVE_TO_RIBOSOME:int = 0;
		public static const CON_MOVE_TO_MEMBRANE:int = 1;
		public static const CON_MOVE_TO_NUCLEUS:int = 2;
		public static const CON_MOVE_TO_EXIT:int = 3;
		
		public static const DYING:int = 2;
		
		public var position_state:int = POS_OUTSIDE_CELL;
		public var motivation_state:int = -1;
		public var condition_state:int = -1;
		
		public var mnode:MembraneNode;
		public var rib:Ribosome;
		public var nuc:Nucleus;
		public var nuc_node:Point;
		
		public var entering:Boolean = false; //are we entering or exiting the membrane?
		public var leaving:Boolean = false; //are we leaving the gameplay zone?
		public var spawnCount:int = 1;
		public var rnaCount:int = 1;
		public var p_canvas:WorldCanvas;
		public var wave_id:String;
		protected var normal_speed:Number;
		protected var escape_speed:Number;
		protected var inside_speed:Number;
		
		public var toCent:Boolean = false;
		
		var absorbCount:int = 0;
		const ABSORB_TIME:int = 10;
		
		//public static var pv_grid:ObjectGrid;
		
		public var isNeutralized:Boolean = false;
		
		protected var DMG_PIERCE_MEMBRANE = 1;
		const INJECT_DISTANCE:Number = 30;
		
		public var newnode_count:int = 0;
		public var NEWNODE_TIME:int = 5;
		
		private var list_lyso:Vector.<Lysosome>;
		
		private var waitEatCounter:int = 0;
		private const WAIT_EAT_TIME:int = 30;
		
		private var shieldBlocked:Boolean = false;
	
		private var vesicleGrow:Boolean = false;
		private var vesicleShrink:Boolean = false;
		public var doesVesicle:Boolean = false;
		public var hasVesicle:Boolean = false;
		private var c_ves_shape:Shape;
		private var ves_size:Number = 0;
		private var ves_max_size:Number = 0;
		private var ves_size_grow:Number = 0.5;
		
		private var cyto_col:uint = 0x44AAFF;
		private var spring_col:uint = 0x0066FF;
		private var gap_col:uint = 0x99CCFF;
		
		public function Virus() 
		{
			singleSelect = false;
			canSelect = false;
			text_title = "Virus";
			text_description = "Oh noes! A virus!";
			text_id = "virus";
			wave_id = "";
			num_id = Selectable.VIRUS;
			setMaxHealth(10, true);
			normal_speed = speed;
			escape_speed = speed * 4;
			inside_speed = speed/2;
			setRadius(25); //MAGIC NUMBER ALERT
			makeGameDataObject();
			//giveVesicle();
		}
		
		public function setVesicle(b:Boolean) {
			doesVesicle = b;
			if (doesVesicle) {
				if (position_state == POS_OUTSIDE_CELL) { //grow a vesicle if you're outside the cell. Otherwise wait until you touch membrane
					giveVesicle();
				}
			}
		}
		
		public function shrinkVesicle() {
			//trace("Virus.shrinkVesicle()");
			vesicleGrow = false;
			vesicleShrink = true;
			addEventListener(RunFrameEvent.RUNFRAME, updateVesicle, false, 0, true);
		}
		
		public function removeVesicle() {
			hasVesicle = false;
		}
		
		public function giveVesicle(maxSize:Boolean=false) {
			hasVesicle = true;
			doesVesicle = true;
			c_ves_shape = new Shape();
			addChild(c_ves_shape);
			setChildIndex(c_ves_shape, 0);//put it at the bottom
			ves_max_size = getRadius() / 2;
			if (maxSize) {
				ves_size = ves_max_size;
				drawVesicle();
			}else {
				vesicleGrow = true;
				addEventListener(RunFrameEvent.RUNFRAME, updateVesicle, false, 0, true);
			}
			//updateVesicle(null);
			
		}
		
		public override function updateBubbleZoom(n:Number) {
			super.updateBubbleZoom(n);
			if(hasVesicle){
				drawVesicle();
			}
		}
		
		private function clearVesicle() {
			c_ves_shape.graphics.clear();
			c_ves_shape.visible = false;
			//hasVesicle = false;
		}
		
		public function updateVesicle(r:RunFrameEvent) {
			if (vesicleGrow && ves_size < ves_max_size) {
				ves_size += ves_size_grow;
				if (ves_size >= ves_max_size) {
					ves_size = ves_max_size;
					vesicleGrow = false;
					removeEventListener(RunFrameEvent.RUNFRAME, updateVesicle);
				}
			}
			if (vesicleShrink && ves_size > 0) {
				ves_size -= ves_size_grow;
				if (ves_size <= 0) {
					ves_size = 0;
					vesicleShrink = false;
					removeEventListener(RunFrameEvent.RUNFRAME, updateVesicle);
					clearVesicle();
				}
			}
			drawVesicle();
		}
		
		public function drawVesicle() {
			if (ves_size > 0) {
				c_ves_shape.graphics.clear();
				c_ves_shape.graphics.beginFill(cyto_col, 1);
				c_ves_shape.graphics.lineStyle(Membrane.OUTLINE_THICK / 3, 0x000000);
				c_ves_shape.graphics.drawCircle(0, 0, ves_size);
				c_ves_shape.graphics.endFill();
				//shape.graphics.drawEllipse(x-size/2,y-size/2,size, size);
				c_ves_shape.graphics.lineStyle(Membrane.SPRING_THICK / 4, spring_col);
				c_ves_shape.graphics.drawCircle(0, 0, ves_size);
				//shape.graphics.drawEllipse(x-size/2,y-size/2,size, size);
				c_ves_shape.graphics.lineStyle(Membrane.GAP_THICK / 6, gap_col);
				c_ves_shape.graphics.drawCircle(0, 0, ves_size);
				//shape.graphics.drawEllipse(x-size/2,y-size/2,size, size);
				
			}
		}
		
		public function addLyso(l:Lysosome) {
			if (list_lyso == null) {
				list_lyso = new Vector.<Lysosome>;
			}
			var isInList:Boolean = false;
			for each(var ll:Lysosome in list_lyso) {
				if (l == ll) {
					isInList = true;
				}
			}
			if(!isInList){
				list_lyso.push(l);
			}
		}
		
		public override function destruct() {
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell, false);
			if (list_lyso) {
				//trace("Virus(" + this.name + ").destruct()");
				releaseLyso();
				for (var i:int = 0; i < list_lyso.length; i++) {
					list_lyso.pop();
				}
				list_lyso = null;
			}
			clearGrid();
			super.destruct();
		}
	
		public function dismissAllLysosExcept(l:Lysosome) {
			//trace("Virus(" + this.name + ").dismissAllLysosExcept(" + l.name + ")");
			if (list_lyso) {
				var length:int = list_lyso.length;
				for (var i:int = length - 1; i >= 0; i--) {
					if (list_lyso[i] != l) {
						list_lyso[i].releaseByVirus(this);
						list_lyso[i] = null;
						list_lyso.splice(i, 1);
					}
				}
			}
		}
		
		
		
		protected function releaseLyso() {
			if(list_lyso){
				var length:int = list_lyso.length;
				for (var i:int = length-1; i >= 0; i--) {
					list_lyso[i].releaseByVirus(this);
					list_lyso[i] = null;
					list_lyso.splice(i, 1);
				}
			}
		}
		
		protected override function killMe() {
			super.killMe();
		}
		
		public function setCanvas(c:WorldCanvas) {
			p_canvas = c;
		}
		
		protected function touchingCell() {
			releaseLyso();
			position_state = POS_TOUCHING_CELL;
			//this.transform.colorTransform = new ColorTransform(0.75,0.75,0.75,1, 0,0,0,0);
		}
		
		protected function insideCell() {
			speed = inside_speed;
			position_state = POS_INSIDE_CELL;
			//this.transform.colorTransform = new ColorTransform(1,1,1,1, 0,0,0,0);
		}
		
		protected function outsideCell() {
			position_state = POS_OUTSIDE_CELL;
			
			//this.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0, 0, 0, 0);
		}
		
		public function setup(doEscape:Boolean=false) {
			if(doEscape){
				//entering = false;
				
				condition_state = CON_MOVE_TO_MEMBRANE;
				onBornInCell();
				insideCell();
				motivation_state = MOT_ESCAPING_CELL;
				
				removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
				playAnim("grow");
				
			}else {
				
				condition_state = CON_MOVE_TO_MEMBRANE;
				outsideCell();
				whatsMyMotivation();
				
				entering = true;
				addEventListener(RunFrameEvent.RUNFRAME, tryEnter, false, 0, true);
				enterMembrane();
			}
		}
		
		protected function onBornInCell() {
			//define per subclass
		}
		
		public function onGrow() {
			if (motivation_state == MOT_ESCAPING_CELL && position_state == POS_INSIDE_CELL) {
				//inCell = true;
				p_cell.onVirusSpawn(wave_id, 1);
				exitMembrane();
			}
		}
		
		protected function tauntCell(r:RunFrameEvent) {
			//define per subclass
		}
		
		public override function releaseFromLysosome(l:Lysosome) {
			//trace("Virus.RELEASE FROM LYSOSOME");
		}
	
		/*public override function releaseFromLyso() {
			switch(motivation_state) {
				case MOT_ESCAPING_CELL: escape(); break;
				case MOT_INVADING_CELL: onInvade(); break;
				case MOT_INFESTING_CELL: onInvade(); break;
			}
		}*/
		
		public override function targetForEating(l:Lysosome=null) {
			addLyso(l);
			//super.targetForEating();
			//don't make it doomed just yet!
		}
		
		protected function onInvade(doDamage:Boolean = true) {
			//trace("Virus.onInvade()");
			mnode = null;
			cancelMove(); //just to be sure
			if(!hasVesicle){
				if (!isNeutralized && doDamage) {
					p_cell.c_membrane.takeDamageAt(x, y, DMG_PIERCE_MEMBRANE);
					p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_entry_wound", wave_id, 1);
				}
			}else {
				removeVesicle();
			}
			
			var v:Vector2D = new Vector2D(x - cent_x, y - cent_y);
			v.normalize();
			v.multiply(-INJECT_DISTANCE);
			x += v.x;
			y += v.y;

			
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell);
			
			entering = false;
			removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
			
			leaving = false;
			
			insideCell();
			//atCell = false;
			//inCell = true;
			
			condition_state = CON_MOVE_TO_RIBOSOME;
			rib = p_cell.findClosestRibosome(x, y,true);
			if (rib) {
				//trace("Virus.onInvade() rib = " + rib);
				moveToObject(rib, FLOAT, true);
			}else {
				//trace("Virus.onInvade() rib is NULL!");
			}
		}
		
		public function onExit() {
			//trace("Virus.onExit() EXIT!");
			
			condition_state = CON_MOVE_TO_EXIT;
			
			speed = escape_speed;
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell);
			
			if(!isNeutralized){
				p_cell.c_membrane.takeDamageAt(x, y, DMG_PIERCE_MEMBRANE); //damage the membrane
				p_cell.onVirusEscape(wave_id,1);
				p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_exit_wound", wave_id, 1);
			}
			
			outsideCell();

			
			removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
						
			mnode = null;
			var v:Vector2D = new Vector2D(x - cent_x, y - cent_y);
			v.normalize();
			
			v.multiply(p_canvas.getBoundary() * 1.5); //leave the screen
			addEventListener(RunFrameEvent.RUNFRAME, checkAbsorb);
			moveToPoint(new Point(x + v.x, y + v.y), GameObject.FLOAT, true);
		}
		
		public function neutralize() {
			
			isNeutralized = true;
			if(position_state != POS_TOUCHING_CELL){
				onExit();
			}
		}
		
		private function checkAbsorb(r:RunFrameEvent) {
			
			absorbCount++;
			if (absorbCount > ABSORB_TIME) {
				absorbCount = 0;
				if (p_canvas.checkAbsorbCellObject(this, isNeutralized)) {
					
					p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_escape", wave_id, 1);
					cancelMove();
					removeEventListener(RunFrameEvent.RUNFRAME, checkAbsorb);
					p_cell.killVirus(this);
				}
			}
		}
		
		protected function whatsMyMotivation() {
			//define per subclass
		}
		
		public function exitMembrane() {
			//entering = false;
			
			removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
			mnode = p_cell.c_membrane.findClosestMembraneHalf(x, y);
			var v:Vector2D = new Vector2D((mnode.x + mnode.p_next.x) / 2, (mnode.y + mnode.p_next.y) / 2);
			v.multiply(2);
			moveToPoint(new Point(v.x,v.y), GameObject.FLOAT, true);
			//speed = escape_speed;
		}
		
		public function enterMembrane() {
			if(motivation_state != MOT_ESCAPING_CELL){
				mnode = p_cell.c_membrane.findClosestMembraneHalf(x, y);
				moveToPoint(new Point((mnode.x + mnode.p_next.x) / 2, (mnode.y + mnode.p_next.y) / 2), GameObject.FLOAT, true);
			}
		}
		
		protected function tryEnter(r:RunFrameEvent) {
			if (condition_state == CON_MOVE_TO_MEMBRANE && position_state == POS_OUTSIDE_CELL) {
				newnode_count++;
				if (newnode_count > NEWNODE_TIME) {
					newnode_count = 0;
					enterMembrane();
				}
			}
		}
		
		public override function calcMovement() {
			
			
			if (mnode) { //if mnode is defined it's assumed we're moving towards it
				pt_dest.x = (mnode.x+mnode.p_next.x) / 2;
				pt_dest.y = (mnode.y+mnode.p_next.y) / 2;
				var v:Vector2D = new Vector2D(pt_dest.x - x, pt_dest.y - y);
				var ang:Number = (v.toRotation() / (Math.PI * 2)) * 360;//(v.toRotation() * 180) / Math.PI;
				
				if(condition_state == CON_MOVE_TO_MEMBRANE){
					rotation = ang - 90;
				}else {
					rotation = ang + 90;
				}
			}
			super.calcMovement();
		}
		
		protected override function onArriveObj() {
			super.onArriveObj();
			if(!isDoomed){
				if (position_state == POS_INSIDE_CELL && rib) { //we're looking for a ribosome
					doRibosomeThing();
				}
			}
		}
		
		protected function clingCell(r:RunFrameEvent) {
			if (mnode) {
				x = (mnode.x+mnode.p_next.x)/2;
				y = (mnode.y+mnode.p_next.y)/2;
			}
		}
		
		public function onTouchCell() {
			
			if (condition_state == CON_MOVE_TO_MEMBRANE && position_state == POS_INSIDE_CELL) { //if we're exiting the cell
				if (!isDoomed) {
					touchingCell();
					mnode = p_cell.c_membrane.findClosestMembraneHalf(x, y);
					addEventListener(RunFrameEvent.RUNFRAME, clingCell, false, 0, true);
					arrivePoint();
					playAnim("exit");
					if (doesVesicle) {
						giveVesicle();
					}
				}
			}
			
			if (condition_state == CON_MOVE_TO_MEMBRANE && position_state == POS_OUTSIDE_CELL) {//if we're entering the cell
				if(checkDefensin()){
					if (!isDoomed) {			
						touchingCell();
						mnode = p_cell.c_membrane.findClosestMembraneHalf(x,y);
						addEventListener(RunFrameEvent.RUNFRAME, clingCell, false, 0, true);
						onTouchCellAnim();
						arrivePoint();		
					}
				}
			}
		}
		
		protected function onTouchCellAnim() {
			playAnim("land");
		}
		
		/*public override function doRecycle() {
			//trace("Virus.doRecycle() p_cell = " + p_cell);
			super.doRecycle();
		}*/
		
	
		
	
		
		public override function startGetEaten() {
			
			removeEventListener(RunFrameEvent.RUNFRAME, tauntCell);
			playAnim("eaten");
			if (hasVesicle) {
				shrinkVesicle();
			}
			addEventListener(RunFrameEvent.RUNFRAME, waitForEat);
			super.startGetEaten();
		}
		
		private function waitForEat(r:RunFrameEvent) {
			waitEatCounter++;
			if (waitEatCounter > WAIT_EAT_TIME) {
				waitEatCounter = 0;
				onDeath();
			}
		}
		
		public override function playAnim(label:String) {
			
			super.playAnim(label);
			if (!dying) {	//you are not allowed to start an animation while dying
				//if we are playing a death animation, that's the end of me
				if (label == "fade") {
					//trace("Virus(" + this.name + " playAnim(\"fade\")");
					releaseLyso();
					dying = true; //HACK to keep things working smoothly
				}
			}
		}

		protected override function arrivePoint(wasCancel:Boolean=false) {
			super.arrivePoint(wasCancel);
			if(!wasCancel){
				if (!entering && !leaving) {		//HACKITY HACK
					if(mnode){
						var x1:Number = x;
						var x2:Number = (mnode.x + mnode.p_next.x) / 2;
						var y1:Number = y;
						var y2:Number = (mnode.y + mnode.p_next.y) / 2;
						var dist2:Number = (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
						if (dist2 <= radius2*2) {
							onTouchCell();
						}else {
							exitMembrane();
						}
					}
					//var dx:Number = x1*x
				}
			}
		}
		
		/*protected override function onArrivePoint() {
			if(!toCent){
				moveToPoint(new Point(cent_x, cent_y), FLOAT, true);
				toCent = true;
			}else {
				super.onArrivePoint();
			}
		}*/
		
		public override function onAnimFinish(i:int, stop:Boolean = true) {
			//trace("CellObject.onAnimFinish() " + i + "me = " + name);
			//trace("Virus.onAnimFinish(" + i + ")");
			super.onAnimFinish(i,stop);
			switch(i) {
				case ANIM_GROW: onGrow(); break;
				case ANIM_LAND: onLand(); break;
				case ANIM_INVADE: onInvade(); break;
				case ANIM_RECYCLE:
				case ANIM_FADE:
				case ANIM_DIE: onDie();  break;
				case ANIM_EXIT: onExit();  super.onAnimFinish(i, stop); break;
			}
			
		}
		
		protected function onDie(){
			if (p_cell) { 
				p_cell.killVirus(this);
			}
			//trace("Virus(" + this.name + ").onDie()");
			releaseLyso();
		}
		
		protected function checkDefensin():Boolean {
			if (hasVesicle) { //vesicles are immune to defensins
				shrinkVesicle(); //shrink the vesicle away
				return true;
			}
			if(!shieldBlocked){
				if (!isNeutralized) {
					var chance:Number = Math.random();
					if(chance < Membrane.defensin_strength){
						playAnim("fade");
						shieldBlocked = true;
						p_cell.showShieldBlock(x, y);
						//trace("Virus.onLand() blocked by defensin! chance=" + chance + " defensin=" + Membrane.defensin_strength);
						return false;
					}else {
						return true;
						//trace("Virus.onLand() NOT blocked by defensin! chance=" + chance + " defensin=" + Membrane.defensin_strength);
					}
					
				}
			}else {
				return false;
			}
			return true;
		}
		
		protected function onLand() {
			//trace("Virus.onLand!");
			if (!isNeutralized) {
				doLandThing();
			}else {
				//trace("Virus.onLand() neutralized =" + isNeutralized + " get Out of here!");
				onExit();
			}
			
		}
		
		protected function doRibosomeThing() {
			//define per subclass
		}
		
		protected function doLandThing() {
			//define per subclass
		}
		
		public override function getPpodContract(xx:Number, yy:Number) {
			if (position_state == POS_TOUCHING_CELL || position_state == POS_INSIDE_CELL) {
				super.getPpodContract(xx, yy);
			}else {
				//donothing
			}
		}
		
		public override function updateLoc() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			updateGridLoc(xx, yy);
		}
		
		
	

		
		public override function doCellMove(xx:Number, yy:Number) {
			if (position_state == POS_TOUCHING_CELL || position_state == POS_INSIDE_CELL) {
				super.doCellMove(xx, yy);
			}else {
				//do nothing if not inside the cell
			}
		}
		
		
		
	}
	
}
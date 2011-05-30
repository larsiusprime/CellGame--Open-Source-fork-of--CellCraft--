package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecLevel.EngineEvent;
	import com.pecSound.SoundLibrary;
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
		public static const MOT_INFESTING_CELL:int = 2;
		public static const MOT_ESCAPING_CELL:int = 3;
	
		public static const CON_MOVE_TO_RIBOSOME:int = 0;
		public static const CON_MOVE_TO_MEMBRANE:int = 1;
		public static const CON_MOVE_TO_NUCLEUS:int = 2;
		
		public static const DYING:int = 2;
		
		public var position_state:int = POS_OUTSIDE_CELL;
		public var motivation_state:int = -1;
		public var condition_state:int = -1;
		
		public var mnode:MembraneNode;
		public var rib:Ribosome;
		public var nuc:Nucleus;
		public var nuc_pore:Point;
		
		public var entering:Boolean = false; //are we entering or exiting the membrane?
		public var leaving:Boolean = false; //are we leaving the gameplay zone?
		public var spawnCount:int = 1;
		public var rnaCount:int = 1;
		public var p_canvas:WorldCanvas;
		public var wave_id:String;
		protected var normal_speed:Number;
		protected var escape_speed:Number;
		
		public var toCent:Boolean = false;
		
		var absorbCount:int = 0;
		const ABSORB_TIME:int = 10;
		
		//public static var pv_grid:ObjectGrid;
		
		public var isNeutralized:Boolean = false;
		
		protected var DMG_PIERCE_MEMBRANE = 1;
		const INJECT_DISTANCE:Number = 30;
		
		public var newnode_count:int = 0;
		public var NEWNODE_TIME:int = 5;
		
		
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
			setRadius(25); //MAGIC NUMBER ALERT
			makeGameDataObject();
		}
		
		public override function destruct() {
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell, false);
			
			clearGrid();
			super.destruct();
		}
		
		public function setCanvas(c:WorldCanvas) {
			p_canvas = c;
		}
		
		protected function touchingCell() {
			position_state = POS_TOUCHING_CELL;
			//this.transform.colorTransform = new ColorTransform(0.75,0.75,0.75,1, 0,0,0,0);
		}
		
		protected function insideCell() {
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
		
		public function onGrow() {
			if (motivation_state == MOT_ESCAPING_CELL && position_state == POS_INSIDE_CELL) {
				//inCell = true;
				exitMembrane();
			}
		}
		
		protected function tauntCell(r:RunFrameEvent) {
			//define per subclass
		}
		
		public override function targetForEating() {
			//don't make it doomed just yet!
			
		}
		
		protected function onInvadeInfest() {
			mnode = null;
			cancelMove(); //just to be sure
			if (!isNeutralized) {
				p_cell.c_membrane.takeDamageAt(x, y, DMG_PIERCE_MEMBRANE);
				p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_entry_wound", wave_id, 1);
			}
			
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell);
			removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
			
			insideCell();
			
			condition_state = CON_MOVE_TO_NUCLEUS;
			nuc_pore = p_cell.c_nucleus.getPoreLoc(0); //get a nucleus pore
			
			if (nuc) {
				moveToPoint(new Point(nuc.x + nuc_pore.x, nuc.y + nuc_pore.y), FLOAT, true);
			}else {
				//trace("Virus.onInvade() rib is NULL!");
			}
		}
		
		protected function onInvade() {
			mnode = null;
			cancelMove(); //just to be sure
			if (!isNeutralized) {
				p_cell.c_membrane.takeDamageAt(x, y, DMG_PIERCE_MEMBRANE);
				p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_entry_wound", wave_id, 1);
			}
			
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell);
			removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
			insideCell();
			
			condition_state = CON_MOVE_TO_RIBOSOME;
			rib = p_cell.findClosestRibosome(x, y,true);
			if (rib) {
				moveToObject(rib, FLOAT, true);
			}else {

			}
		}
		
		public function onExit() {
			//trace("Virus.onExit() EXIT!");
			
			speed = escape_speed;
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell);
			
			if(!isNeutralized){
				p_cell.c_membrane.takeDamageAt(x, y, DMG_PIERCE_MEMBRANE); //damage the membrane
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
			//p_cell = null;
			//mnode = null;
			
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
			/*var SIZE:Number = 100;
			var xx:Number = SIZE * (Math.random()) - SIZE/2;
			var yy:Number = SIZE * (Math.random()) - SIZE/2;*/
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
		
		private function tryEnter(r:RunFrameEvent) {
			if (condition_state == CON_MOVE_TO_MEMBRANE && position_state == POS_OUTSIDE_CELL) {
				newnode_count++;
				if (newnode_count > NEWNODE_TIME) {
					newnode_count = 0;
					enterMembrane();
				}
			}
		}
		
		public override function calcMovement() {	
			if(condition_state == CON_MOVE_TO_MEMBRANE){
				if (mnode) { //if mnode is defined it's assumed we're moving towards it
					pt_dest.x = (mnode.x+mnode.p_next.x) / 2;
					pt_dest.y = (mnode.y+mnode.p_next.y) / 2;
					var v:Vector2D = new Vector2D(pt_dest.x - x, pt_dest.y - y);
					var ang:Number = (v.toRotation() / (Math.PI * 2)) * 360;//(v.toRotation() * 180) / Math.PI;
					
					rotation = ang - 90;
				}
				super.calcMovement();
			}else if (condition_state == CON_MOVE_TO_NUCLEUS) {
				if (nuc) {
					pt_dest.x = (nuc.x + nuc_pore.x);
					pt_dest.y = (nuc.y + nuc_pore.y);
					var v:Vector2D = new Vector2D(pt_dest.x - x, pt_dest.y - y);
					var ang:Number = (v.toRotation() / (Math.PI * 2)) * 360;//(v.toRotation() * 180) / Math.PI;
					
					rotation = ang - 90;
				}
				super.calcMovement();
			}
		}
		
		protected override function onArriveObj() {
			super.onArriveObj();
			if(!isDoomed){
				if (position_state == POS_INSIDE_CELL && rib) { //we're looking for a ribosome
					doRibosomeThing();
				}
			}
		}
		
		protected override function onArrivePoint() {
			super.onArrivePoint();
			if (!isDoomed) {
				if (position_state == POS_INSIDE_CELL && nuc_pore) { //we're looking for a nucleus pore
					doNucleusThing();
				}
			}
		}
		
		private function clingCell(r:RunFrameEvent) {
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
				}
				
			}
			if (condition_state == CON_MOVE_TO_MEMBRANE && position_state == POS_OUTSIDE_CELL) {//if we're entering the cell
				if (!isDoomed) {			
					touchingCell();
					mnode = p_cell.c_membrane.findClosestMembraneHalf(x,y);
					onTouchCellAnim();
					arrivePoint();
				}
			}
			
		}
		
		protected function onTouchCellAnim() {
			playAnim("land");
		}
		
		public override function playAnim(label:String) {
			
			super.playAnim(label);
			if (!dying) {	//you are not allowed to start an animation while dying
				//if we are playing a death animation, that's the end of me
				if (label == "fade") {
					dying = true; //HACK to keep things working smoothly
				}	
			}
		}

		protected override function arrivePoint(wasCancel:Boolean=false) {
			super.arrivePoint(wasCancel);
			if(!wasCancel){
				if (position_state == POS_INSIDE_CELL && motivation_state == MOT_ESCAPING_CELL) { //HACKITY HACK
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
			super.onAnimFinish(i,stop);
			switch(i) {
				case ANIM_GROW: onGrow(); break;
				case ANIM_LAND: onLand(); break;
				case ANIM_INVADE: onInvade(); break;
				case ANIM_FADE:
				case ANIM_DIE:  p_cell.killVirus(this); break;
				case ANIM_EXIT: onExit();  super.onAnimFinish(i, stop); break;
			}
			
		}
		
		protected function onLand() {
			if(!isNeutralized){
				var chance:Number = Math.random();
				
				if(chance > Membrane.defensin_strength){
					doLandThing();
				}else {
					//trace("Virus.onLand() blocked by defensin! chance=" + chance + " defensin=" + Membrane.defensin_strength);
				}
				
			}else {
				onExit();
			}
			
		}
		
		protected function doRibosomeThing() {
			//define per subclass
		}
		
		protected function doNucleusThing() {
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
			
			gdata.x = xx;
			gdata.y = yy;
			
			var old_x:int = grid_x;
			var old_y:int = grid_y;
			grid_x = int(xx / grid_w);
			grid_y = int(yy / grid_h);
			if (grid_x < 0) grid_x = 0;
			if (grid_y < 0) grid_y = 0;
			if (grid_x >= grid_w) grid_x = grid_w - 1;
			if (grid_y >= grid_h) grid_y = grid_h - 1;
			if((old_x != grid_x) || (old_y != grid_y)){
				p_grid.takeOut(old_x,old_y,gdata);
				p_grid.putIn(grid_x,grid_y,gdata);
			}
		}
	
		public function clearGrid() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			gdata.x = xx;
			gdata.y = yy;
			
			grid_x = int(xx / grid_w);
			grid_y = int(yy / grid_h);
			if (grid_x < 0) grid_x = 0;
			if (grid_y < 0) grid_y = 0;
			if (grid_x >= grid_w) grid_x = grid_w - 1;
			if (grid_y >= grid_h) grid_y = grid_h - 1;
			
			var loc_x:int;
			var loc_y:int;
			for (var w:int = -1; w <= 1; w++) {
				for (var h:int = -1; h <= 1; h++) {
					loc_x = grid_x + w;
					loc_y = grid_y + h;
					if (loc_x < 0) loc_x = 0;
					if (loc_y < 0) loc_y = 0;
					if (loc_x >= grid_w) loc_x = grid_w - 1;
					if (loc_y >= grid_h) loc_y = grid_h - 1;
					p_grid.takeOut(loc_x, loc_y, gdata);
				}
			}
			
		}
		
		public function placeInGrid() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			gdata.x = xx;
			gdata.y = yy;
			
			grid_x = int(xx / grid_w);
			grid_y = int(yy / grid_h);
			if (grid_x < 0) grid_x = 0;
			if (grid_y < 0) grid_y = 0;
			if (grid_x >= grid_w) grid_x = grid_w - 1;
			if (grid_y >= grid_h) grid_y = grid_h - 1;
			
			p_grid.putIn(grid_x,grid_y,gdata);
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
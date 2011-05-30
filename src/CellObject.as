package  
{
	import com.pecSound.SoundLibrary;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.cheezeworld.math.Vector2D;
	import flash.geom.Point;
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CellObject extends Selectable
	{
		
		protected var p_cell:Cell;
		protected var p_tube:Microtubule;
		
		public var plopDepth:int = 0;
		
		protected var home:Point;
		
		private var distTravelled:Number = 0;
		private const moveCostDist:Number = Costs.MOVE_DISTANCE;
		//private const oneMicron:Number = Costs.PIXEL_TO_MICRON;
		private var myMoveCost:Number = 0;
		private var myMoveCostBySpeed:Number = 0;
		private var freeMove:Boolean = false;
		
		public var is_active:Boolean = false;
		public var is_basicUnit:Boolean = false;
		public var might_collide:Boolean = false;
		
		protected var is_dividing:Boolean = false;
		
		protected var does_divide:Boolean = false;
		protected var does_move:Boolean = false;

		
		protected var does_pop:Boolean = false;
		
		public var clip_divide:MovieClip;
		
		private static const WORST_STRETCH:Number = 0.35;
		
		private var phDamage:Number = 0;
		private var phDamage_time:int = 30;
		private var phDamage_counter:int = 0;
		
		
		
		public var isInVesicle:Boolean = false;
		public var myVesicle:BigVesicle; //the vesicle I'm in
		
		private var oldSelect:Boolean = false;
		
		public var isOutsideCell:Boolean = false;
		
		public var doesCollide:Boolean = false; //does this collide with the membrane?
		public var hardCollide:Boolean = false; //does this stand rigidly against the membrane?
		
		public function CellObject() 
		{
			setLevel(1);
			speed = 6;
		}
		
		public function init() {
			
			getMyMoveCost();
			if (isNaN(myMoveCost)) {
				myMoveCost = 0;
			}
			myMoveCostBySpeed = myMoveCost * (speed / moveCostDist);
			//trace("mymovecostbyspeed = " + myMoveCostBySpeed);
		}
		
		private function receiveActionList() {
			var v:Vector.<int> = p_cell.getActionListFromEngine(this.num_id);
			if (v != null) {
				list_actions = v.concat();
				//trace("CellObject.receiveActionList() : " + list_actions);
			}
		}
		
		public function playFallSound() {
			Director.startSFX(SoundLibrary.SFX_DROPFALL);
		}
		
		public function playSplishSound() {
			Director.startSFX(SoundLibrary.SFX_SPLISH);	
		}
		
		public override function destruct() {
			p_cell = null;
			super.destruct();
		}
		
		public function setCell(c:Cell) {
			p_cell = c;
			receiveActionList(); //do this here to avoid bugs sine receiveActionList requires access to the cell
		}
		
		public override function giveHealth(amt:uint) {
			super.giveHealth(amt);
			if (selected) {
				if (p_cell.getEngineSelectCode() == Engine.SELECT_ONE) { //SUPER DUPER HACK!
					p_cell.engineUpdateSelected();
				}
			}
		}

		public function setOutsideCell(b:Boolean) {
			isOutsideCell = b;
		}
		
		protected override function heavyDamageClip() {
			super.heavyDamageClip();
			p_cell.checkScrewed(this);
		}
		
		public function setTube(t:Microtubule) {
			p_tube = t;
		}
		
		public function hideOrganelle() {
			visible = false;
			oldSelect = canSelect;
			canSelect = false;
		}
		
		public function showOrganelle() {
			visible = true;
			canSelect = oldSelect;
		}
		
		protected override function mouseDown(m:MouseEvent) {
			if (singleSelect) {
				m.stopPropagation(); //kill the click
				//p_cell.setSelectType(Selectable.NOTHING);
			}else {
				//trace(this + " mousedown");
				p_cell.setSelectType(num_id);
				//m.stopPropagation();
			}
		}
		
		protected override function click(m:MouseEvent) {
			//trace("CellObject.click() this=" + this + " singleSelect=" + singleSelect);
			if(canSelect){
				if (singleSelect) {
					p_cell.selectOne(this,m.stageX,m.stageY);
				}else {
					p_cell.selectMany(this,true);
				}
			}
		}

		public function doCellMove(xx:Number, yy:Number) {
			x += xx;
			y += yy;
			if (isMoving) {
				if (pt_dest) {
					pt_dest.x += xx;
					pt_dest.y += yy;
				}
			}
		}
		
		public function getPpodContract(xx:Number, yy:Number) {
			x -= xx;
			y -= yy;
			if (isMoving) {
				if (pt_dest) {
					pt_dest.x -= xx;
					pt_dest.y -= yy;
				}
				//calcMovement();
			}
		}
		
		
		protected function deployCytoplasm(xx:Number,yy:Number,radius:Number, spread:Number, free:Boolean=true,instant:Boolean=false) {
			var v:Vector2D = new Vector2D(radius+Math.random()*spread, 0); //Nucleus Radius = 75
			v.rotateVector(Math.random() * (Math.PI * 2));
			
			var p:Point = v.toPoint();
			p.x += xx;
			p.y += yy;
			
			if(!instant){
				moveToPoint(p, FLOAT, free);
			}else {
				//trace("CellObject.deployCytoplasm() INSTANT");
				x = p.x;
				y = p.y;
				home = new Point();
				home.x = p.x - cent_x;
				home.y = p.y - cent_y;
			}
		}
		
		protected function getMyMoveCost() {
			var num:Number = Costs.getMoveCostByString(text_id);
			myMoveCost = num;
		}
		
		protected function checkMembrane():Boolean {
			return true;
			/*var m:Number = p_cell.checkMembraneStrength(this);
			if(m > WORST_STRETCH){
				return true;
			}
			return false;*/
		}
		
		protected function checkSpend():Boolean {
			var okay:Boolean = true;
			
			/*if (distTravelled > oneMicron) {		//if its time to spend again
				distTravelled -= oneMicron;		
				
				if (!p_cell.spendATP(myMoveCost)){//try to spend some ATP, if we fail
					okay = false;			   //we can't move
				}
			}*/
			//trace("Spending " + myMoveCostBySpeed);
			if (freeMove)
				return true;
			else {
				if(p_cell){
					return p_cell.spendATP(myMoveCostBySpeed);
				}else {
					return false; //SOMETHING IS WRONG!
				}
			}
				
			//return okay;
		}
		
		protected function finishSpend() {
			/*if (distTravelled > 0) {
				var frac:Number = distTravelled / oneMicron;
				p_cell.spendATP(frac * myMoveCost);
				distTravelled = 0;
			}*/
		}
		
		protected override function onArrivePoint() {
			super.onArrivePoint();
			finishSpend();
		}
		
		protected override function onArriveObj() {
			super.onArriveObj();
			
			finishSpend();
		}
		
		public override function externalMoveToPoint(p:Point, i:int) {
			moveToPoint(p, i);
		}
		
		public override function moveToPoint(p:Point, i:int, free:Boolean = false) {
			freeMove = free;
			super.moveToPoint(p, i, free);
		}
		
		public override function moveToObject(o:GameObject, i:int, free:Boolean = false) {
			freeMove = free;
			super.moveToObject(o, i, free);
		}
		
		public override function push(xx:Number, yy:Number) {
			super.push(xx, yy);
			if(p_tube){
				p_tube.followObj();
			}
			/*if (this is Lysosome) {
				//trace("Lysosome.push(" + xx + "," + yy + ")");
			}*/
			/*if (pt_dest) {
				cancelMovePoint();
			}else if (go_dest) {
				cancelMoveObject();
			}*/
		}
		
		protected override function doMoveToPoint(e:Event) {
			//if(checkMembrane()){
				if (checkSpend()) {
					super.doMoveToPoint(e);
					distTravelled += speed;
					if (p_tube) {
						p_tube.followObj();
					}
				}else { //Don't cancel the move if the player can't afford it, just wait
					//cancelMovePoint();
				}
			//}
		}
		
		protected override function doMoveToGobj(e:Event) {
			//if(checkMembrane()){
				if (checkSpend()) {	
					super.doMoveToGobj(e);
					distTravelled += speed;
					if (p_tube) {
						p_tube.followObj();
					}
				}else { //Don't cancel the move if the player can't afford it, just wait
					//cancelMoveObject();
				}
			//}
		}
		
		public override function doAction(i:int, params:Object=null):Boolean {
			//trace("CellObject.doAction() " + i);
			switch(i){
				case Act.DIVIDE:
					if (canDivide()) 
						return doDivide();
					else
						return false;
					break;
				case Act.RECYCLE:
					return tryRecycle();
					break;
				
			}
			return false;
		}
		
		public function activate() {
			is_active = true;
		}
		
		public override function onAnimFinish(i:int, stop:Boolean = true) {
			//trace("CellObject.onAnimFinish() " + i + "me = " + name);
			switch(i) {
				case ANIM_BUD: 
				case ANIM_GROW: activate(); break;
				
				case ANIM_RECYCLE: onRecycle(); break;
				case ANIM_DIVIDE: finishDivide();  break;
				case ANIM_DAMAGE1: hardRevertAnim();  break;
				case ANIM_DAMAGE2: hardRevertAnim();  break;
				case ANIM_PLOP: onPlop(); break;
			}
			super.onAnimFinish(i,stop);
		}
		
		public function onHalfPlop() {
			p_cell.onHalfPlop(this);
		}
		
		protected function onPlop() {
			p_cell.onPlop(this);
		}
		
		protected function onRecycle() {
			p_cell.onRecycle(this,true,true);
		}
		
		public function canDivide():Boolean { //override this to check if prerequisites have been met as well for divisible things
			return does_divide && !is_dividing;
		}
		
		/*public override function playAnim(s:String) {
			super.playAnim(s);
			if (s == "plop") {
				
			}
		}*/
		
		public function doDivide():Boolean {
			is_dividing = true;
			playAnim("divide");
			
			bumpBubble();
			return true;
			//gotoAndStop("divide");
		}
		
		protected function finishDivide() {
			
			is_dividing = false;
			//playAnim("normal");
			gotoAndStop("normal");
			//define per subclass
		}
		
		public function inVesicle(v:BigVesicle) {
			isInVesicle = true;
			myVesicle = v;
		}
		
		public function outVesicle(unRecycle:Boolean=false) {
			isInVesicle = false;
			if (unRecycle && isDoomed) {
				unDoom();
			}
		}
		
		public function onCanvasWrapperUpdate() {
			
		}

		
		public function unDoom() {
			isDoomed = false;
			
			hideBubble();
			p_cell.unDoomCheck(this);
		}
		
		protected override function killMe() {
			super.killMe();
			if (selected) {
				p_cell.engineUpdateSelected();
			}
			
		}
		
		public function setPHDamage(n:Number,mult:Number=1) {
			var damage:Number = 0;
			if (n <= 7.5) {
				var diff:Number = 7.5 - n;
				
				if (diff <= .25) { //7.5-7.25
					//no problem
				}else if (diff <= 1.0) { //7.25-6.25
					//lowered efficiency
				}else if (diff > 1.0) {
					diff -= 1.0; //diff is now between 0 and 6.5, with 4.5 being super deadly
					diff /= 6.5; //diff is now between 0 and 1
					damage = diff * Cell.MAX_ACID_DAMAGE;
				}
			}
			n = damage * mult;
			
			if (n < 0.001) {
				removeEventListener(RunFrameEvent.RUNFRAME, takePHDamage);
			}else {
				phDamage = n;
				if (phDamage < 1) {
					phDamage_time = 1 / phDamage;
					phDamage_time *= 30; 
					phDamage = 1;
				}else {
					phDamage_time = 30;
				}
				phDamage_counter = 0;
				//if(this is Nucleus)
				//	trace("CellObject.setPHDamage(" + n + ") phDamage_time = " + phDamage_time + " phDamage = " + phDamage);
				addEventListener(RunFrameEvent.RUNFRAME, takePHDamage);
			}
		}
		
		protected function takePHDamage(r:RunFrameEvent) {
			phDamage_counter++;
			if (phDamage_counter > phDamage_time) {
				takeDamage(phDamage,true);
				phDamage_counter = 0;
			}
		}
		
		public override function takeDamage(n:Number, hardKill:Boolean=false) {
			super.takeDamage(n);
			if (selected) {
				p_cell.updateSelected();
			}
		}
		
		public function updateGridLoc(xx:Number,yy:Number) {
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
		
		/*public function finishDivide() {
			revertAnim();
			//gotoAndStop("normal");
		}*/
		
		
		
	}
	
}
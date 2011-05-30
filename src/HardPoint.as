package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class HardPoint extends CellObject
	{
		private var warble_count:Number = 0;
		private const WARBLE_AMOUNT:Number = 1;
		private const WARBLE_MAX:Number = 30;
		public var warble_sign:int = 1;
		private var base_radius:Number;
		
		public var p_escort:CellObject;
		public var isEscort:Boolean = false;
		private var escort_grow_count:Number = 0;
		private var ESCORT_GROW_MAX:Number = 0;
		public var isWarble:Boolean = false;
		
		public var newPos:Point;
		public var posDiff:Point;
		public var newRadius:Number;
		public var radDiff:Number;
		private const UPDATE_TIME:int = 45;
		
		private var posCount:int = 0;
		private var radCount:int = 0;
		
		public function HardPoint() 
		{
			singleSelect = true;
			canSelect = false;
			text_title = "HardPoint";
			text_description = "";
			text_id = "hardpoint";
			num_id = Selectable.HARDPOINT;
			setMaxHealth(999, true);
			doesCollide = true;
			hardCollide = true;
			makeGameDataObject();
			init();
			//clip.visible = false;
		}
		
		public function setNewPos(xx:Number, yy:Number) {
			newPos = new Point(xx, yy);
			posDiff = new Point((xx - x) / UPDATE_TIME, (yy - y) / UPDATE_TIME);
			addEventListener(RunFrameEvent.RUNFRAME, updatePos, false, 0, true);
		}
		
		public function setNewRadius(r:Number) {
			//base_radius = base_radius / 2;
			//setRadius(base_radius * .75);
			//rememberRadius();
			newRadius = r;
			radDiff = (r - base_radius) / UPDATE_TIME;
			addEventListener(RunFrameEvent.RUNFRAME, updateRadius, false, 0, true);
		}
		
		private function updatePos(r:RunFrameEvent) {
			x += posDiff.x;
			y += posDiff.y;
			posCount++;
			if (posCount >= UPDATE_TIME) {
				posCount = 0;
				x = newPos.x;
				y = newPos.y;
				removeEventListener(RunFrameEvent.RUNFRAME, updatePos);
			}
			updateLoc();
		}
		
		private function updateRadius(r:RunFrameEvent) {
			setBaseRadius(base_radius + radDiff);
			//rememberRadius();
			radCount++;
			if (radCount >= UPDATE_TIME) {
				radCount = 0;
				setBaseRadius(newRadius);
				//rememberRadius();
				removeEventListener(RunFrameEvent.RUNFRAME, updateRadius);
			}
		}
		
		public function startWarble() {
			isWarble = true;
			addEventListener(RunFrameEvent.RUNFRAME, warble, false, 0, true);
		}
		
		public function resetWarble() {
			//warble_count = 0;
			//setRadius(base_radius + warble_count);
		}
		
		private function warble(r:RunFrameEvent) {
			warble_count += warble_sign * WARBLE_AMOUNT;
			if (warble_sign == 1 && warble_count > WARBLE_MAX) {
				warble_count = WARBLE_MAX;
				warble_sign *= -1;
			}else if (warble_sign == -1 && warble_count < -WARBLE_MAX) {
				warble_count = -WARBLE_MAX;
				warble_sign *= -1;
			}
			setRadius(base_radius + warble_count);
		}
		
		public function setEscort(c:CellObject) {
			isEscort = true;
			p_escort = c;
			setRadius(c.getRadius()*2);
			rememberRadius();
			//ESCORT_GROW_MAX = base_radius;
			x = p_escort.x;
			y = p_escort.y;
			updateLoc();
			addEventListener(RunFrameEvent.RUNFRAME, doEscort, false, 0, true);
		}
		
		private function doEscort(r:RunFrameEvent) {
			
			/*if(escort_grow_count < ESCORT_GROW_MAX){
				escort_grow_count++;
				setRadius(base_radius + escort_grow_count);
			}*/
			
			if(p_escort.isMoving){
				x = p_escort.x;
				y = p_escort.y;
				updateLoc();
			}else {
				p_escort = null;
				removeEventListener(RunFrameEvent.RUNFRAME, doEscort);
				p_cell.killHardPoint(this);
			}
		}
		
		protected override function autoRadius() {
			setRadius(50);
		}
		
		public function setBaseRadius(r:Number) {
			base_radius = r;
		}
		
		public override function setRadius(r:Number) {
			super.setRadius(r);
			clip.width = r * 2;
			clip.height = r * 2;
			clip.x = 0;
			clip.y = 0;
		}
		
		public function rememberRadius() {
			base_radius = getRadius();
		}
		
		public override function updateLoc() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			updateGridLoc(xx, yy);
		}
	}
	
}
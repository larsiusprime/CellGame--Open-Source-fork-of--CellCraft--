package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class BlankVesicle extends CellObject
	{
		protected var product:int = Selectable.NOTHING;
		protected var product_amount:Number = 0;
		private var dock:DockPoint;
		private var exit:DockPoint;
		private var exit_wait:Boolean = false;
		private var exit_count:int = 0;
		private var EXIT_MAX:int = 60;
		private var dock_wait:Boolean = false;
		private var dock_count:int = 0;
		private var DOCK_MAX:int = 60;
		
		public function BlankVesicle() 
		{
			canSelect = false;
			singleSelect = true;
			text_title = "Vesicle";
			text_description = "A small vesicle on its way to becoming something else";
			text_id = "vesicle";
			bestColors = [1, 1, 0];
			num_id = Selectable.VESICLE;
			list_actions = new Vector.<int>();
			setMaxHealth(25, true);
			speed = 4;
			init();
		}
		
		public function setProduct(i:int,amount:Number=1) {
			product = i;
			product_amount = amount;
			
		}
		
		public override function onAnimFinish(i:int,stop:Boolean=true) {
			super.onAnimFinish(i,stop);
			switch(i) {
				case GameObject.ANIM_GROW: moveToGolgi(); break;
				case GameObject.ANIM_ADHERE: metamorphose(); break;
			}
		}
		
		protected function metamorphose() {
			visible = false;
			dock = null;
			moveToGolgiExit();
		}
		
		private function waitDock(e:RunFrameEvent) {
			dock_count++;
			if (dock_count > DOCK_MAX) {
				dock_count = 0;
				dock_wait = !moveToGolgi(); //try and get a dock
				if (!dock_wait) { //if we're not waiting anymore!
					removeEventListener(RunFrameEvent.RUNFRAME, waitDock);
				}
			}
		}
		
		public function waitForDock() { //wait for a dock
			if(!dock_wait){ //if I'm not ALREADY waiting
				dock_wait = true;
				addEventListener(RunFrameEvent.RUNFRAME, waitDock);
			}
		}
		
		private function waitExit(e:RunFrameEvent) {
			exit_count++;
			if (exit_count > EXIT_MAX) {
				exit_count = 0;
				exit_wait = !p_cell.askForGolgiExit(this); //try and get an exit
				if (!exit_wait) { //if we're not waiting anymore!
					removeEventListener(RunFrameEvent.RUNFRAME, waitExit);
				}
			}
		}
		
		public function waitForExit() { //wait for an exit
			if(!exit_wait){ //if I'm not ALREADY waiting
				exit_wait = true;
				addEventListener(RunFrameEvent.RUNFRAME, waitExit);
			}
		}
		
		protected override function onArrivePoint() {
			
			if (dock != null) {
				playAnim("adhere");
			}else if (exit) {
				
				//p_cell.freeGolgiExitPoint(exit.index);
				p_cell.growFinalVesicle(new Point(x,y), product);
				p_cell.killBlankVesicle(this);
			}
			
		}
		
		public function setDockPoint(d:DockPoint,xoff:int,yoff:int) {
			dock = d.copy();
			pt_dest = new Point(dock.x+xoff, dock.y+yoff - 14);
		}
		
		public function setExit(d:DockPoint, xoff:int, yoff:int) {
			exit = d.copy();
			pt_dest = new Point(exit.x + xoff, exit.y + yoff - 14);
		}
		
		public function moveToGolgiExit() {
			p_cell.askForGolgiExit(this);
		}
		
		public function swimThroughGolgi() {
			moveToPoint(pt_dest, FLOAT,true);
		}
		
		public function moveToGolgi():Boolean {
			//trace("Move to golgi!");
			var move:Boolean = p_cell.dockGolgiVesicle(this);
			if(move){
				moveToPoint(pt_dest, FLOAT,true);
				return true;
			}else {
				waitForDock();
				return false;
			}
			//moveToObject(p_cell.getGolgiDock());
		}
		
		public function growER() {
			playAnim("grow_er");
		}
		
		public function grow() {
			playAnim("grow");
		}
		
	}
	
}
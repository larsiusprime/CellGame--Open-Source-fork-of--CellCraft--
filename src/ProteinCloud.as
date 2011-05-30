package  
{
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ProteinCloud extends CellObject
	{
		private var product:int = Selectable.NOTHING;
		private var exit:DockPoint;
		private var exit_count:int = 0;
		private var exit_wait:Boolean = false;
		private var EXIT_MAX:int = 60; 
		
		public function ProteinCloud() 
		{
			blendMode = BlendMode.DARKEN;
			speed = 2;
			init();
		}
		
		public override function destruct() {
			exit = null;
		}
		
		public function setProduct(i:int) {
			product = i;
		}
		
		public function setExit(d:DockPoint,xoff:int,yoff:int) {
			exit = d.copy();	
			pt_dest = new Point(exit.x+xoff,exit.y+yoff-14);//offset 14 pixels for the animation
		}
		
		private function waitExit(e:RunFrameEvent) {
			exit_count++;
			if (exit_count > EXIT_MAX) {
				exit_count = 0;
				exit_wait = !p_cell.askForERExit(this); //try and get an exit
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
			//p_cell.freeERExitPoint(exit.index); //free the exit point;
			p_cell.growVesicle(this, product);
			p_cell.killProteinCloud(this);
		}
		
		public function swimER() {
			if (pt_dest) {
				moveToPoint(pt_dest, FLOAT,true);
			}
		}
		
	}
	
}
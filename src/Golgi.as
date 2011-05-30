package  
{
	import com.cheezeworld.math.Vector2D;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Golgi extends CellObject
	{
		public var dock0:Locator;
		public var dock1:Locator;
		public var dock2:Locator;
		public var dock3:Locator;
		public var dock4:Locator;
		public var dock5:Locator;
		public var dock6:Locator;
		public var dock7:Locator;
		public var dock8:Locator;
		public var dock9:Locator;
		public var dock10:Locator;
		
		public var exit0:Locator;
		public var exit1:Locator;
		public var exit2:Locator;
		public var exit3:Locator;
		public var exit4:Locator;
		public var exit5:Locator;
		public var exit6:Locator;
		public var exit7:Locator;
		public var exit8:Locator;
		public var exit9:Locator;
		public var exit10:Locator;
		
		private var list_dock:Vector.<DockPoint>;
		private var list_exit:Vector.<DockPoint>;
		
		private var resetCount:int = 0;
		private const busyTime:int = 30 * 2; //2 seconds
		
		public function Golgi() 
		{
			showSubtleDamage = true;
			singleSelect = true;
			text_title = "Golgi Body";
			text_description = "Processes vesicles";
			text_id = "golgi";
			num_id = Selectable.GOLGI;
			bestColors = [0, 0, 1];
			setMaxHealth(250, true);
			list_dock = new Vector.<DockPoint>();
			list_exit = new Vector.<DockPoint>();
			//list_actions = Vector.<int>([Act.BUY_LYSOSOME,Act.BUY_PEROXISOME,Act.MAKE_DEFENSIN]);
			for (var i:int = 0; i < 10; i++) { //create a list of points and remove all the locator objects
				var d:Locator = Locator(getChildByName("dock" + i));
				var p:DockPoint = new DockPoint();
				p.x = int(d.x);
				p.y = int(d.y);
				p.busy = false;
				p.index = i;
				p.setBusyTime(busyTime);
				list_dock.push(p);
				removeChild(d);
				d = null;
				var e:Locator = Locator(getChildByName("exit" + i));
				var ep:DockPoint = new DockPoint();
				ep.x = int(e.x);
				ep.y = int(e.y);
				ep.busy = false;
				ep.index = i;
				ep.setBusyTime(busyTime);
				list_exit.push(ep);
				removeChild(e);
				e = null;
			}
			list_exit.reverse();
			addEventListener(RunFrameEvent.RUNFRAME, checkBusy);
			init();
		}
		
		/*
		public function busyDockingPoint(i) {
			//list_dock[i].busy = true;
			getChildByName("dock" + i).visible = false;
		}
		
		private function freeDockingPoint(i) {
			getChildByName("dock" + i).visible = true;
		}
		
		public function busyExitPoint(i) {
			getChildByName("exit" + i).visible = false;
			//list_exit[i].busy = true;
		}
		
		private function freeExitPoint(i) {
			getChildByName("exit" + i).visible = true;
			//list_exit[i].busy = false;
		}//*/
		
		public function checkBusy(re:RunFrameEvent) {
			resetCount++;
			if (resetCount > busyTime * 6) { //every twelve seconds, clear everything
				resetCount = 0;
				for each (var pp:DockPoint in list_dock) {
					//freeDockingPoint(pp.index);
					pp.unBusy();
					
				}
				for each(var ee:DockPoint in list_exit) {
					//freeExitPoint(ee.index);
					ee.unBusy();
					
				}
			}else {
				for each (var p:DockPoint in list_dock) {
					p.busyCount();
					/*if (!p.busy) {
						freeDockingPoint(p.index);
					}*/
					
				}
				for each (var e:DockPoint in list_exit) {
					e.busyCount();
					/*if(!e.busy){
						freeExitPoint(e.index);
					}*/
					
				}
			}
		}
		
		public function findDockingPoint():DockPoint {
			for each(var p:DockPoint in list_dock) {
				if (p.busy != true) {
					p.makeBusy();
					return p;
				}
			}
			return null;
		}
		
		public function findExitPoint():DockPoint {
			for each(var p:DockPoint in list_exit) {
				if (p.busy != true) {
					p.makeBusy();
					return p;
				}
			}

			return null;
		}
		
	}
	
}
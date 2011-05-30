package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ER extends CellObject
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
		public var dock11:Locator;
		public var dock12:Locator;
		public var dock13:Locator;
		public var dock14:Locator;
		public var dock15:Locator;
		public var dock16:Locator;
		public var dock17:Locator;
		public var dock18:Locator;
		public var dock19:Locator;
		public var dock20:Locator;
		public var dock21:Locator;
		public var dock22:Locator;
		public var dock23:Locator;
		public var dock24:Locator;
		public var dock25:Locator;
		public var dock26:Locator;
		public var dock27:Locator;
		public var dock28:Locator;
		public var dock29:Locator;
		public var dock30:Locator;
		public var dock31:Locator;
		public var dock32:Locator;
		public var dock33:Locator;
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
		public var exit11:Locator;
		public var exit12:Locator;
		public var exit13:Locator;
		public var exit14:Locator;
		public var exit15:Locator;
		public var exit16:Locator;
		public var exit17:Locator;
		public var exit18:Locator;
		public var exit19:Locator;
		public var exit20:Locator;
		public var exit21:Locator;
		public var exit22:Locator;
		public var exit23:Locator;
		public var exit24:Locator;
		public var exit25:Locator;
		public var exit26:Locator;
		public var exit27:Locator;
		public var exit28:Locator;
		public var exit29:Locator;
		public var exit30:Locator;
		public var exit31:Locator;
		public var exit32:Locator;
		public var exit33:Locator;
		
		private var list_dock:Vector.<DockPoint>;
		private var list_exit:Vector.<DockPoint>;
		
		public function ER() 
		{
			showSubtleDamage = true;
			singleSelect = true;
			text_title = "E.R.";
			text_description = "<b>Endoplasmic Reticulum</b>:<br>builds vesicles and membrane";
			text_id = "er";
			num_id = Selectable._ER;
			bestColors = [true, false, false];
			//list_actions = Vector.<int>([Act.MAKE_MEMBRANE]);
			setMaxHealth(100, true);
			list_dock = new Vector.<DockPoint>();
			list_exit = new Vector.<DockPoint>();
			for (var i:int = 0; i < 33; i++) { //create a list of points and remove all the locator objects
				var d:Locator = Locator(getChildByName("dock" + i));
				var p:DockPoint = new DockPoint();
				p.x = int(d.x);
				p.y = int(d.y);
				p.busy = false;
				p.index = i;
				list_dock.push(p);
				//d.visible = true;
				removeChild(d);
				d = null;
				var e:Locator = Locator(getChildByName("exit" + i));
				var ep:DockPoint = new DockPoint();
				ep.x = int(e.x);
				ep.y = int(e.y);
				ep.busy = false;
				ep.index = i;
				list_exit.push(ep);
				//e.visible = true;
				removeChild(e);
				e = null;
			}
			addEventListener(RunFrameEvent.RUNFRAME, checkBusy);
			init();
		}
		
		include "inc_fastmath.as";
		
		
		
		private function busyDockingPoint(i) {
			//list_dock[i].busy = true;
			var dock = (getChildByName("dock" + i));
			dock.visible = false;
		}
		
		private function freeDockingPoint(i) {
			//list_dock[i].busy = false;
			var dock = (getChildByName("dock" + i));
			dock.visible = true;
		}
		
		private function busyExitPoint(i) {
			//list_exit[i].busy = true;
			var exit = (getChildByName("exit" + i));
			exit.visible = false;
		}
		
		private function freeExitPoint(i) {
			//list_exit[i].busy = false;
			var exit = (getChildByName("exit" + i));
			exit.visible = true;
		}
		
		public function checkBusy(re:RunFrameEvent) {
			for each (var p:DockPoint in list_dock) {
				p.busyCount();
				//if (p.busy) busyDockingPoint(p.index);
				//else freeDockingPoint(p.index);
			}
			for each (var e:DockPoint in list_exit) {
				e.busyCount();
				//if (e.busy) busyExitPoint(e.index);
				//else freeExitPoint(e.index);
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
		
		public function findClosestDockingPoint(xx:Number,yy:Number):DockPoint {
			var bestDist2:Number = 1000000000; //One Bill-ion
			var dist2:Number = bestDist2;
			var bestP:DockPoint = null;
			var i:int = 0;
			for each(var p:DockPoint in list_dock) {
				if(p.busy != true){
					dist2 = getDist2(xx, yy, p.x, p.y);
					if (dist2 < bestDist2) {
						bestDist2 = dist2;
						bestP = p;
					}
				}
				i++;
			}
			return bestP;
		}
		
		protected override function autoRadius() {
			setRadius(100);
		}
		
	}
	
}
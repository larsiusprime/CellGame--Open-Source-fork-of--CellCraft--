package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class EvilRNA extends RNA
	{
		private var rotateDir:int = 1;
		
		private var TAUNT_TIME:int = 15;
		private var tauntCount:int = TAUNT_TIME;
		private var hasMnode:Boolean = false;
		private var mnode:MembraneNode;
		private var mnode_dist:Point;
		private var list_slicer:Vector.<SlicerEnzyme>;
		public var doesRotateUp:Boolean = false;
		//public var targetSlicer:SlicerEnzyme;
		
		public function EvilRNA(i:int,count:int=1,pc_id:String="") 
		{
			super(i, count);

			addEventListener(RunFrameEvent.RUNFRAME, tauntCell, false, 0, true);
			speed = 3;
			product_creator_id = pc_id;
		}
		
		public function addSlicer(s:SlicerEnzyme) {
			if (list_slicer == null) {
				list_slicer = new Vector.<SlicerEnzyme>;
			}
			list_slicer.push(s);
		}
		
		public override function destruct() {
			mnode = null;
			mnode_dist = null;
			//targetSlicer = null;
			if(list_slicer){
				for (var i:int = 0; i < list_slicer.length; i++) {
					list_slicer.pop();
				}
				list_slicer = null;
			}
			super.destruct();
			
		}
		
		public function setMnode(m:MembraneNode) {
			//trace("EvilRNA.setMnode(" + m.index + ") me = " + name );
			if(!hasMnode){
				hasMnode = true;
				mnode = m;
				mnode.addRNA(this);
				addEventListener(RunFrameEvent.RUNFRAME, clingToNode, false, 0, true);
			}
			//mnode_dist = new Point(mnode.x-x, mnode.y-y);
		}
		
		public function clingToNode(r:RunFrameEvent) {
			x = (mnode.x + mnode.p_next.x) / 2;
			y = (mnode.y + mnode.p_next.y) / 2;
		}
		
		public override function getPpodContract(xx:Number, yy:Number) {
			if(!hasMnode || (hasMnode && mnode.state_ppod == false)){ 
				x -= xx;
				y -= yy;
				if (isMoving) {
					if (pt_dest) {
						pt_dest.x -= xx;
						pt_dest.y -= yy;
					}
				}
			}
		}
		
		protected override function killMe() {
			if(list_slicer){
				var length:int = list_slicer.length;
				for (var i:int = length-1; i >= 0; i--) {
					list_slicer[i].releaseByRNA(this);
					list_slicer[i] = null;
					list_slicer.splice(i, 1);
				}
			}
			super.killMe();
		}
		
		public override function onAnimFinish(i:int,stop:Boolean=true) {
			super.onAnimFinish(i,stop); //skip the MRNA onAnimFinish
			gotoAndStop("normal");
			switch(i) {
				case ANIM_THREAD:
					playAnim("die_thread");
					break;
				case ANIM_VIRUS_GROW:
					rotateUp();
					break;
				case ANIM_DIE:
					killMe(); 
					break;
				case ANIM_HARDKILL:
					hardKillMe();
					break;
				default:
					break;
			}
		}
		
		
		
		protected override function doMoveToGobj(e:Event) {
			super.doMoveToGobj(e);
			if (hasMnode) {
				var x1:Number = x;
				var x2:Number = cent_x;
				var y1:Number = y;
				var y2:Number = cent_y;
				var dist2:Number = (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
				if (dist2 <= BasicUnit.C_GRAV_R2) {
					mnode.removeRNA(this);
					mnode = null;
					hasMnode = false;
				}else {
					x2 = (mnode.x + mnode.p_next.x) / 2;
					y2 = (mnode.x + mnode.p_next.y) / 2;
					dist2 = (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
					if (dist2 > (50 * 50)) { //HACK AND MAGIC NUMBER
						//trace("EvilRNA dist too great! loc=(" + x + "," + y + ") mloc=(" + x2 + "," + y2 + ")");
						checkOutsideMembrane();
					}
				}
			}
		}
		
		
		
		
		private function checkOutsideMembrane() {
			
			var v_cent:Vector2D = new Vector2D(x - cent_x, y - cent_y);
			var v_node:Vector2D = new Vector2D(x - mnode.x, y - mnode.y);
			var ang:Number = v_cent.angleTo(v_node);
			if (ang < (Math.PI/2)) {
				//we're outside
				x = (mnode.x + mnode.p_next.x) / 2;
				y = (mnode.y + mnode.p_next.y) / 2;
				v_cent.normalize();
				v_cent.multiply(-51);
				x += v_cent.x;
				y += v_cent.y;
			}
		}
		
		
		protected function tauntCell(r:RunFrameEvent) { //every second, asks the cell for something to kill it
			tauntCount++;
			if (tauntCount > TAUNT_TIME) {
				tauntCount = 0;
				p_cell.tauntByEvilRNA(this);
			}
		}
		
		public override function threadRNA(inPlace:Boolean=false) {
			//we ignore the inPlace parameter, because evilRNA just has a different animation for "thread"
			//we have to include the parameter to remain compatible with the overriden function
			
			playAnim("thread");
			deliverProduct();
			//atRibosome = true;
		}
		
		private function rotateUp() {
			if(doesRotateUp){
				rotation = Math.floor(rotation);
				if (rotation < 0) rotation = 360 + rotation;
				addEventListener(RunFrameEvent.RUNFRAME, doRotateUp, false, 0, true);
			}else {
				if(p_rib){
					ribosomeTime();
				}else {
					//cytoplasmTime();
					//trace("EvilRNA.waitForRibosome() me = " + name);
					waitForRibosome();
				}
			}
		}
		
		private function doRotateUp(r:RunFrameEvent) {
			rotation = (0.8) * rotation;
			if (rotation < 1) {
				rotation = 0;
				removeEventListener(RunFrameEvent.RUNFRAME, doRotateUp);
				ribosomeTime();
			}
		}
		
		/*private function cytoplasmTime() {
			trace("EvilRNA.cytoplasmTime() me = " + name + "!");
			var v:Vector2D = new Vector2D(x - cent_x, y - cent_y);
			v.multiply(0.33);
			moveToPoint(new Point(x + v.x, y + v.y), FLOAT, true);
		}*/
		
		protected override function onArrivePoint() {
			super.onArrivePoint();
			ribosomeTime();
		}
		
		protected override function waitRib(e:RunFrameEvent) {
			rib_count++;
			if (rib_count > RIB_MAX) {
				rib_count = 0;
				rib_wait = !p_cell.askForRibosome(this); //if it was successful, we are NOT waiting
				if (p_rib) {
					//moveToRibosome(p_rib, FLOAT);	//if we have a ribosome, go to it!
					ribosomeTime();
					removeEventListener(RunFrameEvent.RUNFRAME, waitRib);
				}
			}
			
		}
		
		private function ribosomeTime() {
			//trace("EvilRNA.ribosomeTime() me = " + name + "!");
			removeEventListener(RunFrameEvent.RUNFRAME, clingToNode);
			if(p_rib){
				moveToRibosome(p_rib, FLOAT); 
			}
			if (nuc_pore) {
				moveToNucleusPore(FLOAT);
			}
		}
		
	}
	
}
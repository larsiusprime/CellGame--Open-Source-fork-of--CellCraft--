package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import com.pecSound.*;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Ribosome extends BasicUnit
	{
		
		public var instant_deploy:Boolean = false;
		//private var busy:Boolean = false;
		private var ready:Boolean = false;
		private var deploying:Boolean = false;
		
		private var p_dock:DockPoint;
		private var p_rna:RNA;
		private var er_wait:Boolean = false; //are we waiting for a free docking point
		private var er_count:int = 0;
		private const ER_MAX:int = 60; //poll every second for a new one
		private var product:int = Selectable.NOTHING; //what we're going to make
		private var product_virus_vesicle:Boolean = false;
		private var product_creator_id:String = ""; //used mostly for virus waves to keep track of child viruses
		private var product_count:int = 0; //how many we're going to make
		private var movingToER:Boolean = false;
		private var processing:Boolean = false;
		private var busyTimer:Timer;
		private var busy_count:int = 0;
		private const BUSY_TIME:int = 30; //1 second
		
		private var process_count:int = 0;
		private const MAX_PROCESS_TIME:int = 150; //5 seconds (thread time ~ 110)
		
		public function Ribosome() 
		{
			canSelect = false;
			buttonMode = false;
			mouseEnabled = false;
			singleSelect = false;
			text_title = "Ribosome";
			text_description = "A \"factory\" - builds things from an RNA \"blueprint\"";
			text_id = "ribosome";
			num_id = Selectable.RIBOSOME;
			bestColors = [0, 0, 1];
			//list_actions = Vector.<int>([Act.MOVE]);
			setMaxHealth(25, true);
			speed = 4;
			does_recycle = true;
			
			busyTimer = new Timer(BUSY_TIME);
			init();
			
		}
		
		public override function destruct() {
			super.destruct();
			p_rna = null;
			product = NOTHING;
			product_count = 0;
		}

		
		public function makeBusy() {
			isBusy = true;
			//busyTimer.start();
			//this.transform.colorTransform = new ColorTransform( -1, -1, -1, 1, 255, 255, 255);
			//this.transform.colorTransform = new ColorTransform( 1, 1, 1, 1, 255,255,255);
			busy_count = 0;
			//addEventListener(RunFrameEvent.RUNFRAME, checkBusyTime,false,0,true);
			//busyTimer.addEventListener(TimerEvent.TIMER, busyTime);
		}
		
		private function checkBusyTime(r:RunFrameEvent) {
			busy_count++;
			if (busy_count > BUSY_TIME) {
				busy_count = 0;
				trace("Ribosome.chcekBusyTime() MAKE FREE");
				makeFree();
				removeEventListener(RunFrameEvent.RUNFRAME, checkBusyTime);
				/*}else {
					if (p_rna == null) {
						trace("Ribosome.checkBusyTime() I AM TIRED OF WAITING!");
						finishProduct();
					}
				}*/
			}
		}
		//failsafe to keep it from getting locked up
		/*private function busyTime(t:TimerEvent) {
			isBusy = false;
			ready = true;
		}*/
		
		public function checkFixBusy() {
			if (product == NOTHING) {
				makeFree();
			}
		}
		
		/**
		 * Tell the Ribosome it is free to accept another RNA. Will only make the Ribosome not busy if it's
		 * not doing anything else
		 */
		
		public function makeFree() {
			if(product == Selectable.NOTHING){ //if I'm not trying to make some product
				if(p_rna == null){
					isBusy = false;
					//this.transform.colorTransform = new ColorTransform( 1, 1, 1, 1, 0, 0, 0, 0);
				}
			}else {
				//trace("Ribosome.makeFree() FAIL! I've got stuff! product="+product + " p_rna==null : " + (p_rna == null));
			}
		}
		
		public override function tryRecycle(oneOfMany:Boolean=false):Boolean {
			if(!isBusy){
				return super.tryRecycle(oneOfMany);
			}
			return false;
		}
		
		/*public function isBusy():Boolean {
			return busy;
		}*/
		
		public function isReady():Boolean {
			return ready;
		}
	
		protected override function killMe() {
			if (product != Selectable.NOTHING) {
				p_cell.abortProduct(product);
			}

			//trace("Ribosome.killMe()!" + name);
			super.killMe();
		}

		public function getRNA():RNA {
			return p_rna;
		}
		
		public function setRNA(m:RNA) {
			p_rna = m;
		}
		
		public function getProduct(i:int, count:int=1,pc_id:String="",pc_vesicle:Boolean=false):Boolean {
			if (!dying) {
				if (product == Selectable.NOTHING) {
					
					product = i;
					product_count = count;
					product_creator_id = pc_id; //mostly used to keep track of virus waves
					product_virus_vesicle = pc_vesicle;
					//p_rna = null; //Don't need you anymore
					return true;
				}else {
					throw new Error("Ribosome.getProduct()! I've already got one!");
					return false;
				}
			}
			return false;
		}
		
		public function checkProduct(i:int) {
			//trace("Ribosome.checkProduct()");
			
			if(!dying){
				var vesicle:Boolean = false;
				switch(i) {
					//Bugs if you don't use Selectable.LYSOSOME, etc
					case Selectable.VIRUS:
					case Selectable.VIRUS_INFESTER:
					case Selectable.VIRUS_INJECTOR:
					case Selectable.VIRUS_INVADER: 
					case Selectable.DNAREPAIR:
					case Selectable.SLICER_ENZYME: vesicle = false; break;
					case Selectable.DEFENSIN: 
					case Selectable.TOXIN:
					case Selectable.LYSOSOME: 
					case Selectable.MEMBRANE:
					case Selectable.PEROXISOME: vesicle = true; break;
					


					default: trace("Ribosome does not recognize product # : " + i+")"); break;// throw new Error("Ribosome does not recognize product #:" + i); break;
				}
				if (vesicle) {
					//trace("Ribosome.checkProduct(" + i + ") TRUE!");
					dockWithER();
				}else {
					produceInPlace();
				}
			}else {
				throw new Error("Ribosome can't check product, is dying!");
			}
		}
		
		public function produceInPlace() {
			if (!dying) {
				makeBusy();
				if (p_rna) {
					//startProcess();
					playAnim("process_inplace");
					//addEventListener(RunFrameEvent.RUNFRAME, processFailSafe, false, 0, true);
					p_rna.threadRNA(true);
				}
			}
		}
		
		
		private function processFailSafe(r:RunFrameEvent) {
			process_count++;
			if (process_count > MAX_PROCESS_TIME) {
				process_count = 0;
				//removeEventListener(RunFrameEvent.RUNFRAME, processFailSafe);
				makeFree();
				if (isBusy) {
					//cancelRNA();
					//makeFree();
					/*if (p_rna) {
						if (p_rna.slicer_killed) {
							cancelRNA();
							makeFree();
							trace("Ribosome.processFailSafe() HARD FREE!");
						}
					}*/
					throw new Error("WHat the HECK");
					//trace("Ribosome.processFailSafe() ERROR!");
				}
				
				if(!isBusy){
					removeEventListener(RunFrameEvent.RUNFRAME, processFailSafe);
				}
			}
		}
		
		/*public function startProcess() {
			processing = true;
			addEventListener(RunFrameEvent.RUNFRAME, countProcess, false, 0, true);
		}
		
		private function countProcess(r:RunFrameEvent) {
			process_count++;
			if (process_count > PROCESS_TIME) {
				process_count = 0;
				if (!processing) {
					cancelRNA();
				}
			}
		}*/
		
		
		public function dockWithER() {
			//trace("Ribosome.dockWithER()");
			if (!dying) {
				makeBusy();
				if (p_cell.dockRibosomeER(this)) { //if it succeeded
					//that's cool
					//trace("Ribosome.dockWithER() Success!");
					movingToER = true;
					if(er_wait){ //stop waiting
						removeEventListener(RunFrameEvent.RUNFRAME, waitER);
						er_wait = false;
						er_count = 0;
					}
				}else {
					//trace("Ribosome.dockWithER() FAILURE!");
					er_wait = true; //start waiting
					er_count = 0;
					addEventListener(RunFrameEvent.RUNFRAME, waitER,false,0,true);
				}
			}
		}
		
		public function finishRNA(inPlace:Boolean=false) {
			if (inPlace) {
				onAnimFinish(ANIM_PROCESS_INPLACE);
			}else{
				onAnimFinish(ANIM_PROCESS);
			}
		}
		
		public function cancelRNA() {
			//trace("Ribosome.cancelRNA()!");
			p_rna = null;
			product = Selectable.NOTHING;
			product_count = 0;
			hardRevertAnim();
			makeFree();
		}
		
		private function waitER(e:RunFrameEvent) {
			er_count++;
			if (er_count > ER_MAX) {
				er_count = 0;
				dockWithER();
			}
		}
		
		private function makeProduct() {
			if (!dying) {
				if (p_rna) {
					//startProcess();
					playAnim("process");
					p_rna.threadRNA();
					//addEventListener(RunFrameEvent.RUNFRAME, processFailSafe, false, 0, true);
				}
			}
			//trace("RIBOSOME Make some " + product);
		}
		
		private function finishProduct() {
			if(!dying){
				
				switch(product) {
					case Selectable.LYSOSOME: p_cell.sendERProtein(this, Selectable.LYSOSOME); break;
					case Selectable.TOXIN: p_cell.sendERProtein(this, Selectable.TOXIN); break;
					case Selectable.DEFENSIN: p_cell.sendERProtein(this, Selectable.DEFENSIN); break;
					case Selectable.MEMBRANE: p_cell.sendERProtein(this, Selectable.MEMBRANE); break;
					case Selectable.PEROXISOME: p_cell.sendERProtein(this, Selectable.PEROXISOME); break;
					case Selectable.VIRUS:
					case Selectable.VIRUS_INJECTOR:
					case Selectable.VIRUS_INVADER:
					case Selectable.VIRUS_INFESTER: p_cell.spawnRibosomeVirus(this, product, product_count,product_creator_id,product_virus_vesicle); break;
					case Selectable.SLICER_ENZYME: p_cell.spawnRibosomeSlicer(this, product_count); break;
					case Selectable.DNAREPAIR: p_cell.spawnRibosomeDNARepair(this, product_count); break;
					default: trace("Ribosome.finishProduct()" + product); break;
				}
				p_rna = null;
				product = Selectable.NOTHING; //i've got no product now
				product_virus_vesicle = false;
				//it's not free until it deploys and goes back home!
				p_dock = null;
			}
		}
		
		private function revertAnim() {
			 gotoAndStop(1);  
			 clip.visible = true;
		}
		
		public override function playAnim(label:String) {
			if (label == "grow") {
				//if (Math.random() > 0.5) {
					Director.startSFX(SoundLibrary.SFX_POP1);
				//}else{
				//	Director.startSFX(SoundLibrary.SFX_POP2);
				//}
			}
			super.playAnim(label);
		}
		
		public function ribosomeDeploy(instant:Boolean=false) {
			/*if (home) {
				if (instant) {
					x = home.x + cent_x;
					y = home.y + cent_y;
					ready = true;
				}else {
					deploying = true;
					moveToPoint(home, FLOAT, true);
				}
			}else{*/
				p_rna = null;
				product = NOTHING; //just to be safe
				deploying = true;
				deployCytoplasm(p_cell.c_nucleus.x, p_cell.c_nucleus.y, 90, 20, true, instant);
				if (instant) {
					ready = true; //HACK HACK HACK
				}
			//}
			//when deploying is done, it is made free 
		}
		
		public override function onAnimFinish(i:int, stop:Boolean = true) {
			//trace("Ribosome.onAnimFinish() " + i + " isDying = " + dying);
			if (!dying) {	//same as the super.onAnimFinish, but doesn't gotoAndStop(1);
			    if(stop){
					clip.play();
					anim_vital = false;
					removeEventListener(RunFrameEvent.RUNFRAME, doAnim);
				}
			
				switch(i) {
					case ANIM_GROW: ribosomeDeploy(instant_deploy); revertAnim(); break;
					case ANIM_DOCK: makeProduct(); break;
					case ANIM_PROCESS: processing = false;
									   finishProduct(); 
									   revertAnim(); 
									   ribosomeDeploy(); break; //deploy makes it free!
					case ANIM_PROCESS_INPLACE:
											processing = true;
											finishProduct(); 
											revertAnim(); 
											makeFree();  break;
				}
			}else { //handle the dying cases
				//trace("Ribosome.onAnimFinish() DIE! " + name);
				switch(i) {
					case ANIM_DIE: break;
					case ANIM_RECYCLE: 
						onRecycle();
						break;
				}
			}
		}
		
		protected override function onDeadTimer(t:TimerEvent) {
			//trace("Ribosome.onDeadTimer()!" + name);
			onRecycle(); //complexify this when its possible to die AND recycle separately
			
		}
		
		protected override function onRecycle() {
			//trace("Ribosome.onAnimFinish() RECYCLE!" + name);
			revertAnim();
			p_cell.onRecycle(this,true,false);
			removeEventListener(TimerEvent.TIMER, onDeadTimer);
		}
		
		public function doDock() {
			if (p_rna) {
				playAnim("dock");
				p_rna.descend();
			}else {
				ready = true;
			}
		}
		
		protected override function arrivePoint(wasCancel:Boolean=false) {
			if(!wasCancel){
				onArrivePoint();
			}
			
			if (pt_dest) {
				x = pt_dest.x;
				y = pt_dest.y;
			}
			
			isMoving = false;

			removeEventListener(RunFrameEvent.RUNFRAME, doMoveToPoint);
		}
		
		
		protected override function onArrivePoint() {
			if(!dying){
				if(movingToER){
					doDock();
					movingToER = false;
				}else {
					ready = true;
				}
				
				if (deploying) {
					deploying = false;
					makeFree();
				}
			}
		}
		
		public function setDockPoint(d:DockPoint,xoff:int,yoff:int) {
			p_dock = d.copy();
			pt_dest = new Point(p_dock.x+xoff, p_dock.y+yoff-10);//10 pixels higher to account for my "landing" animation
			moveToPoint(pt_dest, FLOAT,true);
		}
		
		protected override function doMoveToPoint(e:Event) {
			super.doMoveToPoint(e);
			if(p_rna){
				p_rna.x = x;
				p_rna.y = y;
			}
		}
		
		public override function startGetEaten() {
			super.startGetEaten();
			
			if (p_rna) {
				p_rna.hardKill();
			}
		}
		
		public override function doRecycle() {

			super.doRecycle();
			playAnim("recycle");
		}
	}
	
}
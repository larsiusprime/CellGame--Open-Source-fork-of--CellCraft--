package  
{
	import flash.display.DisplayObject;
	import com.pecSound.*;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class RNA extends CellObject
	{
		protected var product:int;
		protected var product_creator_id:String; 
		public var product_virus_vesicle:Boolean = false; //if my product is a virus, is it vesicle-bound
		protected var product_count:int=1;
		protected var p_rib:Ribosome; //the ribosome I'm targetting
		protected var atRibosome:Boolean = false; //have I arrived?
		
		protected var p_nucleus:Nucleus;
		protected var nuc_pore:Point;
		protected var nuc_pore_index:int;
		
		protected var rib_wait:Boolean = false; //are we waiting for a ribosome?
		protected var rib_count:int = 0;
		protected var RIB_MAX:int = 60; //poll for a ribosome every second if idle
		
		public var na_value:int = 1;
		
		protected var dock_count:int = 0;
		protected const DOCK_TIME:int = 300;
		public var slicer_killed:Boolean = false;
		
		public var invincible:Boolean = false;
		
		public function RNA(i:int,count:int=1) 
		{
			canSelect = false;
			singleSelect = true;
			product = i;
			if (i == Selectable.NOTHING) {
				throw new Error("RNA received illegal product!");
			}
			product_count = count;
			//addEventListener(RunFrameEvent.RUNFRAME, run);
			speed = 2;
			init();
		}
		
		
		
		public override function destruct() {
			p_rib = null;
			removeEventListener(RunFrameEvent.RUNFRAME, waitRib);
			super.destruct();
		}
		
		protected override function autoRadius() {
			setRadius(2);
		}
		
		public function setNAValue(i:int) {
			na_value = i;
		}
		
		public function getNAValue():int {
			return na_value;
		}
		
		protected function waitRib(e:RunFrameEvent) {
			rib_count++;
			if (rib_count > RIB_MAX) {
				rib_count = 0;
				rib_wait = !p_cell.askForRibosome(this); //if it was successful, we are NOT waiting
				if (p_rib) {
					moveToRibosome(p_rib, FLOAT);	//if we have a ribosome, go to it!
					removeEventListener(RunFrameEvent.RUNFRAME, waitRib);
				}
			}
			
		}
		
		/*private function run(e:RunFrameEvent) {
			if (rib_wait) {
				rib_count++;
				if (rib_count > RIB_MAX) {
					rib_count = 0;
					rib_wait = !p_cell.askForRibosome(this); //if it was successful, we are NOT waiting
					if (p_rib) {
						moveToRibosome(p_rib, FLOAT);	//if we have a ribosome, go to it!
					}
				}
			}
		}*/
		
		protected override function stopWhatYouWereDoing(isObj:Boolean) {
			super.stopWhatYouWereDoing(isObj);
			if (!atRibosome) {
				//trace("RNA.stopWhatYouWereDoing()!");
				waitForRibosome();
			}
		}
		
		
		
		public function waitForRibosome() {
			
			rib_wait = true;
			rib_count = 0;
			p_rib = null;
			addEventListener(RunFrameEvent.RUNFRAME, waitRib, false, 0, true);
		}
		
		public function setNPore(p:Point, n:Nucleus, i:int) {
			//trace("RNA.setNPore(" + p + "," + n + "," + i + ")");
			nuc_pore = p;
			p_nucleus = n;
			nuc_pore_index = i;
			p_rib = null;
		}
		
		public function setRibosome(r:Ribosome) {
			p_rib = r;
			p_rib.setRNA(this);
			p_rib.makeBusy();
		}
		
		protected function moveToNucleusPore(method:int) {
		//trace("RNA.moveToNucleusPore!");
			moveToPoint(new Point(p_nucleus.x + nuc_pore.x, p_nucleus.y + nuc_pore.y), method, true);
			
		}
		
		public override function calcMovement() {
			if (nuc_pore) {
				pt_dest.x = p_nucleus.x + nuc_pore.x;
				pt_dest.y = p_nucleus.y + nuc_pore.y;
			}
			super.calcMovement();
		}
		
		protected function moveToRibosome(r:Ribosome, method:int) {
			p_rib = r;
			moveToObject(GameObject(r), method,true);
		}
		
		
		protected override function onArrivePoint() {
			if (nuc_pore) {
				//p_nucleus.getPoreByI();
				p_nucleus.openPore(nuc_pore_index);
				playAnim("infest");
			}
		}
		
		protected override function onArriveObj() {
			if(p_rib){
				dockRNA();
				//show up right over the 
				p_cell.onTopOf(this, p_rib);
			}
			//p_cell.setChildIndex(this, p_cell.getChildIndex(p_rib + 1));
		}
		
		private function dockRNA() {
			playAnim("dock");
			atRibosome = true;
			
			if (p_rib && !p_rib.dying) {
				//p_rib.setRNA(this);
				deliverCheckProduct();
			}else {
				//DESTROY
			}
			
			addEventListener(RunFrameEvent.RUNFRAME, dockWait, false, 0, true);
		}
		
		private function dockWait(r:RunFrameEvent) {
			dock_count++;
			if (dock_count > DOCK_TIME) {
				removeEventListener(RunFrameEvent.RUNFRAME, dockWait);
				dock_count = 0;
				if (p_rib) {
					if (p_rib.getRNA() == this) {
						p_rib.cancelRNA();
					}
					p_rib = null;
				}
				hardRevertAnim();
				rib_wait = true;
			}
		}
		
		public function descend() {
			playAnim("descend");
		}
		
		public function threadRNA(inPlace:Boolean = false) {
			removeEventListener(RunFrameEvent.RUNFRAME, dockWait);
			if (inPlace) {
				playAnim("thread_inplace");
			}else{
				playAnim("thread");
			}
			deliverProduct();
			//atRibosome = true;
		}
		
		public override function playAnim(label:String) {
			if (label == "grow") {
				Director.startSFX(SoundLibrary.SFX_CRACK);
			}
			super.playAnim(label);
		}
		
		public override function onAnimFinish(i:int,stop:Boolean=true) {
			super.onAnimFinish(i,stop);
			gotoAndStop("normal");
			//trace("RNA.onAnimFinish() " + i);
			switch(i) {
				case ANIM_THREAD:
					playAnim("die_thread");
					invincible = true;
					break;
				case ANIM_GROW:
					//trace("RNA.onAnimFinish() p_rib = " + p_rib);
					if(p_rib){
						moveToRibosome(p_rib, FLOAT); 
					}
					break;
				case ANIM_VIRUS_INFEST:
					//invincible = true;
					killMe();
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

		public function mnodeMove(xx:Number, yy:Number) {
			x += xx;
			y += yy;
			if (isMoving) {
				if(pt_dest){
					pt_dest.x += xx;
					pt_dest.y += yy;	
				}
			}
		}
		
		public function getProduct():int {
			return product;
		}

		public function getProductCreator():String{
			return product_creator_id;
		}
		
		public function deliverCheckProduct() {
			p_rib.checkProduct(product); //tell the ribosome to do something
			
			//dying = true;
		}
		
		public function deliverProduct() {
			if(p_rib.getProduct(product,product_count,product_creator_id,product_virus_vesicle)){
				product = NOTHING;
				
			}else {
				throw new Error("RNA could not deliver product " + product + " to Ribosome " + p_rib);
			}
		}
		
		
		
		public function hardKill() {
			//trace("MRNA.hardKill()!");
			hardKillMe();
			//playAnim("hardkill");
		}
		
		private function revertAnim() {
			 gotoAndStop(1);  
			 clip.visible = true;
		}

		protected function hardKillMe() {
			if (product != NOTHING) {
				p_cell.abortProduct(product);
			}
			if (p_rib) { 
				if(!p_rib.dying){
					p_rib.makeFree();
				}
				p_rib = null;
			}
			if (p_cell) {
				p_cell.killRNA(this);	   //kill this RNA
			}		
		}
		
		public function onSlicerKill():Boolean {
			slicer_killed = true;
			if (p_rib) {
				if(p_rib.getRNA() == this){
					p_rib.cancelRNA();
					p_rib.makeFree(); //make it so I can't deliver my product if I'm sliced
					p_rib = null;
					atRibosome = false;
				}
			}
			if(!dying){			  //if I haven't already been killed or haven't finished threading
				if (nuc_pore) {
					p_nucleus = null;
					nuc_pore = null;
					cancelMove();
				}
				return true;
			}else {
				return false;
			}
		}
		
		protected override function killMe() {
			dying = true;
			if (p_rib && atRibosome) { //check to see if I'm actually at my ribosome. If so, deliver my product
				if(!p_rib.dying){
					p_rib.makeFree();
					if (this is EvilRNA || this is EnzymeRNA) {
						if(slicer_killed == false){
							p_rib.finishRNA(true);
						}else {
							if (p_rib.getRNA == null) {
								p_rib.cancelRNA();
							}
							if(p_rib.getRNA() == this){
								p_rib.cancelRNA();
							}
						}
					}else {
						p_rib.finishRNA(false);
					}
					p_rib = null;
				}else {
					p_cell.abortProduct(product); //if the ribosome we're delivering to is dying, don't bother, just cancel this product
				}
			}else if (nuc_pore) {
				if (this is EvilRNA) {
					p_cell.onVirusInfest(product_creator_id, 1);
					p_nucleus.infestByRNA(this);
				}
			}
			if (p_cell) {
				p_cell.killRNA(this);	   //kill this RNA
			}else {
				//trace("myname=" + name + " well shucks p_cell=" + p_cell);
			}
		}
		
		
	}
	
}
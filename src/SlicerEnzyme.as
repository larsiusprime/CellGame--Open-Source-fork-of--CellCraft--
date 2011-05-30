package  
{
	import com.pecSound.SoundLibrary;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class SlicerEnzyme extends BasicUnit
	{
		public var targetRNA:EvilRNA;
		public var hasRNA:Boolean = false;
		public var instant_deploy:Boolean = false;
		public var play_init_sound:Boolean = true;
		
		public var killedSomething:Boolean = false;
		
		private var release_count:int = 0;
		private var release_time:int = 30;
		private var old_spot:Point;
		
		public function SlicerEnzyme() 
		{
			does_recycle = true;
			speed = 3;
			num_id = Selectable.SLICER_ENZYME;
			text_id = "slicer";
			text_title = "Slicer Enzyme";
			text_description = "Destroys viral RNA";
			//list_actions = Vector.<int>([Act.RECYCLE]);
			singleSelect = false;
			canSelect = true;
			setMaxHealth(1, true);
			MAX_COUNT = 5; //recalculate more often for better tracking
			snapToObject = false; //KEEPS EM IN THE MEMBRANE!
		}
		
		protected override function autoRadius() {
			setRadius(25);
		}
		
		public override function init() {
			super.init();
			
			if(play_init_sound)
				Director.startSFX(SoundLibrary.SFX_SLICER_RISE);
			
			slicerDeploy(instant_deploy);
		}
		
		public function targetEvilRNA(e:EvilRNA){
			
			targetRNA = e;
			hasRNA = true;
			targetRNA.addSlicer(this);
			moveToObject(e, GameObject.FLOAT,true);
			/*var c:ColorTransform = this.transform.colorTransform;
			c.redOffset = 255;
			c.blueMultiplier = 0.5;
			c.greenMultiplier = 0.5;
			//c.blueMultiplier = 0;
			//c.greenMultiplier = 0;
			this.transform.colorTransform = c;*/
			//addEventListener(RunFrameEvent.RUNFRAME,
		}
		
		public function releaseByRNA(r:EvilRNA) {
			if (targetRNA == r) {
				releaseRNA();
			}
		}
		
		protected override function arriveObject(wasCancel:Boolean=false) {
			if(go_dest && hasRNA){ //AVOID BUG WHERE SLICERS RESET TO (0,0) when their RNA target disappears
				x = go_dest.x;
				y = go_dest.y;
			}
			if(!wasCancel){
				onArriveObj();
			}
			removeEventListener(RunFrameEvent.RUNFRAME, doMoveToGobj);
		}
		
		protected override function stopWhatYouWereDoing(isObj:Boolean) {
			trace("SlicerEnzyme.stopWhatYouWEreDoing()");
			if (isObj) {
				cancelMoveObject();
			}else {
				cancelMovePoint();
			}
			//define rest per subclass
		}
		
		public function releaseRNA() {
			targetRNA = null;
			hasRNA = false;
			/*var c:ColorTransform = this.transform.colorTransform;
			c.redOffset = 0;
			c.blueMultiplier = 1;
			c.greenMultiplier = 1;*/
			//this.transform.colorTransform = c;
			if (isMoving) {
				cancelMove();
				slicerDeploy();
			}
		}
		
		protected override function onArriveObj() {
			//throw new Error("Testing");
			
			
			if(!dying){
				if (hasRNA) {
					if (targetRNA.dying == false && targetRNA.invincible == false) {
						if(targetRNA.onSlicerKill()){
							Director.startSFX(SoundLibrary.SFX_ZLAP);
							targetRNA.cancelMove();
							killedSomething = true;
							targetRNA.playAnim("die");
							useMe();
							releaseRNA();
						}
					}
				}
			}
			
			super.onArriveObj();
			//old_spot = new Point(x, y);
			
			//releaseRNA();
			
			
			//addEventListener(RunFrameEvent.RUNFRAME, releaseWait, false, 0, true);
						
			if (!dying) { //if I survived and it died, go back to waiting
				if (!hasRNA) {
					slicerDeploy();
				}
			}
		}
		
		/*private function releaseWait(r:RunFrameEvent) {
			release_count++;
			if (release_count > release_time) {
				release_count = 0;
				var d2 = (((x - old_spot.x) * (x - old_spot.x)) + ((y - old_spot.y) * (y - old_spot.y)));
				if (d2 < 10) {//MAGIC NUMBER
					removeEventListener(RunFrameEvent.RUNFRAME, releaseWait);
					//releaseRNA();
					slicerDeploy();
					trace("RELEASE SLICER!");
				}
			}
		}*/
		
		public function slicerDeploy(instant:Boolean = false) {
			//trace("SlicerEnzyme.slicerDeploy(" + instant + ")");
			deployCytoplasm(p_cell.c_nucleus.x,p_cell.c_nucleus.y,170,35,true,instant);
		}
		
		protected override function onRecycle() {
			p_cell.onRecycle(this,true,!killedSomething);
		}
		
		private function useMe() {
			playAnim("recycle");
			//trace("SlicerEnzyme.useMe() p_cell=" + p_cell);
		}
		
		/*public override function onAnimFinish(i:int, stop:Boolean = true) {
			switch(i) {
				case ANIM_RECYCLE: trace("SlicerEnzyme.onAnimFinish() KILLME "); p_cell.killSlicerEnzyme(this); break;
			}
			super.onAnimFinish(i, stop);
		}*/
	}
	
}
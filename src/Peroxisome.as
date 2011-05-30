package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecSound.SoundLibrary;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Peroxisome extends BasicUnit
	{
		//private var eat_target:Selectable;
		//private var recycleSelfOnEat:Boolean;
		
		private var targetRadical:FreeRadical;
		public var orderOnDeath:Boolean = false;
		
		public function Peroxisome() 
		{
			text_title = "Peroxisome";
			text_description = "A large vesicle filled with hydrogen peroxide. Neutralizes toxins.";
			text_id = "peroxisome";
			num_id = Selectable.PEROXISOME;
			setMaxHealth(20, true);
			list_actions = Vector.<int>([Act.MOVE, Act.RECYCLE]);
			init();
			speed = 4;
			
			makeGameDataObject();
			doesCollide = true;
		}
		
		/*private function doPop() {
			playAnim("pop");
		}*/
		
		public override function onAnimFinish(i:int,stop:Boolean=true) {
			super.onAnimFinish(i,stop);
			switch(i) {
				case ANIM_GROW: finishGrow();  break;
				//case ANIM_DIGEST_START: eatTheTarget();  break;
				//case ANIM_DIGEST:  finishDigest();  break;
				/*case ANIM_POP: finishPop(); break;
				case ANIM_FUSE: finishFuse(); break;
				case ANIM_BUD: finishBud(); break;*/
				default: break;
			}
		}
		
		public function bud() {
			playAnim("bud");
		}
		
		public function grow() {
			playAnim("grow");
		}
		
		public function setTargetRadical(r:FreeRadical) {
			targetRadical = r;
			moveToObject(r, GameObject.FLOAT, true);
			isBusy = true;
		}
		
		public function finishGrow() {
			deployGolgi();
		}
		
		public function deployGolgi(instant:Boolean = false ) {
			var p:Point = p_cell.getGolgiLoc(); 
			deployCytoplasm(p.x, p.y, 100, 20,true,instant); 
		}
		
		/*protected override function doMoveToGobj(e:Event) {
			super.doMoveToGobj(e);
			if (targetRadical) {
				var dx:Number = x - targetRadical.x;
				var dy:Number = y - targetRadical.y;
				var dist2:Number = (dx * dx) + (dy * dy);
				if (dist2 <= radius2*2) {
					arriveObject();
				}
			}
		}*/
		
		protected override function stopWhatYouWereDoing(isObj:Boolean) {
			isBusy = false;
			super.stopWhatYouWereDoing(isObj);
			//define rest per subclass
		}
		
		public override function cancelMove() {
			targetRadical = null;
			isBusy = false;
			super.cancelMove();
			
		}
		
		protected override function onArriveObj() {
			//throw new Error("Testing");
			if(!dying){
				if (targetRadical) {
					if (targetRadical.dying == false && targetRadical.invincible == false) {
						Director.startSFX(SoundLibrary.SFX_ZLAP);
						targetRadical.cancelMove();
						targetRadical.playAnim("recycle"); // kill the radical
						targetRadical = null;
						isBusy = false;
						p_cell.onAbsorbRadical(this);
						takeDamage(1); //take 1 damage each time you eat a radical. Eventually you'll die
					}else {
						targetRadical = null;
						isBusy = false;
					}
					
				}
			}
			super.onArriveObj();
			
			if (!dying && targetRadical == null) { //if I survived and it died, go back to waiting
				isBusy = false;
			}
			
		}

		public override function takeDamage(n:Number, hardKill:Boolean = false) {
			super.takeDamage(n, hardKill);
			if (health <= 0) {
				orderOnDeath = true;
			}
			updateLook();
		}
		
		private function updateLook() {
			/*var dark:Number = health / maxHealth;
			if (dark < 0.25) dark = 0.25;*/
			var h:Number = health / maxHealth;
			h *= 1.5;
			if (h > 1) h = 1;
			if (h < 0.25) h = 0.25;
			
			var c:ColorTransform = new ColorTransform();
			c.redMultiplier = h;
			c.blueMultiplier = h;
			c.greenMultiplier = h;
			this.transform.colorTransform = c;
		}
		
		/*public function getCircleVolumeV():Number {
			return getCircleVolume() * VOL_V;
		}
		
		public function getCircleVolumeX():Number {
			return getCircleVolume() * VOL_X;
		}*/
		
		/*
		public function finishDigest() {
			isBusy = false;
			rotation = 0;  //return to normal
			if (recycleSelfOnEat) {
				recycleSelfOnEat = false;
				p_cell.startRecycle(this);
				//super.);
			}
		}
		
		public function eatTheTarget() {
			eat_target.onDeath();
			eat_target = null;
		}*/
		
		/*public function fuseWithBigVesicle(b:BigVesicle) {
			if (b) {
				var v:Vector2D = new Vector2D(x - b.x, y - b.y);
				rotation = v.toRotation() * 180 / Math.PI;
				rotation -= 90;
				moveToObject(b, EDGE);
				fuse_target = b;
				isBusy = true;
				return true;
			}
			return false;
		}*/
		
		/*public function eatSomething(s:Selectable):Boolean {
			if (s) {
				var v:Vector2D = new Vector2D(x - s.x, y - s.y);
				rotation = v.toRotation() * 180 / Math.PI; //turn to face it so the engulf animation looks right
				rotation -= 90;							   //offset to make it work
				moveToObject(s, FLOAT);
				eat_target = s;
				p_cell.onTopOf(CellObject(eat_target), CellObject(this),true);
				isBusy = true;
				return true;
			}
			return false;
		}*/
		
		public override function tryRecycle(isOfMany:Boolean=false):Boolean {
			cancelMove();
			isRecycling = true;
			
			return p_cell.bigVesicleRecycleSomething(this);
		}
			
		public override function updateLoc() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			updateGridLoc(xx, yy);
		}
	}
	
}
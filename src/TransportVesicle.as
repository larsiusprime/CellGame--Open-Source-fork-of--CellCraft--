package  
{
	import com.pecSound.SoundLibrary;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class TransportVesicle extends BlankVesicle
	{
		private var mnode:MembraneNode;
		private var myBigVesicle:BigVesicle;
		
		public function TransportVesicle() 
		{
			
		}
		
		public override function onAnimFinish(i:int,stop:Boolean=true) {
			//super.super.onAnimFinish(i,stop);
			var passItUp:Boolean = true;
			switch(i) {
				case GameObject.ANIM_GROW: passItUp = false;  moveToMembrane(); break;
				case GameObject.ANIM_GROW_2: passItUp = false; startFade(); break; 
				case GameObject.ANIM_FADE: onFade(); break;
				//passItUp = false;  moveToMembrane(); break;
				case GameObject.ANIM_ADHERE: passItUp = false; metamorphose(); break;
			}
			if(passItUp){
				super.onAnimFinish(i, stop);
			}
		}
		
		private function onFade() {
			if (myBigVesicle) {
				if (product == MEMBRANE) {
					myBigVesicle.goToMembrane();
				}
			}
			p_cell.killBlankVesicle(this);
		}
		
		public function getProduct():int {
			return product;
		}
		
		public function setBigVesicle(b:BigVesicle) {
			myBigVesicle = b;
		}
		
		private function startFade() {
			playAnim("fade");
			var newRadius:int = 30;//MAGIC NUMBER! OOPS! width / 2;
			if (product == Selectable.MEMBRANE) {
				p_cell.makeMembraneVesicle(this,newRadius);
			}
		}
		
		private function moveToMembrane() {
			mnode = p_cell.c_membrane.findClosestMembraneNode(x, y);
			moveToPoint(new Point(mnode.x,mnode.y),GameObject.FLOAT,true);
		}
		
		protected override function metamorphose() {
			if (product == Selectable.DEFENSIN) {
				p_cell.showShieldSpot(product_amount, x, y);
				Director.startSFX(SoundLibrary.SFX_SHIELD);
				p_cell.c_membrane.addDefensin(product_amount);
				
			}else if (product == Selectable.MEMBRANE) {
				p_cell.makeMembrane(); 
			}else if (product == Selectable.TOXIN) {
				p_cell.fireToxinParticle(x, y);
				//p_cell.makeToxin();
			}
			p_cell.killBlankVesicle(this);
		}
		
		protected override function onArrivePoint() {
			
			if (mnode != null) {
				//playAnim("adhere");
				metamorphose();
			}else {
				
			}
			
		}
		
	}
	
}
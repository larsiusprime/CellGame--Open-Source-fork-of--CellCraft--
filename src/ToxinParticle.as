package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecLevel.EngineEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ToxinParticle extends CellObject
	{
		private var absorbCount:int = 0;
		private const ABSORB_TIME:int = 10;
		
		public var p_canvas:WorldCanvas;
		
		private var scaleSpeed:Number = .066;
		private var theScale:Number = 1;
		private var MAX_SCALE:Number = 3;
		
		public function ToxinParticle() 
		{
			singleSelect = true;
			canSelect = false;
			does_recycle = false;
			
			//canSelect = false;
			text_title = "Toxin Particle";
			text_description = "It's a toxin particle!";
			text_id = "toxin_particle";
			num_id = Selectable.TOXIN_PARTICLE;
			bestColors = [1, 0, 0];
			//list_actions = Vector.<int>();
			setMaxHealth(250, true);
			init();
			
			speed = 3;
		}
		
		public function setCanvas(c:WorldCanvas) {
			p_canvas = c;
		}
		
		protected override function autoRadius() {
			setRadius(25);
		}
		
		public function getOuttaHere() {
			
			var v:Vector2D = new Vector2D(x-cent_x, y-cent_y);
			v.normalize();
			x += v.x * 45; //shove to outside the membrane
			y += v.y * 45;
			
			v.multiply(p_canvas.getBoundary() * 1.5);
			
			moveToPoint(new Point(cent_x+v.x,cent_y+v.y),FLOAT,true);
			addEventListener(RunFrameEvent.RUNFRAME, checkAbsorb, false, 0, true);
		}
		
		private function checkAbsorb(r:RunFrameEvent) {
			
			theScale += scaleSpeed;
			scaleX = theScale;
			scaleY = theScale;
			
			var fade:Number = ((theScale-1) / MAX_SCALE);
			alpha = 1.0 - fade;
			//trace("fade = " + fade);
			
			if (theScale >= MAX_SCALE) {
				p_cell.makeToxin(x, y);
				p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "toxin_escape","null", 1);
				cancelMove();
				removeEventListener(RunFrameEvent.RUNFRAME, checkAbsorb);
				p_cell.killToxinParticle(this);
			}
			//alpha = theScale / MAX_SCALE;
			//if (absorbCount > ABSORB_TIME) {
				//absorbCount = 0;
				/*if (p_canvas.checkAbsorbCellObject(this,false)) {
					
					p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "toxin_escape","null", 1);
					cancelMove();
					removeEventListener(RunFrameEvent.RUNFRAME, checkAbsorb);
					
					p_cell.killToxinParticle(this);
				}*/
			//}
		}
				
		
		
	}
	
}
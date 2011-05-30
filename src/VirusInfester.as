package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecLevel.EngineEvent;
	import com.pecSound.SoundInfo;
	import com.pecSound.SoundLibrary;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class VirusInfester extends Virus
	{
		public static const RNA_COUNT:Number = 5;
		public static const SPAWN_COUNT:Number = 2;
		
		
		private const RNA_DISTANCE:Number = 5;
		
		public function VirusInfester() 
		{
			singleSelect = false;
			canSelect = false;
			text_title = "Infester Virus";
			text_description = "Invades your membrane and infests the Nucleus!";
			text_id = "virus_infester";
			num_id = Selectable.VIRUS_INFESTER;
			setMaxHealth(10, true);
			rnaCount = RNA_COUNT;
			spawnCount = SPAWN_COUNT;
			speed = 8;
		}
		
		protected override function whatsMyMotivation() {
			motivation_state = MOT_INFESTING_CELL;
		}
		
		protected function doNucleusThing() {
			if (!isDoomed && !dying) {

				var vec2:Vector2D = new Vector2D(x - cent_x, y - cent_y);
				vec2 = vec2.getNormalized();
				vec2.multiply(INJECT_DISTANCE);
				Director.startSFX(SoundLibrary.SFX_VIRUS_INFECT);
				var theRot:Number = (Math.PI * 2) / RNA_COUNT;
				for (var i:int = 0; i < RNA_COUNT; i++) {
					
					p_cell.generateVirusRNA(this, num_id, 1, SPAWN_COUNT, x + vec2.x, y + vec2.y, 0,true,true);
				}
				playAnim("fade"); //killMe
			}
		}
		
		protected override function doRibosomeThing() {
			if(!isDoomed && !dying){
				var vec:Vector2D = new Vector2D(RNA_DISTANCE, 0);
				var vec2:Vector2D = new Vector2D(x - cent_x, y - cent_y);
				vec2 = vec2.getNormalized();
				vec2.multiply(INJECT_DISTANCE);
				Director.startSFX(SoundLibrary.SFX_VIRUS_INFECT);
				var theRot:Number = (Math.PI * 2) / RNA_COUNT;
				for (var i:int = 0; i < RNA_COUNT; i++) {
					vec.rotateVector(theRot);
					p_cell.generateVirusRNA(this, num_id, 1, SPAWN_COUNT, x + vec.x+vec2.x, y + vec.y+vec2.y, 0,true);
				}
				playAnim("fade"); //killMe
			}
		}
		
		public override function calcMovement() {
		
			if (nuc) {
				pt_dest.x = (nuc.x + nuc_node.x);
				pt_dest.y = (nuc.y + nuc_node.y);
				var v:Vector2D = new Vector2D(pt_dest.x - x, pt_dest.y - y);
				var ang:Number = (v.toRotation() / (Math.PI * 2)) * 360;//(v.toRotation() * 180) / Math.PI;
				
				if(condition_state == CON_MOVE_TO_NUCLEUS){
					rotation = ang - 90;
				}
			}
			super.calcMovement();
		}
		
		protected override function onArrivePoint() {
			super.onArrivePoint();
			if(!isDoomed){
				if (position_state == POS_INSIDE_CELL) {
					if(nuc_node){
						doNucleusThing();
					}
				}
			}
		}
		
		protected override function onInvade(doDamage:Boolean=true) {
			//trace("VirusInfester.onInvade()");
			mnode = null;
			cancelMove(); //just to be sure
			if (!isNeutralized && doDamage) {
				p_cell.c_membrane.takeDamageAt(x, y, DMG_PIERCE_MEMBRANE);
				p_cell.notifyOHandler(EngineEvent.ENGINE_TRIGGER, "virus_entry_wound", wave_id, 1);
			}
			
			removeEventListener(RunFrameEvent.RUNFRAME, clingCell);
			
			entering = false;
			removeEventListener(RunFrameEvent.RUNFRAME, tryEnter);
			
			leaving = false;
			
			insideCell();
			
			condition_state = CON_MOVE_TO_RIBOSOME;
			nuc = p_cell.c_nucleus;
			var a:Array = (p_cell.getNucleusPore());
			nuc_node = Point(a[0]);
			if (nuc) {
				moveToPoint(new Point(nuc.x + nuc_node.x, nuc.y+nuc_node.y), FLOAT, true);
			}
			/*rib = p_cell.findClosestRibosome(x, y,true);
			
			if (rib) {
				moveToObject(rib, FLOAT, true);
			}else {
			}*/
		}
		
		/*public override function onAnimFinish(i:int, stop:Boolean = true) {
			super.onAnimFinish(i,stop);
			switch(i) {
				case ANIM_GROW: onGrow(); break;
				case ANIM_LAND: onLand(); break;
				case ANIM_INVADE: onInvade(); break;// onInvadeInfest(); break;
				case ANIM_FADE:
				case ANIM_DIE:  p_cell.killVirus(this); break;
				case ANIM_EXIT: onExit();  super.onAnimFinish(i, stop); break;
			}
		}*/
		
		protected override function touchingCell() {
			
			releaseLyso();
			removeEventListener(RunFrameEvent.RUNFRAME, tauntCell);
			position_state = POS_TOUCHING_CELL;
			//this.transform.colorTransform = new ColorTransform(1,1,1,1, 0,0,0,0);
		}
		
		protected override function insideCell() {
			speed = inside_speed;
			addEventListener(RunFrameEvent.RUNFRAME, tauntCell, false, 0, true);
			position_state = POS_INSIDE_CELL;
			//this.transform.colorTransform = new ColorTransform(1,1,1,1, 32,32,32,0);
		}
		
		protected override function outsideCell() {
			position_state = POS_OUTSIDE_CELL;
			//this.transform.colorTransform = new ColorTransform(0.75, 0.75, 0.75, 1, 0, 0, 0, 0);
		}
		
		protected override function onTouchCellAnim() {
			playAnim("invade");
		}
		
		protected override function doLandThing() {
			mnode = null;
			playAnim("invade"); //invade the membrane
		}
		
		protected override function tauntCell(r:RunFrameEvent) {
			tauntCount++;
			if (tauntCount > TAUNT_TIME) {
				tauntCount = 0;
				p_cell.tauntByVirus(this);
			}
		}
	}
	
}
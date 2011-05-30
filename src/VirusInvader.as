package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecSound.SoundInfo;
	import com.pecSound.SoundLibrary;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class VirusInvader extends Virus
	{
		public static const RNA_COUNT:Number = 4;
		public static const SPAWN_COUNT:Number = 1;
		
		
		private const RNA_DISTANCE:Number = 5;
		
		public function VirusInvader() 
		{
			singleSelect = false;
			canSelect = false;
			text_title = "Invader Virus";
			text_description = "Invades your membrane and deposits RNA!";
			text_id = "virus_invader";
			num_id = Selectable.VIRUS_INVADER;
			setMaxHealth(10, true);
			rnaCount = RNA_COUNT;
			spawnCount = SPAWN_COUNT;
			speed = 6;
		}
		
		protected override function whatsMyMotivation() {
			motivation_state = MOT_INVADING_CELL;
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
		

		
		protected override function touchingCell() {
			//trace("TOUCHING CELL GO W
			releaseLyso();
			removeEventListener(RunFrameEvent.RUNFRAME, tauntCell);
			position_state = POS_TOUCHING_CELL;
			//this.transform.colorTransform = new ColorTransform(0.75,0.75,0.75,1, 0,0,0,0);
		}
		
		protected override function insideCell() {
			speed = inside_speed;
			addEventListener(RunFrameEvent.RUNFRAME, tauntCell, false, 0, true);
			position_state = POS_INSIDE_CELL;
			//this.transform.colorTransform = new ColorTransform(1,1,1,1, 0,0,0,0);
		}
		
		protected override function outsideCell() {
			removeEventListener(RunFrameEvent.RUNFRAME, tauntCell);
			position_state = POS_OUTSIDE_CELL;
			//this.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0, 0, 0, 0);
		}
		
		protected override function onTouchCellAnim() {
			playAnim("invade");
		}
		
		protected override function doLandThing() {
			mnode = null;
			playAnim("invade"); //invade the membrane
		}
		
		protected override function onInvade(doDamage:Boolean=true) {
			super.onInvade();
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
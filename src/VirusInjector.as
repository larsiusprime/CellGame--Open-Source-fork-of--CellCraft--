package  
{
	import com.cheezeworld.math.Vector2D;
	import com.pecSound.SoundLibrary;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class VirusInjector extends Virus
	{
		public static const RNA_COUNT:Number = 1;
		public static const SPAWN_COUNT:Number = 2; 
		
		public function VirusInjector() 
		{
			singleSelect = false;
			canSelect = false;
			text_title = "Injector Virus";
			text_description = "Injects RNA into your membrane!";
			text_id = "virus_injector";
			num_id = Selectable.VIRUS_INJECTOR;
			setMaxHealth(10, true);
			rnaCount = RNA_COUNT;
			spawnCount = SPAWN_COUNT;
			speed = 6;
		}
		
		protected override function whatsMyMotivation() {
			motivation_state = MOT_INJECTING_CELL;
		}
		
		
		protected override function insideCell() {
			speed = inside_speed;
			addEventListener(RunFrameEvent.RUNFRAME, tauntCell, false, 0, true);
			position_state = POS_INSIDE_CELL;
			//this.transform.colorTransform = new ColorTransform(1,1,1,1, 0,0,0,0);
		}
		
		protected override function doLandThing() {
			var vec:Vector2D = new Vector2D(x - cent_x, y - cent_y);
			vec.normalize();
			vec.multiply(INJECT_DISTANCE);
			//trace("Virus.onLand()"+vec);
			Director.startSFX(SoundLibrary.SFX_VIRUS_INFECT);
			p_cell.generateVirusRNA(this, num_id, rnaCount, spawnCount, x+vec.x, y+vec.y, 0);
			playAnim("fade"); //kill me
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
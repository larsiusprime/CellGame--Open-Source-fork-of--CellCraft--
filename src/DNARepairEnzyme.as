package  
{
	import com.pecSound.SoundLibrary;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class DNARepairEnzyme extends BasicUnit
	{
		public var goingNucleus:Boolean = false;
		private const HEAL_VALUE:int = 5;
		
		public function DNARepairEnzyme() 
		{
			does_recycle = true;
			speed = 2;
			num_id = Selectable.DNAREPAIR;
			text_id = "dnarepair";
			text_title = "DNA Repair Enzyme";
			text_description = "Repairs the Nucleus' DNA";
			//list_actions = Vector.<int>([Act.RECYCLE]);
			//singleSelect = false;
			canSelect = true;
			setMaxHealth(1, true);
			MAX_COUNT = 5; //recalculate more often for better tracking
			
		}
		
		public override function init() {
			super.init();
			Director.startSFX(SoundLibrary.SFX_REPAIR_RISE);
			tryGoNucleus();
			//repairDeploy();
		}
		
		protected override function onRecycle() {
			p_cell.onRecycle(this,true,false);
		}
		
		protected override function onArrivePoint() {
			super.onArrivePoint();
			if (!dying) {
				if (goingNucleus == false) {
					tryGoNucleus();
				}
			}
		}
		
		protected override function onArriveObj() {
			//throw new Error("Testing");
			if (!dying) {
				if (goingNucleus == false) {
					tryGoNucleus();
				}else {
					if (p_cell.c_nucleus) {
						Director.startSFX(SoundLibrary.SFX_HEAL);
						p_cell.c_nucleus.healDNA(HEAL_VALUE);
						//p_cell.c_nucleus.(HEAL_VALUE);
						p_cell.onHealSomething(p_cell.c_nucleus, HEAL_VALUE);
						p_cell.showHealSpot(HEAL_VALUE, x, y);
						goingNucleus = false;
						useMe();
					}
				}
			}
			super.onArriveObj();
			
			if (!dying && !goingNucleus) { //if I survived and it died, go back to waiting
				repairDeploy();
			}
		}
		
		public function tryGoNucleus() {
			if (p_cell.getNucleusDamage() > 0 || p_cell.getNucleusInfestation() > 0) {
				goingNucleus = true;
				moveToObject(p_cell.c_nucleus, GameObject.FLOAT,true);
			}
		}
		
		public function repairDeploy() {
			//deployCytoplasm(p_cell.c_nucleus.x,p_cell.c_nucleus.y,170,35);
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
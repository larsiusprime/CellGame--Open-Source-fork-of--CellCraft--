package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class EvilDNA extends EvilRNA
	{
		
		public function EvilDNA(i:int,count:int=1,pc_id:String="") 
		{
			super(i, count, pc_id);
			invincible = true;
		}
		
		//evil DNA doesn't taunt the cell and is thus effectively immune to slicers
		protected override function tauntCell(r:RunFrameEvent) { //every second, asks the cell for something to kill it
			/*tauntCount++;
			if (tauntCount > TAUNT_TIME) {
				tauntCount = 0;
				p_cell.tauntByEvilRNA(this);
			}*/
		}
		
	}
	
}
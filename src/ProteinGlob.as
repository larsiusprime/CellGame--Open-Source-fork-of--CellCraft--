package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ProteinGlob extends CellObject
	{
		
		public function ProteinGlob() 
		{
			singleSelect = true;
			//canSelect = false;
			text_title = "Protein Glob";
			text_description = "It's a glob of protein. Recycle it to get lots of Amino Acids!";
			text_id = "protein_glob";
			num_id = Selectable.PROTEIN_GLOB;
			bestColors = [1, 0, 0];
			list_actions = Vector.<int>([Act.MOVE,Act.RECYCLE]);// Act.MAKE_BASALBODY]);
			setMaxHealth(250, true);
			init();
		}
		
		protected override function autoRadius() {
			setRadius(40);
		}
		
		protected override function onRecycle() {
			p_cell.onRecycle(this, true, true);
		}
		
		public override function tryRecycle(oneOfMany:Boolean=false):Boolean {
			//cancelMove();
			isRecycling = true;
			return p_cell.bigVesicleRecycleSomething(this);
		}
		
	}
	
}
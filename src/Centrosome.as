package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Centrosome extends CellObject
	{
		
		public function Centrosome() 
		{
			showSubtleDamage = true;
			singleSelect = true;
			text_title = "Centrosome";
			text_description = "Organizes the cell's cytoskeleton";
			text_id = "centrosome";
			num_id = Selectable.CENTROSOME;
			bestColors = [0, 0, 1];
			//list_actions = Vector.<int>([]);// Act.MAKE_BASALBODY]);
			setMaxHealth(250, true);
			init();
		}
		
		protected override function autoRadius() {
			setRadius(35);
		}

		
		
		public override function getPpodContract(xx:Number, yy:Number) {
			x -= xx;
			y -= yy;
			p_cell.getPpodContract(xx, yy);
		}
		
	}
	
}
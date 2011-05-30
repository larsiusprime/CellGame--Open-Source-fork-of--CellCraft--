package  
{
	import SWFStatsTest.*;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Mitochondrion extends ProducerObject
	{
		public function Mitochondrion() 
		{
			showSubtleDamage = true;
			singleSelect = true;
			text_title = "Mitochondrion";
			text_description = "Consumes Glucose and produces ATP";
			text_id = "mitochondrion";
			num_id = Selectable.MITOCHONDRION;
			setMaxHealth(100, true);
			bestColors = [1, 0, 0];
			list_actions = Vector.<int>([Act.MOVE,Act.DIVIDE,Act.RECYCLE,Act.TOGGLE]); //add recycle later
			does_divide = true;
			
			produce_time = 45;
			produce_counter = Math.random() * produce_time;
			
			
			
			//ATP,NA,AA,FA,G
			_inputs = new Array(0, 0, 0, 0, 1);
			_outputs = new Array(38, 0, 0, 0, 0);
			
			_inputs2 = new Array(0, 0, 0, 1, 0);
			_outputs2 = new Array(108, 0, 0, 0, 0);
			
			allowAlternateBurn = true;
			init();
		}
		
		protected override function doAlternateBurn() {
			if (!p_cell.canAfford(250, 0, 0, 0,0)) { //if we're below 250 ATP, burn that fat!
				super.doAlternateBurn();
			}
			/*if (p_cell.spend(_inputs2, new Point(x, y + (height / 2)), 0.5)) {
				alternateBurn = true;
				playAnim("process");
				checkRadical();
			}*/
		}
		
		protected override function finishDivide() {
			if(Director.STATS_ON){Log.LevelCounterMetric("cell_mitochondrion_divide", Director.level);}
			if(Director.STATS_ON){Log.LevelAverageMetric("cell_mitochondrion_divide",Director.level,1);}
			Cell(parent).placeMitochondrion(this.x + 75 , this.y,false,true,false);
			super.finishDivide();
		}
		
		
	}
	
}
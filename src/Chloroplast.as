package  
{
	import SWFStats.*;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Chloroplast extends ProducerObject
	{
			
		public function Chloroplast() 
		{
			showSubtleDamage = true;
			text_title = "Chloroplast";
			text_description = "Produces Glucose from co2, water, and sunlight";
			text_id = "chloroplast";
			num_id = CHLOROPLAST;
			setMaxHealth(100, true);
			singleSelect = true;
			//list_actions = Vector.<int>([Act.MOVE, Act.DIVIDE, Act.RECYCLE,Act.TOGGLE]);
			does_divide = true;
			
			produce_time = 45;
			_inputs = new Array(0, 0, 0, 0, 0);
			_outputs = new Array(0, 0, 0, 0, 1);
			
			spawn_radical = 1;		  //up to 5 radicals
			chance_radical = 0.25; 	  //much more likely to make a radical than a mitochondrion
			//chance_invincible = 0.05; //1 in 20 chance of producing an invincible radical
			chance_invincible = 0;
			init();
		}
		
		public function setSunlight(s:Number) {
			setEfficiency(s);
			if (efficiency > 0) {
				is_producing = true;
			}else {
				is_producing = false;
			}
		}
		
		protected override function finishDivide() {
			if(Director.STATS_ON){Log.LevelCounterMetric("cell_chloroplast_divide", Director.level);}
			if(Director.STATS_ON){Log.LevelAverageMetric("cell_chloroplast_divide", Director.level, 1);}
			
			Cell(parent).placeChloroplast(this.x + 75 , this.y);
			super.finishDivide();
		}
	}
	
}
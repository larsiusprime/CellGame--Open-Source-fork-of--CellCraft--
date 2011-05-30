package   
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CostPanel extends Sprite
	{
		public var cost1:MiniCost;
		public var cost2:MiniCost;
		public var cost3:MiniCost;
		public var cost4:MiniCost;
		public var cost5:MiniCost;
		
		public var text_move:TextField;
		
		public function CostPanel() 
		{
			text_move.visible = false;
			text_move.text = "";
		}

		
		
		public function showMoveCost(atp:Number) {
			cost1.setType("atp");
			cost1.setAmount(atp);
			cost1.visible = true;
			visible = true;
			var i:int = 2;
			while (i <= 5) {
				var currCost:MiniCost = MiniCost(getChildByName("cost" + i));
				currCost.visible = false;
				currCost.setAmount(0);
				i++;
			}
			text_move.visible = true;
			text_move.text = " per " + String(Costs.getMoveDistInMicrons()) + " microns.";
		}
		
		
		/**
		 * What this function will do is display this cost. Anything costing 0 will not be shown.
		 * So  "10 ATP, 10 NA, 10 FA, 10 AA, 00 G" will omit glucose, 
		 * and "00 ATP, 10 NA, 00 FA, 10 AA, 10 G" will look like : "10 NA, 10 AA"
		 * @param	atp
		 * @param	na
		 * @param	fa
		 * @param	aa
		 * @param	g
		 */
		 
		public function showCost(atp:int, na:int, fa:int, aa:int, g:int, recycleRNA:Boolean = false) {
			text_move.visible = false;
			text_move.text = "";
			visible = true;
			var i:int = 1;
			var s:String = "";
			var amt:int = 0;
			while (i <= 5) {
				var currCost:MiniCost = MiniCost(getChildByName("cost" + i));
				var recycle:Boolean = false;
				if (atp != 0) { s = "atp"; amt = atp; atp = 0; }
				else if (na != 0) { s = "na"; amt = na; na = 0; if (recycleRNA) recycle = true;}
				else if (fa != 0) { s = "aa"; amt = fa; fa = 0; }
				else if (aa != 0) { s = "fa"; amt = aa; aa = 0; }
				else if (g != 0)  { s = "g"; amt = g; g = 0; }
				
				if (s != ""){
					currCost.setType(s); 
					if (amt != 0){
						currCost.setAmount(amt,recycle);
						currCost.visible = true;
					}else {
						currCost.visible = false;
					}
				}else {
					currCost.visible = false;
				}
				s = "";
				amt = 0;
				i++;
			}
		}
		
		public function hide() {
			visible = false;
		}
	}
	
}
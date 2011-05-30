package{

	public class Costs{
	
		//Building things generally costs ATP, AA, and FA.
		//Digesting things ONLY costs ATP, you get back 75% of the other building materials		
		public static const ENTROPY:Number = 0.75;
		
		//You ONLY but positive numbers in the make/sell arrays.
		//This is interpreted in the following ways: 
		//making things always DEBITS the amounts given at face value
		//selling things always CREDITS the amounts given at face value, EXCEPT ATP, which is always debited
		//(an if statement in cost calculations flips this)

		public static const AAX:int = 10;
		
		public static const AA_PER_NA:int = 5*AAX; //1 NA is enough for an RNA to code 5 AA's
		
		public static const MAKE_EVIL_RNA:Array = [0, 0.25, 0, 0, 0];
		public static const SELL_EVIL_RNA:Array = [0, 0.25, 0, 0, 0];
		
		public static const MAKE_RNA:Array = [0, 1, 0, 0, 0];
		public static const SELL_RNA:Array = [0, 1, 0, 0, 0];
		
		public static const MAKE_RIBOSOME:Array = [2,1,1*AAX,0,0]; //ATP,NA,AA,FA,G
		public static const SELL_RIBOSOME:Array = [1,1,1*AAX,0,0]; //ATP,NA,AA,FA,G
			
		public static const MAKE_VESICLE:Array = [10, 0, 1*AAX, 5, 0];
		public static const SELL_VESICLE:Array = [4, 0, 1*AAX, 5, 0];
		
		public static const MAKE_LYSOSOME:Array = [15,0,2.5*AAX,1,0];
		public static const SELL_LYSOSOME:Array = [8,0,2.5*AAX,1,0];
		
		public static const MAKE_PEROXISOME:Array = [50,0,5*AAX,2,0];
		public static const SELL_PEROXISOME:Array = [25,0,5*AAX,2,0];
		
		public static const MAKE_DNAREPAIR:Array = [50, 0, 10*AAX, 0, 0];
		public static const SELL_DNAREPAIR:Array = [50, 0, 10*AAX, 0, 0];
		
		public static const MAKE_SLICER:Array = [5,0,1*AAX,0,0];
		public static const SELL_SLICER:Array = [3,0,1*AAX,0,0];
		
		public static const SELL_PROTEIN_GLOB:Array = [50, 0, 100*AAX, 0, 0];
		
		public static const MITOCHONDRION_DIVIDE:Array = [250, 5, 10*AAX, 25, 10];
		public static const SELL_MITOCHONDRION:Array = [100, 5, 10*AAX, 25, 10];
		
		public static const CHLOROPLAST_DIVIDE:Array = [200, 5, 10*AAX, 25, 10];
		public static const SELL_CHLOROPLAST:Array = [100, 5, 10*AAX, 25, 10];
		
		public static const REWARD_INJECTOR:Array = [0, 0.02, 0.25*AAX, 0.25, 0];
		public static const REWARD_INVADER:Array = [0, 0.025, 0.25*AAX, 0.25, 0];
		public static const REWARD_INFESTER:Array = [0, 0.025, 0.25*AAX, 0.25, 0];
		
		public static const MAKE_VIRUS_INJECTOR:Array = [5, 0, 0, 0, 0];
		public static const SELL_VIRUS_INJECTOR:Array = [2, 0, 0, 0, 0];
		
		public static const MAKE_VIRUS_INVADER:Array = [10, 0, 0, 0, 0];
		public static const SELL_VIRUS_INVADER:Array = [0, 0, 0, 0, 0];
		
		public static const MAKE_VIRUS_INFESTER:Array = [20, 0, 0, 0, 0];
		public static const SELL_VIRUS_INFESTER:Array = [0, 0, 0, 0, 0];
		
		//public static const ER_MAKE_GOLGI:Array = [1000, 0, 250, 250, 250];
		//public static const ER_SELL_MEMBRANE:Array = [100, 0, 5, 5, 0];// [100, 0, 10, 50, 0];
		
		
		
		public static const ER_MAKE_MEMBRANE:Array = [100, 0, 5*AAX, 5, 0];// [100, 0, 10, 50, 0];
		public static const SELL_MEMBRANE:Array = [50, 0, 5*AAX, 5, 0];
		
		public static const SELL_DEFENSIN:Array = [50, 0, 5*AAX, 1, 0];
		public static const ER_MAKE_DEFENSIN:Array = [100, 0, 5*AAX, 1, 0];
		
		public static const MAKE_TOXIN:Array = [50, 0, 2.5	*AAX, 1, 0];
		public static const SELL_TOXIN:Array = [25, 0, 2.5*AAX, 1, 0];
		
		public static const PIXEL_TO_MICRON:Number = 50; //pixels to micron ratio
		public static const MOVE_DISTANCE:Number = PIXEL_TO_MICRON * 10; //how many pixels the below costs get you
		public static const MOVE_DISTANCE2:Number = MOVE_DISTANCE*MOVE_DISTANCE; //to save sqrts
		
		public static const BLEB:Array = [10, 0, 0, 0, 0];
		public static const PSEUDOPOD:Array = [10, 0, 0, 0, 0];
		
		public static const RIBOSOME_MOVE:Number = 1;
		public static const LYSOSOME_MOVE:Number = 2.5;
		public static const PEROXISOME_MOVE:Number = 10;
		public static const SLICER_MOVE:Number = 0.1;
		public static const MITOCHONDRION_MOVE:Number = 50;
		public static const CHLOROPLAST_MOVE:Number = 50;
		public static const FIX_MEMBRANE:Number = 25;
		
		

		
		public function Costs(){
		
		}
		
		/**
		 * Returns an array with the cost of a given action and selectable object. This function is fine for an interface 
		 * query, but DON'T YOU DARE USE THIS IN A LOOP! This function was designed to be cheap and easy, so long as you 
		 * name the costs consistently, it justs work as you add new costs and actions. If you need speed, you'll have 
		 * to write a hack that looks things up more directly.
		 * @param	s
		 * @param	action
		 * @return the cost [atp, na, aa, fa, g]
		 */
		
		public static function getActionCostByIndex(s:Selectable, action:int):Array {
			//IF YOU USE THIS IN A LOOP YOU ARE ASKING FOR IT!
			return Costs[s.getTextID().toUpperCase() + "_" + Act.getS(action).toUpperCase()];
		}
		
		public static function getMoveCostByString(s:String):Number {
			return Costs[s.toUpperCase() + "_MOVE"];
		}
		
		public static function getRecycleCostByString(s:String):Array {
			return Costs["SELL_"+s.toUpperCase()];
		}
		
		public static function getRecycleCostByName(s:Selectable):Array{
			return Costs["SELL_"+s.getTextID().toUpperCase()];
		}
		
		public static function getMoveCostByName(s:Selectable):Number {
			return Costs[s.getTextID().toUpperCase() + "_MOVE"];
		}
		
		public static function getActionCostByName(s:Selectable, actionName:String):Array {
			return Costs[s.getTextID().toUpperCase() + "_" + actionName.toUpperCase()];
		}
	
		public static function getRNACost(a:Array):int {
			var i:int = Math.ceil(a[2] / AA_PER_NA); 
			i *= MAKE_RNA[1];
			return i;
			//if AA = 0, i = 0;
			//if AA = 4, i = 1;
			//if AA = 5, i = 1;
			//if AA = 9, i = 2;
			//if AA = 10, i = 2;
			//if AA = 11, i = 3;
		}
		
		//Lysosomes, peroxisomes, and slicer enzymes need RNA to spawn, so this adds that into the cost
		//You automatically get it back when the RNA degrades, so it's not in the sell price

		public static function getMAKE_TOXIN(i:int = 1):Array {
			var a:Array = MAKE_TOXIN.concat();
			a[1] += getRNACost(a);
			
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMAKE_DEFENSIN(i:int = 1):Array {
			var a:Array = ER_MAKE_DEFENSIN.concat();
			a[1] += getRNACost(a);
			
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMAKE_MEMBRANE(i:int = 1):Array {
			var a:Array = ER_MAKE_MEMBRANE.concat();
			a[1] += getRNACost(a);
			
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMAKE_LYSOSOME(i:int=1):Array {
			var a:Array = MAKE_LYSOSOME.concat();
					
			a[1] += getRNACost(a); //add the NA cost of an RNA
			
			for (var j:int = 0; j < a.length; j++) {	//multiply times i, the number of lysosomes ordered
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMAKE_PEROXISOME(i:int=1):Array {
			var a:Array = MAKE_PEROXISOME.concat();
			a[1] += getRNACost(a);
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMAKE_RIBOSOME(i:int = 1):Array {
			var a:Array = MAKE_RIBOSOME.concat();
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		/*public static function getMAKE_VESICLE():Array {
			var a:Array = MAKE_VESICLE.concat();
			
		}*/
		
		public static function getMAKE_SLICER(i:int=1):Array {
			var a:Array = MAKE_SLICER.concat();
			//a[1] += MAKE_RNA[1];
			a[1] += getRNACost(a);
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMAKE_DNAREPAIR(i:int = 1):Array {
			var a:Array = MAKE_DNAREPAIR.concat();
			//a[1] += MAKE_RNA[1];
			a[1] += getRNACost(a);
			for (var j:int = 0; j < a.length; j++) {
				a[j] *= i;
			}
			return a;
		}
		
		public static function getMoveDistInMicrons():Number {
			return MOVE_DISTANCE / PIXEL_TO_MICRON;
		}
	}

}
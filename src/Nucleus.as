package  
{
	import com.pecLevel.WaveEntry;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Nucleus extends CellObject
	{
		public var loc_nucleolus:Locator;
		public var nclip:NucleusAnim;
		public var splatter:MovieClip;
		
		public var infester:String = "";
		public static var CHECK_INFEST:Boolean = false;
		//private var infestation:Number=0;
		//private var infestation_max:Number = 10;
		
		public function Nucleus() 
		{
			showSubtleDamage = true;
			singleSelect = true;
			text_title = "Nucleus";
			text_description = "Central command structure, produces DNA & RNA";
			text_id = "nucleus";
			num_id = Selectable.NUCLEUS;
			bestColors = [false, true, false];
			list_actions = Vector.<int>([Act.BUY_RIBOSOME,Act.BUY_SLICER,Act.APOPTOSIS,Act.NECROSIS,Act.MITOSIS]);// ([Act.REPAIR, Act.MITOSIS, Act.APOPTOSIS]);
			setMaxHealth(200, true);
			nclip = clip.nclip;
			//clip = MovieClip(nclip);
			CHECK_INFEST = false;
			//p_cell.onNucleusInfest(false);
			init();
		}
		
		protected override function autoRadius() {
			setRadius(75);
		}
		
		public function getNucleolusLoc():Point {
			return new Point(x + loc_nucleolus.x, y + loc_nucleolus.y);
		}
		
		public function getPorePoint(i:int = 0):Array { //returns a pore location with no anim
			var a:Array = nclip.getPorePoint(i);
			return a;
		}
		
		public function getPoreByI(i,type:int = 0):Point {
			var p:Point = nclip.getPoreByI(i, type);
			return p;
		}
		
		public function openPore(i, type:int = 0) {
			nclip.openPore(i, type);
		}
		
		public function healDNA(i:int) {
			if (hasInfestation) {
				infestation -= i;
				if (infestation <= 0) {
					infestation = 0;
					hasInfestation = false;
					CHECK_INFEST = false;
					p_cell.onNucleusInfest(false);
					removeEventListener(RunFrameEvent.RUNFRAME, infestTick, false);
				}
				showInfestation();
			}else {
				giveHealth(i);
			}
		}
		
		public function infestByRNA(r:RNA) {
			
			infester = r.getProductCreator();
			var w:WaveEntry = p_cell.getWave(infester);
						
			if (infestation <= 0) {
				//trace("Nucleus.infestByRNA start INFESTTICK!");
				hasInfestation = true;
				CHECK_INFEST = true;
				p_cell.onNucleusInfest(true);
				addEventListener(RunFrameEvent.RUNFRAME, infestTick, false, 0, true);
			}
			
			infestation += 1;
			if (infestation > max_infestation) {
				infestation = max_infestation;
			}
			
			showInfestation();
			
			callForHelp();
			
			//trace("Nucleus.infestByRNA(r)!!!");
			//makeSplatter(r.x, r.y);
		}
		
		
		public override function takeDamage(n:Number, hardKill:Boolean = false) {
			callForHelp();
			super.takeDamage(n, hardKill);
			if (health <= 0) {
				p_cell.checkNucleusScrewed();
			}
		}
		
		private function callForHelp() {
			p_cell.nucleusCallForHelp();
		}
		
		private function infestTick(r:RunFrameEvent) {
			infest_count++;
			if (infest_count > INFEST_TIME) {
				//trace("Nucleus.infestTime()!");
				infest_count = 0;
				onInfestTick();
			}
		}
		
		private function onInfestTick() {
			//trace("Nucleus.onInfestTick()!");
			var newinfest:Number = infestation / max_infestation * INFEST_MULT;
			
			var w:WaveEntry = p_cell.getWave(infester);
	
			//trace("Nucleus.onInfestTick() w.count " + w.count + "original_count = " + w.original_count+ " newinfest = " + newinfest);
			
			if(w.count <= w.original_count){			
				infest_rate += (newinfest);
			}else {
				/*var diff:Number = (w.count + newinfest) - w.original_count;
				if(newinfest-diff > 0){
					infest_rate += (newinfest - diff)
				}*/
			}
			
			while (infest_rate > 1) {
				//trace("Nucleus.onInfestTick GO BABY GO!");
				infest_rate -= 1;
				p_cell.generateInfestRNA(VIRUS_INFESTER,infester);
				if (isNaN(infest_rate)) {
					infest_rate = 0;
				}
			}
			
		}
		
		public function getInfester():String {
			return infester;
		}
		
		public function showInfestation() {
			//splatter.gotoAndPlay();
			var percent:Number = infestation/max_infestation;
			if (percent <= 0.009) {
				splatter.gotoAndStop("0%");
			}else if (percent <= 0.2) {
				splatter.gotoAndStop("20%");
			}else if (percent <= 0.4) {
				splatter.gotoAndStop("40%");
			}else if (percent <= 0.6) {
				splatter.gotoAndStop("60%");
			}else if (percent <= 0.8) {
				splatter.gotoAndStop("80%");
			}else {
				splatter.gotoAndStop("100%");
			}
			
			//trace("Nucleus.showInfestation()! infestation = " + infestation + " maxinfestation="+ max_infestation + " percent="+percent);
			
			if (selected) {
				p_cell.updateSelected();
			}
			//var percent:Number = (infestation / infestation_max ) * 100;
			
		}
		
		/*private function makeSplatter(x:Number, y:Number) {
			
		}*/
		
		public function getPoreLoc(i:int=0,doOpen:Boolean=false):Point { //returns a pore location and makes it open
			var p:Point = nclip.getPoreLoc(i,doOpen);
			p.x += x;
			p.y += y;
			return p;
		}
		
		public function freePore(i:int=0):Boolean {
			return nclip.freePore(i);
		}
		
		protected override function wiggle(yes:Boolean) {
			cacheAsBitmap = !yes;
			if(clip){
				if (yes) {
					if(clip.nclip)
						clip.nclip.play();
				}else {
					if(clip.nclip)
						clip.nclip.stop();
				}
			}
		}
		
		protected override function showLightDamage() {
			super.showLightDamage();
			nclip.visible = false;
		}
		
		protected override function showHeavyDamage() {
			super.showLightDamage();
			nclip.visible = false;
		}
	}
	
}
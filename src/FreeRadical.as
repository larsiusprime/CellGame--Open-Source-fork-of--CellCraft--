package 
{
	import com.pecSound.SoundLibrary;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class FreeRadical extends CellObject
	{
		private var targetStr:String = "";
		private var targetObj:CellObject;
		private var makerObj:CellObject;
		public var invincible:Boolean = false;
		private var myDamage:Number = 5;
		
		public static var chance_nuc:Number;
		public static var chance_mito:Number;
		public static var chance_lyso:Number;
		public static var chance_chlor:Number;
		public static var chance_slicer:Number;
		public static var chance_perox:Number;
		
		private static const MITO_WEIGHT:Number = 10;
		private static const CHLORO_WEIGHT:Number = 10;
		private static const LYSO_WEIGHT:Number = 2;
		private static const SLICER_WEIGHT:Number = 0.5;
		private static const PEROX_WEIGHT:Number = 1;
		
		private var decelerate:Number = 1 / 30;
		private var minSpeed = 2;
		
		private var tauntCounter:int = 0;
		private var TAUNT_TIME:int = 15;
		
		public function FreeRadical() {
			does_recycle = true;
			speed = 2.5;
			num_id = Selectable.FREE_RADICAL;
			text_id = "freeradical";
			text_title = "Free Radical";
			text_description = "Damages DNA & Organelles!";
			list_actions = Vector.<int>([Act.RECYCLE,Act.DISABLE]);
			//singleSelect = false;
			canSelect = false;
			singleSelect = false;
			
		}
		
		protected override function doMoveToGobj(e:Event) {
			if(speed > minSpeed){
				speed -= decelerate;
			}
			tauntCounter++;
			if (tauntCounter > TAUNT_TIME) {
				tauntCounter = 0;
				if(!invincible){
					p_cell.tauntByRadical(this);
				}
			}
			super.doMoveToGobj(e);
		}
		
		public function setMaker(c:CellObject) {
			makerObj = c;
		}
		
		public override function init() {
			super.init();
			//Director.startSFX(SoundLibrary.SFX_SLICER_RISE);
			//slicerDeploy();
			Director.startSFX(SoundLibrary.SFX_RADICAL_RISE);
			radicalDeploy();
			p_cell.tauntByRadical(this);
		}
		
		public function setTargetStr(t:String) {
			targetStr = t;
		}
		
		public function targetSomething(e:CellObject,goThereNow:Boolean=true){
			targetObj = e;
			if(goThereNow){
				moveToObject(e, GameObject.FLOAT,true);
			}else {
				var p:Point = new Point( (x + cent_x) / 2, (y + cent_y) / 2);
				moveToPoint(p, GameObject.FLOAT, true);
			}
		}
		
		protected override function onArrivePoint() {
			super.onArrivePoint();
			if(targetObj){
				moveToObject(targetObj, GameObject.FLOAT,true);
			}else {
				radicalDeploy();
			}
		}
		
		public override function cancelMove() {
			targetObj = null;
			super.cancelMove();
		}
		
		protected override function onArriveObj() {
				
			if(!dying){
				if (targetObj) {
					if (targetObj.dying == false && targetObj.getHealth() > 0) {
						//Director.startSFX(SoundLibrary.SFX_ZLAP);
						targetObj.takeDamage(myDamage);
						p_cell.onRadicalHit(targetObj);
						p_cell.makeStarburst(x, y);
						//targetRNA.onSlicerKill();
						//targetRNA.cancelMove();
						//targetRNA.playAnim("die");
						//targetRNA = null;
						targetObj = null;
						useMe();
					}else {
						targetObj = null;
						radicalDeploy();
					}
				}
			}
			super.onArriveObj();
			
			if (!dying && targetObj == null) { //if I survived and it died, go back to waiting
				radicalDeploy();
			}
		}
		
		public function radicalDeploy() {
			//deployCytoplasm(p_cell.c_nucleus.x,p_cell.c_nucleus.y,170,35);
			
			var c:CellObject = findRadicalTarget();
			var goThereNow:Boolean = true; //if we are targetting something, go directly there
			if (c == null) {			//if no target was returned, target my maker
				c = makerObj;
				goThereNow = false; 	//if we are targetting the maker, go away then come back
			}
			targetSomething(c, goThereNow);
			//p_cell.tauntByRadical(this);
		}
		
		private function findRadicalTarget():CellObject {
			if (targetStr != "") {
				if (targetStr == "nucleus") {
					c = p_cell.c_nucleus;
				}else if (targetStr == "mitochondrion") {
					c = p_cell.getRandomMito();
				}else if (targetStr == "chloroplast") {
					c = p_cell.getRandomChloro();
				}else if (targetStr == "slicer") {
					c = p_cell.getRandomSlicer();
				}else if (targetStr == "peroxisome") {
					c = p_cell.getRandomPerox();
				}else if (targetStr == "lysosome") {
					c = p_cell.getRandomLyso();
				}else {
					c = null;
				}
			}else{
				var m:Number = Math.random();
				var c:CellObject;
				if (m < chance_nuc) {
					c = p_cell.c_nucleus;
				}else if (m < chance_mito) {
					c = p_cell.getRandomMito();
				}else if (m < chance_chlor) {
					c = p_cell.getRandomChloro();
				}else if (m < chance_slicer) {
					c = p_cell.getRandomSlicer();
				}else if (m < chance_perox) {
					c = p_cell.getRandomPerox();
				}else if (m < chance_lyso) {
					c = p_cell.getRandomLyso();
				}else {
					c = null;
				}
				if ( c == makerObj) { //if we somehow targetted our maker, set it to null so we target ourselves correctly
					c = null;			//fixes instant damage bug
				}
			}
			return c;
		}
		
		private function useMe() {
			playAnim("recycle");
			//trace("SlicerEnzyme.useMe() p_cell=" + p_cell);
		}
		
		public static function updateChances(lm:Number,lc:Number,ls:Number,lp:Number,ll:Number) {
			lm *= MITO_WEIGHT;
			lc *= CHLORO_WEIGHT;
			ls *= SLICER_WEIGHT;
			lp *= PEROX_WEIGHT;
			ll *= LYSO_WEIGHT;
			var chance_total:Number = lm + lc + ls + lp + ll;
			
			var nuc:Number = chance_total / 3; //this makes a 25% of affecting the nucleus, no matter what
			chance_total += nuc;
			
			chance_total *= 1.05; //extra % - will return null
			
			chance_nuc = nuc / chance_total;
			chance_mito = (nuc+lm) / chance_total;
			chance_chlor = (nuc+lm+lc) / chance_total;
			chance_slicer = (nuc+lm+lc+ls) / chance_total;
			chance_perox = (nuc+lm+lc+ls+lp) / chance_total;
			chance_lyso = (nuc + lm + lc + ls + ll) / chance_total;
			
			//trace("FreeRadical.updateChances() total = " + chance_total + " n,m,c,s,p,l=" + chance_nuc + "," + chance_mito + "," + chance_chlor + "," + chance_slicer + "," + chance_perox + "," + chance_lyso);
		}
	}
	
}
package  
{
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Selectable extends GameObject
	{
		public static const NOTHING:int = -1;
		public static const CENTROSOME:int = 0;
		public static const CYTOSKELETON:int = 1;
		public static const MEMBRANE:int = 2;
		public static const NUCLEUS:int = 3;
		public static const _ER:int = 4;
		public static const GOLGI:int = 5;
		public static const CHLOROPLAST:int = 6;
		public static const MITOCHONDRION:int = 7;
		public static const SLICER_ENZYME:int = 8;
		public static const RIBOSOME:int = 9;
		public static const VESICLE:int = 10;
		public static const PEROXISOME:int = 11;
		public static const LYSOSOME:int = 12;
		public static const BIGVESICLE:int = 13;
		public static const PROTEIN_GLOB:int = 14;
		public static const GLYCOGEN:int = 15;
		public static const VIRUS:int = 16;
		public static const VIRUS_INJECTOR:int = 17;
		public static const VIRUS_INVADER:int = 18;
		public static const VIRUS_INFESTER:int = 19;
		public static const DEFENSIN:int = 30;
		public static const FREE_RADICAL:int = 40;
		public static const DNAREPAIR:int = 50;
		public static const HARDPOINT:int = 70;
		public static const TOXIN:int = 90;
		public static const TOXIN_PARTICLE:int = 91;
		
		
		//public static const 
		
		public var isDoomed:Boolean = false; //if you're doomed, you are GOING to die and can't go anywhere
		protected var does_recycle:Boolean = false;
		public var isRecycling:Boolean = false;
		
		protected var canSelect:Boolean = true;		
		protected var singleSelect:Boolean = false; //is this thing selectable with click only, or the grow circle?
		protected var text_title:String = "UNKNOWN";
		protected var text_description:String = "No Data";	
		public var text_id:String = "unknown";	 //public for speed reading purposes
		public var num_id:int = -1;
		protected var bestColors:Array = [false, false, false];
		
		protected var selected:Boolean;
		
		protected var infestation:Number = 0;
		protected var max_infestation:Number = 100;
		protected var hasInfestation:Boolean = false;
		
		protected var infest_count:int = 0;
		protected const INFEST_TIME:int = 30; 
		protected const INFEST_MULT:Number = 5;
		protected var infest_rate:Number = 0.0;
		
		protected var list_actions:Vector.<int>;
		
		public var recycleOfMany:Boolean = false;
		
		public function Selectable() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.CLICK, click);
			list_actions = new Vector.<int>();
			setupActions();
			buttonMode = true;
		}
			
		public override function destruct() {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.CLICK, click);
		}

		public function setActions(v:Vector.<int>) {
			list_actions = v.concat();
		}
		
		public function setupActions() {
			list_actions = Vector.<int>([Act.MOVE, Act.REPAIR, Act.DIVIDE, Act.RECYCLE, Act.POP]);
			//list_actions = Vector.<int>([Act.MOVE, Act.RECYCLE, Act.POP, Act.REPAIR, Act.DIVIDE]);
		}
		
		public function getInfest():Number {
			return infestation;
		}
		
		public function getMaxInfest():Number {
			return max_infestation;
		}
		
		public function getTextTitle():String {
			return text_title;
		}
		
		public function getTextDescription():String {
			return text_description;
		}
		
		public function getTextID():String {
			return text_id;
		}
	
		public function getNumID():int {
			return num_id;
		}

		public function setCanSelect(yes:Boolean) {
			canSelect = yes;
		}
		
		public function getCanSelect():Boolean {
			return canSelect;
		}
		
		public function getSingleSelect():Boolean {
			return singleSelect;
		}

		public function makeDoomed() {
			isDoomed = true;
			doomline();
		}

		public function releaseFromLysosome(l:Lysosome) {
			
		}
		
		public function targetForEating(l:Lysosome=null) {
			makeDoomed();
		}
		
		public override function startGetEaten() {
			if (!isDoomed) {
				cancelMove();
				makeDoomed();
			}
			super.startGetEaten();
		}
		
		public function makeSelected(yes:Boolean) {
			if(canSelect){
				if (yes) {
					selected = true;
					outline();
					//hilight(0.5);
				}else {
					selected = false;
					unOutline();
					//unHilight();
				}
			}
		}
		
		public function isSelected():Boolean {
			return selected;
		}
		
		public function getActionList():Vector.<int> {
			if (!isDoomed) {
				return list_actions.concat();
			}else { 
				return getDoomList();
			}
		}
		
		public function getDoomList():Vector.<int> {
			var v:Vector.<int> = new Vector.<int>;
			v.push(Act.CANCEL_RECYCLE);
			return v;
		}
		
		public function darken() {
			darklight(0.25);
		}
		
		public function undarken() {
			darklight(0);
		}
		
		protected function darklight(amount:Number) {
			var c:ColorTransform = this.transform.colorTransform;
	
			c.redMultiplier = 1 - amount;
			c.greenMultiplier = 1 - amount;
			c.blueMultiplier = 1 - amount;
			
			this.transform.colorTransform = c;
		}
		
		protected function doomline() {
			//I don't know what to do with this
			showBubble("x");
		}
		
		protected function outline() {
			var f:GlowFilter = new GlowFilter(0xFF9900, 1, 3, 3, 3);
			var f1:GlowFilter = new GlowFilter(0xFFFF00, 1, 3, 3, 3);
			var f2:GlowFilter = new GlowFilter(0xFFFFFF, 1, 5, 5, 5);
			this.filters = [f2, f1, f];
		}
		
		protected function unOutline() {
			this.filters = [];
			if (isDoomed) {
				doomline();
			}
		}
		
		protected function hilight(amount:Number) {
			var c:ColorTransform = this.transform.colorTransform;
			if(!bestColors[0]){
				c.redMultiplier = 1 - amount;
			}
			c.redOffset = 255 * amount;
			
			if (!bestColors[1]){
				c.greenMultiplier = 1-amount;
			}
			c.greenOffset = 255 * amount;
			
			if (!bestColors[2]){
				c.blueMultiplier = 1 - amount;
			}
			c.blueOffset = 255 * amount;
			
			this.transform.colorTransform = c;
		}
		
		protected function unHilight() {
			var c:ColorTransform = this.transform.colorTransform;
			c.redMultiplier = 1;
			c.redOffset = 0;
			c.greenMultiplier = 1;
			c.greenOffset = 0;
			c.blueMultiplier = 1;
			c.blueOffset = 0;
			this.transform.colorTransform = c;
		}
		
		protected function mouseDown(m:MouseEvent) {
			if(canSelect){
				if (singleSelect) {
					m.stopPropagation(); //kill the click
				}else {
					
				}
			}
		}
		
		protected function click(m:MouseEvent) {
			if(canSelect){
				if (singleSelect) {
					trace("CLICK!");
				}
			}
		}
		
		public static function countSelectables(vc:Vector.<Selectable>):Array {
			var r:int = 0; //ribosomes
			var l:int = 0; //lysosomes
			var p:int = 0; //peroxisomes
			var v:int = 0; //vesicles
			var se:int = 0; //slier enzymes
			
			var n:int = 0; //number of things
			for each(var item:Selectable in vc) {
				switch(item.getNumID()) {
					case RIBOSOME: r++; break;
					case LYSOSOME: l++; break;
					case PEROXISOME: p++; break;
					case VESICLE: v++; break;
					case SLICER_ENZYME: se++; break;
				}
			}
			if (r > 0) n++;
			if (l > 0) n++;
			if (p > 0) n++;
			if (v > 0) n++;
			if (se > 0) n++;
			return [n, r, l, p, v, se];
		}
		

		
		public function tryRecycle(oneOfMany:Boolean=false):Boolean {
			if (oneOfMany) {
				recycleOfMany = true;
			}
			if (does_recycle && !isRecycling) {
				doRecycle();
				return true;
			}
			return false;
		}
		
		public function doRecycle() {
			cancelMove();
			isRecycling = true;
			playAnim("recycle");
		}
		

		
		public override function moveToObject(o:GameObject, i:int,free:Boolean=false) {
			if (!isDoomed) {
				super.moveToObject(o, i, free);
			}
		}
		
		public function externalMoveToPoint(p:Point, i:int) {
			moveToPoint(p, i);
		}
		
		public override function moveToPoint(p:Point,i:int,free:Boolean=false) {
			if (!isDoomed) {
				super.moveToPoint(p, i, free);
			}
		}
		

	}
	
}
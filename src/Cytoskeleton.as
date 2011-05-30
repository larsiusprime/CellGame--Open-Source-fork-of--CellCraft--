package  
{
	import com.cheezeworld.math.Vector2D;
	import com.woz.WizardOfOz;
	import flash.geom.Point;
	import com.pecSound.SoundLibrary;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Cytoskeleton extends CellObject
	{
		private var skeletonReady:Boolean = false;
		
		private var list_tubes:Vector.<Microtubule>;	   //tubes that hold something
		private var list_tubes_blank:Vector.<Microtubule>; //tubes that are just structural (like for ppoding)
		
		private var list_grav:Vector.<GravPoint>;			//grav points that hold something
		private var list_grav_warble:Vector.<GravPoint>;			//grav points that hold something
		private var list_grav_blank:Vector.<GravPoint>;		//grav points that are just structural (like for ppoding)
		//private var list_grav_warble:Vector.<GravPoint>;
		//
		private var list_circ:Vector.<Number>;
		
		private var p_centrosome:Centrosome;
		private var p_nucleus:Nucleus;
		private var p_membrane:Membrane;
		
		public static const PPOD_RADIUS:Number = 150;
		public static const PPOD_RADIUS2:Number = PPOD_RADIUS * PPOD_RADIUS;
		public static const GRAV_RADIUS:Number = 100;
		public static const GRAV_RADIUS2:Number = GRAV_RADIUS * GRAV_RADIUS;
		public static const PPOD_SPEED:Number = 12;
		public static var SHOW:Boolean = false;
		
		public static var MEM_FRAC:Number = 0.7;
		public static var MEM_WARBLE_FRAC:Number = 1-(0.6);
		public static var MEM_WARBLECIRC_FRAC:Number = 0.7 * 0.8;
		public static var WARBLE_POINTS:int = 6;
		
		public var isPPoding:Boolean = false;
		
		public var cent_radius:Number = 100;
		//public static var CENTRAL_GRAV_RADIUS:Number = 100;
		
		public function Cytoskeleton() 
		{
			visible = false;
			canSelect = false;
			singleSelect = true;
			Microtubule.PPOD_R2 = PPOD_RADIUS2;
		}
		
		public override function init() {
			super.init();
			list_tubes = new Vector.<Microtubule>;
			list_tubes_blank = new Vector.<Microtubule>;
			list_grav = new Vector.<GravPoint>;
			list_grav_blank = new Vector.<GravPoint>;
			list_grav_warble = new Vector.<GravPoint>;
			list_circ = new Vector.<Number>;
			list_circ.length = WARBLE_POINTS * 2;
			list_grav_warble.length = WARBLE_POINTS;
			for (var i:int = 0; i < WARBLE_POINTS; i++) {
				list_grav_warble[i] = new GravPoint(new Point(), null, 1);
			}
			addEventListener(RunFrameEvent.RUNFRAME, run);
		}
		
		public function show() {
			visible = true;
			SHOW = true;
		}
		
		public function hide() {
			visible = false;
			SHOW = false;
		}
		
		public override function destruct() {
			clearGravPoints();
			clearTubes();
			p_centrosome = null;
			p_membrane = null;
			super.destruct();
		}
		
		public function setMembrane(m:Membrane) {
			p_membrane = m;
		}
		
		public function setNucleus(n:Nucleus) {
			p_nucleus = n;
		}
		
		public function setCent(c:Centrosome) {
			p_centrosome = c;
			x = p_centrosome.x;
			y = p_centrosome.y; //line them up*/
		}
		
		public override function doCellMove(xx:Number, yy:Number) {
			for each(var t:Microtubule in list_tubes) {
				t.doCellMove(xx, yy);
			}
			recordGravityPoints();
		}
		
		public function ppodContract(m:Microtubule, xx:Number, yy:Number) {
			//x -= xx;
			//y -= yy;
			/*p_centrosome.x = x;
			p_centrosome.y = y;*/
			for each(var t:Microtubule in list_tubes) {
				t.ppodContract(xx, yy);
			}

			//DO NOT PPOD CONTRACT PPOD TUBES!
			recordGravityPoints();
		}
		
		public function updateTube() {
			//trace("Cytoskeleton.updateTube()");
			recordGravityPoints();
		}
		
		public function finishTube(isBlank:Boolean = true) {
			//trace("Cytoskeleton.finishTube()!");
			var bool:Boolean = true;
			var theList:Vector.<Microtubule>;
			if (isBlank) {
				theList = list_tubes_blank;
			}else {
				theList = list_tubes;
			}
			var length:int = theList.length;
			
			for (var i:int = 0; i < length; i++) {
				if (theList[i].amReady == false) {
					bool = false;
					//trace("Cytsokeleton.finishTube()! list_tubes[" + i + "].amReady= " + list_tubes[i].amReady);
				}else {
					//tubeList[i].showDebugShape();
				}
			}
			skeletonReady = bool;
			//trace("Cytoskeleton.finishTube() skeletonReady = " + skeletonReady);
			if (skeletonReady) {
				//hookUpMicrotubules();
				newWarblePoints();
				recordGravityPoints();
				//trace("Cytoskeleton.finishTube()");
				p_membrane.onSkeletonReady();
			}
		}
		
		function makeNewTube(c:CellObject) {
			var p:Point = new Point(c.x - x, c.y - y);
			var mt:Microtubule = makeMicrotubule(p);
			mt.setObject(c);
			updateAll();
		}
		
		function makeTubes(list:Vector.<CellObject>) {
			//trace("LIST = " + list);
			var length:int = list.length;
			for (var i:int = 0; i < length; i++) {
				var org:CellObject = list[i];
				var p:Point = new Point(org.x - x, org.y - y);
				var mt:Microtubule = makeMicrotubule(p);
				mt.setObject(org);
			}

		}
		
		public function updateAll() {
			recordGravityPoints();
		}
		
		public function onStartPPod() {
			isPPoding = true;
			p_membrane.onStartPPod();
		}
		
		public function onCancelPPod() {
			isPPoding = false;
			p_membrane.onFinishPPod();
		}
		
		public function onFinishPPod() {
			isPPoding = false;
			p_membrane.onFinishPPod();
		}
		
		public function cancelPseudopod() {
			for each(var m:Microtubule in list_tubes_blank) {
				m.cancelPPod();
			}
		}
		
		public function tryPseudopod(x2:Number, y2:Number, cost:Number) {
			p_engine.onPseudopod();
			
			var dx:Number = x2 - p_centrosome.x;
			var dy:Number = y2 - p_centrosome.y;
			var d2:Number = (dx * dx) + (dy * dy);
			
			var overShot:Boolean = false;
			
			if (d2 > WizardOfOz.LENS_RADIUS2) { //test to see if the ppod is beyond our range
				overShot = true;
			}
			
			var v:Vector2D = new Vector2D(dx, dy); //get a vector from the point to the centrosome
			v.normalize(); 						   //make it a unit vector
			v.multiply((cent_radius - (PPOD_RADIUS))); //find the point right near the edge of the membrane
			
			var p:Point = new Point(p_centrosome.x + v.x, p_centrosome.y + v.y);
			var m:Microtubule = makePPodMicrotubule(p);
				
			if (overShot) {  //if we overshot somehow, make us stop short of escaping the lens
				var v2:Vector2D = new Vector2D( dx, dy) //get a vector from the centrosome to the point
				v2.normalize(); 						  //make it a unit vector
				v2.multiply(WizardOfOz.LENS_RADIUS);	  //multiply by the lens radius
				x2 = p_centrosome.x + v2.x;				  //this is our new ppod point
				y2 = p_centrosome.y + v2.y;
			}
			
			m.setObjectSelf(); //the microtubule's cellObject is itself!
			m.setSpeed(PPOD_SPEED);
			m.ppodTo(x2, y2);
			
			Director.startSFX(SoundLibrary.SFX_DRAIN);
			p_cell.spendATP(cost, p, 1, 0, false);
			//recordGravityPoints();
		}
		
		private function makePPodMicrotubule(p:Point):Microtubule {
			var temp:Microtubule = new Microtubule();
			temp.setPoints(new Point(0, 0), p);
			temp.setSkeleton(this);
			temp.isBlank = true;
			addChild(temp);
			list_tubes_blank.push(temp);
			
			temp.instantGrow();
			
			return temp;
		}
		
		private function makeMicrotubule(p:Point):Microtubule {
			var temp:Microtubule = new Microtubule();
			temp.setPoints(new Point(0,0),p);
			temp.setSkeleton(this);
			temp.isBlank = false;
			addChild(temp);
			list_tubes.push(temp);

			temp.instantGrow();
			
			return temp;
		}
		
		public function removeTube(m:Microtubule, isBlank:Boolean = false) {
			
			var i:int = 0;
			var length:int;
			if(!isBlank){
				length = list_tubes.length;
				for (i = 0; i < length; i++) {
					if (list_tubes[i] == m) {
						list_tubes[i].destruct();
						removeChild(m);
						list_tubes.splice(i, 1);
						break;
					}
				}
			}else {
				//trace("Cytoskeleton.removeTube() " + m.name);
				//trace("Cytoskeleton.removeTube() " + list_tubes_blank);
				length = list_tubes_blank.length;
				for (i = 0; i < length; i++) {
					if (list_tubes_blank[i] == m) {
						list_tubes_blank[i].destruct();
						removeChild(m);
						list_tubes_blank.splice(i, 1);
						break;
					}
				}
				//trace("Cytoskeleton.removeTube() after " + list_tubes_blank);
			}

			recordGravityPoints();

		}
		
		public function clearTubes() {
			var length:int = list_tubes.length - 1;
			for (var i:int = length; i >= 0; i--) {
				removeChild(list_tubes[i]);
				list_tubes[i].destruct();
				list_tubes[i] = null;
			}
			list_tubes = null;
			length = list_tubes_blank.length - 1;
			for (i = length; i >= 0; i--) {
				removeChild(list_tubes_blank[i]);
				list_tubes_blank[i].destruct();
				list_tubes_blank[i] = null;
			}
		}
		
		public function getTubes():Vector.<Microtubule> {
			return list_tubes;
		}
		
		public function getBlankTubes():Vector.<Microtubule> {
			return list_tubes_blank;
		}
		
		private function hookUpMicrotubules() {
			
		}
		
		
		private function clearGravPoints() {
			var i:int = 0;
			if(list_grav){
				var length:int = list_grav.length;
				for (i = 0; i < length; i++) {
					list_grav[i].destruct();
					list_grav[i] = null;
				}
				list_grav = new Vector.<GravPoint>;	
			}
			if (list_grav_blank) {
				length = list_grav_blank.length;
				for (i = 0; i < length; i++) {
					list_grav_blank[i].destruct();
					list_grav_blank[i] = null;
				}
				list_grav_blank = new Vector.<GravPoint>;
			}

		}
		
		public function updateGravityPoints(doWarble:Boolean=false) {
			var length:int = list_tubes.length;
			
			for (var j:int = 0; j < length; j++) {			//just do the regular organelles
				var p:Point = list_tubes[j].getTerminus();  //we don't need a new gravity point, just a regular point
				try{
					list_grav[j].x = p.x;					//update the existing gravPoint's location only	
					list_grav[j].y = p.y;
				}catch (e:Error) {
					//trace(e + "list_tubes.length = " + list_tubes.length + " list_grav.length = " + list_grav.length);
				}
			}
			var r:Number = p_membrane.getRadius();
			var count:int = 0;
			for each(var t:Microtubule in list_tubes_blank) {
				var g:GravPoint = t.getGravPoint();
					list_grav_blank[count].x = g.x;
					list_grav_blank[count].y = g.y;
					count++;
			}
			if(doWarble){
				getWarblePoints();
			}
			p_membrane.updateGravPoints(list_grav,list_grav_blank);
		}
		
		/*private function setBlankGravPoint(i:int, xx:Number, yy:Number, r:Number) {
			
			if (list_grav_blank[i]) {
				list_grav_blank[i].x = xx;
				list_grav_blank[i].y = yy;
				list_grav_blank[i].radius = r;
				list_grav_blank[i].radius2 = r * r;
			}else {
				throw new Error("Cytoskeleton.setBlankGravPoint(): index " + i + " out of range " + list_grav.length);
			}
		}
		
		private function setGravPoint(i:int, obj:CellObject, r:Number) {
			if (list_grav[i]) {
				list_grav[i].x = obj.x;
				list_grav[i].y = obj.y;
				list_grav[i].p_obj = obj;
				list_grav[i].radius = r;
				list_grav[i].radius2 = r * r;
			}else {
				throw new Error("Cytoskeleton.setGravPoint(): index " + i + " out of range " + list_grav.length);
			}
		}*/
		
		private function recordGravityPoints() {
			//trace("Cytoskeleton.recordGravityPoints()");
			clearGravPoints();
			
			var length:int = list_tubes.length;
			var j:int = 0;
			var r:Number = GRAV_RADIUS;	
			var rr:Number = p_membrane.getRadius();
			var frac:Number = MEM_FRAC;
			cent_radius = rr*frac;
			for (j = 0; j < length; j++) {
				
				var m:Microtubule;
				var gg:GravPoint;
				if (list_tubes[j].p_obj) {
					var g:GravPoint = list_tubes[j].getGravPoint();
					gg = g.copy();
					if (list_tubes[j].hasCentrosome) {			//Centrosome is a special case
						
						gg.radius = cent_radius;
						gg.radius2 = cent_radius * cent_radius;
						updateCentralGrav();
					}else{
						gg.radius = GRAV_RADIUS;
						gg.radius2 = GRAV_RADIUS2;
					}
					list_grav.push(gg);
				}
			}
			
			
			length = list_tubes_blank.length;
			for (j = 0; j < length; j++) {
				var ggg:GravPoint = list_tubes_blank[j].getGravPoint();
				gg = ggg.copy();				//OMG DON'T you forget to clone data objects : BUGZORS!
				gg.radius = PPOD_RADIUS;
				gg.radius2 = PPOD_RADIUS2;
				list_grav_blank.push(gg);
			}
				
			//getWarblePoints();
			updateGravityPoints(true);
			
			//p_membrane.updateGravPoints(list_grav,list_grav_blank);
		}
		
		public function updateCentralGrav() {
			//CENTRAL_GRAV_RADIUS = cent_radius;
			BasicUnit.updateCGravR2(cent_radius * cent_radius);
		}
		
		public function updateWarbleCircle() {
			//circ:Vector.<Number> = new Vector.<Number>();
	
				var MAX:int = WARBLE_POINTS;
				
				var rr:Number = p_membrane.getRadius()*MEM_WARBLECIRC_FRAC;
				
				var count:int = 0;
				for(var i:Number = 0; i < MAX; i++){
					var xloc:Number = ((Math.cos(i / MAX * Math.PI*2)) * rr);
					var yloc:Number = ((Math.sin(i / MAX * Math.PI*2)) * rr);
					list_circ[count] = xloc;// .push(xloc);
					list_circ[count + 1] = yloc;// .push(yloc);
					count += 2;
					//list_grav.push(new GravPoint(new Point(xloc, yloc), null, r2));
				}
			
		}
		
		private function getWarblePoints() {
			//trace("Cytoskeleton.getWarblePoints() " + list_grav_warble.length);
			if(list_grav_warble){
				for each(var g:GravPoint in list_grav_warble) {
					if (g) {
						var gg:GravPoint = g.copy();
						gg.x += p_centrosome.x;
						gg.y += p_centrosome.y;
						list_grav.push(gg);
					}
				}
			}
			//trace("Cytoskeleton.getWarblePoints after = " + list_grav);
		}
		
		public function newWarblePoints():Vector.<GravPoint> {
			var rr:Number = p_membrane.getRadius();
			//var frac:Number = MEM_FRAC;
			var r2:Number = (WARBLE_POINTS * (MEM_WARBLE_FRAC) * (rr)) / (WARBLE_POINTS);
			return makeWarblePoints(r2);
			
			//trace("Cytoskeleton.newWarblePoints() " + list_grav_warble.length);
		}
		
		public function makeWarblePoints(r2:Number):Vector.<GravPoint> {
			if (list_circ) {
				var xo:Number = 0;// p_centrosome.x;
				var yo:Number = 0;// p_centrosome.y;
				updateWarbleCircle();
				
				var theR:Number = r2;
				var count:int = 0;
				var length:int = list_circ.length;
				for (var i:int = 0; i < length; i += 2) {
					list_grav_warble[count].x = list_circ[i] + xo;
					list_grav_warble[count].y = list_circ[i+1] + yo;
					list_grav_warble[count].radius = theR;
					list_grav_warble[count].radius2 = theR;
					list_grav_warble[count].p_obj = null;
					count++;
					//trace("Cytoskeleton.makeWarblePoints() list_grav_warble[" + count + "]=" + list_grav_warble[count]);
					//list_grav_warble.push(new GravPoint(new Point(list_circ[i]+xo, list_circ[i + 1]+yo), null, theR));
				}
			}
			return list_grav_warble.concat();
			//trace("Cytoskeleton.makeWarblePoints()  " + list_circ + "," + list_grav_warble);
		}
		
		private function run(r:RunFrameEvent) {
			
			for each(var m:Microtubule in list_tubes) {
				m.dispatchEvent(r);
			}
			for each(var mm:Microtubule in list_tubes_blank) {
				mm.dispatchEvent(r);
			}
		}
		
		
	}
	
}
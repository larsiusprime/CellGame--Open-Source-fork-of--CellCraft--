package  
{
	import com.cheezeworld.math.Vector2D;
	import com.woz.WizardOfOz;
	import com.pecSound.SoundLibrary;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class WorldCanvas extends GameObject
	{
		private var p_director:Director;
		private var p_cell:Cell;
//		private var p_engine:Engine;
		private var p_woz:WizardOfOz;
		
		private var lensLoc:Vector2D;
		
		private var lensRadius:Number = 0;
		private var lensRadius2:Number = 0;
		private var boundary:Number = 0;
		private var boundary_close:Number = 0;
		private var boundary_far:Number = 0;
		private var boundary2:Number = 0;
		private var boundary_close_2:Number = 0;
		private var boundary_far_2:Number = 0;
		private var visible_area:Number = 0;
		
		private const BOUND_MULT:Number = 1.5;
		private const BOUND_CLOSE_MULT:Number = 1.01;
		private const BOUND_FAR_MULT:Number = 2.0;
		
		private var list_running:Vector.<CanvasObject>;
		private var list_goodies:Vector.<GoodieGem>;
		private var list_wrappers:Vector.<CanvasWrapperObject>;
		private var list_showMeTheMoney:Vector.<ShowMeTheMoney>;
		
		private var zoom:Number = 1;
		
		public static const LOC_SURROUND:String = "surround";
		public static const LOC_NEARBY:String = "nearby";
		
		public static const MOVE_TOWARDS_CELL:String = "towards_cell";
		public static const MOVE_AWAY_CELL:String = "away_cell";
		
		public var c_cgrid:ObjectGrid;
		//the dimensions of the canvas grid have the be the same as the normal GameObject grid.
		
		public function WorldCanvas() 
		{
			lensLoc = new Vector2D();
		}
		
		public function setDirector(d:Director) {
			p_director = d;
		}

		public function setCell(c:Cell) {
			p_cell = c;
			onCellMove(0,0);
		}
		public function setCGrid(g:ObjectGrid) {
			c_cgrid = g;
		}
		
		//gets this from the WOZ directly
		public function receiveWoz(w:WizardOfOz) {
			p_woz = w;
		}
		
		public function init() {
			//setChildren();
			//makeLists();
			list_running = new Vector.<CanvasObject>;
			list_goodies = new Vector.<GoodieGem>;
			list_wrappers = new Vector.<CanvasWrapperObject>;
			list_showMeTheMoney = new Vector.<ShowMeTheMoney>;
			c_cgrid = new ObjectGrid();
			addEventListener(RunFrameEvent.RUNFRAME, run);
			//addEventListener(MouseEvent.CLICK, click);
		}
		
		public override function destruct() {
			p_director = null;
			p_cell = null;
			//destruct the lists
			super.destruct();
		}
		
		public function run(r:RunFrameEvent) {
			for each(var c:CanvasObject in list_running) {
				c.dispatchEvent(r);
			}
		}
		
		public function getResource(s:String):Number {
			return p_engine.getResource(s);
		}
		
		public function getMaxResource(s:String):Number {
			return p_engine.getMaxResource(s);
		}
		
		public function updateLensSize(r:Number) {
			visible_area = r * r * Math.PI;
			lensRadius = r;
			lensRadius2 = r * r;
			CanvasObject.LENS_RADIUS = r;
			CanvasObject.LENS_RADIUS2 = r * r;
			Microtubule.LENS_R2 = r*r * 0.8;
			boundary = lensRadius * BOUND_MULT;
			boundary_close = lensRadius * BOUND_CLOSE_MULT;
			boundary_far = lensRadius * BOUND_FAR_MULT;
			boundary2 = boundary * boundary;
			boundary_close_2 = boundary_close * boundary_close;
			boundary_far_2 = boundary_far * boundary_far;
			
			
		}

		public function getBoundary():Number {
			return boundary;
		}
		
		
		public function onCellMove(xx:Number,yy:Number) {
			lensLoc.x = p_cell.c_centrosome.x;
			lensLoc.y = p_cell.c_centrosome.y;
			checkBounds();
			for each(var c:CanvasObject in list_running) {
				c.updateLoc();
			}
			for each(var s:ShowMeTheMoney in list_showMeTheMoney) {
				s.x -= xx;
				s.y -= yy;
			}
		}
		
		/**
		 * Like showMeTheMoneyArray(), but doesn't actually give you anything, just shows it
		 * @param	arr
		 * @param	xx
		 * @param	yy
		 */
		
		public function justShowMeTheMoneyArray(arr:Array, xx:Number,yy:Number,speed:Number=1,offset:Number=0,scaleMode:Boolean=true){
			//ATP,NA,AA,FA,G
			var length:int = arr.length;
			var off:int = 0;
			for (var i:int = 0; i < length; i++) {
				var amt:int = arr[i];
				if (amt != 0) {
					var type:String = "";
					switch(i) {
						case 0: type = "atp"; break;
						case 1: type = "na"; break;
						case 2: type = "aa"; break;
						case 3: type = "fa"; break;
						case 4: type = "g"; break;
					}
					//trace("WorldCanvas.justShowMeTheMoneyArray() off=" + (off+offset));
					justShowMeTheMoney(type, amt, xx, yy, speed, off+offset,scaleMode);
					off++;
				}
			}
		}
		
		/**
		 * This function does showMeTheMoney(), but for an array
		 * @param	arr
		 * @param	xx
		 * @param	yy
		 */
		
		public function showMeTheMoneyArray(arr:Array, xx:Number, yy:Number,speed:Number=1) {
			justShowMeTheMoneyArray(arr, xx, yy);
			p_engine.produce(arr);
		}

		public function showShieldBlock(xx:Number, yy:Number) {
			var m:ShowMeTheMoney = new ShowMeTheMoney("shield_block", 0, xx, yy);
			m.matchZoom(zoom);
			m.setCanvas(this);
			list_showMeTheMoney.push(m);
			addChild(m);
			addRunning(m);
		}
		
		/**
		 * This function just shows the little resource icon popup, it doesn't give you anything
		 * @param	type
		 * @param	amt
		 * @param	xx
		 * @param	yy
		 */
		
		public function justShowMeTheMoney(type:String, amt:Number, xx:Number,yy:Number,speed:Number=1,offset:Number=0,scaleMode:Boolean=true) {
			var m:ShowMeTheMoney = new ShowMeTheMoney(type, amt, xx, yy,speed,offset,scaleMode);
			m.matchZoom(zoom);
			m.setCanvas(this);
			list_showMeTheMoney.push(m);
			addChild(m);
			addRunning(m);
		}
		
		/**
		 * This function creates a little resource icon popup and puts the given resource in the bank for you
		 * @param	type
		 * @param	amt
		 * @param	xx
		 * @param	yy
		 */
		
		public function showMeTheMoney(type:String, amt:Number, xx:Number,yy:Number, speed:Number=1,offset:int=0,scaleMode:Boolean=true) {
			justShowMeTheMoney(type, amt, xx, yy,speed,offset,scaleMode);
			p_engine.setResource(type, amt);
		}
		
		public function removeMeTheMoney(s:ShowMeTheMoney) {
			var i:int = 0;
			for each(var ss:ShowMeTheMoney in list_showMeTheMoney) {
				if (s == ss) {
					list_showMeTheMoney.splice(i, 1);
				}
				i++;
			}
			killRunning(s);	
		}

		//p_canvas.spawnObject(id, loc_id, move_type, count, value);
		
		public function spawnObject(id:String, loc_id:String, move_type:String="null", count:Number=0, value:Number=0, distance:Number=0) {
			//var things:Vector.<CanvasObject> = new Vector.<CanvasObject>;
			//trace("WorldCanvas.spawnObject(" + id + "," + loc_id + "," + move_type + "," + count + "," + value + ")");
			var thing:CanvasObject;
			for (var i:Number = 0; i < count; i++){
				thing = makeObjectFromId(id,value);
				if (thing) {
					var loc:Vector2D = makeLocFromId(loc_id, i, count - 1,distance);
					thing.x = loc.x;
					thing.y = loc.y;
					thing.putInGrid();
				}
				if (move_type != "null") {
					moveSpawnObject(thing, move_type);
				}
			}
		}
		
		private function moveSpawnObject(thing:CanvasObject, move_type:String) {
			if (move_type == MOVE_TOWARDS_CELL) {
				thing.moveToObject(p_cell.c_centrosome, GameObject.FLOAT, true);
			}
		}
		
		private function makeLocFromId(id:String,i:Number,i_max:Number,distance:Number=0):Vector2D {
			//var v:Vector2D = new Vector2D(cent_x, cent_y);
			var push:Number = lensRadius*0.25;
			push *= distance;
			var radiusSize:Number = (lensRadius * 1.05) + push; //add some fudge space
			var v:Vector2D = new Vector2D(radiusSize, 0);
			if (id == LOC_NEARBY) {
				v.x = radiusSize;
				v.rotateVector(Math.random() * Math.PI * 2);
			}else if (id == LOC_SURROUND) {
				if(i != 0){
					var rot:Number = i / i_max;
					v.rotateVector(rot * (Math.PI * 2));
				}
			}
			v.x += cent_x;
			v.y += cent_y;
			return v;
		}
		
		private function makeObjectFromId(id:String,value:Number):CanvasObject {
			var type:String;
			if (id.substr(0, 3) == "gem") {
				type = id.substr(4, id.length - 4);
				return makeGoodieGem(type, value);
			}else if (id.substr(0, 3) == "ves") {
				type = id.substr(4, id.length - 4);
				return makeVesicleWrapper(type, value);
			}
			return null;
		}
		
		public function makeVesicleWrapper(type:String, value:Number=0):CanvasWrapperObject {
			//trace("WorldCanvas.makeVesicleWrapper(" + type + "," + value + ")");
			var cw:CanvasWrapperObject = new CanvasWrapperObject();
			cw.setCanvas(this);
			list_wrappers.push(cw);
			addRunning(cw);
			addChild(cw);
			cw.setCell(p_cell);
			cw.makeVesicleObjectFromId(type);
			cw.matchZoom(zoom);
			return cw;
		}

		/*public function makeWrapper(type:String, value:Number = 0):CanvasWrapperObject {
			var cw:CanvasWrapperObject = new CanvasWrapperObject();
			cw.setCanvas(this);
			list_wrappers.push(cw);
			addRunning(cw);
			addChild(cw);
			cw.setCell(p_cell);
			cw.makeNakedObjectFromId(type);
			//cw.matchZoom(zoom);
			return cw;
		}*/
		
		public function encounterVirus(type:String) {
			//trace("WorldCanvas.encounterVirus(" + type + ")");
			
			var size:Number = 40; //magic number, size of virus, fix this later
			var v2:Vector2D = new Vector2D(lensRadius + size, 0);
			v2.rotateVector(Math.random() * 2 * Math.PI);
			
			var v:Virus = p_cell.makeVirus(type,v2.x+cent_x,v2.y+cent_y);
			//trace("virus = " + v + "loc = " + v.x + "," + v.y);
			//trace("cent = " + cent_x + "," + cent_y);
		}
		
		public function encounterGoodieGem(type:String, amt:Number) {
			var size:Number = 50; //MAGIC NUMBER ~ max size of goodie gem
			var v:Vector2D = new Vector2D(lensRadius+size, 0); 
			var rotate:Number = Math.random() * 2 * Math.PI;
			v.rotateVector(rotate);
			var dx:Number = cent_x + v.x;		//do this to guess if it's outside the boundary
			var dy:Number = cent_y + v.y;
			var d2:Number = dx * dx + dy * dy;

			if (d2 > BOUNDARY_R2) {
				//trace("WorldCanvas.encounterGoodieGem() BOUNDARY FAIL v = " + v + "d2 = " + d2 + " boundary = " + BOUNDARY_R2);
			}else {
				var g:GoodieGem = makeGoodieGem(type, amt);
				var size:Number = (g.width > g.height) ? g.width : g.height;
				v = new Vector2D(lensRadius + size, 0);
				v.rotateVector(rotate);	
				g.x = cent_x + v.x;	//do this to get it's real position & stuff
				g.y = cent_y + v.y;

				g.putInGrid();
			}
			//trace("WorldCanvas.encounterGoodieGem()! type=" + type + " amt=" + amt);
		}

		private function makeGoodieGem(type:String, amt:Number):GoodieGem {
			var g:GoodieGem = new GoodieGem(type, amt);
			g.setCanvas(this);
			list_goodies.push(g);
			addRunning(g);
			addChild(g);
			g.matchZoom(zoom);
			return g;
		}
		
		public function killRunning(g:CanvasObject) {
			var i:int = 0;
			for each(var gg:CanvasObject in list_running) {
				if (g == gg) {
					list_running.splice(i, 1);
				}
				i++;
			}
			removeChild(g);
			g.destruct();
			g = null;
		}
		
		public function addRunning(g:CanvasObject) {
			list_running.push(g);
		}
		
		public function onZoomChange(n:Number) {
			zoom = n;
			for each(var g:CanvasObject in list_running) {
				g.matchZoom(zoom);
			}
		}
		
		public function checkBounds() {
			for each(var g:CanvasObject in list_running) {
				var dx:Number = g.x - lensLoc.x;
				var dy:Number = g.y - lensLoc.y;
				var d2:Number = (dx * dx) + (dy * dy);
				if (d2 > boundary_far_2 ){
					if(g is GoodieGem){
						//trace("WorldCanvas.checkBounds() " + g + " is out of bounds!");
						p_woz.absorbGoodieGem(GoodieGem(g).getType());
						killGoodieGem(GoodieGem(g));
					}
				}
			}
		}

		public function checkAbsorbVirus(v:Virus, justKill:Boolean = false):Boolean {
			var dx:Number = v.x - lensLoc.x;
			var dy:Number = v.y - lensLoc.y;
			var d2:Number = (dx * dx) + (dy * dy);
			if (d2 > boundary_close_2) {
				return p_woz.absorbCellObject(v,justKill);
			}
			return false;
		}
		
		//check if we're absorbing a cell object
		public function checkAbsorbCellObject(g:CellObject,justKill:Boolean=false):Boolean{
			var dx:Number = g.x - lensLoc.x;
			var dy:Number = g.y - lensLoc.y;
			var d2:Number = (dx * dx) + (dy * dy);
			if (d2 > boundary2) {
				return p_woz.absorbCellObject(g,justKill);
			}
			return false;
		}
		
		public function onTouchCanvasWrapper(cw:CanvasWrapperObject) {
			//trace("WorldCanvas.onTouchCanvasWrapper() " + cw);
			killCanvasWrapperObject(cw);
		}

		public function showImmediateAlert(s:String) {
			p_engine.showImmediateAlert(s);
		}
		
		public function onCollectGoodieGemAmount(g:GoodieGem,amount:Number) {
			var type:String = g.getType();
			Director.startSFX(SoundLibrary.SFX_COIN);
			showMeTheMoney(type, amount, g.x, g.y,1,0,false); //normal speed, no offset, don't scale it with zoom!
		}
		
		public function onCollectGoodieGem(g:GoodieGem) {
			var type:String = g.getType();
			var amount:Number = g.getAmount();
			Director.startSFX(SoundLibrary.SFX_COIN);
			showMeTheMoney(type, amount, g.x, g.y,1,0,false); //normal speed, no offset, don't scale it with zoom!
			killGoodieGem(g);
		}
		
		private function killCanvasWrapperObject(cw:CanvasWrapperObject) {
			var i:int = 0;
			for each(var cwo:CanvasWrapperObject in list_wrappers) {
				if (cw == cwo) {
					list_wrappers.splice(i, 1);
				}
				i++;
			}
			cw.destruct();
			killRunning(cw);
		}
		
		private function killGoodieGem(g:GoodieGem) {
			var i:int = 0;
			for each(var gg:GoodieGem in list_goodies) {
				if (g == gg) {
					list_goodies.splice(i, 1);
				}
				i++;
			}
			g.destruct();
			killRunning(g);
		}
		
		public function updateCanvasGridLoc(xx:Number,yy:Number) {
			c_cgrid.x = xx;
			c_cgrid.y = yy;
		}
		
		public function updateCanvasGrid(w:int,h:int,wsize:Number, hsize:Number, hardUpdate:Boolean=false) {
			c_cgrid.wipeGrid();
			c_cgrid.makeGrid(w, h, wsize, hsize);
			c_cgrid.displayGrid();
			
			if(hardUpdate){
				for each(var c:CanvasObject in list_running) { //make sure canvas objects don't loose their position on a membrane update
					c.resetLoc();
				}
			}
			
			//just to be safe
			CanvasObject.setCanvasGrid(c_cgrid);
		}
		
		public function showGrid() {
			c_cgrid.displayGrid(true);
			addChild(c_cgrid);
		}
		
		public function hideGrid() {
			if(getChildByName(c_cgrid.name))
				removeChild(c_cgrid);
		}
	}
	
}
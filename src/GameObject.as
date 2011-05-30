package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import com.cheezeworld.math.Vector2D;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class GameObject extends MovieClip implements IGameObject
	{
		private var c_bubble:InfoBubble;
		public var loc_bubble:Locator;
		
		private var pt_bubble:Point;
		
		public var clip:MovieClip;
		public var anim:MovieClip;
		private var radius:Number; //what is your bounding circle, for collision or selection
		public var radius2:Number;
		
		protected var lastDist2:Number; //the distance to the obj last frame
		
		protected var p_world:World;
		protected var p_engine:Engine;
		
		protected var isDamaged:Boolean = false;
		protected var damageLevel:int = 0;
		protected var showSubtleDamage:Boolean = false; //flash intermediate damage anims?
		
		protected var has_health:Boolean=false; //either has health or doesn't
		protected var health:Number; //how much health does it have?
		protected var maxHealth:Number;
		protected var level:int = 0; //does it have an upgrade level?
		protected var maxLevel:int = 3;
		
		public var anim_wiggle:Boolean = true; //trivial animation, stuff we can turn off
		public var anim_vital:Boolean = false; //are we doing a vital animation? (ie, something whose timing matters?)
		
		public static const ANIM_GROW:int = 0;
		public static const ANIM_GROW_2:int = 1;

		
		public static const ANIM_THREAD:int = 10;
		public static const ANIM_DIE:int = 12;
		public static const ANIM_DOCK:int = 13;
		public static const ANIM_PROCESS:int = 14;
		public static const ANIM_PROCESS_INPLACE:int = 15;
		public static const ANIM_HARDKILL:int = 20;
		public static const ANIM_ADHERE:int = 26;
		public static const ANIM_DIGEST:int = 27;
		public static const ANIM_DIGEST_START:int = 28;
		public static const ANIM_RECYCLE:int = 29;
		public static const ANIM_DIVIDE:int = 30;
		public static const ANIM_POP:int = 31;
		public static const ANIM_MERGE:int = 32;
		public static const ANIM_FUSE:int = 33;
		public static const ANIM_DAMAGE1:int = 34;
		public static const ANIM_DAMAGE2:int = 35;
		public static const ANIM_BUD:int = 36;
		public static const ANIM_LAND:int = 37;
		public static const ANIM_FADE:int = 38;
		public static const ANIM_EXIT:int = 39;
		public static const ANIM_VIRUS_GROW:int = 40;
		public static const ANIM_VIRUS_INFEST:int = 41;
		public static const ANIM_INVADE:int = 42;
		
		public static const ANIM_PLOP:int = 50;
		
		private var has_io:Boolean = false;
		
		protected var pt_dest:Point; //destination point
		protected var go_dest:GameObject; //destination game object

		
		private var move_mode:int; 
		public var isMoving:Boolean = false; //for read only - dont get smart ideas
		
		private var move_dist:Number; //how far to move
		public var v_move:Vector2D; //my movement vector
		private var move_count:int = 0; //
		protected var MAX_COUNT:int = 15; //how long between recalcs
		
		public static const FLOAT:int = 0;		//float to destination
		public static const WAYPOINT:int = 1;	//follow waypoints
		public static const EDGE:int = 2; 		//float to edge of destination
		
		public var dying:Boolean = false;
		private var deadTimer:Timer;
		
		protected var speed:Number = 1;
		
		
		private static const boundX:int = 640;
		private static const boundY:int = 480;
		
		protected var grid_x:int = 0;
		protected var grid_y:int = 0;
		protected static var grid_w:Number = 0;
		protected static var grid_h:Number = 0;
		protected static var span_w:Number = 0;
		protected static var span_h:Number = 0;
		protected static var p_grid:ObjectGrid;
		
		public static var cent_x:Number = 0;
		public static var cent_y:Number = 0;
		
		protected static var BOUNDARY_W:Number = 1000;
		protected static var BOUNDARY_H:Number = 1000;
		
		protected static var BOUNDARY_R:Number = 1000;
		protected static var BOUNDARY_R2:Number = 1000 * 1000;
		
		protected var gdata:GameDataObject;
		
		protected var snapToObject:Boolean = true;
		
		include "inc_fastmath.as";
		
		public function GameObject() 
		{
			autoRadius();
			createInfoLoc();
			//makeGameDataObject();
		}
		
		private function createInfoLoc() {
			if (loc_bubble) {	//replace the locator with a data point signifying where the bubble goes
				pt_bubble = new Point(loc_bubble.x, loc_bubble.y);
				removeChild(loc_bubble);
				loc_bubble = null;
			}else {				//just guess
				
				pt_bubble = new Point(0, 0);
			}
		}
		
		public function hasIO():Boolean {
			return has_io;
		}
		
		public function instantSetHealth(i:int) {
			health = i;
			if (health <= 0) {
				health = 0;
				onDamageKill();
			}else if (health < maxHealth * 0.25) {
				if (damageLevel != 2) {
					heavyDamageClip();
				}
			}else if (health < maxHealth * 0.5) {
				if (damageLevel != 1) {
					lightDamageClip();
				}
			}else {
				if (damageLevel != 0) {
					showNoDamage();
				}
			}
		}
		
		public function takeDamage(n:Number,hardKill:Boolean=false) {
			health -= n;
			if (health <= 0) {
				health = 0;
				onDamageKill();
			}else if (health < maxHealth * 0.25) {
				if(damageLevel != 2){
					showHeavyDamage();
				}
			}else if (health < maxHealth * 0.5) {
				if(damageLevel != 1){
					showLightDamage();
				}
			}else {
				if(damageLevel != 0){
					showNoDamage();
				}
			}
		}
		
		protected function bumpBubble() {
			if(c_bubble){
				setChildIndex(c_bubble, numChildren - 1);
			}
		}
		
		protected function showNoDamage() {
			isDamaged = false;
			damageLevel = 0;
			if(clip){
				clip.gotoAndStop("normal");
			}
			bumpBubble();
		}
		
		protected function showLightDamage() {
			if(showSubtleDamage){
				playAnim("damage_1");
			}
			
			lightDamageClip();
		}
		
		protected function showHeavyDamage() {
			if(showSubtleDamage){
				playAnim("damage_2");
			}
			
			heavyDamageClip();
		}

		protected function lightDamageClip() {
			isDamaged = true;
			damageLevel = 1;
			if(clip){
				clip.gotoAndStop("damage_1");
			}
			bumpBubble();
		}
		
		protected function heavyDamageClip() {
			isDamaged = true;
			damageLevel = 2;
			if(clip){
				clip.gotoAndStop("damage_2");
			}
		
			bumpBubble();
		}
		

		
		protected function onDamageKill() { 
			if (!dying) {
				hideBubble();
				onDeath();
				dying = true;
				//trace("GameObject.onDamageKill() " + this + " " + name);
			}
		}
		
		public function getDamageLevel():int {
			return damageLevel;
		}
		
		public function getHealth():int {
			return health;
		}
		
		public function getMaxHealth():int {
			return maxHealth;
		}

		
		
		public function setSpeed(n:Number) {
			speed = n;
		}
		
		public function setLevel(l:int) {
			level = l;
		}
		
		public function getLevel():int {
			return level;
		}
		
		public function getMaxLevel():int {
			return maxLevel;
		}

		public function giveHealth(amt:uint) {			
			health += amt;
			if (health > maxHealth) {
				health = maxHealth;
			}
		}
		
		public function giveMaxHealth() {
			health = maxHealth;
		}
		
		public function setMaxHealth(m:int, fillUp:Boolean) {
			if (m < maxHealth) {
				if (health > m) { //fill DOWN if health was above new maximum
					health = m;
				}
			}
			maxHealth = m;
			if (fillUp) {
				health = maxHealth;
			}
			has_health = true;
		}
		
		public function setWorld(w:World) {
			p_world = w;
		}
		
		public function setEngine(e:Engine) {
			p_engine = e;
		}
		
		public function destruct() {
			p_world = null;
			p_engine = null;
			if(c_bubble){
				removeChild(c_bubble);
				c_bubble = null;
			}
			
		}
		
		protected function autoRadius() {
			var r:Number = width;
			if (height > r) r = height;
			setRadius(r / 2);
		}
		
		public function setRadius(r:Number){
			radius = r;
			radius2 = radius * radius;
		}
		
		public function getRadius():Number {
			return radius;
		}
		
		public function getCircleVolume():Number {
			return Math.PI * (radius * radius);
		}
		
		public function getSphereVolume():Number {
			return (4 / 3) * Math.PI*(radius * radius * radius);
		}
		
		public function getRadius2():Number {
			return radius * radius;
		}
		
		/**
		 * Handles pausing and returning to the correct animation. True pauses the animation, False returns to its
		 * natural state
		 * @param	yes
		 */
		
		public function pauseAnimate(yes:Boolean) {
			if (!yes) {
				//trace("UNPAUSE!");
				if (anim_wiggle) {	
					wiggle(true);
				}else {
					//wiggle(false);
				}
			}
			else {
				//trace("PAUSE!");
				wiggle(false);
			}
		}
		
		protected function wiggle(yes:Boolean) {
			cacheAsBitmap = !yes;
			if(clip){
				if (yes) {
					if(clip.clip)
						clip.clip.play();
				}else {
					if(clip.clip)
						clip.clip.stop();
				}
			}
		}
		
		
		public function animateOn() { //just turn on wiggling
			anim_wiggle = true;
			wiggle(true);
		}
		
		public function animateOff() { //just turn off wiggling
			anim_wiggle = false;
			wiggle(false);
		}
		
		public function playAnim(label:String) {
			//trace("GameObject.playAnim() label = " + label + "me=" + name);
			if (!dying) {	//you are not allowed to start an animation while dying
			
				gotoAndStop(label);
				if(anim)
					anim.stop();
					
				anim_vital = true;
				addEventListener(RunFrameEvent.RUNFRAME, doAnim);
				
				if(clip)
					clip.visible = false;
				
				//if we are playing a death animation, that's the end of me
				if (label == "die" || label == "recycle") {
					killMe();
				}	
			}
		}
		
		protected function doAnim(e:RunFrameEvent) {
			if(anim){
				anim.gotoAndStop(anim.currentFrame + 1);
			}
		}
		
		public function startGetEaten() {
			hideBubble();
			
		}
		
		public function onDeath() {
			cancelMove();
			playAnim("recycle");
			isDamaged = true;
			
		}

		public function kill() {
			cancelMove();
			playAnim("die");
		}
		
		public function onAnimFinish(i:int, stop:Boolean=true) {
			if (!dying) {
				if (stop) {
					hardRevertAnim();
				}
			}
		}
		
		protected function hardRevertAnim() {
			gotoAndStop(1);
			clip.visible = true;
			if (clip.clip)
				clip.clip.gotoAndPlay(1);
			else {
				//trace("GameObject.onAnimFinish() NO clip.clip!" + this.name + " " + this);
			}
			anim_vital = false;
			removeEventListener(RunFrameEvent.RUNFRAME, doAnim);
		}
		
		public function doAction(i:int, params:Object=null):Boolean {
			//trace("Performing action (" + i +")!");
			return true;
		}
		
		public function calcMovement() {
			var v:Vector2D = new Vector2D();
			if(pt_dest){
				v.x = pt_dest.x - x;
				v.y = pt_dest.y - y;
			}else if (go_dest) {
				v.x = go_dest.x - x;
				v.y = go_dest.y - y;
			}
			//move_dist = v.length;
			v.normalize();
			v.multiply(speed);
			v_move = v.copy();
		}
		
		public function getIsMoving():Boolean {
			return isMoving;
		}
		
		public function moveToObject(o:GameObject, i:int,free:Boolean=false) {
			if(!dying){
				go_dest = o;
				
				pt_dest = null;
				move_mode = i;
				isMoving = true;
				calcMovement();
				removeEventListener(RunFrameEvent.RUNFRAME, doMoveToPoint);
				addEventListener(RunFrameEvent.RUNFRAME, doMoveToGobj,false,0,true);
				
			}

		}
		
		public function moveToPoint(p:Point,i:int,free:Boolean=false) {
			pt_dest = p;
			go_dest = null;
			move_mode = i;
			isMoving = true;
			calcMovement();
			removeEventListener(RunFrameEvent.RUNFRAME, doMoveToGobj);
			addEventListener(RunFrameEvent.RUNFRAME, doMoveToPoint,false,0,true);
			
		}
		
		protected function onArrivePoint() {
			isMoving = false;
		}
		
		protected function onArriveObj() {
			isMoving = false;
		}
		
		
		protected function doMoveToPoint(e:Event) {
			x += v_move.x;
			y += v_move.y;
			move_count++;
			if (move_count > MAX_COUNT) {
				move_count = 0;
				calcMovement();
			}
			var x1:Number = x;
			var y1:Number = y;
			var x2:Number = pt_dest.x;
			var y2:Number = pt_dest.y;
			var dist2:Number = (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
			lastDist2 = dist2;
			if (dist2 <= speed*2) {
				arrivePoint();
			}
			updateLoc();

		}
		
		public function cancelMove() {
			cancelMoveObject();
			cancelMovePoint();
		}
		
		protected function cancelMovePoint() {
			if(pt_dest){
				pt_dest.x = x;
				pt_dest.y = y;
				arrivePoint(true);
			}
		}
		
		protected function arrivePoint(wasCancel:Boolean=false) {
			if(!wasCancel){
				onArrivePoint();
				if (pt_dest) {
					x = pt_dest.x;
					y = pt_dest.y;
				}
			}
			isMoving = false;
			/*if (this is Virus) {
				if (Virus(this).entering == false) {
					trace("Virus.arrivePoint leaving()");
				}
				//trace("Virus has arrived");
			}*/
			removeEventListener(RunFrameEvent.RUNFRAME, doMoveToPoint);
		}
		
		public function pushVector(d2:Number, v:Vector2D) {
			var dist:Number = Math.sqrt(d2);
			x += v.x * dist;
			y += v.y * dist;
			updateLoc();
		}
		
		public function push(xx:Number, yy:Number) {
			x += xx;
			y += yy;
			updateLoc();
		}

		protected function doMoveToGobj(e:Event) {
			if (go_dest == null || go_dest.dying) {
				stopWhatYouWereDoing(true);
			}else if(go_dest){
				x += v_move.x;
				y += v_move.y;
				move_count++;
				if (move_count > MAX_COUNT) {
					move_count = 0;
					calcMovement();
				}
				var x1:Number = x;
				var y1:Number = y;
				var x2:Number = go_dest.x;
				var y2:Number = go_dest.y;
				var dist2:Number = (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
				lastDist2 = dist2;
				if(move_mode == FLOAT){
					if (dist2 <= radius2) {
						arriveObject();
					}
				}else if (move_mode == EDGE) {
					if (dist2 <= radius2 + go_dest.getRadius2()) {
						arriveObject();
					}
				}
				updateLoc();
			}
		}

		protected function stopWhatYouWereDoing(isObj:Boolean) {
			if (isObj) {
				cancelMoveObject();
			}else {
				cancelMovePoint();
			}
			//define rest per subclass
		}
		
		protected function cancelMoveObject() {
			arriveObject(true);
		}
		
		protected function arriveObject(wasCancel:Boolean=false) {
			if (!wasCancel) {
				if (move_mode == FLOAT) {
					if (go_dest) {
						if(snapToObject){
							x = go_dest.x;
							y = go_dest.y;
						}
					}
				}
				onArriveObj();
			}
			isMoving = false;
			removeEventListener(RunFrameEvent.RUNFRAME, doMoveToGobj);
		}
		
		protected function killMe() {
			dying = true;
			deadTimer = new Timer(1500, 0);
			addEventListener(TimerEvent.TIMER, onDeadTimer, false, 0, true);
			deadTimer.start();
			//defined per subclass
		}
		
		protected function onDeadTimer(t:TimerEvent) {
			//hard KILL ME
		}

		public static function setBoundaryBox(w:Number, h:Number) {
			BOUNDARY_W = w;
			BOUNDARY_H = h;
		}
		
		public static function setBoundaryRadius(r:Number) {
			//trace("Gameobject.setBoundaryRadius(" + r + ")");
			BOUNDARY_R = r;
			BOUNDARY_R2 = r * r;
		}
		
		public static function setCentLoc(x:Number, y:Number) {
			cent_x = x;
			cent_y = y;
		}
		
		public static function setGrid(g:ObjectGrid){
			grid_w = g.getCellW();
			grid_h = g.getCellH();
			span_w = g.getSpanW();
			span_h = g.getSpanH();
			//trace("gridsize = ("+grid_w+","+grid_h+")");
			p_grid = g;
		}
		
		public function putInGrid() {
			var xx:Number = x - cent_x + span_w / 2;
			var yy:Number = y - cent_y + span_h / 2;
			gdata.x = xx;
			gdata.y = yy;			
			grid_x = int(xx/grid_w);
			grid_y = int(yy / grid_h);
			if (grid_x < 0) grid_x = 0;
			if (grid_y < 0) grid_y = 0;
			if (grid_x >= grid_w) grid_x = grid_w - 1;
			if (grid_y >= grid_h) grid_y = grid_h - 1;
			p_grid.putIn(grid_x, grid_y, gdata);
		}
		
		public function place(xx:Number,yy:Number){
			x = xx;
			y = yy;
			updateLoc();
		}
		
		
		public function makeGameDataObject() {
			gdata = new GameDataObject();
			gdata.setThing(x, y, getRadius(),this, GameObject);
		}
		
		public function getGameDataObject():GameDataObject {
			return gdata;
		}
		
		public function updateLoc() {
			/*var xx:Number = x + span_w / 2;
			var yy:Number = y + span_h / 2;
			
			gdata.x = xx;
			gdata.y = yy;
			
			var old_x:int = grid_x;
			var old_y:int = grid_y;
			grid_x = int(x/grid_w);
			grid_y = int(y/grid_h);
			if((old_x != grid_x) || (old_y != grid_y)){
				p_grid.takeOut(old_x,old_y,this);
				p_grid.putIn(grid_x,grid_y,this);
			}*/
		}
	
		public function matchZoom(n:Number) {
			scaleX = 1 / n;
			scaleY = 1 / n;
		}
		
		
		
		public function updateBubbleZoom(n:Number) {
			if (c_bubble) {
				c_bubble.matchZoom(n);
			}
		}
		
		protected function hideBubble() {
			if (c_bubble) {
				c_bubble.visible = false;
			}
		}
		
		protected function showBubble(s:String) {
			//trace("GameObject.showBubble() " + s);
			if (!c_bubble) {
				c_bubble = new InfoBubble();
				addChild(c_bubble);
				c_bubble.x = pt_bubble.x;
				c_bubble.y = pt_bubble.y;
				c_bubble.matchZoom(World.getZoom());
			}else {
				setChildIndex(c_bubble, numChildren - 1);
			}
			if (c_bubble.visible == false) {
				c_bubble.visible = true;
			}
			c_bubble.setIcon(s);
		}
	}
	
}
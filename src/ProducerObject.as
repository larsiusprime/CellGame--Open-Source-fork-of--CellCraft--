package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ProducerObject extends CellObject
	{
		protected var efficiency:Number = 1;
		protected var produce_time:int = 30; //produces every X frames
		protected const PRODUCE_TIME:int = 30; //produces every X frames
		protected var produce_counter:int = 0; 
		protected var is_producing:Boolean = true;
		
		protected var _inputs:Array;
		protected var _outputs:Array;
		
		protected var allowAlternateBurn:Boolean = false;
		protected var alternateBurn:Boolean = false;
		
		
		
		protected var _inputs2:Array;
		protected var _outputs2:Array;
		
		protected var firstRadical:Boolean = false;
		protected var radicalsOn:Boolean = true;
		protected var count_radical:Number = 0;
		protected var spawn_radical:Number = 0.5; 				//number of radicals to spawn
		
		protected var chance_radical:Number	   =	0.10;		//chance of producing a radical 
		protected var chance_invincible:Number = 	0.00; 	//chance of producing an invincible radical (must be <= chance_radical)
												//it's like a dice roll - roll chance_invincible or less, and we make an invincible radical
												//roll higher than that but below chance_radical, and it's a normal radical
		
		/**
		 * Don't change this externally!
		 */
		private var toggle_on:Boolean = true; 
		private var brown_fat_toggle_on:Boolean = false;
		
		//private var heat_amount:Number = 0;
		private var HEAT_PER_BURN:Number = 0.25;
		
		public static const NOTHING:int = -1;
		public static const ATP:int = 0;
		public static const NA:int = 1;
		public static const FA:int = 2;
		public static const AA:int = 3;
		public static const G:int = 4;
		
		public function ProducerObject() 
		{
			addEventListener(RunFrameEvent.RUNFRAME, produce, false, 0, true);
			setRadicals(Cell.RADICALS_ON);
			makeGameDataObject();
			doesCollide = true;
		}
		
		public override function destruct() {
			removeEventListener(RunFrameEvent.RUNFRAME, produce);
			super.destruct();
		}
		
		protected function setEfficiency(e:Number) {
			efficiency = e;
			produce_time = PRODUCE_TIME / efficiency;
		}
		
		protected function produce(r:RunFrameEvent) {
			if (is_producing && toggle_on) {
				if(!anim_vital && !isDoomed && !isDamaged){		//if we're not in the middle of doing something, like dividing
					produce_counter++;
					if (produce_counter > produce_time) {
						produce_counter = 0;
						if (p_cell.spend(_inputs, new Point(x, y + (height / 3)), 0.5)) {
							playAnim("process");
							if (brown_fat_toggle_on) {
								bumpBubble();
							}
							
							//trace("ProducerObject.produce() this=" + this +" name=" + this.name);
							checkRadical();
						}else if (allowAlternateBurn) {
							doAlternateBurn();

						}
					}
				}
			}
		}
		
		protected function doAlternateBurn() {
			if (p_cell.spend(_inputs2, new Point(x, y + (height / 2)), 0.5)) {
				alternateBurn = true;
				playAnim("process");
				checkRadical();
			}
		}
		
		public override function takeDamage(n:Number,hardKill:Boolean=false) {
			super.takeDamage(n);
			if (health <= 0) {
				if (hardKill) {
					super.onDamageKill(); //lets ProducerObjects  be recycled
				}
			}
		}
		
		protected override function onDamageKill() {
			//do nothing: Producer Objects can't be damagekilled!
		}
		
		public function setRadicals(b:Boolean) {
			radicalsOn = b;
		}
				
		protected function checkRadical() {
			if (radicalsOn) {
				if(firstRadical){ //make it so that they don't produce radicals on the first produce
					var m:Number = Math.random();
					
					count_radical += spawn_radical;
								
					for (var i:int = 0; i < Math.floor(count_radical); i++) {
						var isInvincible:Boolean = (m < chance_invincible);
						p_cell.makeRadical(this, isInvincible);
						count_radical -= 1;
					}
				}else {
					firstRadical = true;
				}
			}
			/*var m:Number = Math.random();
			var critical:Boolean = false;
			if(m > 0){
				if (m < chance_radical) {			//first, check to see if we rolled a radical
					if (m < chance_invincible) {	//next, check to see if we rolled an INVINCIBLE radical
						critical = true;
						//trace("ProducerObject.checkRadical() : INVINCIBLE!");
					}
					//trace("ProducerObject.checkRadical() : Make Free Radical!");
					//var m2:Number = (Math.random() * spawn_radical) + 1; //spawn between 1 and (spawn_radical) radicals
					
					for (var i:int = 0; i < spawn_radical; i++){
						p_cell.makeRadical(this, false); //make the radical
					}
				}
			}*/
		}
		
		protected function finishProcess() {
			if (!alternateBurn) {
				if (brown_fat_toggle_on) {
					p_cell.produceHeat(HEAT_PER_BURN,1, new Point(x, y - (height / 3)), 0.5);
				}else{
					p_cell.produce(_outputs, 1, new Point(x, y - (height / 3)), 0.5);
				}
			}else {
				alternateBurn = false;
				p_cell.produce(_outputs2, 1, new Point(x, y - (height / 3)), 0.5);
			}
		}
		
		public override function onAnimFinish(i:int, stop:Boolean = true) {
			switch(i) {
				case ANIM_PROCESS: finishProcess(); break;
			}
			super.onAnimFinish(i,stop);
		}
		
		public override function doAction(i:int, params:Object = null):Boolean {
			switch(i) {
				case Act.DISABLE:
					setToggle(false);
					return true;
					break;
				case Act.ENABLE:
					setToggle(true);
					return true
					break;
				case Act.DISABLE_BROWN_FAT:
					setBrownFatToggle(false);
					return true;
					break;
				case Act.ENABLE_BROWN_FAT:
					setBrownFatToggle(true);
					return true;
					break;
			}
			return super.doAction(i, params);
		}

		public function getBrownFatToggle():Boolean {
			return brown_fat_toggle_on;
		}
		
		public function getToggle():Boolean {
			return toggle_on;
		}
		
		public function setBrownFatToggle(y:Boolean){
			brown_fat_toggle_on = y;
			/*if (brown_fat_toggle_on) {
				//do stuff
				
			}else {
				//do other stuff
			}*/
			showCorrectBubble();
		}
		
		public function setToggle(y:Boolean) {
			toggle_on = y;
			
			/*if (toggle_on){
				
			}
			else {
				//trace("ProducerObject.setToggle() toggle_on = " + toggle_on + " should show bubble");
			}*/
			showCorrectBubble();
		}
		
		private function showCorrectBubble() {
			if (!toggle_on) {
				showBubble("cancel");
			}else {
				if (brown_fat_toggle_on) {
					showBubble("white_fire");
				}else {
					hideBubble();
				}
			}
		}
		
		public override function unDoom() {
			super.unDoom();
			setToggle(toggle_on); //do this so we show the enabled status even after we undoom it
		}
		
		public function toggle() {
			if (toggle_on) {
				setToggle(false);
			}else {
				setToggle(true);
			}
		}
		
		public override function tryRecycle(isOfMany:Boolean=false):Boolean {
			cancelMove();
			isRecycling = true;
			return p_cell.bigVesicleRecycleSomething(this);
		}
		
		public override function updateLoc() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			updateGridLoc(xx, yy);
		}
		
	}
	
}
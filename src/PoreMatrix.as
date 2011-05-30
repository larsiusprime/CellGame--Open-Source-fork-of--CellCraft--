package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class PoreMatrix extends Sprite
	{
		var ready:Vector.<MovieClip>;
		var busy:Vector.<MovieClip>;
		
		public var pore_01:MovieClip;
		public var pore_02:MovieClip;
		public var pore_03:MovieClip;
		public var pore_04:MovieClip;
		public var pore_05:MovieClip;
		public var pore_06:MovieClip;
		public var pore_07:MovieClip;
		public var pore_08:MovieClip;
		public var pore_09:MovieClip;
		public var pore_10:MovieClip;
		public var pore_11:MovieClip;
		public var pore_12:MovieClip;
		public var pore_13:MovieClip;
		public var pore_14:MovieClip;
		public var pore_15:MovieClip;
		public var pore_16:MovieClip;
		public var pore_17:MovieClip;
		public var pore_18:MovieClip;
		public var pore_19:MovieClip;
		public var pore_20:MovieClip;
		public var pore_21:MovieClip;
		public var pore_22:MovieClip;
		public var pore_23:MovieClip;
		public var pore_24:MovieClip;
		
		public function PoreMatrix() 
		{
			busy = new Vector.<MovieClip>();
			ready = new Vector.<MovieClip>();
			for (var i:int = 0; i < 24; i++) {
				var pore:MovieClip = MovieClip(getChildByName("pore_" + pad(i+1)));
				if(pore){
					ready.push(pore);
				}else {
					trace("Class PoreMatrix: Error creating pore_" + pad(i+1));
				}
			}
		}
		
		private function pad(i:int):String {
			if (i < 10) {
				return "0"+String(i)
			}else
				return String(i);
		}
		
		public function animateFinish() {
			var pore:MovieClip;
			if(busy.length >= 1){
				pore = busy[0]; //get the first pore in the busy array
			}
			if (pore) {
				busy.splice(0, 1); //remove it from the busy array
				ready.push(pore);  //push it onto the ready array
			}
		}
		
		public function getPoreByI(i:int):MovieClip {
			return this["pore_" + pad(i)];
		}
		
		public function openPore(i:int) {
			var p:MovieClip = getPoreByI(i);
			p.gotoAndPlay("open");
		}
		
		public function getPore(doOpen:Boolean=false):MovieClip{
			var n:Number = Math.floor(Math.random() * ready.length);
			var pore:MovieClip;
			if(ready.length != 0){
				pore = ready[n]; 		//get it to return
				ready.splice(n, 1); 				//remove it from the ready array
				busy.push(pore);					//push it onto the busy array
				//trace("pore = " + pore);
				if(doOpen){
					pore.gotoAndPlay("open"); 			//animate it opening
				}
			}else {
				n = Math.floor(Math.random() * busy.length);
				pore = busy[n];
			}
			return pore; //return the pore
			
		}
		
		public function freePore():Boolean {
			if (ready.length > 1) {
				return true;
			}
			return false;
		}
		
	}
	
}
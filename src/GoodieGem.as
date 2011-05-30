package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class GoodieGem extends CanvasObject
	{
		public var text:TextField;
		public var icon:MovieClip;
		public var icon2:MovieClip;
		
		private var type:String;
		private var amount:int;
		
		
		public function GoodieGem(t:String,am:int) 
		{
			type = t;
			amount = am;
			icon.gotoAndStop(type);
			icon2.gotoAndStop(type);
			text.htmlText = "<b>" + am.toString() + "</b>";
			setRadius(25);
		}
		
		public override function destruct() {
			super.destruct();
		}
		
		public function getType():String {
			return type;
		}
		
		public function getAmount():Number {
			return amount;
		}
		
		public override function onTouchCell() {
			if(!dying){
				super.onTouchCell();
				if(p_canvas){
					p_canvas.onCollectGoodieGem(this);
				}
				dying = true;
			}
		}
		
		/**
		 * Where d2 is the square of the distance penetrated, and v is a unit vector in the direction penetrated
		 * @param	d2
		 * @param	v
		 */
		
		public function onTouchCell2(d2:Number,v:Vector2D) {
			//var diff:Number = checkResource();
			onTouchCell();
			/*if (diff <= 0) {					//give all of me. Negative means we have room to spare
				onTouchCell();
			}else if (diff <= amount - 1) { 	//Positive means we have too much. Check for giving partial amount.
				p_canvas.onCollectGoodieGemAmount(this, diff);
				amount -= diff;
				text.htmlText = "<b>" + amount.toString() + "</b>";
				pushAway(d2, v);
			}else {								//We don't have any room
				p_canvas.showImmediateAlert("Can't carry any more " + type.toUpperCase() + "! Fully saturated!");
				pushAway(d2,v);
			}*/
		}
		
		private function checkResource():Number {
			
			var amt:Number = p_canvas.getResource(type);
			var max_amt:Number = p_canvas.getMaxResource(type);
			if(type == "g"){
				return (amt + amount - (max_amt * 2));
			}
			return (amt + amount - (max_amt));
			
			//45 G, 100 max G, get 15 = (45+15) - (100) = 60 - 100 = -40
			//99 G, 100 max G, get 15 = (99+15) - (100) = 114 - 100 = 14
			//85 G, 100 max G, get 15 = (85+15) - (100) = 100 - 100 = 0
			
		}
		
		/**
		 * Where d2 is the square of the distance penetrated, and v is a unit vector in the direction 
		 * @param	d2
		 * @param	v
		 */
		
		private function pushAway(d2:Number, v:Vector2D) {
			var dist:Number = Math.sqrt(d2);
			dist *= 4; //fudge factor to avoid crap
			v.multipliedBy(dist);//if this is a true penetration, should reverse the direction
			x += v.x;
			y += v.y;
		}
		
	}
	
}
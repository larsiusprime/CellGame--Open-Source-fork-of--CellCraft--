package  
{
	import com.cheezeworld.math.Vector2D;
	import fl.controls.NumericStepper;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class GameDataObject 
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var radius2:Number;
		public var id:String;
		public var ptr:*; //pointer to whatever I am
		public var ptr_class:Class; //what class is that thing
		
		public function GameDataObject() 
		{

		}
		
		public function destruct() {

		}
		
		public function setThing(xx:Number, yy:Number, r:Number, thing:Object, c:Class) {
			x = xx;
			y = yy;
			radius = r;
			radius2 = r * r;
			ptr = thing;
			ptr_class = c;
		}
	}
	
}
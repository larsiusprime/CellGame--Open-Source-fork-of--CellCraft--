package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ToggleButtonEvent extends Event
	{
		public static const TOGGLE_ON:String = "ToggleOn";
		public static const TOGGLE_OFF:String = "ToggleOff";
		public var data:*;
		
		public function ToggleButtonEvent(type:String,data:*) 
		{
			this.data = data;
			super(type);
		}
		
		public override function clone():Event {
			var t:ToggleButtonEvent = new ToggleButtonEvent(type, data);
			return t;
		}
		
	}
	
}

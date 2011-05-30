package  
{
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MouseExtendEvent extends MouseEvent
	{
		public static const RELEASE_OUTSIDE:String = "ReleaseOutside";
		public var data:*;
		
		public function MouseExtendEvent(type:String,data:*) 
		{
			this.data = data;
			super(type);
		}
		
		public override function clone():Event {
			var r:MouseExtendEvent = new MouseExtendEvent(type, data);
			return r;
		}
		
	}
	
}

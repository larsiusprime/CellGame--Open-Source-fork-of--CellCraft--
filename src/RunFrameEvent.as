package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class RunFrameEvent extends Event
	{
		public static const RUNFRAME:String = "RunFrame";
		public static const FAUXFRAME:String = "FauxFrame";
		public var data:*;
		
		public function RunFrameEvent(type:String,data:*) 
		{
			this.data = data;
			super(type);
		}
		
		public override function clone():Event {
			var r:RunFrameEvent = new RunFrameEvent(type, data);
			return r;
		}
		
	}
	
}

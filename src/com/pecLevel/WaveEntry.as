package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class WaveEntry 
	{
		public var id:String;
		public var type:String;
		public var count:int;
		public var original_count:int;
		public var spawned_count:int=0;
		public var escaped_count:int = 0;
		public var infest_count:int = 0;
		public var release_count:int;
		public var active:Boolean;
		public var spread:Number;
		public var vesicle:Number; //number between 0 & 1 signifying percent of viruses wrapped in vesicles
		public var delay:int; //frames to delay the virus from activating
		public var defeated:Boolean = false; //has this wave been killed by the player?
		public var sleep_seconds:int; //how many seconds does this thing wait before coming back?
		
		public var frac:Number; 	 //what fraction of our original amount to we have?
		public var dormant_time:Number = 0; //how many frames have we lied dormant
		
		public const TIME_CHANCE:Number = 10; //how many encounter ticks to lie dormant for (1% chance)*(100*(count/original_count)) of releasing all viruses
		
		public function WaveEntry() 
		{
			
		}
		
		public function copy():WaveEntry {
			var w:WaveEntry = new WaveEntry();
			w.id = id;
			w.type = type;
			w.count = count;
			w.original_count = original_count;
			w.release_count = release_count;
			w.spawned_count = spawned_count;
			w.escaped_count = escaped_count;
			w.infest_count = infest_count;
			w.active = active;
			w.spread = spread;
			w.delay = delay;
			w.frac = frac;
			w.vesicle = vesicle;
			w.dormant_time = dormant_time;
			return w;
		}
		
		public function toString():String {
			return ("WaveEntry{id=" + id + ",type=" + type + ",count=" + count + "}");
		}
	}
	
}
package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Discovery 
	{
		public var id:String;
		public var discovered:Boolean = false;
		
		public function Discovery(s:String,b:Boolean=false) 
		{
			id = s;
			discovered = b;
			trace("new Discovery(" + id + "," + discovered + ")");
		}
		
	}
	
}
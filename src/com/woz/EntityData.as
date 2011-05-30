package com.woz 
{
	import com.cheezeworld.math.Vector2D;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class EntityData 
	{
		public var is_thing:Boolean; //is this a specific thing, or not?
		
		public var loc:Vector2D;	//where is this located?
		public var name:String;		//what is the name of this?
		public var type:String;		//what is this?
		public var count:int;		//how many are there
		public var aggro:Number;	//if it's hostile, how hostile?
		public var spawn:Number;	//does it spawn? how often?
		public var active:Boolean = false; //is it activated?
				
		public function EntityData() 
		{
			loc = new Vector2D();
		}
		
	}
	
}
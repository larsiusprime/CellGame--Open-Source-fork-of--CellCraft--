package com.pecLevel
{
	public class LevelData extends Object
	{
		// Note that the naming convention here (and in Stuff/ThingEntry) in indicates the structure of the XML.  
		// So, variable foo_bar is going to be found in the tag "foo" with the attribute "bar":
		// <foo bar="lol" />
		
		public var level_index:int;
		public var level_title:String;
		
		//public difficulty:int //are we doing difficulty? If so, I need to know how much.

		public var size_width:Number //Bounding box
		public var size_height:Number

		public var background_name:String //background identifier. "petri_dish", "alligator_mouth", etc
		public var boundary_circle:Boolean = false;
		public var boundary_circle_r:Number = 0;
		
		public var boundary_box:Boolean = false;
		public var boundary_box_w:Number = 0;
		public var boundary_box_h:Number = 0;
		
		public var start_x:Number //player's start location
		public var start_y:Number

		public var levelStuff:LevelStuff = new LevelStuff();
		public var levelThings:LevelThings = new LevelThings();
		//public levelEvents:LevelEvents:
		public var levelObjectives:Vector.<Objective> = new Vector.<Objective>(); 
		public var levelDiscoveries:Vector.<Discovery> = new Vector.<Discovery>();
		
		public var start_mitos:int = 0;
		public var start_chloros:int = 0;
		public var start_lysos:int = 0;
		public var start_peroxs:int = 0;
		public var start_ribos:int = 0;
		public var start_slicers:int = 0;
		
		public var start_atp:Number = 0;
		public var start_na:Number = 0;
		public var start_aa:Number = 0;
		public var start_fa:Number = 0;
		public var start_g:Number = 0;
		
		// Include consts for reference here
		static const LEVEL_0:int = 0;
		static const LEVEL_1:int = 1;
		static const LEVEL_2:int = 2;
		static const LEVEL_3:int = 3;
		static const LEVEL_BONUS_1:int = 50;
	
		public function toString():String {
			var str:String = "LevelData (index=" + level_index + " title=" + level_title +")\n";
			str += "...size = (" + size_width + "x" + size_height + "); start = (" + start_x +"," + start_y + ")\n";
			str += "...start resources = (atp=" + start_atp + " na=" + start_na + " aa=" + start_aa + " fa=" + start_fa + " g=" + start_g + ")\n";
			str += "...stuff : " + levelStuff.toString();
			str += "...things : " + levelThings.toString();
			str += "...objectives : " + levelObjectives.toString();
			return str;
		}	
	}
}
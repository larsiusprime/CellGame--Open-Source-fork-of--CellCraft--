package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class GameLevelInfo 
	{
		private var max_level:int; 					//maximum level index. Minimum is 0
		private var list_lvl_cinemas:Vector.<int>; 	//index of whether there's a cinema after a level, and what it is
		private var list_lvl_designation:Vector.<int>;
		private var list_lvl_names:Vector.<String>;
		private var list_lvl_label:Vector.<int>;
		
		public static const LVL_INTRO:int = 0;
		public static const LVL_REAL:int = 1;
		
		public function GameLevelInfo(i:int) 
		{
			//baked mode:
			setup(7);
			bakeData();
		}
		
		public function get maxLevel() {
			return max_level;
		}
		
		/**
		 * Give me the num of the level you just finished, I'll show you the next movie
		 * @param	i
		 */
		
		public function getLvlCinema(i:int):int {
			return list_lvl_cinemas[i];
		}
		
		public function getLvlDesignation(i:int):int {
			return list_lvl_designation[i];
		}
		
		public function getLvlName(i:int):String {
			return list_lvl_names[i];
		}
		
		public function getLvlLabel(i:int):int {
			return list_lvl_label[i];
		}
		
		private function setup(i:int) {
			max_level = i;
			list_lvl_cinemas = new Vector.<int>;
			list_lvl_designation = new Vector.<int>;
			list_lvl_label = new Vector.<int>;
			list_lvl_names = new Vector.<String>;
			
			list_lvl_cinemas.length = max_level + 1; //same number of indeces as levels
			list_lvl_designation.length = max_level + 1;
			list_lvl_names.length = max_level + 1;
			list_lvl_label.length = max_level + 1;
			
			for (var j:int = 0; j <= max_level; j++) { //default is no cinemas
				list_lvl_cinemas[j] = Cinema.NOTHING;
			}
		}
		
		private function bakeData() {
			
			//Baked Mode:
			
			list_lvl_designation[0] = LVL_REAL;
			list_lvl_designation[1] = LVL_REAL;
			list_lvl_designation[2] = LVL_REAL;
			list_lvl_designation[3] = LVL_REAL;
			list_lvl_designation[4] = LVL_REAL;
			list_lvl_designation[5] = LVL_REAL;
			list_lvl_designation[6] = LVL_REAL;
			list_lvl_designation[7] = LVL_REAL;
			
			list_lvl_label[0] = 1;
			list_lvl_label[1] = 2;
			list_lvl_label[2] = 3;
			list_lvl_label[3] = 4;
			list_lvl_label[4] = 5;
			list_lvl_label[5] = 6;
			list_lvl_label[6] = 7;
			list_lvl_label[7] = 8;
			
			list_lvl_names[0] = "Pseudopod for the Win";
			list_lvl_names[1] = "Let's get Nuclear";
			list_lvl_names[2] = "Insane in the Membrane";
			list_lvl_names[3] = "Invasive Infection";
			list_lvl_names[4] = "Green Thumb";
			list_lvl_names[5] = "The Longest Journey";
			list_lvl_names[6] = "Heat Shock Crisis";
			list_lvl_names[7] = "Indigestion";
						
			/*
			list_lvl_cinemas[0] = Cinema.SCENE_LAB_INTRO;
			list_lvl_cinemas[1] = Cinema.SCENE_LAB_BOARD;
			list_lvl_cinemas[4] = Cinema.SCENE_LAUNCH;
			list_lvl_cinemas[5] = Cinema.SCENE_CRASH;
			list_lvl_cinemas[6] = Cinema.SCENE_LAND_CROC;
			list_lvl_cinemas[7] = Cinema.SCENE_FINALE;
			*/
			
			list_lvl_cinemas[0] = Cinema.SCENE_A;
			list_lvl_cinemas[1] = Cinema.SCENE_A;
			list_lvl_cinemas[4] = Cinema.SCENE_A;
			list_lvl_cinemas[5] = Cinema.SCENE_A;
			list_lvl_cinemas[6] = Cinema.SCENE_A;
			list_lvl_cinemas[7] = Cinema.SCENE_FINALE;
		}
		
	}
	
}
package  
{
	
	/**
	 * Class DState is a stack of states for the director. 
	 * The assumption this class makes is that each state is 
	 * mutually exclusive with each other state, only one is 
	 * necessary to fully describe the current state of the game, 
	 * and only one can be experienced at a time. Also, with the 
	 * exception of initialization, one can only go from one state 
	 * to another - one can not skip intermediate steps, and one 
	 * can only traverse the stack through pushing new states on or 
	 * popping old states off. If the player is playing the game (INGAME), 
	 * then opens a menu (INMENU) and then pauses the game (PAUSED) - 
	 * he must unpause the game and close the menu (in that order!) 
	 * in order to resume playing the game.
	 * 
	 * @author Lars A. Doucet
	 */
	public class DState 
	{
		private var stack:Vector.<int>;
		
		public static const NOSTATE:int = -1; //error or null state
		public static const PRELOAD:int = 0;
		public static const TITLE:int =  1; //the title screen
		public static const INGAME:int = 2; //gameplay
		public static const PAUSED:int = 3; //the game is paused
		public static const FAUXPAUSED:int = 4; //the game is paused, but we still let certain things run. Used for in-engine cinematics, etc
		public static const INMENU:int = 5; //in-game menu
		public static const CINEMA:int = 6; //we're in a cutscene
		
		public function DState() 
		{
			stack = new Vector.<int>;
			stack[0] = NOSTATE;
		}
		
		public function traceStack() {
			var s:String = "StateStack = ";
			for (var i:int = 0; i < stack.length; i++) {
				s += stateToString(stack[i]) + " ,";
			}
			trace(s);
		}
		
		public function stateToString(i:int):String {
			var s:String;
			switch(i) {
				case NOSTATE: s = "nostate"; break;
				case PRELOAD: s = "preload"; break;
				case TITLE: s = "title"; break;
				case INGAME: s ="ingame"; break;
				case PAUSED: s ="paused"; break;
				case INMENU: s ="inmenu"; break;
				case CINEMA: s = "cinema"; break;
				case FAUXPAUSED: s = "fauxpaused"; break;
				default: s = "???"; break;
			}
			return String(i) + ":" + s;
		}
		
		public function quickTest() {
			trace("stack was = " + stack);
			push(TITLE);
			push(INGAME);
			push(INMENU);
			push(PAUSED);
			pop();
			pop();
			pop();
			push(CINEMA);
			trace("stack = " + stack);
		}
		
		public function push(i:int) {
			if (i >= PRELOAD && i <= CINEMA) {
				stack.push(i);
			}else {
				throw new Error("DState.push() : statecode " + i + " not recognized!");
			}
		}
		
		public function pop():int {
			if(stack.length > 0)
				return stack.pop();
			else
				return NOSTATE;
		}
		
		public function setState(i:int) {
			if (stack.length == 1){
				if (i >= PRELOAD && i <= CINEMA) {
					stack[0] = i;
				}
			}
		}
		
		public function getTop():int {
			if(stack.length >= 1)
				return stack[stack.length - 1];
			else
				return NOSTATE;
		}
		
		public function getPrev():int {
			if (stack.length >= 2) {
				return stack[stack.length - 2];
			}
			else {
				return NOSTATE;
			}
		}
		
	}
	
}
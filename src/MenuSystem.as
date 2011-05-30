package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem extends MovieClip
	{
		public static const INGAME:int = 0;
		public static const OPTIONS:int = 1;
		public static const TUTORIAL:int = 2;
		public static const HISTORY:int = 3;
		public static const ENCYCLOPEDIA:int = 4;
		public static const LEVELPICKER:int = 5;
		public static const REWARD:int = 6;
		public static const SCREWED:int = 7;
		public static const ENDLEVEL:int = 8;
		
		protected var myIndex:int = -1;
		protected var p_director:Director;
		protected var p_engine:Engine;
		
		public static const EXIT_PICK:int = 1;
		public static const EXIT_TITLE:int = 0;
		public static const EXIT_RESET:int = 2;
		
		public function MenuSystem() 
		{
			addEventListener(MouseEvent.MOUSE_OVER, normalCursor,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT, fancyCursor,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT, fancyCursor,false,0,true);
		}
		
		public function fancyCursor(e:MouseEvent) {
			p_director.fancyCursor();
		}
		
		public function normalCursor(e:MouseEvent) {
			p_director.normalCursor()
		}
		
		public function destruct() {
			
		}
		
		public function init() {
			p_director.tempHighQuality();
		}
		
		public function exit() {
			p_director.normalQuality();
			p_director.exitMenu();
		}
		
		public function setIndex(i:int) {
			myIndex = i;
		}
		
		public function getIndex():int {
			return myIndex;
		}
		
		public function setDirector(d:Director) {
			p_director = d;
		}
		
		public function setEngine(e:Engine) {
			p_engine = e;
		}
		
		public function onFadeOut() {
			
		}
	}
	
}
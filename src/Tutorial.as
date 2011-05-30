package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Tutorial 
	{
		public var title:String;
		public var tut:String;
		
		public function Tutorial(ti:String,tu:String) 
		{
			title = ti;
			tut = tu;
		}
	
		public function toString():String {
			return ("Tutorial{"+title + ":" + tut+"}");
		}
	}
	
}
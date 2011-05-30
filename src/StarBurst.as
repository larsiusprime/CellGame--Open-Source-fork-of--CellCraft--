package  
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class StarBurst extends MovieClip
	{
		public var p_cell:Cell;
		
		public function StarBurst() 
		{
			
		}
		
		public function finishAnim() {
			p_cell.removeStarburst(this);
			p_cell = null;
		}
	}
	
}
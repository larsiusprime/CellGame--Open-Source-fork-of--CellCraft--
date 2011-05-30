package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class NucleusAnim extends MovieClip
	{
		public var pores:PoreMatrix;
		public var n_pores:NucleolusPoreMatrix;
		public var clip1:MovieClip;
		
		public function NucleusAnim() 
		{
			clip1 = null; //to avoid a bug in SelectedPanel
		}
		
		/**
		 * 0 for regular pore, 1 for Nucleolus pore
		 * @param	i
		 * @return
		 */
		
		public function getPoreLoc(i:int=0,doOpen:Boolean=false):Point{
			var p:MovieClip;
			if(i == 0){
				p = pores.getPore(doOpen);
			}else {
				p = n_pores.getPore(doOpen);
			}
			var pt:Point = new Point(p.x, p.y);
			pt.x *= scaleX;
			pt.y *= scaleY;
			return pt;
		}
		
		public function getPorePoint(i:int = 0):Array {
			var p:MovieClip;
			if (i == 0) {
				p = pores.getPore(false);
			}else {
				p = n_pores.getPore(false);
			}
			var pt:Point = new Point(p.x, p.y);
			pt.x *= scaleX;
			pt.y *= scaleY;
			var name:String = p.name;
			var id:int = Number(name.substr(5, 2));
			//trace("NucleusAnim.getPorePoint id = " + id);
			return [pt, id];
		}
		
		public function getPoreByI(i,type:int = 0):Point {
			var p:MovieClip;
			if (type == 0) {
				p = pores.getPoreByI(i);
			}else {
				p = n_pores.getPoreByI(i);
			}
			var pt:Point = new Point(p.x, p.y);
			pt.x *= scaleX;
			pt.y *= scaleY;
			return pt;
			//var p:Point = nclip.getPoreByI(i, type);
			//return p;
		}
		
		public function openPore(i, type:int = 0) {
			if (type == 0) {
				pores.openPore(i);
			}else {
				n_pores.openPore(i);
			}
		}
		
		
		public function freePore(i:int = 0) {
			if(i == 0){
				return pores.freePore();
			}else {
				return n_pores.freePore();
			}
		}
	}
	
}
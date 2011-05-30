package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class TutorialEntry 
	{
		public var label:String;
		public var list_tuts:Vector.<Tutorial>;
		
		public function TutorialEntry(v:Vector.<Tutorial>=null,l=null) 
		{
			if (l) {
				label = l;
			}
			if (v) {
				list_tuts = v.concat();
			}
		}
		
		public function setList(v:Vector.<Tutorial>) {
			list_tuts = v.concat();
		}
		
		public function getList():Vector.<Tutorial> {
			return list_tuts.concat();
		}
		
		public function destruct() {
			for each(var t:Tutorial in list_tuts) {
				list_tuts.pop();
			}
			list_tuts = null;
		}
		
	}
	
}
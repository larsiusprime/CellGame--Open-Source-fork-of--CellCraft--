package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class TutorialArchive 
	{
		private var list_tutorials:Vector.<TutorialEntry>;
		private var list_alerts:Vector.<String>;
		private var list_messages:Vector.<MessageEntry>;
		private var p_engine:Engine;
		
		public function TutorialArchive() 
		{
			list_tutorials = new Vector.<TutorialEntry>;
			list_alerts = new Vector.<String>;
			list_messages = new Vector.<MessageEntry>;
		}
		
		public function setEngine(e:Engine) {
			p_engine = e;
		}
		
		public function addTutorial(t:TutorialEntry) {
			list_tutorials.push(t);
		}
		
		public function getTutorial(i:int):TutorialEntry{
			return list_tutorials[i];
		}
		
		public function addAlert(s:String) {
			list_alerts.push(s);
		}
		
		public function getAlert(i:int):String {
			return list_alerts[i];
		}
		
		public function addMessage(m:MessageEntry) {
			list_messages.push(m);
		}
		
		public function getMessage(i:int):MessageEntry {
			return list_messages[i];
		}
		
		public function getCounts():Array {
			return [list_tutorials.length, list_alerts.length, list_messages.length];
		}
		
		/**
		 * This function is slow. Don't use it in a loop. Also, only use it to remove a specific element
		 * @param	t
		 */
		
		public function removeTutorial(t:TutorialEntry) {
			var i:int = 0;
			for each(var te:TutorialEntry in list_tutorials) {
				if (t.getList().join() == te.getList().join()) {
					te.destruct();
					list_tutorials.splice(i, 1);
				}
				i++;
			}
		}
		
	}
	
}
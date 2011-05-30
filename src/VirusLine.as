package  
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class VirusLine extends MovieClip
	{
		public var id:String = "";
		public var clip:MovieClip;
		public var rnaclip:MovieClip;
		//public var timeclip:MovieClip;
		public var txt_1:TextField;
		public var txt_2:TextField;
		
		private var _active:Boolean = false;
		private var _showTime:Boolean = false;
		private var _time:int = 0;
		private var _virus:String = "injector";
		private var _virus_count:int = 0;
		private var _dormant_count:int = 0;
		private var _rna_count:int = 0;
		public var blank:Boolean = true;
		public var readyToCheck:Boolean = false;
		
		
		public function VirusLine() 
		{
			//timeclip.visible = false;
			//timeclip.stop();
		}
		
		public function get virus_count():int {
			return _virus_count;
		}
		
		public function clear() {
			_active = false;
			_time = 0;
			_virus = "injector";
			_virus_count = 0;
			_dormant_count = 0;
			_rna_count = 0;
			blank = true;
			readyToCheck = false;
		}
		
		public function checkActive() {
						
			if (_rna_count > 0 || _virus_count > 0) {
				_active = true;
				if(_rna_count > 0){
					rnaclip.gotoAndStop("rna");
					rnaclip.visible = true;
				}else {
					rnaclip.visible = false;
				}
			}else {
				
				_active = false;
				if (_dormant_count > 0) {
					_showTime = true;
					if (_rna_count <= 0) {
						rnaclip.visible = true;
						rnaclip.gotoAndStop("time");
						VirusGlass(parent).onVirusTime(this);
					}
				}else {
					_showTime = false;
					
				}
			}
			
		}
		
		private function updateCount() {
			if (_active) {
				txt_1.htmlText = "<b>"+(_virus_count + _dormant_count).toString()+"</b>";
				if(_rna_count > 0)
					txt_2.htmlText = "<b>"+_rna_count.toString()+"</b>";
				else {
					txt_2.text = "";
				}
			}else{
				if (_showTime && _rna_count <= 0) {
					txt_2.htmlText = "<b>"+_time.toString()+"</b>";
				//timeclip.gotoAndStop(_time + 1);
				}
			}
			/*else {
				txt_1.htmlText = "<b>"+_dormant_count.toString()+"</b>";
				
			}*/
			
			if(readyToCheck){
				if (_virus_count <= 0 && _rna_count <= 0 && _dormant_count <= 0) {
					blank = true;
					visible = false;
					readyToCheck = false;
					if (_virus == "infester") {
						if (!Nucleus.CHECK_INFEST) {
							VirusGlass(parent).onFinishVirusLine(this);
						}
					}else{
						VirusGlass(parent).onFinishVirusLine(this);
					}
				}
			}
		}
		
		public function setTime(i:int) {
			_time = i;
			updateCount();
		}
		
		public function oneLessVirus() {
			_virus_count--;
			updateCount();
		}
		
		public function addVirus(i:int) {
			_virus_count += i;
			checkActive();
			updateCount();
			readyToCheck = true;
		}
		
		public function addRNA(i:int) {
			_rna_count += i;
			checkActive();
			updateCount();
			//trace("VirusLine.addRNA() _rna_count now = " + _rna_count);
		}
		
		public function oneLessRNA() {
			_rna_count--
			checkActive();
			updateCount();
		}
		
		public function setCount(vc:int, rc:int, dc:int=0, t:int=0) {
			if (vc != -1) _virus_count = vc;
			if(rc != -1) _rna_count = rc;
			if(dc != -1) _dormant_count = dc;
			if(t != -1) _time = t;
			checkActive();
			updateCount();
		}
		
		public function setDormant(d:int) {
			_dormant_count = d;
			updateCount();
		}
		
		public function finishFade() {
			VirusGlass(parent).finishFade();
		}
		
		public function setVirus(wave_id:String, v:String,vc:int,rc:int,dc:int=0,time:int=0) {
			id = wave_id;
			blank = false;
			clip.gotoAndStop(v);
			clip.clip.play();
			_virus = v;
			_virus_count = vc;
			_rna_count = rc;
			_dormant_count = dc;
			_time = time;
			checkActive();
			updateCount();
		}
	}
	
}
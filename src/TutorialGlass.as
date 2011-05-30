package  
{
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import SWFStats.*;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class TutorialGlass extends InterfaceElement
	{
		public var anim:MovieClip;
		public var c_virusGlass:VirusGlass;
		public var c_talkGlass:TalkGlass;
		private var tuts:int = 0;
		private var alerts:int = 0;
		private var msgs:int = 0;
		/*public var c_text_tuts:TextField;
		public var c_text_alerts:TextField;
		public var c_text_messages:TextField;*/
		public var c_butt_review:SimpleButton;
		public var c_text:TextField;
		public var c_book:EncyclopediaBook;
		private var lastEntry:String = "root";
		private var head_txt:String = "Objective:";
		public var c_butt_next:ShowNextButt;
		public var c_arrow:MovieClip;
		
		public var doShowArrow:Boolean = false;
		
		public function TutorialGlass() 
		{
			setText("");
			c_butt_review.addEventListener(MouseEvent.CLICK, review,false,0,true);
			//c_butt_next.addEventListener(MouseEvent.CLICK, getNextObj, false, 0, true);
			c_book.init(this);
			hideButtNext();
			hideArrow();
		}
		
		public function setArrowShow(b:Boolean) {
			doShowArrow = b;
		}
		
		private function hideArrow() {
			c_arrow.visible = false;
			c_arrow.stop();
			removeChild(c_arrow);
		}
		
		private function showArrow() {
			c_arrow.visible = true;
			c_arrow.play();
			addChild(c_arrow);
		}

		public function virusGlow() {
			anim.gotoAndPlay("red");
			//setHeadText("Kill the Viruses!");
		}
		
		public function justGlow() {
			anim.gotoAndPlay("glow");
			//setHeadText("Objective:");
		}
		
		public function onVirusTime(id:String,count:int) {
			p_master.onVirusTime(id,count);
		}
		
		public function happyGlow(txt:String = null, a:Array = null) {
			if (txt) {
				setText(txt);
			}
			if (a) {
				setInfo(a[0], a[1], a[2]);
			}
			anim.gotoAndPlay("glow");
			//setHeadText("Objective:");
		}
		
		public function setInfo(tut:int, alert:int, msg:int) {
			tuts = tut;
			alerts = alert;
			msgs = msg;
			/*c_text_tuts.text = tut.toString();
			c_text_alerts.text = alert.toString();
			c_text_messages.text = msg.toString();*/
		}
		
		public function setText(txt:String) {
			c_text.text = txt;
		}
		
		public function review(m:MouseEvent) {
			p_master.review();
		}
		
		public function hideButtNext() {
			//c_text.visible = true;
			c_butt_next.visible = false;
		}
		
		public function hideTutorialText() {
			c_text.text = "";
		}
		
		public function showButtNext() {
			Director.startSFX(SoundLibrary.SFX_CLICK_FOR_NEXT);
			c_text.htmlText= "<b>COMPLETE!</b>";
			//c_text.visible = false;
			c_butt_next.visible = true;
			c_butt_next.shine();
			if (doShowArrow) {
				//doShowArrow = false;
				showArrow();
			}
		}
		
		public function getNextObj() {
			p_master.getNextObj();
			if (doShowArrow) {
				doShowArrow = false;
				hideArrow();
			}
		}
		
		public function onBookClick() {
			if(Director.STATS_ON){Log.CustomMetric("encyclopedia_open_tutorial_glass" + lastEntry, "encyclopedia");}
			p_master.showEncyclopedia(lastEntry);
		}
		
		public function newEntry(str:String) {
			lastEntry = str;
			c_book.newEntry();
		}
		
		public function setTalk(talker:String, emotion:String) {
			c_talkGlass.setTalk(talker, emotion);
		}
		
		public function enemyAlert(type:String, count:int, wave_id:String="null") {
			c_virusGlass.setWarning(type, count, wave_id);
			//virusGlow();
		}
		
		public function onFinishEnemyAlert(type:String, count:int, wave_id:String = "null") {
			trace("TutorialGlass.onFinishEnemyAlert(" + type + "," + count + "," + wave_id + ")");
			p_master.onFinishEnemyAlert(type, count, wave_id);
			//justGlow();
		}
	}
	
}
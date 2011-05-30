package  
{
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_Tutorial extends MenuSystem
	{
		public var c_butt_prev:SimpleButton;
		public var c_butt_next:SimpleButton;
		public var c_butt_okay:SimpleButton;
		public var c_butt_cancel:SimpleButton;
		//public var c_title_text:TextField;
		public var c_tutorialContent:MovieClip;
		//public var c_back:MovieClip;
		public var c_fade_anim:MovieClip;
		
		private var max_tut:int = 1;
		private var curr_tut:int = 0;
		private var list_tuts:Vector.<Tutorial>;
		
		private var exitLabel:String = "normal";
		
		public function MenuSystem_Tutorial(data:TutorialEntry=null) {
			//trace("MenuSystem_Tutorial() New=" + this.name);
			c_butt_cancel.visible = false;
			c_butt_prev.visible = false;
			c_butt_next.visible = false;
			c_butt_okay.visible = false;
			//c_back.visible = false;
			//c_title_text.visible = true;
			c_tutorialContent.visible = true;
			if(data){
				list_tuts = data.list_tuts.concat();
				//trace("MenuSystem_Tutorial() list_tuts = " + list_tuts);
			}else {
				throw new Error("No Tutorial Data!");
			}
		}
		
		public override function destruct() {
			clearTuts();
			c_butt_prev.removeEventListener(MouseEvent.CLICK, goPrev);
			c_butt_prev.removeEventListener(MouseEvent.CLICK, goNext);
			c_butt_cancel.removeEventListener(MouseEvent.CLICK, cancel);
			c_butt_okay.removeEventListener(MouseEvent.CLICK, goOkay);
			list_tuts = null;
		}
		
		private function clearTuts() {
			for each(var t:Tutorial in list_tuts) {
				t = null;
				list_tuts.pop();
			}
		}
		
		public override function init() {
			super.init();
			c_butt_prev.addEventListener(MouseEvent.CLICK, goPrev,false,0,true);
			c_butt_next.addEventListener(MouseEvent.CLICK, goNext,false,0,true);
			c_butt_cancel.addEventListener(MouseEvent.CLICK, cancel,false,0,true);
			c_butt_okay.addEventListener(MouseEvent.CLICK, goOkay,false,0,true);
			//trace("MenuSystem_Tutorial.init() list_tuts = " + list_tuts);
			setTutorials(list_tuts);
			//list_tuts = new Vector.<Tutorial>();
		}
		
		private function goPrev(m:MouseEvent) {
			//trace("MenuSystem_Tutorial.goPrev()");
			if (curr_tut == 0) {
				throw new Error("There is no previous tutorial!");
			}else {
				curr_tut--;
				setTutorial(list_tuts[curr_tut]);
			}
		}
		
		private function goNext(m:MouseEvent) {
			//trace("MenuSystem_Tutorial.goNext()");
			if (curr_tut == max_tut) {
				throw new Error("There is no next tutorial!");
			}else {
				curr_tut++;
				setTutorial(list_tuts[curr_tut]);
			}
		}
		
		public function setTutorials(v:Vector.<Tutorial>) {
			//trace("MenuSystem_Tutorial.setTutorials() v = " + v);
			list_tuts = v.concat();
			curr_tut = 0;
			max_tut = list_tuts.length - 1;
			setTutorial(list_tuts[curr_tut]);
			//trace("MenuSystem_Tutorial.setTutorials() " + v);
		}
		
		public function setTutorial(t:Tutorial) {
			//trace("MenuSystem_Tutorial.setTutorial() " + curr_tut + "/" + max_tut);
			setContent(t.tut);
			setTitle(t.title);
			if (curr_tut == 0) {
				c_butt_prev.visible = false;
			}else {
				c_butt_prev.visible = true;
			}
			if (curr_tut == max_tut) {
				c_butt_okay.visible = true;
				c_butt_next.visible = false;
			}else if (curr_tut < max_tut) {
				c_butt_okay.visible = false;
				c_butt_next.visible = true;
			}
			
			
			if (t.tut.substr(0, 8) == "discover") {
				Director.startSFX(SoundLibrary.SFX_DISCOVERY);
			}else if (t.tut.substr(0, 9) == "newaction") {
				Director.startSFX(SoundLibrary.SFX_NEWACTION);
			}
		}
		
		public function setTitle(txt:String) {
			c_tutorialContent.c_title_text.htmlText = "<b>" + txt + "</b>";

		}
		
		public function setContent(str:String) {
			if (str.substr(0, 4) == "talk") {
				exitLabel = "talk";
			}else {
				exitLabel = "normal";
			}
			c_tutorialContent.gotoAndStop(str);
		}
	
		public function cancel(m:MouseEvent) {
			exit();
		}
		
		public function goOkay(m:MouseEvent) {
			//trace("MenuSystem_Tutorial.goOkay()" + this.name);
			exit();
		}
		
		public override function exit() {
			fadeOut();
		}
		
		public function fadeOut() {
			//c_back.visible = false;
			c_butt_cancel.visible = false;
			c_butt_next.visible = false;
			c_butt_okay.visible = false;
			c_butt_prev.visible = false;
			//c_title_text.visible = false;
			c_tutorialContent.visible = false;
			//c_fade_anim.visible = true;
			c_fade_anim.gotoAndPlay(exitLabel);
		}
		
		public override function onFadeOut() {
			//c_fade_anim.visible = false;
			super.exit();
		}
		
		
	}
	
}
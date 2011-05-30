package  
{
	//import com.cheezeworld.screens.IScreenItem;
	import fl.controls.Button;
	import fl.controls.List;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import SWFStats.*;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_History extends MenuSystem
	{
		public var c_butt_cancel:SimpleButton;
		public var c_butt_select:Button;
		public var c_list:List;
		public var c_title_text:TextField;
		public var c_back:MovieClip;
		public var c_fade_anim:MovieClip;
		
		private var theTut:TutorialEntry;
		private var theAlert:String = "";
		private var theMessage:MessageEntry;
		
		//private var list_tuts:Vector.<Tutorial>;
		
		public function MenuSystem_History(data:TutorialArchive) {
			trace("MenuSystem_History() New=" + this.name);
			
			if(data){
				populateList(data);
			}else {
				throw new Error("No Tutorial Data!");
			}
		}
		
		private function populateList(data:TutorialArchive) {
			//THIS IS WHERE THE ERROR IS
			var a:Array = data.getCounts();
			var i:int = 0;
			var o:Object;
			for (i = 0; i < a[0]; i++) {
				var t:TutorialEntry = data.getTutorial(i);
				o = new Object();
				//o.label = "(Tutorial): " +  t.label;
				o.label = t.label;
				o.data = t;
				c_list.addItem(o);
			}
			for (i = 0; i < a[1]; i++) {
				var al:String = data.getAlert(i);
				o = new Object();
				o.label = "(Alert): " + al;
				o.data = al;
				c_list.addItem(o);
			}
			for (i = 0; i < a[2]; i++) {
				var m:MessageEntry = data.getMessage(i);
				o = new Object();
				o.label = "(Message): " + m.speaker.toUpperCase() + ": " + m.message;
				o.data = m;
				c_list.addItem(o);
			}
		}
		
		public override function destruct() {
			c_butt_cancel.removeEventListener(MouseEvent.CLICK, cancel);
		}
		public override function init() {
			super.init();
			c_butt_select.addEventListener(MouseEvent.CLICK, selectAndClose,false,0,true);
			c_butt_cancel.addEventListener(MouseEvent.CLICK, cancel,false,0,true);
		}
		
		public function setTitle(txt:String) {
			c_title_text.htmlText = "<b>" + txt + "</b>";
		}
		
		public function cancel(m:MouseEvent) {
			exit();
		}
		
		public function selectAndClose(m:MouseEvent) {
			
			trace("MenuSystem_History.selectAndClose()!");
			var o:Object = c_list.selectedItem;
			if (o.data is TutorialEntry) {
				theTut = TutorialEntry(o.data);
				if(Director.STATS_ON){Log.CustomMetric("history_review_tut_" + theTut.label);}
			}else if (o.data is String) {
				theAlert = String(o.data);
				if(Director.STATS_ON){Log.CustomMetric("history_review_alert_" + theAlert);}
			}else if (o.data is MessageEntry) {
				theMessage = MessageEntry(o.data);
				if(Director.STATS_ON){Log.CustomMetric("history_review_message_" + theMessage.message);}
			}
			
			trace("MenuSystem_History.selectAndClose() data=" + o.data + "theTut=" + theTut + " theAlert=" + theAlert + " theMessage=" + theMessage);
			quickExit();
		}
		
		public override function exit() {
			fadeOut();
		}
		
		private function quickExit() {
			hideStuff();
			onFadeOut();
		}
		
		private function hideStuff() {
			c_back.visible = false;
			c_list.visible = false;
			c_butt_select.visible = false;
			c_butt_cancel.visible = false;
		}
		
		public function fadeOut() {
			hideStuff();
			c_fade_anim.play();
		}
		
		public override function onFadeOut() {
			sendSomethingToEngine();
			super.exit();
		}
		
		private function sendSomethingToEngine() {
			trace("MenuSystem_History.sendSomethingToEngine()! theTut=" + theTut + " theAlert=" + theAlert + " theMessage=" + theMessage);
			if (theTut) {
				p_engine.getHistoryTut(theTut);
			}else if (theAlert != "") {
				p_engine.getHistoryAlert(theAlert);
			}else if (theMessage) {
				p_engine.getHistoryMessage(theMessage);
			}
		}
		
		
	}
	
}
package  
{
	import com.pecLevel.WaveEntry;
	import com.pecSound.SoundLibrary;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MenuSystem_EndLevel extends MenuSystem
	{
		public var butt:SimpleButton;

		public var grade:MovieClip;
		public var txt_time:TextField;
		
		public var performance:String = "f";
		

		
		public function MenuSystem_EndLevel() 
		{
			butt.addEventListener(MouseEvent.CLICK, onOkay, false, 0, true);
		}
		
		public override function destruct() {
			
			butt.removeEventListener(MouseEvent.CLICK, onOkay);
			removeChild(grade);
			removeChild(txt_time);
			removeChild(butt);
			super.destruct();
		}
		
		public function setData(n:Number) {
			calcPerformance(n);
		}
		
		public function calcPerformance(n:Number) {
			
			var gpa:Number = n;
			
			
			if (gpa <= -1) {
				performance = "pass";
				gpa = -1;
			}else if (gpa >= 4.8) {
				performance = "a+";
				gpa = 5;
			}else if (gpa >= 3.8) {
				performance = "a";
				gpa = 4;
			}else if (gpa >= 2.8) {
				performance = "b";
				gpa = 3;
			}else if (gpa >= 1.8) {
				performance = "c";
				gpa = 2;
			}else if (gpa >= 0.8) {
				performance = "d";
				gpa = 1;
			}else{
				performance = "d-";
				gpa = 0;
			}
			
			if (performance != "pass") {
				gotoAndStop("defense");
			}
			
			var seconds:int = Engine.getTimeSeconds();  //get raw seconds
			var minutes:int = Math.floor(seconds / 60); //get raw minutes
			var hours:int = Math.floor(minutes / 60);   //get raw hours
			seconds = seconds % 60;
			minutes = minutes % 60;
			
			var secondStr:String = seconds.toString(); if (seconds < 10) secondStr = "0" + secondStr;
			var minuteStr:String = minutes.toString(); if (minutes < 10) minuteStr = "0" + minuteStr;
			var hourStr:String = hours.toString();
			
			var timeStr:String = "";
			if (hours > 0) timeStr += hourStr + ":";
			timeStr += minuteStr + ":" + secondStr;
			txt_time.htmlText = "<b>" + timeStr + "</b>";
			grade.gotoAndStop(performance);
			Engine.logFinalGPA(n, gpa, performance);
			Engine.logFinalTime(Engine.getTimeSeconds());
		}
		
		public function onOkay(m:MouseEvent) {
			exit();
		}
		
	}
	
}
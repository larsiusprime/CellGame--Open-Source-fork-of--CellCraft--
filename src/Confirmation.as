package  
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Confirmation extends MovieClip
	{
		private var caller:IConfirmCaller;
		private var command:String;
		
		public var butt_yes:SimpleButton;
		public var butt_no:SimpleButton;
		
		public function Confirmation() 
		{
			hide();
		}
		
		public function confirm(call:IConfirmCaller, comm:String) {
			caller = call;
			command = comm;
			show();
			gotoAndStop(command);
		}
		
		private function onYes(m:MouseEvent) {
			caller.onConfirm(command, true);
			hide();
		}
		
		private function onNo(m:MouseEvent) {
			caller.onConfirm(command, false);
			hide();
		}
		
		private function hide() {
			caller = null;
			command = "";		
			visible = false;
			butt_yes.removeEventListener(MouseEvent.CLICK, onYes);
			butt_no.removeEventListener(MouseEvent.CLICK, onNo);
		}
		
		private function show() {
			visible = true;
			butt_yes.addEventListener(MouseEvent.CLICK, onYes, false, 0, true);
			butt_no.addEventListener(MouseEvent.CLICK, onNo, false, 0, true);
		}
		
	}
	
}
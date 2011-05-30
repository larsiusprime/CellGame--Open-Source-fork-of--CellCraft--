package  
{
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class NewThingMenu extends InterfaceElement
	{
		public var c_switcher:MovieClip;
		public var butt:SimpleButton;
		public var text:TextField;
		public var the_name:String;
		
		public function NewThingMenu() 
		{
			
		}
		
		public function showMenu(label:String,title:String) {
			trace("NewThingMenu.showMenu(" + label + "," + title + ")");
			text.htmlText = "<b>"+title+"</b>";
			c_switcher.gotoAndStop(label);
			x = 260;
			y = 220;
			butt.addEventListener(MouseEvent.CLICK, clickButt);
			the_name = label;
		}
		
		public function clickButt(m:MouseEvent) {
			p_master.onClickNewThingMenu(the_name);
		}
		
	}
	
}
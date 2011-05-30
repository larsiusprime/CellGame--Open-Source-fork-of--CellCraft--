package   
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CircleButton extends MovieClip
	{
		public var clip:MovieClip;
		public var icon:MovieClip;
		public var hilight:MovieClip;
		
		public var p_menu:ActionMenu;
		
		public var c_box:MovieClip;
		public var c_text:TextField;
		
		public static const SIZE:Number = 40;
		
		private var theText:String = "";	  //Human Readable, ie : "Make Basal Body"
		private var action:int;				  //Action code, ie: Act.MAKE_BASALBODY (12)
		private var actionString:String = ""; //Computer String, ie : "make_basalbody";
		
		public function CircleButton() 
		{
			buttonMode = true;
			cacheAsBitmap = true;
			clip.blendMode = "subtract";
			clip.mouseEnabled = false;
			icon.mouseEnabled = false;
			hilight.mouseEnabled = false;
			setColor(0, 65, 255);
			addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
			hideBoxText();
			c_text.autoSize = TextFieldAutoSize.CENTER;
			//addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}

	//public function mouseUp(m:MouseEvent) {
			
		//}
		
		public function hideBoxText() {
			c_box.visible = false;
			c_text.visible = false;
			c_text.text = "";
		}
		
		public function setBoxText(s:String) {
			c_box.width = s.length * 10;
			c_box.x = - Math.round(c_box.width / 2) + 1;
			
			c_text.text = s;
			theText = s;
		}
		
		public function setMenu(a:ActionMenu) {
			p_menu = a;
		}
		
		public function showBoxText() {
			c_text.text = theText;
			c_box.visible = true;
			c_text.visible = true;
		}
		
		public function rollOver(m:MouseEvent) {
			over();
		}
		
		public function rollOut(m:MouseEvent) {
			out();
		}
		
		public function over() {
			gotoAndStop("_over");
			icon.x = 0;
			icon.x = 0;
			showBoxText();
			showCost();
		}
		
		public function out() {
			//trace("CircleButton.out!");
			gotoAndStop("_up");
			icon.x = 0;
			icon.y = 0;
			hideBoxText();
			hideCost();
		}
		
		public function mouseDown(m:MouseEvent) {
			gotoAndStop("_down");
			icon.x = 1;
			icon.y = 1;
		}
		
		public function click(m:MouseEvent) {
			p_menu.doAction(action,actionString);
			out();
		}
		
		private function showCost() {
			//trace("CircleButton.showCost() : " + actionString);
			p_menu.showCost(actionString);
		}
		
		private function hideCost() {
			p_menu.hideCost();
		}
		
		private function setColor(r:int, g:int, b:int) {
			var col:ColorTransform = clip.transform.colorTransform;
			col.redMultiplier = 0;
			col.greenMultiplier = 0;
			col.blueMultiplier = 0;
			col.redOffset = 255-r;
			col.greenOffset = 255-g;
			col.blueOffset = 255 - b;
			clip.transform.colorTransform = col;
		}
		
		private function setIcon(s:String) {
			icon.gotoAndStop(s);
		}
		
		public function setAction(i:int) {
			action = i;
			actionString = Act.getS(i);
			switch(i) {
				case Act.MOVE: setBoxText("Move"); setIcon("move"); setColor(0, 0, 255); break;
				case Act.POP: setBoxText("Pop");  setIcon("pop"); setColor(100, 100, 100); break;
				case Act.RECYCLE: setBoxText("Recycle"); setIcon("recycle"); setColor(255, 0, 0); break;
				case Act.CANCEL_RECYCLE: setBoxText("Cancel Recycle"); setIcon("cancel_recycle"); setColor(0,0,0); break;
				case Act.REPAIR: setBoxText("Repair"); setIcon("+"); setColor(0, 255, 0); break;
				case Act.DIVIDE: setBoxText("Divide");  setIcon("divide"); setColor(255, 255, 255); break;
				case Act.APOPTOSIS: setBoxText("Apoptosis"); setIcon("skull"); setColor(100, 100, 100); break;
				case Act.NECROSIS: setBoxText("Necrosis"); setIcon("skull"); setColor(128, 0, 0); break;
				case Act.MITOSIS: setBoxText("Mitosis"); setIcon("divide"); setColor(255, 255, 255); break;
				case Act.MAKE_BASALBODY: setBoxText("Make Basal Body"); setIcon("+basalBody"); setColor(0, 255, 0); break;
				case Act.MAKE_MEMBRANE: setBoxText(Act.getTxt(i)); setIcon("+membrane"); setColor(0, 255, 255); break;
				case Act.TAKE_MEMBRANE: setBoxText(Act.getTxt(i)); setIcon("-membrane"); setColor(255, 0, 0); break;
				case Act.MAKE_VESICLE: setBoxText("Make Vesicle"); setIcon("+vesicle"); setColor(0, 255, 0); break;
				case Act.UPGRADE_ER: setBoxText("Upgrade ER"); setIcon("upgradeER"); setColor(0, 255, 255); break;
				case Act.ATTACH_ER: setBoxText("Attach ER"); setIcon("attachER"); setColor(0, 128, 255); break;
				case Act.DETACH_ER: setBoxText("Detach ER"); setIcon("detachER"); setColor(0, 0, 128); break;
				case Act.DISABLE: setBoxText("Disable"); setIcon("cancel"); setColor(128, 0, 0); break;
				case Act.ENABLE: setBoxText("Enable"); setIcon("enable"); setColor(0, 255, 64); break;
				case Act.TOGGLE: setBoxText("Toggle"); setIcon("?"); setColor(128, 128, 128); break;
				case Act.ENABLE_BROWN_FAT: setBoxText("Enable burn G for heat"); setIcon("fire"); setColor(0, 128, 255); break;
				case Act.DISABLE_BROWN_FAT: setBoxText("Disable burn G for heat"); setIcon("no_fire"); setColor(64, 0, 0); break;
				case Act.MAKE_DEFENSIN: setBoxText(Act.getTxt(i)); setIcon("+defend"); setColor(0, 255, 255); break;
				case Act.TAKE_DEFENSIN: setBoxText(Act.getTxt(i)); setIcon("-defend"); setColor(255, 0, 0); break;
				case Act.BUY_LYSOSOME: setBoxText(Act.getTxt(i)); setIcon("lysosome"); setColor(0, 255, 255); break;
				case Act.BUY_PEROXISOME: setBoxText(Act.getTxt(i)); setIcon("peroxisome"); setColor(0, 255, 255); break;
				case Act.DISABLE_AUTO_PEROXISOME: setBoxText(Act.getTxt(i)); setIcon("no_auto_peroxisome"); setColor(0, 0, 0); break;
				case Act.ENABLE_AUTO_PEROXISOME: setBoxText(Act.getTxt(i)); setIcon("auto_peroxisome"); setColor(0, 128, 255); break;
				
				case Act.BUY_SLICER: setBoxText(Act.getTxt(i)); setIcon("slicer"); setColor(0, 255, 255); break;
				case Act.BUY_RIBOSOME: setBoxText(Act.getTxt(i)); setIcon("ribosome"); setColor(0, 255, 255); break;
				case Act.BUY_DNAREPAIR: setBoxText(Act.getTxt(i)); setIcon("dnarepair"); setColor(0, 255, 255); break;
				case Act.MAKE_GOLGI: setBoxText(Act.getTxt(i)); setIcon("golgi"); setColor(0, 255, 255); break;
				case Act.MAKE_TOXIN: setBoxText(Act.getTxt(i)); setIcon("flask"); setColor(0, 255, 255); break;
			}
		}
		
	}
	
}
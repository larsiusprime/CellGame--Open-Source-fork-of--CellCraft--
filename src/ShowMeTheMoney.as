package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ShowMeTheMoney extends CanvasObject
	{
		public var icon:MovieClip;
		public var text:TextField;
		
		private var trueLoc:Point;
		private var trueLocTxt:Point;
		private var trueLocIcon:Point;
		
		private var type:String;
		private var amount:Number;
		
		private var zoom:Number = 1;

		private var offset:Number = 0;
		private const OFFSET_AMOUNT:Number = 30;
		
		private var zoomOffX:int = 0;
		
		private static const ZOOM_OUT_MAX:Number = 0.2; //from 0-this, show nothing
		private static const ZOOM_OUT_HIGH:Number = 0.3; //from MAX-this, show tiny 
		private static const ZOOM_OUT_LOW:Number = 0.4; //from HIGH-this, show mid 
		private static const ZOOM_OUT_MIN:Number = 1.0; //from LOW-this+, show normal 
		
		private const RISE_AMOUNT:Number = 30; //how many frames to rise for
		private var riseSpeed:Number = 1;		//how many screen-space pixels to rise each frame
		private var riseSign:Number = 1;		//how many screen-space pixels to rise each frame
		private var riseCount:Number = 0;
		
		private var scaleMode:Boolean = false;
		
		/**
		 * This class is the icon that shows up whenever you get or lose a resource
		 */
		
		public function ShowMeTheMoney(t:String,a:Number,xx:Number,yy:Number,speed:Number=1,off:Number=0,scMode:Boolean=true) 
		{
			trueLoc = new Point(xx, yy);
			trueLocTxt = new Point(text.x,text.y);
			//trueLocIcon = new Point(text.x,text.y);
			riseSpeed = speed;
			
			setType(t);
			setAmount(a);
			setScaleMode(scMode);
			
			offset = off;
			x = xx;
			y = yy - offset * (OFFSET_AMOUNT / zoom);
		}
		
		public function setScaleMode(mode:Boolean) {
			scaleMode = mode;
			matchZoom(zoom);
		}
		
		public override function destruct() {
			super.destruct();
			
		}
		
		
		public function setType(t:String) {
			type = t;
			icon.gotoAndStop(t);
		}
		
		public function setAmount(a:Number) {
			amount = a;
			var s:String = "";
			var s1:String = "";
			var c:uint;
			if(amount > 0){
				c = 0xFFFFFF;
				s = "+";
				riseSign = 1;
				setGlow(1);
				text.visible = true;
			}
			else if(amount < 0){
				c = 0xFF0000;
				
				s = "<font color=\"#FFFFFF\">";
				s1 = "</font>";
				riseSign = -1; //fall
				setGlow( -1);
				text.visible = true;
			}else if (amount == 0) {
				riseSign = 1;
				//setGlow(1);
				text.visible = false;
			}
			if(type != "fire"){
				text.htmlText = "<b>" + s + a.toFixed(0) + s1 + "</b>";
			}else {
				text.htmlText = "<b>" + s + a.toFixed(2) + s1 + "</b>";
			}
			addEventListener(RunFrameEvent.RUNFRAME, rise,false,0,true);
		}
		
		
		public override function matchZoom(n:Number) {
			zoom = n;
			super.matchZoom(n);
			x = trueLoc.x;
			y = trueLoc.y - offset * (OFFSET_AMOUNT / zoom);
			
			if(scaleMode){
				updateIcon();
				updateText();
			}
		}
		
		public function updateIcon() {
			icon.visible = true;
			if (zoom <= ZOOM_OUT_MAX) { //zoomed all the way out
				icon.visible = false;
			}else if (zoom <= ZOOM_OUT_HIGH) { //zoomed high
				icon.gotoAndStop(type + "_tiny");
			}else if (zoom <= ZOOM_OUT_LOW) {
				icon.gotoAndStop(type + "_");
			}else if (zoom <= ZOOM_OUT_MIN) {
				icon.gotoAndStop(type);
			}
		}
		
		public function setGlow(i:int) {
			var glow:GlowFilter;
			var glow2:GlowFilter;
			if(i == 1){
				glow = new GlowFilter(0x000000, 1, 4, 4, 5);
				text.filters = [glow];
			}else {
				glow = new GlowFilter(0xFF0000, 1, 3, 3, 3);
				glow2 = new GlowFilter(0x990000, 1, 3, 3, 3);
				text.filters = [glow,glow2];
			}
		}
		
		public function updateText() {
			text.visible = true;
			if (zoom <= ZOOM_OUT_MAX) { //zoomed all the way out
				zoomOffX = 0;
				text.visible = false;
			}else if (zoom <= ZOOM_OUT_HIGH) { //zoomed high
				zoomOffX = 10;
				if (amount < 0) 
					text.htmlText = "<b><font color=\"#FFFFFF\">-</b></font>";
				else if (amount > 0) 
					text.htmlText = "<b>+</b>";
				else 
					text.htmlText = "";
			}else if (zoom <= ZOOM_OUT_LOW) {
				zoomOffX = 5;
				setAmount(amount);
			}else if (zoom <= ZOOM_OUT_MIN) {
				zoomOffX = 0;
				setAmount(amount);
			}
			
			//text.x = trueLocTxt.x + zoomOffX;
		}
		
		private function rise(r:RunFrameEvent) {
			y -= riseSpeed * riseSign / zoom;
			riseCount++;
			if (riseCount > RISE_AMOUNT) {
				riseCount = 0;
				removeEventListener(RunFrameEvent.RUNFRAME,rise);
				terminate();
			}
		}
		
		private function terminate() {
			p_canvas.removeMeTheMoney(this);
		}
		
		
	}
	
}
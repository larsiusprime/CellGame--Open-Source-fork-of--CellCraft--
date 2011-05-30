package {
	
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.geom.ColorTransform;
	
	public class Zoomer extends MySlider{
		public var plus:SimpleButton;
		public var minus:SimpleButton;
		private const zRange:Number = 2;
		private var oldZoom:Number=0;
		private var zoomScale:Number=0.5;
		
		
		public function Zoomer(){
			
		}
		
		public override function init() {
			super.init();
			minus.addEventListener(MouseEvent.CLICK, doMinus);
			plus.addEventListener(MouseEvent.CLICK, doPlus);
			setValue(0.5);
			update();
		}
		
		private function doPlus(m:MouseEvent){
			handle.y -= step;
			if(handle.y < min)
				handle.y = min;
				
			update();
		}
		
		private function doMinus(m:MouseEvent){
			handle.y += step;
			if(handle.y > max)
				handle.y = max;
				
			update();
		}
		
		public function unTakeOver() {
			var t:ColorTransform = this.transform.colorTransform;
			//t.redOffset = 0;
			//this.transform.colorTransform = t;
		}
		
		public function takeOver() {
			var t:ColorTransform = this.transform.colorTransform;
			//t.redOffset = 255;
			//this.transform.colorTransform = t;
		}
		
		public function wheelZoom(i:int) {
			var j:int;
			if (i > 0) {
				for (j = 0; j < i; j++){
					doPlus(null);
				}
			}else if (i < 0) {
				for (j = 0; j > i; j--){
					doMinus(null);
				}
			}
		}
		
		public function getZoomScale():Number {
			return (zoomScale); 
		}
		
		/**
		 * Give me the scale you want in the game, I'll get the zoom
		 * @param	zoom
		 */
		
		public function setZoomScale(zs:Number) {
			//if you want .25 scale, that's going to be when the val is .75
			//that is 1 - zoomScale gives us .75
			zoomScale = zs;
			var val:Number = (1 - zoomScale);
			if (val < 0.1) val = 0.1;
			if (val > 1) val = 1;
			handle.y = val * range;

			update();
		}
		
		protected override function update() {
			
			super.update();
			
			var zoom:Number = (zRange-(_value * zRange) + 0.1); //
			
			if(oldZoom != zoom){
				p_master.changeZoom(zoom); //do this to get the right values
			}
			oldZoom = zoom;
			
			var val:Number = handle.y / range;
			val = 1 - val;
			zoomScale = val;
		}
	}
}
package {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class MySlider extends InterfaceElement{
		public var handle:Sprite;

		protected var _value:Number;
		protected var old_value:Number;
		
		protected var max:Number = 100;
		protected var min:Number = 0;
		protected var range:Number = max-min;
		protected var step:Number = range/50;
		protected var dragging:Boolean = false;
		
		
		public function MySlider(){
			//handle.y = range/2;

		}
		
		/**
		 * For your slider to properly work, it must manually have its init() function called! 
		 * This is to avoid runtime errors when the items are created via code and not having
		 * been placed on stage natively
		 */
		
		public function init() {
			handle.addEventListener(MouseEvent.MOUSE_DOWN,grabHandle);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,dropHandle);
			setValue(0);
		}
		
		public function setValue(v:Number){
			old_value = _value;
			_value = v;
			if(_value > 1)
				_value = 1;
			if(_value < 0)
				_value = 0;
			handle.y = _value*range;
			update();
		}
		
		//doesn't call certain callbacks to avoid recursive loops
		protected function hardSetValue(v:Number){
			old_value = _value;
			_value = v;
			if(_value > 1)
				_value = 1;
			if(_value < 0)
				_value = 0;
			handle.y = _value*range;
		}
		
		private function grabHandle(m:MouseEvent) {
			handle.startDrag(false, new Rectangle(handle.x,0,0,range));
			addEventListener(Event.ENTER_FRAME,doUpdate);
			dragging = true;
		}
				
		private function dropHandle(m:MouseEvent){
			handle.stopDrag();
			removeEventListener(Event.ENTER_FRAME,doUpdate);
			update();
			dragging = false;
		}
		
		private function doUpdate(e:Event){
			update();
		}
		

		protected function update(){
			old_value = _value;
			_value = handle.y/range;
		}
		
		//to be called externally only in order to set the handle, don't call any zoom functions!
		public function oldValue() {
			_value = old_value;
			handle.y = _value * range;
			//update();
		}
	}


}
package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class CustomRadio extends InterfaceElement{
	
		public var b1:MovieClip;
		public var b2:MovieClip;
		public var b3:MovieClip;
	
		var b_count:int = 3;
		var _value:int = 1;
			
		public function CustomRadio(){
			setup();
		}
		
		private function setup(){
			b1.addEventListener(MouseEvent.CLICK,click1);
			b2.addEventListener(MouseEvent.CLICK,click2);
			b3.addEventListener(MouseEvent.CLICK,click3);
		}
		
		private function click1(m:MouseEvent){
			select(b1);
			_value = 1;
		}
		
		private function click2(m:MouseEvent){
			select(b2);
			_value = 2;
		}
		
		private function click3(m:MouseEvent){
			select(b3);
			_value = 3;
		}
		
		private function select(m:MovieClip){
			for(var i:int = 1; i <= b_count; i++){
				MovieClip(getChildByName("b"+i)).gotoAndStop("off");
			}
			m.gotoAndStop("on");
		}
	}
}

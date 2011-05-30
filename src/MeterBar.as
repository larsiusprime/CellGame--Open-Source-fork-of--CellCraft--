package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;

	public class MeterBar extends Sprite{
	
		public var bar:MovieClip;
		
		protected var maxWidth:Number;
	
		public function MeterBar(){
			maxWidth = bar.width;
		}
		
		public function setColor(c:uint){
			var ct:ColorTransform = bar.transform.colorTransform;
			ct.color = c;
			bar.transform.colorTransform = ct;
		}
		
		public function setPercent(n:Number){
			if(n > 1) n = 1;
			if(n < 0) n = 0;
			bar.width = n*maxWidth;
		}
	
	}

}
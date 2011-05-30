package {

	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;

	public class MeterBar_resource extends MeterBar{
		
		//public var text_percent:TextField;
		private var percent:Number;
		public var over_bar:MovieClip;
				
		public function MeterBar_resource(){
		
		
		}
		
		public function setOverColor(c:uint){
			var ct:ColorTransform = over_bar.transform.colorTransform;
			ct.color = c;
			over_bar.transform.colorTransform = ct;
		}
		
		public override function setPercent(n:Number) {
			var over:Boolean = false;
			var over_n:Number = 0;
			
			if (n > 1) {
				over_n = n - 1;
				over = true;
				n = 1;
			}
			if(n < 0) n = 0;
			bar.width = n*maxWidth;
			percent = n * 100;
			percent = Math.floor(percent);
			
			if (over) {
				if (over_n > 1) {
					over_n = 1;
				}
				over_bar.width = over_n * maxWidth;
				over_bar.visible = true;
			}else {
				over_bar.visible = false;
			}
			//text_percent.text = String(percent) + "%";
		}
	
	}
}
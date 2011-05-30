package {
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.display.MovieClip;
	
	
	public class MiniCost extends InterfaceElement{
	
		public var cost_text:TextField;
		public var cost_icon:MovieClip;
		public var plus:MovieClip;
		
		private var isWhite:Boolean;
		private var type:String;
	
		public function MiniCost(){
			plus.visible = false;
		}
		
		public function setType(s:String){
			cost_icon.gotoAndStop(s);
			type = s;
		}
		
		public function setWhite() {
			isWhite = true;
			var f:GlowFilter = new GlowFilter(0x000000, 1, 3, 3, 600, 1, false, false);
			//var myfilt:Array = new Array();
			//myfilt.push(f);
			cost_text.filters = [f];
		}
	
		public function setAmount(n:Number, recycle:Boolean=false){
			var neg:Boolean = false;
			if(n >= 0){
				if (n < 10) {
					n = Math.floor(n*10)/10;
				}else{
					n = Math.floor(n);
				}
			}else{
				n = Math.floor(n);
				neg = true;
				n *= -1;
			}
			cost_text.htmlText = "<b>"+String(n)+"</b>";
			
			if(neg){
				cost_text.textColor = 0x00FF00;
				cost_text.filters = [new GlowFilter(0x000000, 1, 4, 4, 4)];
				plus.gotoAndStop(1);
				plus.visible = true;
			}else {
				cost_text.filters = [];
				if(!isWhite){
					cost_text.textColor = 0x000000;
				}else{
					cost_text.textColor = 0xFFFFFF;
					cost_text.filters = [new GlowFilter(0x000000, 1, 4, 4, 4)];
				}
				
					
					
				plus.gotoAndStop(2);
				plus.visible = false;
				if (recycle) { //show that we're just recycling this value
					cost_text.textColor = 0x0000FF;
					plus.gotoAndStop(3);
					plus.visible = true;
				}
				
			}
		}
	
	}
}
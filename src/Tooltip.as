package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Tooltip extends Sprite{
	
		public var box:MovieClip;
		public var arrow:MovieClip;
		public var text:TextField;
		
		private var shoveH:int=0; //-1, 0, 1 : -1(left), 0(center), 1(right)
		private var shoveV:int=1; //-1, 0, 1 : -1(top) , 0(side)  , 1(bottom)
	
		private var exists:Boolean = false;
	
		public function Tooltip(){
			checkSingleton();
			text.autoSize = TextFieldAutoSize.LEFT;
			setText("TOOLTIP");
			getOuttaHere();
		}
		
		private function checkSingleton(){
			if(exists){
				throw new Error("Singleton Violation : " + this + " already exists!");
			}else{
				exists = true;
			}
		}
		
		public function setText(s:String){
			text.text = s;
			
			box.width = text.width + 6;
			arrow.x = box.width/2 - arrow.width/2;
		}
	
		public function updateArrow(){
			if(shoveV == 0){
				if(shoveH == -1){
					arrow.rotation = 90;
				}else if(shoveH == 1){
					arrow.rotation = -90;
				}else{
					arrow.rotation = 0;
				}
			}else{
				arrow.rotation = 0;
			}
			
			if(shoveH == 0){
				arrow.x = box.x + box.width/2 - arrow.width/2;
				
			}
			else if(shoveH == -1){
				arrow.x = box.x + arrow.width;
				
			}else if(shoveH == 1){
				arrow.x = box.x + box.width - arrow.width;
			}
			
			if(shoveV == 0){
				arrow.y = box.y + box.height/2 + arrow.height/2 -1;
				arrow.x += arrow.width-2;
				arrow.scaleY = 1;

			}else if(shoveV == 1){
				arrow.rotation = 0;
				arrow.scaleY = 1;
				arrow.y = box.y + box.height - 2;
			}else{
				arrow.rotation = 0;
				arrow.scaleY = -1;
				arrow.y = box.y;
			}
			
			
		}
		
		public function updateBoxAndArrow(){
			if(shoveH == 1){
				box.x = - box.width + arrow.width/2;
			}else if(shoveH == -1){
				box.x = 0;
			}else{
				box.x = - box.width/2;
			}
			
			box.y = - box.height*2;
			text.x = box.x + 3;
			text.y = box.y + 3;
			
			updateArrow();
		}
	
		public function shoveArrow(){
			
		}
	
		public function showTextAt(s:String,xx:Number,yy:Number,sh:int,sv:int){
			shoveH = sh;
			shoveV = sv;
			x = xx;
			y = yy;
			setText(s);
			
			updateBoxAndArrow();
			visible = true;
		}
		
		public function hideIfText(s:String){
			if(text.text == s){
				getOuttaHere();
			}
		}
		
		public function getOuttaHere(){
			visible = false;
			x = 1000;
			y = 1000;
		}
	
	}

}
package {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class Temperature extends InterfaceElement{
		
		public var thermometer:MovieClip;
		public var tempText:TextField;
		
		private var temperature:int;
		
		public function Temperature(){
			setTemperature(25);
			setTTString("Temperature in degrees Celsius");
			//setTToff(5,15);
			tt_shove(1,0);
			setTToff(-20,50);
		}
		
		public function setTemperature(i:int){
			temperature = i;
			tempText.text = String(temperature);
			thermometer.gotoAndStop(i+1);
		}
		
	
	}

}
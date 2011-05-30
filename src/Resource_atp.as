package {

	import flash.display.Sprite;

	public class Resource_atp extends ResourceMeter{
	
		public function Resource_atp(){
			setAmounts(100,1000);
			setTTString("ATP : Adenosine Triphosphate(energy)");
			tt_shove(-1,-1);
			setTToff(-3,105);
		}
	
	}

}
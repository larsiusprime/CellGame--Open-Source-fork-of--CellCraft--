package  
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class MembraneHealth extends InterfaceElement
	{
		public var c_health:HealthGem;
		public var c_shield:ShieldGem;
		public var c_heading:MovieClip;
		
		public function MembraneHealth() 
		{
			
		}
		
		public function setHealth(i:int) {
			//trace("MembraneHealth.setHealth(" + i + ")");
			c_health.amount = i;
		}
		
		public function setShield(n:Number) {
			c_shield.amount = n;
			if (n <= 0) {
				c_shield.visible = false;
			}else {
				c_shield.visible = true;
			}
		}
		
		public override function blackOut() {
			super.blackOut();
			c_health.visible = false;
			c_shield.visible = false;
			c_heading.visible = false;
		}
		
		public override function unBlackOut() {
			super.unBlackOut();
			c_health.visible = true;
			
			if(c_shield.amount > 0){
				c_shield.visible = true;
			}
			c_heading.visible = true;
		}
		
	}
	
}
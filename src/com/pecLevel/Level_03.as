package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Level_03 extends BakedLevel
	{
		
		public function Level_03(e:Engine) 
		{
			
			super(e);
			
			if(Director.BAKED_MODE){
				//Baked Mode
				isBaked = true;
				myXML = new XML(new Director.Level_03_XML());
				bakeData();
			}else {
				//Debug Mode
				loadFile("level_03.xml");
			}
			
		}
		
	}
	
}
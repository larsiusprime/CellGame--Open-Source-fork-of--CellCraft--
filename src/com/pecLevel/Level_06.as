package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Level_06 extends BakedLevel
	{
		
		public function Level_06(e:Engine) 
		{
			
			super(e);
			
			if(Director.BAKED_MODE){
				//Baked Mode
				isBaked = true;
				myXML = new XML(new Director.Level_06_XML());
				bakeData();
			}else {
				//Debug Mode
				loadFile("level_06.xml");
			}
		}
		
	}
	
}
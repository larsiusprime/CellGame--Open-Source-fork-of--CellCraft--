package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Level_07 extends BakedLevel
	{
		
		public function Level_07(e:Engine) 
		{
			
			super(e);
			
			if(Director.BAKED_MODE){
				//Baked Mode
				isBaked = true;
				myXML = new XML(new Director.Level_07_XML());
				bakeData();
			}else {
				//Debug Mode
				loadFile("level_07.xml");
			}
		}
	}
	
}
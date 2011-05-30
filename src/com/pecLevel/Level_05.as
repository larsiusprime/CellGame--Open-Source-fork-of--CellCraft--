package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Level_05 extends BakedLevel
	{
		
		public function Level_05(e:Engine) 
		{
			
			super(e);
			
			if(Director.BAKED_MODE){
				//Baked Mode
				isBaked = true;
				myXML = new XML(new Director.Level_05_XML());
				bakeData();
			}else {
				//Debug Mode
				loadFile("level_05.xml");
			}
		}
	}
	
}
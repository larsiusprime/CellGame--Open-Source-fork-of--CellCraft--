package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Level_02 extends BakedLevel
	{
		
		public function Level_02(e:Engine) 
		{
			
			super(e);
			
			if(Director.BAKED_MODE){
				//Baked Mode
				isBaked = true;
				myXML = new XML(new Director.Level_02_XML());
				bakeData();
			}else {
				//Debug Mode
				loadFile("level_02.xml");
			}
		}
	}
	
}
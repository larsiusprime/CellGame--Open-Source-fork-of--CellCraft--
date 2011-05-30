package com.pecLevel 
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Level_04 extends BakedLevel
	{
		
		public function Level_04(e:Engine) 
		{
			
			super(e);
			
			if(Director.BAKED_MODE){
				//Baked Mode
				isBaked = true;
				myXML = new XML(new Director.Level_04_XML());
				bakeData();
			}else {
				//Debug Mode
				loadFile("level_04.xml");
			}
		}
		
	}
	
}
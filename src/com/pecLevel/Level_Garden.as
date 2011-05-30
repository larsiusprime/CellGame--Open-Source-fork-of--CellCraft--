package com.pecLevel{
	
	public class Level_Garden extends BakedLevel{
		
		public function Level_Garden(e:Engine){
			//Debug Mode
			super(e);
			
			loadFile("level_garden.xml");
			//loadFile("testLevel.xml");
			
			//Baked Mode
			/*myXML = new XML((<![CDATA[
				<cellcraft>
					<levelInfo>
						<level index="1" title="textLevel" />
						<size width="800" height="800" />
						<start x="400" y="400" />
						<background name="BackFile.png" />
					</levelInfo>
				
					<levelStuff>
						<goodies>
							<stuff name="General NA" type="nucleicAcid" count="10" spawn="0.5" />
							<stuff name="General FA" type="fattyAcid" count="5" spawn="0.9" />
						</goodies>
						<enemies>
							<stuff name="Virus Batch 1" type="virus" count="20" aggro="0.8" spawn="0.3" />	
						</enemies>
						<objects>
						</objects>
					</levelStuff>
				
					<levelThings>
						<goodies>
							<thing name="Glucose Pool" type="glucose" x="100" y="100" count="50" spawn="1" />
						</goodies>
						<enemies>
							<thing name="Angry Virus 1" type="virus" x="200" y="300" count="1" aggro="1.0" spawn="0" health="1.0" />
							<thing name="Angry Virus 2" type="virus" x="240" y="320" count="1" aggro="1.0" spawn="0" health="0.8" />
						</enemies>
						<objects>
							<thing name="Rock 1" type="rock" x="500" y="400" count="1" spawn="0" />
						</objects>
					</levelThings>
				</cellcraft>
				]]>).toString());
			bakeData();*/
		}
	}
}
package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.Boid;
	import com.cheezeworld.math.Vector2D;

	public class Alignment extends ABehavior implements IGroupBehavior
	{		
		public function Alignment()
		{
			super( AISettings.alignmentWeight, AISettings.alignmentPriority );
			averageHeading = new Vector2D();
		}
		
		public override function calculate():Vector2D
		{
			averageHeading.x=0;
			averageHeading.y=0;
			neighborCount=0;
			
			var i:int = agent.steering.neighbors.length;		
 			while( --i >= 0 )
 			{
				ob = agent.steering.neighbors[i];
				if( ob != agent )
				{
					averageHeading.x += ob.heading.x;
					averageHeading.y += ob.heading.y;
					neighborCount++;
				}
			}
			
			if( neighborCount > 0 )
			{
				averageHeading.x /= neighborCount;
				averageHeading.y /= neighborCount;
				
				averageHeading.x -= agent.heading.x;
				averageHeading.y -= agent.heading.y;
			}
			
			//trace( "<Alignment> avgHeading: " + averageHeading );
			return averageHeading;
		}
		
		private var averageHeading:Vector2D;
		private var ob:Boid;
		private var neighborCount:int;
		
	}
}
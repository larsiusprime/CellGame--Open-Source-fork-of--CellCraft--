package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.Boid;
	import com.cheezeworld.math.Vector2D;

	public class Cohesion extends ABehavior implements IGroupBehavior
	{
		
		public function Cohesion()
		{
			super( AISettings.cohesionWeight, AISettings.cohesionPriority );
			centerOfMass = new Vector2D();
			steeringForce = new Vector2D();
		}
		
		public override function calculate():Vector2D
		{
			centerOfMass.x=0;
			centerOfMass.y=0;
			steeringForce.x=0;
			steeringForce.y=0;
			neighborCount=0;
			
			var i:int = agent.steering.neighbors.length;		
 			while( --i >= 0 )
 			{
				neighbor = agent.steering.neighbors[ i ];
				if( neighbor != agent )
				{
					centerOfMass.x += neighbor.actualPos.x;
					centerOfMass.y += neighbor.actualPos.y;	
					neighborCount++;
				}				
			}
			
			if( neighborCount > 0 )
			{
				centerOfMass.x /= neighborCount;
				centerOfMass.y /= neighborCount;
				
				//steeringForce = Seek.calc( agent, centerOfMass ); ---- ( made algorithm local for speed )
				steeringForce.x = centerOfMass.x - agent.actualPos.x;
				steeringForce.y = centerOfMass.y - agent.actualPos.y;
				steeringForce.normalize();
				steeringForce.x *= agent.maxSpeed;
				steeringForce.y *= agent.maxSpeed;
				steeringForce.x -= agent.velocity.x;
				steeringForce.y -= agent.velocity.y;
				// ----------------------------------------------------
			}
			
			return steeringForce;
		}
		
		private var centerOfMass:Vector2D;
		private var steeringForce:Vector2D;
		private var neighborCount:int;
		private var neighbor:Boid;
		
	}
}
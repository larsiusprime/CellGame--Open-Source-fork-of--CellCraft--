package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.Boid;
	import com.cheezeworld.math.Vector2D;

	/**
	 * The agent will attempt to "dodge" or avoid other agents. 
	 * @author colby
	 * 
	 */	
	public class Seperation extends ABehavior implements IGroupBehavior
	{
		
		public var seperationDistance:Number	=	5;
		
		public function Seperation()
		{
			super( AISettings.separationWeight, AISettings.seperationPriority );
			steeringForce = new Vector2D();
			toAgent = new Vector2D();
		}
		
		public override function calculate():Vector2D
		{
			var normalized:Vector2D = new Vector2D;
			steeringForce.x=0;
			steeringForce.y=0;
			
			var i:int = agent.steering.neighbors.length;
 			while( --i >= 0 )
 			{
				neighbor = agent.steering.neighbors[ i ];
				if( neighbor != agent )
				{
					
					toAgent.x = agent.actualPos.x - neighbor.actualPos.x;
					toAgent.y = agent.actualPos.y - neighbor.actualPos.y;
					var len:Number = toAgent.length;
					len = ( len == 0 ? 0.001 : len );
					normalized.x = ( toAgent.x == 0 ? 0.001 : toAgent.x / len );
					normalized.y = ( toAgent.y == 0 ? 0.001 : toAgent.y / len );
					 
					steeringForce.x += ( -len / normalized.x );
					steeringForce.y += ( -len / normalized.y );
					 
				}				
			}
			return steeringForce;
		}
		
		private var steeringForce:Vector2D;
		private var neighbor:Boid;
		private var toAgent:Vector2D;
		
	}
}
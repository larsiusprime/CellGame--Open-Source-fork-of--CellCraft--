package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.*;
	import com.cheezeworld.math.Transformations;
	import com.cheezeworld.math.Vector2D;

	public class ObstacleAvoidance extends ABehavior
	{
		private const BRAKE_WEIGHT:Number = 0.2;
		
		public var obstacles:Array;
		
		public function ObstacleAvoidance( obstacles:Array )
		{
			super( AISettings.obstacleAvoidanceWeight, AISettings.obstacleAvoidancePriority );
			this.obstacles = obstacles;
			
		}
		
		public override function calculate():Vector2D
		{
			var localPosOfClosest:Vector2D;
			var ob:Entity;
			var toTarget:Vector2D;
			var localPos:Vector2D;
			
			var boxLength:Number = agent.radius*2 + ( agent.velocity.length / agent.maxSpeed ) * agent.radius*2;
			var distToClosest:Number = Number.POSITIVE_INFINITY;
			var closestIntersecting:Entity = null;
			
			// -- Create a list of all entities in the view range --
			var obstaclesInRange:Array = [];
			
			var i:int = obstacles.length;		
 			while( --i >= 0 )
 			{
				ob = obstacles[i];
				
				toTarget = ob.actualPos.subtractedBy( agent.actualPos );
				
				var range:Number = boxLength + ob.radius;
				
				if( ob != agent && toTarget.lengthSq < range * range )
				{
					obstaclesInRange.push( ob );
				}
			}
			
			i = obstaclesInRange.length;		
 			while( --i >= 0 )
 			{
				ob = obstaclesInRange[i];
				localPos = Transformations.pointToLocalSpace( ob.actualPos, agent.heading, agent.side, agent.actualPos );
				
				if( localPos.x >= 0 )
				{
					var expandedRadius:Number = ob.radius + agent.radius;
					
					if( localPos.y > -expandedRadius && localPos.y < expandedRadius )
					{
						//line/circle intersection test.
						//x = cX +/-sqrt(r^2-cY^2) for y=0.
						var cX:Number = localPos.x;
						var cY:Number = localPos.y;
						
						var sqrtPart:Number = Math.sqrt( expandedRadius * expandedRadius - cY * cY );
						var ip:Number = cX - sqrtPart;
						
						if( ip <= 0 ) ip = cX + sqrtPart;
						
						//test to see if this is closest, if so keep it
						if( ip < distToClosest )
						{
							distToClosest = ip;
							
							closestIntersecting = ob;
							
							localPosOfClosest = localPos;
						}
					}
				}
			}
			
			var steeringForce:Vector2D = new Vector2D();
			if( closestIntersecting != null )
			{
				//change steering force based on how close object is
				var multiplier:Number = 1 + ( boxLength - localPosOfClosest.x ) / boxLength;
				
				//calculate the lateral force
				steeringForce.y = ( closestIntersecting.radius - localPosOfClosest.y ) * multiplier;
				
				steeringForce.x = ( closestIntersecting.radius - localPosOfClosest.x ) * BRAKE_WEIGHT;
				
			}
			
			//convert back to world space
			return Transformations.vectorToWorldSpace( steeringForce, agent.heading, agent.side );
		}
	}
}
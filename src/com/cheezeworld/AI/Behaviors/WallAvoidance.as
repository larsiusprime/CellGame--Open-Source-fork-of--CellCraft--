//TODO - fix this...it doesn't work =/

package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.AI.Wall;
	import com.cheezeworld.math.Geometry;
	import com.cheezeworld.math.Transformations;
	import com.cheezeworld.math.Vector2D;

	public class WallAvoidance extends ABehavior
	{
		
		public var walls:Array;
		public var feelerLength:Number;
		
		public function WallAvoidance( a_walls:Array, a_feelerLength:Number=0 )
		{
			super( AISettings.wallAvoidanceWeight, AISettings.wallAvoidancePriority );
			this.walls = a_walls;
			feelerLength = a_feelerLength;					
		}
		
		public override function calculate():Vector2D
		{
			var temp:Vector2D;
			var feelers:Array = [];
			var wall:Wall;
			var distToThisIP:Number;
			var ip:Vector2D = new Vector2D();
			var closestIP:Vector2D;
			var overShoot:Vector2D;
			var closestWall:Wall;
			var steeringForce:Vector2D = new Vector2D();
			
			feelerLength = ( feelerLength == 0 ? feelerLength = agent.radius*3 : feelerLength );
			
			//create feelers -----------------------------------------------------------
			feelers[0] = agent.actualPos.addedTo( agent.heading.multipliedBy(feelerLength) );
			
			temp = agent.heading.copy();
			Transformations.rotateAroundOrigin( temp, 0.7853981633974483 ); // 45 degrees
			feelers[1] = agent.actualPos.addedTo( temp.multipliedBy(feelerLength*0.5) );
			
			temp = agent.heading.copy();
			Transformations.rotateAroundOrigin( temp, -0.7853981633974483 );
			feelers[2] = agent.actualPos.addedTo( temp.multipliedBy(feelerLength*0.5) );
			// -------------------------------------------------------------------------
			
			var distToClosestIP:Number = Number.MAX_VALUE;
			
			closestWall = null;
			
			var j:int = walls.length-1;
			for(var i:int = 0; i < 3; ++i) // for each feeler
			{
				while( j >= 0 ) // for each wall
				{
					wall = walls[ j-- ];
					distToThisIP = Geometry.lineIntersection( agent.actualPos, feelers[ i ], wall.fromPoint, wall.toPoint, ip );
					if( distToThisIP && distToThisIP < distToClosestIP )
					{
						distToClosestIP = distToThisIP;
						closestWall = wall;
						closestIP = ip;
					}
				} //next wall
				
				if( closestWall )
				{
					overShoot = feelers[i].subtractedBy( closestIP );
					
					steeringForce.addTo( closestWall.normal.multipliedBy( overShoot.length ));
				}
			}//next feeler
			
			return steeringForce;
										
		}
		
		private const HALF_PI:Number = Math.PI / 2;
		
	}
}
package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.MovingEntity;
	import com.cheezeworld.math.Transformations;
	import com.cheezeworld.math.Vector2D;

	public class OffsetPursuit extends ABehavior
	{
		
		public var leader:MovingEntity;
		public var offset:Vector2D;
		
		public function OffsetPursuit( a_leader:MovingEntity, a_offset:Vector2D )
		{
			super( AISettings.offsetPursuitWeight, AISettings.offsetPursuitPriority );
			leader = a_leader;
			offset = a_offset;
		}
		
		public override function calculate():Vector2D
		{
			if( leader == null )
			{
				return new Vector2D();
			}
			var worldOffsetPos:Vector2D = Transformations.pointToWorldSpace( offset, leader.heading, leader.side, leader.actualPos );
			var toOffset:Vector2D = worldOffsetPos.subtractedBy( agent.actualPos );
			
			var lookAheadTime:Number = toOffset.length / ( agent.maxSpeed + leader.velocity.length );
			
			return Arrive.calc( agent, worldOffsetPos.addedTo( leader.velocity.multipliedBy( lookAheadTime ) ), AISettings.arriveFast );
		}
		
	}
}
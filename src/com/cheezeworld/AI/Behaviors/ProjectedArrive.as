package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.MovingEntity;
	import com.cheezeworld.math.Vector2D;
	import com.cheezeworld.screens.*;

	public class ProjectedArrive extends ABehavior
	{
		
		public function get speed():int{ return m_speed; }
		public function set speed( value:int ):void
		
		{
			if( value != AISettings.arriveFast && value != AISettings.arriveNormal && value != AISettings.arriveSlow )
			{
				value = AISettings.arriveNormal;
				trace( "<ProjectedArrive>> Unknown value supplied. Defaulting to NORMAL" );
			}
			m_speed = value;
						
		}
		
		public var target:Vector2D;
		public var projectionDistance:Number;
		
		public function ProjectedArrive( a_target:Vector2D, a_projectionDistance:Number, a_decelerationSpeed:int=3 )
		{
			super( AISettings.arriveWeight, AISettings.arrivePriority );
			target = a_target;
			speed = a_decelerationSpeed;
			projectionDistance = a_projectionDistance
		}
		
		public override function calculate():Vector2D
		{
			var normalized:Vector2D = agent.actualPos.subtractedBy( target ).getNormalized();
			var newTarget:Vector2D = target.addedTo( normalized.multipliedBy( projectionDistance ) );
			
			var toTarget:Vector2D = newTarget.subtractedBy( agent.actualPos );
			var dist:Number = toTarget.length;
			
			if( dist > 0.01 )
			{
				var spd:Number = dist / ( m_speed * AISettings.speedTweaker );

				spd = ( spd > agent.maxSpeed ? agent.maxSpeed : spd ); 
				
				toTarget.multiply( spd / dist );
				return toTarget.subtractedBy( agent.velocity );
			}
			return new Vector2D();
			
			
		}
		
		public static function calc( agent:MovingEntity, target:Vector2D, projectionDistance:Number, speed:int=3 ):Vector2D
		{			
			var normalized:Vector2D = agent.actualPos.subtractedBy( target ).getNormalized();
			var newTarget:Vector2D = target.addedTo( normalized.multipliedBy( projectionDistance ) );
			
			var toTarget:Vector2D = newTarget.subtractedBy( agent.actualPos );
			var dist:Number = toTarget.length;
			
			if( dist > 0.01 )
			{
				var spd:Number = dist / ( speed * AISettings.speedTweaker );

				spd = ( spd > agent.maxSpeed ? agent.maxSpeed : spd );
				
				toTarget.multiply( spd / dist );
				
				return toTarget.subtractedBy( agent.velocity );
			}
			return new Vector2D();
		}
		
		private var m_speed:int;
		
		
	}
}
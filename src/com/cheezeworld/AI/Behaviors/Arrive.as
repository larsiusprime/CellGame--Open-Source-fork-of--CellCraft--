package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.MovingEntity;
	import com.cheezeworld.math.Vector2D;
	import com.cheezeworld.screens.*;

	public class Arrive extends ABehavior
	{
		
		public function get speed():int{ return m_speed; }
		public function set speed( value:int ):void
		{
			if( value != AISettings.arriveFast && value != AISettings.arriveNormal && value != AISettings.arriveSlow )
			{
				value = AISettings.arriveNormal;
				trace( "<Arrive:set speed> Unknown value supplied. Defaulting to NORMAL" );
			}
			m_speed = value;
						
		}
		
		public var target:Vector2D;
		
		public function Arrive( a_target:Vector2D, a_decelerationSpeed:int=3 )
		{
			super( AISettings.arriveWeight, AISettings.arrivePriority );
			target = a_target;
			speed = a_decelerationSpeed;
		}
		
		public override function calculate():Vector2D
		{
			var toTarget:Vector2D = target.subtractedBy( agent.actualPos );
			var dist:Number = toTarget.length;
			
			if( dist > 0.01 )
			{
				var spd:Number = dist / ( m_speed * AISettings.speedTweaker );

				spd = ( spd > agent.maxSpeed ? agent.maxSpeed : spd );
				
				toTarget.multiply( spd / dist );
				toTarget.subtract( agent.velocity );
				return toTarget;
			}
			return new Vector2D();
		}
		
		public static function calc( a_agent:MovingEntity, a_target:Vector2D, a_speed:int=3 ):Vector2D
		{			
			var toTarget:Vector2D = a_target.subtractedBy( a_agent.actualPos );
			var dist:Number = toTarget.length;
			
			if( dist > 0.01 )
			{
				var spd:Number = dist / ( a_speed * AISettings.speedTweaker );

				spd = ( spd > a_agent.maxSpeed ? a_agent.maxSpeed : spd );
				
				toTarget.multiply( spd / dist );
				toTarget.subtract( a_agent.velocity );
				return toTarget;
			}
			return new Vector2D();
		}
		
		private var m_speed:int;
		
		
	}
}


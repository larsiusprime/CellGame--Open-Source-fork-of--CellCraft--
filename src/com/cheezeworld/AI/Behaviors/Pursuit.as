package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.MovingEntity;
	import com.cheezeworld.math.Vector2D;

	public class Pursuit extends ABehavior
	{
		public function get evader() : MovingEntity { return m_evader; }
		public function set evader( a_agent:MovingEntity ) : void
		{
			m_evader = a_agent;
			m_target = a_agent.actualPos;
		}
		
		public var seekDistSq:Number;
		
		public function Pursuit( a_evader:MovingEntity, a_seekDistSq:Number=0 )
		{
			m_evader = a_evader;
			m_target = m_evader.actualPos;
			seekDistSq = a_seekDistSq;
			
			super( AISettings.pursuitWeight, AISettings.pursuitPriority );
		}
		
		public override function calculate():Vector2D
		{
			var toEvader:Vector2D = m_evader.actualPos.subtractedBy(agent.actualPos);
			
			if( toEvader.lengthSq > seekDistSq && seekDistSq > 0 )
			{
				return new Vector2D();
			} 
			
			var relativeHeading:Number = agent.heading.dotOf(m_evader.heading);
			
			if( ( toEvader.dotOf( agent.heading ) > 0 ) && ( relativeHeading < -0.95 ) ) //acos(0.95)=18 degs
			{ 
				m_target = m_evader.actualPos;
				return ( m_target.subtractedBy( agent.actualPos).getNormalized() ).multipliedBy( agent.maxSpeed ).subtractedBy( agent.velocity );
			}
			
			var lookAheadTime:Number = toEvader.length / ( agent.maxSpeed + m_evader.velocity.length );
			//lookAheadTime += turnAroundTime();
			
			m_target = m_evader.actualPos.addedTo( m_evader.velocity.multipliedBy( lookAheadTime ) );
			return ( m_target.subtractedBy( agent.actualPos ).getNormalized() ).multipliedBy( agent.maxSpeed ).subtractedBy( agent.velocity );
		}
		
		public static function calc( a_agent:MovingEntity, a_evader:MovingEntity, a_seekDistSq:Number = 0 ):Vector2D
		{
			var target:Vector2D;
			var toEvader:Vector2D = a_evader.actualPos.subtractedBy( a_agent.actualPos );
			
			if( toEvader.lengthSq > a_seekDistSq && a_seekDistSq > 0 )
			{
				return new Vector2D();
			} 
			
			var relativeHeading:Number = a_agent.heading.dotOf( a_evader.heading );
			
			if( ( toEvader.dotOf( a_agent.heading ) > 0 ) && ( relativeHeading < -0.95 ) ) //acos(0.95)=18 degs
			{ 
				target = a_evader.actualPos;
				return ( target.subtractedBy( a_agent.actualPos ).getNormalized() ).multipliedBy( a_agent.maxSpeed ).subtractedBy( a_agent.velocity );
			}
			
			var lookAheadTime:Number = toEvader.length / ( a_agent.maxSpeed + a_evader.velocity.length );
			//lookAheadTime += turnAroundTime();
			
			target = a_evader.actualPos.addedTo( a_evader.velocity.multipliedBy( lookAheadTime ) );
			return ( target.subtractedBy( a_agent.actualPos ).getNormalized() ).multipliedBy( a_agent.maxSpeed ).subtractedBy( a_agent.velocity );
		}
		
		private function turnAroundTime():Number
		{
			var toTarget:Vector2D = m_target.subtractedBy( agent.actualPos ).getNormalized();
			var dot:Number = agent.heading.dotOf( toTarget );
			
			//tweak this number to effect the time. EX:
			//If vehicle is heading opposite then 0.5 will mean
			//a 1 second turnaround time is returned
			var coefficient:Number = 0.5;
			
			return ( dot - 1.0 ) * -coefficient;
		}
		
		private var m_evader:MovingEntity;
		private var m_target:Vector2D;
		
	}
}
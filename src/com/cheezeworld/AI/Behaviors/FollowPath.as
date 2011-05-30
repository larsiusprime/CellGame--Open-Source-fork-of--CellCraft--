package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.math.Vector2D;

	public class FollowPath extends ABehavior
	{
		
		public var path:Array;
		public var seekDistanceSq:Number;
		public var isPatrolling:Boolean;
		
		/**
		 * Agent will follow a set path 
		 * @param a_path
		 * @param a_pathSeekDistance
		 * 
		 */		
		public function FollowPath( a_path:Array, a_isPatrolling:Boolean = false, a_pathSeekDistanceSq:Number = 900 )
		{
			super( AISettings.followPathWeight, AISettings.followPathPriority, AISettings.followPathProbability );
			path = a_path;
			seekDistanceSq = a_pathSeekDistanceSq;
			isPatrolling = a_isPatrolling;
		}
		
		public override function calculate():Vector2D
		{
			var len:int = path.length;
			
			if( path[ m_wpIndex ].distanceSqTo( agent.actualPos ) < seekDistanceSq )
			{
				( ++m_wpIndex >= len && isPatrolling  ) ? m_wpIndex = 0 : m_wpIndex;
			}
			
			return ( m_wpIndex < len ? Seek.calc( agent, path[ m_wpIndex ] ) : Arrive.calc( agent, path[ m_wpIndex ] )) ;
		}
		
		private var m_wpIndex:int;
		
	}
}
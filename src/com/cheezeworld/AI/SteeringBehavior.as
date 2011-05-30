// TODO -- create 2nd calculation method which uses percentages

package com.cheezeworld.AI
{
	import com.cheezeworld.AI.Behaviors.*;
	import com.cheezeworld.entity.Boid;
	import com.cheezeworld.entity.Entity;
	import com.cheezeworld.entity.GameWorld;
	import com.cheezeworld.math.Vector2D;

	
	public class SteeringBehavior
	{
		public static const CALCULATE_SUM:int		=	0; //Simply adds up all of the behaviors and truncates them to the max acceleration
		public static const CALCULATE_SPEED:int		=	1; // Prioritized Dithering
		public static const CALCULATE_ACCURACY:int 	= 	2; // Weighted Truncated Running Sum with Prioritization
		
		public var behaviors:Array;
		public var neighbors:Array;
		public var calculateMethod:int = CALCULATE_ACCURACY;
		
		public function SteeringBehavior( a_agent:Boid, a_calculationMethod:int = CALCULATE_ACCURACY )
		{
			calculateMethod = a_calculationMethod;
			m_agent = a_agent;
			m_force = new Vector2D();
			behaviors = [];
			neighbors = [];
		}
		
		public function addBehavior( behavior:ABehavior ):void
		{
			behaviors.push( behavior );
			behavior.agent = m_agent;
			m_hasChanged = true;
			if( behavior is IGroupBehavior ) m_hasGroupBehavior=true;
		}
		
		public function getBehavior( behaviorClass:Class ) : ABehavior
		{
			for each( var behavior:ABehavior in behaviors )
			{
				if( behavior is behaviorClass )
				{
					return behavior;
				}
			}
			throw new Error( "<SteeringBehavior> Behavior does not exist!" );
		}
		
		public function removeBehavior( behavior:Class ):void
		{
			var behaviorToRemove:ABehavior;

			for( var i:int = 0; i < behaviors.length; i++ )
			{				
				if( behaviors[ i ] is behavior )
				{
					behaviorToRemove = behaviors[ i ];
					break;
				}
			}
			
			behaviors.splice( i, 1 );
			if( m_hasGroupBehavior && behaviorToRemove is IGroupBehavior )
			{
				i = behaviors.length;		
	 			while( --i >= 0 )
	 			{
					if( behaviors[ i ] is IGroupBehavior )
					{
						return;	
					}
				}
				m_hasGroupBehavior = false;
			}
			
		}
		
		public function clearBehaviors():void
		{
			behaviors = [];
			m_hasGroupBehavior = false;
		}
		
		public function calculate():Vector2D
		{
			if( m_hasChanged )
			{
				sort();
				m_hasChanged=false;
			}  
			m_force.x=0; m_force.y=0;

			if( m_hasGroupBehavior )
			{
				neighbors = [];
				var dist:Number = m_agent.neighborDistance * m_agent.neighborDistance;
				for each( var entity:Entity in m_agent.parent.getChildren() )
				{
					if( entity is Boid && entity.actualPos.distanceSqTo( m_agent.actualPos ) < dist )
					{
						neighbors.push( entity );
					}
				}
				
			}
			
			switch( calculateMethod )
			{
				case CALCULATE_SUM:
					runningSum();
					break;
				case CALCULATE_SPEED:
					prioritizedDithering();
					break;
				case CALCULATE_ACCURACY:
					wtrsWithPriorization();
					break;
				default:
					throw new Error( "<SteeringBehavior> Error: '" + calculateMethod + "' is an invalid calculation method." );
			}
			
			return m_force;
		}
		
		private function prioritizedDithering() : void
		{
			var i:int = behaviors.length;		
 			while( --i >= 0 )
 			{
				var behavior:ABehavior = behaviors[ i ];
				if( Math.random() < behavior.probability )
				{
					m_force.addTo( behavior.calculate().multipliedBy( behavior.weight ));	
				}				
				
				if( !m_force.isZero() )
				{
					m_force.truncate( m_agent.maxAcceleration );
					return;
				}	
			}
		}
		
		private function wtrsWithPriorization() : void
		{
			var i:int = behaviors.length;		
 			while( --i >= 0 )
 			{
				var behavior:ABehavior = behaviors[ i ];
				
				if( !accumulateForce( m_force, behavior.calculate().multipliedBy( behavior.weight ))) return;	
			}
		}
		
		private function runningSum() : void
		{
			var i:int = behaviors.length;		
 			while( --i >= 0 )
 			{
				var behavior:ABehavior = behaviors[ i ];
				m_force.addTo( behavior.calculate().multipliedBy( behavior.weight ));
			}			
			
			m_force.truncate( m_agent.maxAcceleration );
		}
		
		/**
		 * Adds the force to the running total 
		 * @param a_runningTotal the total of the steering forces so far
		 * @param a_forceToAdd the next steering force to add
		 * @return Returns false if there is no more force left to use.
		 * 
		 */		
		private function accumulateForce( a_runningTotal:Vector2D, a_forceToAdd:Vector2D ) :Boolean
		{
			var magnitudeSoFar:Number = a_runningTotal.length;
			var magnitudeRemaining:Number = m_agent.maxAcceleration - magnitudeSoFar;
			if( magnitudeRemaining <= 0 ) return false;
			
			var magnitudeToAdd:Number = a_forceToAdd.length;
			
			if( magnitudeToAdd < magnitudeRemaining )
			{
				a_runningTotal.x += a_forceToAdd.x;
				a_runningTotal.y += a_forceToAdd.y;
				return true;
			}
			else
			{
				a_runningTotal.addTo( a_forceToAdd.getNormalized().multipliedBy( magnitudeRemaining ) );
				return false;
			}
		}
		
		
		
		public function dispose():void
		{
			behaviors = null;
			neighbors = null;
			m_world = null;
			m_force = null;
			m_agent = null;
		}
		
		// -- PRIVATE --
		
		private function sort():void
		{
			behaviors.sort(behaviorsCompare);
		}
		
		private function behaviorsCompare( a:ABehavior, b:ABehavior ):int
		{
			if( a.priority < b.priority ) return 1;
			if( a.priority == b.priority ) return 0;
			return -1;
		}
		
		private var m_world:GameWorld;
		private var m_hasChanged:Boolean;
		private var m_hasGroupBehavior:Boolean;
		private var m_force:Vector2D;
		private var m_agent:Boid;

	}
}
package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.AI.AISettings;
	import com.cheezeworld.entity.MovingEntity;
	import com.cheezeworld.math.Vector2D;

	public class Interpose extends ABehavior
	{
		
		public var targetA:MovingEntity;
		public var targetB:MovingEntity;
		
		public function Interpose(targetA:MovingEntity, targetB:MovingEntity)
		{
			super( AISettings.interposeWeight, AISettings.interposePriority );
			this.targetA = targetA;
			this.targetB = targetB;
		}
		
		public override function calculate():Vector2D
		{
			midPoint = ( targetA.actualPos.addedTo(targetB.actualPos ) ).dividedBy( 2 );
			
			var timeToReachMidPoint:Number = agent.actualPos.distanceTo(midPoint) / agent.maxSpeed;
			
			posA = targetA.actualPos.addedTo( targetA.velocity.multipliedBy( timeToReachMidPoint ) );
			posB = targetB.actualPos.addedTo( targetB.velocity.multipliedBy( timeToReachMidPoint ) );
			
			midPoint = ( posA.addedTo( posB ) ).dividedBy( 2 );
			
			return Arrive.calc( agent, midPoint, AISettings.arriveFast );
		}
		
		private var midPoint:Vector2D;
		private var posA:Vector2D;
		private var posB:Vector2D;
		private var toTarget:Vector2D;
		
	}
}
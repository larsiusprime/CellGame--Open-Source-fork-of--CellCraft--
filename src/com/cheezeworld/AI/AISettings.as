package com.cheezeworld.AI
{
	public class AISettings
	{
		public function AISettings()
		{
			
		}
		
		// Arrive speed settings
		public static var speedTweaker:Number	=	.3;
		public static var arriveFast:Number		=	1;
		public static var arriveNormal:Number	=	3;
		public static var arriveSlow:Number		=	5;
		
		// Wander Settings
		public static var wanderJitter:Number	=	300; // ( per second )
		public static var wanderDistance:Number	=	25;
		public static var wanderRadius:Number	=	15;
		
		// Probabilities - Used to determine the chance that the Prioritized Dithering ( fastest ) calculation method will run a behavior
		public static var separationProbability:Number			=	0.2;
		public static var cohesionProbability:Number			=	0.6;
		public static var alignmentProbability:Number			=	0.3;
		
		public static var dodgeProbability:Number			=	0.6;
		
		public static var seekProbability:Number				=	0.8;
		public static var fleeProbability:Number				=	0.6;
		public static var pursuitProbability:Number				=	0.8;
		public static var evadeProbability:Number				=	1;
		public static var offsetPursuitProbability:Number		=	0.8;
		public static var arriveProbability:Number				=	0.5;
		
		public static var obstacleAvoidanceProbability:Number	=	0.5;
		public static var wallAvoidanceProbability:Number		=	0.5;
		public static var hideProbability:Number				=	0.8;
		public static var followPathProbability:Number			=	0.7;
		
		public static var interposeProbability:Number			=	0.8;		
		public static var wanderProbability:Number				=	0.8;
		
		// Weights - Scalar to effect the weights of individual behaviors
		public static var separationWeight:Number			=	1;
		public static var alignmentWeight:Number			=	3;
		public static var cohesionWeight:Number				=	2;
		
		public static var dodgeWeight:Number				=	1;		
		
		public static var seekWeight:Number					=	1;
		public static var fleeWeight:Number					=	1;
		public static var pursuitWeight:Number				=	1;
		public static var evadeWeight:Number				=	0.1;
		public static var offsetPursuitWeight:Number		=	1;
		public static var arriveWeight:Number				=	1;
		
		public static var obstacleAvoidanceWeight:Number	=	3;
		public static var wallAvoidanceWeight:Number		=	10;
		public static var hideWeight:Number					=	1;
		public static var followPathWeight:Number			=	0.5;
		
		public static var interposeWeight:Number			=	1;		
		public static var wanderWeight:Number				=	1;
		
		// Priorities - Order in which behaviors are calculated ( lower numbers get calculated first )
		public static var wallAvoidancePriority:Number		=	10;
		public static var obstacleAvoidancePriority:Number	=	20;
		public static var evadePriority:Number				=	30;
		public static var hidePriority:Number				=	35;
		
		public static var seperationPriority:Number			=	40;
		public static var alignmentPriority:Number			=	50;
		public static var cohesionPriority:Number			=	60;
		
		public static var dodgePriority:Number				=	65;
		
		public static var seekPriority:Number				=	70;
		public static var fleePriority:Number				=	80;
		public static var arrivePriority:Number				=	90;
		public static var pursuitPriority:Number			=	100;
		public static var offsetPursuitPriority:Number		=	110;
		public static var interposePriority:Number			=	120;
		public static var followPathPriority:Number			=	130;
		public static var wanderPriority:Number				=	140;
		

	}
}
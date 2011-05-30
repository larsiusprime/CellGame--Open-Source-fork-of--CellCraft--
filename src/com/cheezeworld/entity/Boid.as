package com.cheezeworld.entity
{
	import com.cheezeworld.AI.SteeringBehavior;
	import com.cheezeworld.math.Vector2D;
	import com.cheezeworld.rendering.*;
	import com.cheezeworld.screens.*;
	import com.cheezeworld.utils.*;
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;;

	public class Boid extends MovingEntity
	{

 		/**
 		 * The distance that this Vehicle will percieve other Vehicles to be within it's "neighborhood" 
 		 */		
 		public var neighborDistance:Number; 					
  		public var steering:SteeringBehavior;
 		
 		//INITIALIZATION -----------------------------------------------------------------------------------
 		
		/**
		 * Extended MovingVehicle. Used to add steering behaviors. 
		 * @param params
		 * 
		 */ 		
		public function Boid( a_params:BoidParams )
		{
			super( a_params );
			
 			neighborDistance = a_params.neighborDistance;
			
			steering = new SteeringBehavior(this);
 		}
 		// -------------------------------------------------------------------------------------------------
 		
 		
 		
 		override public function update(timePassed:int):void
 		{
 			
 			setInitialValues(timePassed);
			
			calculateForces()	 
			
			calculateSteering(); 			
 			
 			calculateFinalVelocity();
 			
 			updateHeading();

 			updatePosition();
 			
 			updateChildren( timePassed );
 		}
 		
 		public override function dispose():void
 		{
 			_parent = null;
 			steering.dispose();
 			steering = null;
 			super.dispose();
 		}
 		
 		// -- PRIVATE --
 		
 		protected function calculateSteering():void
 		{
 			acc = steering.calculate();		
 			velocity.x += acc.x;
 			velocity.y += acc.y;
 		}
 	}
}
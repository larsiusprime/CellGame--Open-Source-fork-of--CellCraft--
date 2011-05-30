package com.cheezeworld.AI.Behaviors
{
	import com.cheezeworld.entity.Boid;
	import com.cheezeworld.math.Vector2D;
	
	public class ABehavior
	{
		
		public var weight:Number;		// Amount the final force will be scaled by
		public var probability:Number;	// Probability this will be calculated in prioritized dithering
		public var priority:int;		// Order in which this will be calculated vs other behaviors
		public var agent:Boid;
		
		public function ABehavior( a_weight:Number=1, a_priority:int=1, a_probability:Number=1 )
		{
			this.weight = a_weight;
			this.priority = a_priority;
			this.probability = a_probability;
		}
		
		public function calculate():Vector2D
		{
			throw new Error( "<ABehavior> Abstract function -- Must be overriden!" );
		}
	}
}
package com.cheezeworld.entity
{
	public class BoidParams extends MovingEntityParams
	{
		public var neighborDistance:Number;
		
		public function BoidParams( a_params:Object = null )
		{
			neighborDistance = 0;
			
			super( a_params );
		}
		
	}
}
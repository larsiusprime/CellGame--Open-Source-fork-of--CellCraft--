/* 
Copyright 2008 Cheezeworld.com 

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.cheezeworld.entity
{
	
	import com.cheezeworld.math.*;
	
	import flash.utils.Dictionary;
	
	public class MovingEntity extends Entity
	{
		private const BOUNCE_STOP_SPEED:Number		 = 50;
		
		public static const BOUNDS_BOUNCE:String = "bounce";
		public static const BOUNDS_WRAP:String	 = "wrap";
		public static const BOUNDS_REMOVE:String = "remove";
		public static const BOUNDS_NONE:String 	 = "none";
	
		/** CAUTION!
		 * The heading variable is left open for speed purposes, however it should only be set externally
		 * using the setHeading function! The side variable should never be set externally.
		 */				
		public function setHeading( a_value:Vector2D ):void
		{
	  		if(a_value.lengthSq==0)
	  		{
	  			heading.x=1;heading.y=0;
	  		} else 
	  		{
	  			heading=a_value;
	  		}
	  		side = heading.getPerp();
	  	}
		
		/**
		 * This should never be set externally, unless there is a good reason... 
		 */		
		public var velocity:Vector2D;			// Speed per second
		public var acc:Vector2D;				// Keeping this as a public so it can be visible for debug etc
		public var maxAcceleration:Number;		// Speed per second to accelerate
		public var friction:Number;				// Amount to slow down velocity when hitting things
		public var damping:Number;				// Amount to slow down the velocity by each tick
		public var heading:Vector2D;			// The direction this entity is going
		public var side:Vector2D;				// Parallel to heading
	  	public var maxSpeed:Number;				// Max speed per second
	  	public var boundsBehavior:String;		// What to do when this entity passes edges
	  	public var doesRotMatchHeading:Boolean;	// Will the rotation be locked to the direction the entity is "heading"
	  	public var maxTurnRate:Number;			// Degrees per second, 0 for unlimited rotation speed
		
		public function MovingEntity( a_params:MovingEntityParams )
		{
			super( a_params );
			
			velocity = new Vector2D();
	 		heading = new Vector2D( 1, 0 );
	 		side = heading.getPerp();
	 		_forces = [];
	 		_constantForces = new Dictionary();
	 		_oldVelocity = new Vector2D();
	 		
	 		doesRotMatchHeading = a_params.doesRotMatchHeading;
	 		maxSpeed = a_params.maxSpeed;
	 		maxAcceleration = a_params.maxAcceleration;
	 		boundsBehavior = a_params.boundsBehavior;
	 		friction = a_params.friction;
	 		damping = a_params.damping;
	 		maxTurnRate = a_params.maxTurnRate;
		}
		
		public function rotateToPosition( a_target:Vector2D ) : void
		{
			rotation = Math.atan2( a_target.y - actualPos.y, a_target.x - actualPos.x );
	 	}
		
		public function applyForce( a_force:Vector2D ):void
		{
			_forces.push( a_force );
		}
		
		public function addConstantForce( a_force:Vector2D, a_id:String ) : void
		{
			_constantForces[ a_id ] = a_force;
		}
		
		public function removeForce( a_id:String ) : void
		{
			delete _constantForces[ a_id ];
			_constantForces[ a_id ] = null;
		}
	 	
	 	public override function update( a_timePassed:int ):void
		{
			setInitialValues(a_timePassed);
			
			calculateForces();
			
			calculateFinalVelocity();
			
	 		updatePosition();
	 		
	 		updateHeading();
	 		
	 		updateChildren( a_timePassed );
		}
	 	
	 	override public function dispose():void
	 	{
	 		_forces = null;
	 		_constantForces = null;
	 		_oldVelocity = null;
	 		velocity = null;
	 		heading = null;
	 		side = null;
	 		super.dispose();
	 	}
	 	
	 	// -- PRIVATE --
	 	
	 	override protected function setInitialValues( a_timePassed:int ):void
	 	{		
	 		_stepSize = a_timePassed * 0.001;
	 		actualPos.x = newPos.x;
			actualPos.y = newPos.y;
	 		
	 		// .. Update bounds ...
	 		bounds.center.x = actualPos.x
			bounds.center.y = actualPos.y;
			bounds.left = bounds.center.x - bounds.halfWidth;
			bounds.right = bounds.center.x + bounds.halfWidth;
			bounds.top = bounds.center.y - bounds.halfHeight;
			bounds.bottom = bounds.center.y + bounds.halfHeight;
			bounds.topLeft.x = bounds.left; 
			bounds.topLeft.y = bounds.top;
			bounds.bottomRight.x = bounds.right; 
			bounds.bottomRight.y = bounds.bottom;
			bounds.topRight.x = bounds.right; 
			bounds.topRight.y = bounds.top;
			bounds.bottomLeft.x = bounds.left; 
			bounds.bottomLeft.y = bounds.bottom;
			
			_oldVelocity.x = velocity.x;
			_oldVelocity.y = velocity.y;
	 	}
	 	
	 	protected function calculateForces():void
	 	{ 	
	 		acc = new Vector2D();
					
			var force:Vector2D;
			var i:int = _forces.length;
	 		while( --i >= 0 )
	 		{
				force = _forces[i];
				acc.x += force.x;
				acc.y += force.y;
			}
			
			_forces = [];
			
			for each( force in _constantForces )
			{
				acc.x += force.x;
				acc.y += force.y;
			}
	 		
	 		velocity.x += acc.x;
	 		velocity.y += acc.y;
	 	}
	 	
	 	protected function calculateFinalVelocity():void
	 	{
			if( maxTurnRate > 0 && _oldVelocity.angleTo( velocity ) > ( maxTurnRate * MathUtils.DEG_TO_RAD ) * _stepSize )
			{
			 	var mat:Matrix2D = new Matrix2D();
				mat.rotate( ( ( maxTurnRate * MathUtils.DEG_TO_RAD ) * _stepSize ) * heading.sign( velocity ) );
			 	mat.transformVector( _oldVelocity );
			 	mat.transformVector( heading );
			 	velocity.x = _oldVelocity.x;
				velocity.y = _oldVelocity.y;
			}
 			
	 		velocity.x *= damping;
	 		velocity.y *= damping;
	 		
	 		velocity.truncate( maxSpeed );
	 	}
	 			
	 	protected function updatePosition():void
	 	{
	 		//trace( "<MovingEntity> Acc: " + acc );
	 		var dx:Number = velocity.x * _stepSize;
	 		var dy:Number = velocity.y * _stepSize;	 			
	 		
			actualPos.x += dx;
			actualPos.y += dy;
	 		
	 		switch( boundsBehavior )
	 		{
	 			case BOUNDS_WRAP:
	 				wrapOnBounds();
	 			break;
	 			case BOUNDS_BOUNCE:
	 				bounceOnBounds();
	 			break;
	 			case BOUNDS_REMOVE:
	 				removeOnBounds();
	 			break;
	 		}
	 		
	 		newPos.x = actualPos.x;
	 		newPos.y = actualPos.y;
	 	}
	 	
	 	protected function updateHeading():void
	 	{
	 		if( ( velocity.x * velocity.x + velocity.y * velocity.y ) > 0.001 )
	 		{
	 			heading = velocity.getNormalized();
	 			side.x = -heading.y;
				side.y = heading.x;
	 			
	 			if( doesRotMatchHeading )
	 			{
	 				var x:Number = heading.x;
	 				var y:Number = heading.y;
		 			var ang:Number = Math.atan( y / x );
		 			if( y < 0 && x > 0 ){ rotation = ang; }
		 			else if( ( y < 0 && x < 0 ) || ( y > 0 && x < 0 ) )
	 			    {
	 			   		rotation = ang + 3.141592653589793;
	 			    }
		 			else{ rotation = ang + 6.283185307179586; }
	 			}
	 		} 
	 		else 
	 		{
	 			velocity.x=0;
	 			velocity.y=0;
	 		}
	 	}
	 	
	 	protected function wrapOnBounds():void
	 	{
	 		if( actualPos.x > _parent.bounds.width + radius )
	 		{
	 			actualPos.x = 0-radius + ( actualPos.x - _parent.bounds.width );
	 		}
	 		else if( actualPos.y > _parent.bounds.height+radius )
	 		{
	 			actualPos.y = 0-radius + ( actualPos.y - _parent.bounds.height );
	 		}
	 		else if( actualPos.x < -radius )
	 		{
	 			actualPos.x = _parent.bounds.width+radius + actualPos.x;
	 		}
	 		else if( actualPos.y < -radius )
	 		{
	 			actualPos.y = _parent.bounds.height+radius + actualPos.y;
	 		}
	 	}
	 	
	 	protected function bounceOnBounds():void
	 	{
	 		
	 		if( actualPos.x > _parent.bounds.width - radius )
	 		{
	 			velocity.x *= -1;
	 			velocity.x *= friction;
	 			velocity.y *= friction;			
	 			if( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED ){ velocity.x = 0; }
	 			if( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED ){ velocity.y = 0; }
	 			actualPos.x = _parent.bounds.width - radius;
	 		}
	 		else if( actualPos.x < radius )
	 		{
	 			velocity.x *= -1;
	 			velocity.x *= friction;	 	
	 			velocity.y *= friction;	 			
	 			if( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED ){ velocity.x = 0; }
	 			if( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED ){ velocity.y = 0; }
	 			actualPos.x = radius;
	 		}	 		
	 		
	 		if( actualPos.y > _parent.bounds.height - radius )
	 		{
	 			velocity.y *= -1;
	 			velocity.x *= friction;	
	 			velocity.y *= friction;
	 			if( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED ){ velocity.x = 0; }
	 			if( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED ){ velocity.y = 0; }
	 			actualPos.y = _parent.bounds.height - radius;
	 		}
	 		
	 		else if( actualPos.y < radius )
	 		{
	 			velocity.y *= -1;
	 			velocity.x *= friction;	
	 			velocity.y *= friction;
	 			if( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED ){ velocity.x = 0; }
	 			if( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED ){ velocity.y = 0; }
	 			actualPos.y = radius;
	 		}	 		
	 	}
	 	
	 	protected function removeOnBounds():void
	 	{
	 		if( actualPos.x > _parent.bounds.width + radius )
	 		{
	 			_parent.removeChild(id);
	 		}
	 		else if( actualPos.y > _parent.bounds.height+radius )
	 		{
	 			_parent.removeChild(id);
	 		}
	 		else if( actualPos.x < -radius )
	 		{
	 			_parent.removeChild(id);
	 		}
	 		else if( actualPos.y < -radius )
	 		{
	 			_parent.removeChild(id);
	 		}
	 		
	 	}
	 	
	 	protected var _oldVelocity:Vector2D;
	 	protected var _forces:Array;
	 	protected var _constantForces:Dictionary;
	}
}
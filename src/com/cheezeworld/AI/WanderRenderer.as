//Origin :		* * *
//				* O *
//				* * *

package com.cheezeworld.AI
{
	import com.cheezeworld.AI.Behaviors.Wander;
	import com.cheezeworld.entity.Boid;
	import com.cheezeworld.entity.GameCamera;
	import com.cheezeworld.math.Transformations;
	import com.cheezeworld.math.Vector2D;
	import com.cheezeworld.rendering.ARenderer;
	
	import flash.display.*;

	public class WanderRenderer extends ARenderer
	{
		
		public var radiusColor:uint;
		public var dotColor:uint;
		
		/**
		 *  
		 * @param a_entity
		 * @param a_camera
		 * @param a_canvas
		 * @param a_data May contain radiusColor:uint, and dotColor:uint
		 * 
		 */		
		public function WanderRenderer( a_entity:Boid, a_camera:GameCamera, a_canvas:DisplayObjectContainer, a_data:Object=null )
		{
			super( a_entity, a_camera, a_canvas );
			
			a_data.radiusColor == null ? radiusColor = 0xFFFFFF : radiusColor = a_data.radiusColor;
			a_data.dotColor == null ? dotColor = 0xFF2222 : dotColor = a_data.boundsColor;	
			
			
			m_entity = a_entity;
			
 			g = _container.graphics;

			_viewBoxWidth = m_entity.radius * 2;
			_viewBoxHeight = m_entity.radius * 2;
		}
		
		protected override function draw():void
		{
			var wander:Wander = m_entity.steering.getBehavior( Wander ) as Wander;
		
			g.clear();
			
			// .. Draw Radius ...
			var radiusPosition:Vector2D = m_entity.heading.multipliedBy( wander.distance );
			g.moveTo( 0, 0 );
			g.lineStyle( 1, radiusColor );
			g.drawCircle( radiusPosition.x, radiusPosition.y, wander.radius );
			
			// .. Draw Target ...
			var targetPosition:Vector2D = wander.v1.copy();
			Transformations.rotateAroundOrigin( targetPosition, m_entity.rotation );
			g.lineStyle( 1, dotColor );
			g.drawCircle( targetPosition.x, targetPosition.y, 3 );			
		}
		
		protected override function updateViewBox():void
		{
			_viewBoxX = m_entity.actualPos.x - m_entity.radius;
			_viewBoxY = m_entity.actualPos.y - m_entity.radius;
		}
		
		public override function dispose():void
		{
			g = null;
			m_entity = null;
			super.dispose();
		}
		
		private var g:Graphics;
		private var m_entity:Boid;
	}
}
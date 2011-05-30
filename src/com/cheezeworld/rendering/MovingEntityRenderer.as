package com.cheezeworld.rendering
{
	import com.cheezeworld.entity.GameCamera;
	import com.cheezeworld.entity.MovingEntity;
	
	import flash.display.DisplayObjectContainer;

	public class MovingEntityRenderer extends EntityRenderer
	{
		
		public var velocityColor:uint;
		public var accColor:uint;
		
		/**
		 * 
		 * @param a_data May contain variables: boundsColor:uint, velocityColor:uint, accColor:uint
		 * 
		 */		
		public function MovingEntityRenderer(a_entity:MovingEntity, a_camera:GameCamera, a_canvas:DisplayObjectContainer, a_data:Object)
		{
			super(a_entity, a_camera, a_canvas, a_data);
			
			velocityColor = ( a_data.velocityColor == null ? 0x00FF00 : a_data.velocityColor );
			accColor = ( a_data.accColor == null ? 0xFF0000 : a_data.accColor );
			m_entity = a_entity;
		}
		
		public override function dispose():void
		{
			m_entity = null;
			super.dispose();
		}
		
		protected override function draw() : void
		{
			super.draw();
			
			// Draw Velocity
			g.lineStyle( 1, velocityColor );
			g.moveTo( 0, 0 );
			g.lineTo( m_entity.velocity.x, m_entity.velocity.y );
			
			// Draw Acceleration
			g.lineStyle( 1, accColor );
			g.moveTo( 0, 0 );
			g.lineTo( m_entity.acc.x, m_entity.acc.y );
		}
		
		private var m_entity:MovingEntity;
		
	}
}
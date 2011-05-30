package com.cheezeworld.AI
{
	import com.cheezeworld.math.Vector2D;
	
	import flash.display.Graphics;
	
	public class Wall
	{
		private const NORMAL_DRAWLEN:Number	= 10;
		
		public var fromPoint:Vector2D;
		public var toPoint:Vector2D;
		public var normal:Vector2D;
		public var midPoint:Vector2D;
		
		public function Wall( a_fromPoint:Vector2D, a_toPoint:Vector2D )
		{
			fromPoint = a_fromPoint; 
			toPoint = a_toPoint;
			calculateNormal();
			midPoint = new Vector2D( ( fromPoint.x+toPoint.x ) * 0.5, ( fromPoint.y + toPoint.y ) * 0.5 );
			/* 
			//(A+B)/2
			_pos.x = (_a.x+_b.x) * 0.5;
			_pos.y = (_a.y+_b.y) * 0.5;
			_localA = _a.subtractedBy(_pos);
			_localB = _b.subtractedBy(_pos);
			_width = _localA.x - _localB.x;
			_height = _localA.y - _localB.y;
			 */
		}
		
		public function draw( a_graphics:Graphics, a_color:uint = 0x000000, a_drawNormal:Boolean = true ) : void
		{
			a_graphics.lineStyle( 1, a_color );
			a_graphics.moveTo( fromPoint.x, fromPoint.y );
			a_graphics.lineTo( toPoint.x, toPoint.y );
			if( a_drawNormal )
			{
				a_graphics.moveTo( midPoint.x, midPoint.y );
				a_graphics.lineTo( midPoint.x + normal.x*NORMAL_DRAWLEN, midPoint.y + normal.y*NORMAL_DRAWLEN );
			}				
		}
		
		// -- PRIVATE --
		
		private function calculateNormal():void
		{
			var temp:Vector2D;
			temp = toPoint.subtractedBy( fromPoint );
			temp.normalize();
			normal = new Vector2D( -temp.y, temp.x ); // Perpendicular of normal
		}
		
		private var m_width:Number;
		private var m_height:Number;

	}
}
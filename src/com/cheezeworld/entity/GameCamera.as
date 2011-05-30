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

/*
	NOTES: Default Camera Size SHOULD match the size of the display!
*/

package  com.cheezeworld.entity
{
	import com.cheezeworld.math.Vector2D;
	
	import flash.events.*;

	public class GameCamera extends Entity
	{
		public static const MOVE:String = "camera_move_event";

		public function GameCamera( a_gameWorld:GameWorld, a_width:Number, a_height:Number )
		{
			super( new EntityParams() );
			parent = a_gameWorld;
			
			m_oldPos = new Vector2D(-1,-1);
			
			setSize( a_width, a_height );

			onWorldResize( new EntityEvent( EntityEvent.RESIZE, { width:a_gameWorld.bounds.width, height:a_gameWorld.bounds.height } ) );
			
			a_gameWorld.addEventListener( EntityEvent.RESIZE, onWorldResize, false, 0, true );
		}
		
		public function setSize( a_width:int, a_height:int ) : void
		{
			bounds.setSize( a_width, a_height );
			dispatchEvent( new EntityEvent( EntityEvent.RESIZE, { width:a_width, height:a_height } ) );
		}
		
		public override function update( timePassed:int ):void
		{
			if( m_followPos )
			{
				newPos.Set( m_followPos.x, m_followPos.y );
			}
			
			//Check to see if camera has moved
			if( m_oldPos.x != newPos.x || m_oldPos.y != newPos.y )
			{
				m_oldPos.x = actualPos.x;
	 			m_oldPos.y = actualPos.y;
				actualPos.x = newPos.x;
	 			actualPos.y = newPos.y;
	 			
	 			//constrain camera to inside of world -------
	 			if( actualPos.x - bounds.halfWidth < 0 )
	 			{
	 				actualPos.x = bounds.halfWidth;
	 			} 
	 			else if ( actualPos.x + bounds.halfWidth >= m_worldWidth )
	 			{
	 				actualPos.x = m_worldWidth - bounds.halfWidth;
	 			}
	 			if( actualPos.y - bounds.halfHeight < 0 )
	 			{
	 				actualPos.y = bounds.halfHeight;
	 			} 
	 			else if( actualPos.y + bounds.halfHeight >= m_worldHeight )
	 			{
	 				actualPos.y = m_worldHeight - bounds.halfHeight;
	 			}
	 			newPos.x = actualPos.x
	 			newPos.y = actualPos.y;
	 			// ------------------------------------------
	 			
	 			bounds.moveTo( actualPos );
	 			
	 			dispatchEvent( new Event( GameCamera.MOVE ) );
			}
		}
		
		public function followPos( a_pos:Vector2D ):void
		{
			m_followPos = a_pos;
		}
		
		// -- PRIVATE
		
		private function onWorldResize( e:EntityEvent ) : void
		{
			m_worldWidth = e.data.width; 
			m_worldHeight = e.data.height;
			
			update(0);
		}

		private var m_followPos:Vector2D;
		private var m_worldWidth:Number;
		private var m_worldHeight:Number;
		private var m_oldPos:Vector2D;
		
	}
}
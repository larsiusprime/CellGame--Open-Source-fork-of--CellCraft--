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
package com.cheezeworld.rendering
{
	import com.cheezeworld.entity.GameWorld;
	import com.cheezeworld.utils.Input;
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.Point;
	
	public class GameWorldRenderer extends ARenderer
	{	
		private const MAX_LAYERS:int = 16;
		
		public function GameWorldRenderer( a_world:GameWorld, a_renderSurface:DisplayObjectContainer )
		{
			var canvas:Sprite = new Sprite();			
			var layer:Sprite;
			for( var i:int = 0; i < MAX_LAYERS; i++ )
			{
				layer = new Sprite();
				canvas.addChild( layer );
			}
			
			super( a_world, a_world.camera, canvas );
			
			m_renderSurface = a_renderSurface;
	 		m_canvasBmpData = new BitmapData( a_world.camera.bounds.width, a_world.camera.bounds.height, true, 0x00000000 );
	 		m_canvasBitmap = new Bitmap( m_canvasBmpData );
	 		m_renderSurface.addChild( m_canvasBitmap );
		}
		
		public function getLayer( value:int ) : Sprite
	 	{
	 		if( value < 1 || value > MAX_LAYERS )
	 		{ 
	 			throw new Error( "<GameWorldRenderer> Value must be between 1 and " + MAX_LAYERS ); 
	 		}
	 		
	 		return _canvas.getChildAt( value - 1 ) as Sprite;
	 	}
		
		public function moveCanvas( x:int, y:int ) : void
		{
			m_canvasBitmap.x = x;
			m_canvasBitmap.y = y;
			Input.instance.activateWorldMouse( _entity as GameWorld, x, y );
		}
	
		public override function update( timePassed:int ):void
		{
			m_canvasBmpData.fillRect( m_canvasBmpData.rect, 0x00000000 );
			m_canvasBmpData.draw( _canvas );
		}
		
		public override function dispose():void
		{
	 		m_canvasBmpData.dispose();
	 		m_renderSurface.removeChild(m_canvasBitmap);
	 		m_canvasBmpData = null;
	 		m_canvasBitmap = null;
			super.dispose();
		}
		
		// -- PRIVATE --
		
		private var m_canvasBmpData:BitmapData;
		private var m_canvasBitmap:Bitmap;
		private var m_renderSurface:DisplayObjectContainer;
	
	}
}
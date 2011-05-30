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
	import com.cheezeworld.entity.Entity;
	import com.cheezeworld.entity.GameCamera;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;

	public class BitmapRenderer extends ARenderer
	{
		
		/**
		 * 
		 * @param a_data Should contain one variable: bitmapData:BitmapData
		 * 
		 */		
		public function BitmapRenderer( a_entity:Entity, a_camera:GameCamera, a_canvas:DisplayObjectContainer, a_data:Object )
		{
			super( a_entity, a_camera, a_canvas );
			
			if( a_data.bitmapData == null || !( a_data.bitmapData is BitmapData ) )
			{
				throw new Error( "<BitmapRenderer> a_data.bitmapData must contain variable of type BitmapData!" );
			}
 			m_bmp = new Bitmap( a_data.bitmapData );
			m_bmp.x = -m_bmp.width/2; 
			m_bmp.y = -m_bmp.height/2;
 			_container.addChild( m_bmp );

 			_viewBoxWidth = m_bmp.width;
 			_viewBoxHeight = m_bmp.height;
		}
		
		public override function dispose():void
		{
			m_bmp = null;
			super.dispose();
		}
		
		protected override function updateViewBox():void
		{
			_viewBoxX = _entity.actualPos.x - m_bmp.width * 0.5;
			_viewBoxY = _entity.actualPos.y - m_bmp.height * 0.5;
		}
		
		protected override function draw():void
		{
			// handle rotations
		}
		
		private var m_bmp:Bitmap;
		
	}
}
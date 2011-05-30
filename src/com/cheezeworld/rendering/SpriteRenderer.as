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
	import com.cheezeworld.math.MathUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class SpriteRenderer extends ARenderer
	{
		/**
		 * 
		 * @param a_data Should contain the variable sprite:Class
		 * 
		 */		
		public function SpriteRenderer( a_entity:Entity, a_camera:GameCamera, a_canvas:DisplayObjectContainer, a_data:Object )
		{
			super( a_entity, a_camera, a_canvas );
			
			if( a_data.sprite == null || !( a_data.sprite is Class ) )
			{
				throw new ArgumentError( "<SpriteRenderer> a_data.sprite must contain variable of type Class! (which must subclass Sprite)" );
			}
			m_sprite = new a_data.sprite();
			m_sprite.x = -m_sprite.width/2; 
			m_sprite.y = -m_sprite.height/2;
 			_container.addChild( m_sprite );
		}
		
		protected override function updateViewBox():void
		{
			_viewBoxX = _entity.actualPos.x - m_sprite.width * 0.5;
			_viewBoxY = _entity.actualPos.y - m_sprite.height * 0.5;
			_viewBoxWidth = m_sprite.width;
 			_viewBoxHeight = m_sprite.height;
		}
		
		protected override function draw():void
		{
			_container.rotation = _entity.rotation * MathUtils.RAD_TO_DEG;
		}
		
		private var m_sprite:Sprite;
		
	}
}
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
	import com.cheezeworld.math.Vector2D;
	
	import flash.display.*;

	public class EntityRenderer extends ARenderer
	{
		
		public var boundsColor:uint;
		
		/**
		 * 
		 * @param a_data May contain variable: boundsColor:uint in order to specify color rendered.
		 * 
		 */		
		public function EntityRenderer( a_entity:Entity, a_camera:GameCamera, a_canvas:DisplayObjectContainer, a_data:Object )
		{
			super( a_entity, a_camera, a_canvas );
			
			a_data.boundsColor == null ? boundsColor = Math.random() * 0xFFFFFF : boundsColor = a_data.boundsColor;
			
 			g = _container.graphics;

			_viewBoxWidth = _entity.radius * 2;
			_viewBoxHeight = _entity.radius * 2;
		}
		
		protected override function draw():void
		{
			g.clear();
			
			g.lineStyle( 1 , boundsColor );
			g.drawCircle( 0, 0, _entity.radius );
			
			var heading:Vector2D = Vector2D.rotToHeading( _entity.rotation );
			g.moveTo( 0, 0 );
			g.lineTo( heading.x * _entity.radius, heading.y * _entity.radius );
		}
		
		protected override function updateViewBox():void
		{
			_viewBoxX = _entity.actualPos.x - _entity.radius;
			_viewBoxY = _entity.actualPos.y - _entity.radius;
		}
		
		public override function dispose():void
		{
			g = null;
			super.dispose();
		}
		
		protected var g:Graphics;
	}
}


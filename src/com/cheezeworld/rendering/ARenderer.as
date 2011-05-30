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

//Abstract class

package com.cheezeworld.rendering
{
	import com.cheezeworld.entity.Entity;
	import com.cheezeworld.entity.GameCamera;
	import com.cheezeworld.entity.IGameObject;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.*;
	
	public class ARenderer extends EventDispatcher implements IGameObject
	{	
		protected var _canvas:DisplayObjectContainer;
		private var m_camera:GameCamera;
		protected var _container:Sprite;
		
		/**
		 * 
		 * @param a_entity The entity to render
		 * @param a_camera The Camera this renderer will use for it's perspective
		 * @param a_canvas The Layer to render to
		 * @param a_data Subclasses which require additional data in the constructor should use this object
		 * 
		 */		
		public function ARenderer( a_entity:Entity, a_camera:GameCamera, a_canvas:DisplayObjectContainer, a_data:Object=null )
		{
			m_camera = a_camera;
			m_isVisible = true;
			_container = new Sprite();
			
			_entity = a_entity;			
			_canvas = a_canvas;
			
 			_canvas.addChild( _container );
 			
 			a_entity.addGameObject( this );
		}
		
		public function update( timePassed:int ):void
		{
			updateViewBox();
			performCulling();
			
			if( m_isVisible )
			{
				draw();
					 			
				if( _entity.scale != m_previousScale )
				{
					m_previousScale = _entity.scale;
					_container.scaleX = _entity.scale;
					_container.scaleY = _entity.scale;
				}

				_container.x = ( ( _entity.actualPos.x - m_camera.actualPos.x ) + m_camera.bounds.width * 0.5 );
				_container.y = ( ( _entity.actualPos.y - m_camera.actualPos.y ) + m_camera.bounds.height * 0.5 );
 			}		
		}
		
		public function dispose():void
		{
			_canvas.removeChild( _container );	
 			
			_canvas = null;
			m_camera = null;
			_container = null;
			_entity = null;
		}
		
		// -- PRIVATE --
		
		protected function draw():void
		{
			throw new Error( "<ARenderer> Abstract function: Must be overriden!" );
		}
		
		/**
		 * Update values m_viewBoxX, m_viewBoxY, m_viewBoxWidth, m_vewBoxHeight
		 * so that the culling will work correctly. 
		 * 
		 */		
		protected function updateViewBox():void
		{
			throw new Error( "<ARenderer> Abstract function: Must be overriden!" );
		}
		
		private function performCulling() : void
		{
 			if( _viewBoxX + _viewBoxWidth < m_camera.bounds.left )
 			{ //nope
 				m_isVisible = false;
 				_container.visible = false;
 			} 
 			else if( _viewBoxX > m_camera.bounds.left + m_camera.bounds.width )
 			{ //nope
 				m_isVisible = false;
 				_container.visible = false;
 			} 
 			else if( _viewBoxY + _viewBoxHeight < m_camera.bounds.top )
 			{ //nope
 				m_isVisible = false;
 				_container.visible = false;
 			} 
 			else if( _viewBoxY > m_camera.bounds.top + m_camera.bounds.height )
 			{ //nope
 				m_isVisible = false;
 				_container.visible = false;
 			} 
 			else
 			{ //yes it does intersect!
 				m_isVisible = true;
 				_container.visible = true;
 			}
		}
  		
  		protected var _viewBoxX:Number;
  		protected var _viewBoxY:Number;
  		protected var _viewBoxWidth:Number;
  		protected var _viewBoxHeight:Number;
  		protected var _entity:Entity;
  		
  		private var m_isVisible:Boolean;
  		private var m_previousScale:Number;

	}
}
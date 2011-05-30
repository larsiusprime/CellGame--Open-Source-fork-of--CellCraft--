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

package com.cheezeworld.math
{
	public class AABBox
	{
		public var left:Number;
		public var right:Number;
		public var top:Number;
		public var bottom:Number;
		
		public var width:Number;
		public var height:Number;
		public var halfWidth:Number; 
		public var halfHeight:Number;
		public var topLeft:Vector2D;
		public var topRight:Vector2D;
		public var bottomRight:Vector2D;
		public var bottomLeft:Vector2D;
		public var center:Vector2D;
		
		/**
		 * Use to store Rect shape data 
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 * 
		 */		
		public function AABBox( center:Vector2D, width:Number, height:Number )
		{
			this.center = new Vector2D( center.x, center.y );
						
			this.width = width;
			this.height = height;
			halfWidth = width / 2;
			halfHeight = height / 2;
			
			left = center.x - halfWidth;
			right = center.x + halfWidth;
			top = center.y - halfHeight;
			bottom = center.y + halfHeight;
			
			topLeft = new Vector2D( left, top );
			topRight = new Vector2D( right, top );
			bottomRight = new Vector2D( right, bottom );
			bottomLeft = new Vector2D( left, bottom );	
					
		}
		
		/**
		 * Use to change any values in the AABBox so that everything is updated correctly. 
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 * 
		 */		
		public function Set( center:Vector2D, width:Number, height:Number ):void
		{
			this.center.x = center.x;
			this.center.y = center.y;
			
			this.width = width;
			this.height = height;
			halfWidth = width / 2;
			halfHeight = height / 2;
			
			left = center.x - halfWidth;
			right = center.x + halfWidth;
			top = center.y - halfHeight;
			bottom = center.y + halfHeight;
			
			topLeft.x = left; 
			topLeft.y = top;
			topRight.x = right; 
			topRight.y = top;
			bottomRight.x = right; 
			bottomRight.y = bottom;
			bottomLeft.x = left; 
			bottomLeft.y = bottom;
		}
		
		public function setSize( width:Number, height:Number ):void
		{
			this.width = width;
			this.height = height;
			halfWidth = width / 2;
			halfHeight = height / 2;
			
			left = center.x - halfWidth;
			right = center.x + halfWidth;
			top = center.y - halfHeight;
			bottom = center.y + halfHeight;
			
			topLeft.x = left; 
			topLeft.y = top;
			topRight.x = right; 
			topRight.y = top;
			bottomRight.x = right; 
			bottomRight.y = bottom;
			bottomLeft.x = left; 
			bottomLeft.y = bottom;
		}
		
		/**
		 * Centers the box at the specified point. 
		 * @param point Center point at which to move the box.
		 * 
		 */		
		public function moveTo( point:Vector2D ):void
		{
			
			center.x = point.x;
			center.y = point.y;
			left = center.x - halfWidth;
			right = center.x + halfWidth;
			top = center.y - halfHeight;
			bottom = center.y + halfHeight;
			topLeft.x = left; 
			topLeft.y = top;
			topRight.x = right; 
			topRight.y = top;
			bottomRight.x = right; 
			bottomRight.y = bottom;
			bottomLeft.x = left; 
			bottomLeft.y = bottom;
		}
		
		public function isOverlapping( box:AABBox ):Boolean
		{
			return!( ( box.top > bottom ) ||
					 ( box.bottom < top ) ||
					 ( box.left > right ) ||
					 ( box.right < left ) );
		}
		
		 
	}
}
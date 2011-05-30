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
	
	/**
	 * A few functions for transforming Vectors 
	 * @author Colby Cheeze
	 * 
	 */	
	public class Transformations
	{	
		/**
		 * Function is currently incomplete! 
		 * @param points
		 * @param pos
		 * @param foward
		 * @param side
		 * @param scale
		 * @return 
		 * 
		 */		
		public static function worldTransformPoints(points:Array, pos:Vector2D, foward:Vector2D, side:Vector2D, scale:Vector2D):Array{
			throw new Error("This function is incomplete!");
		}
		
		/**
		 * Converts a point from local space to world space. 
		 * @param point The point to convert
		 * @param heading The Heading of the local object
		 * @param side The perpendicular vector of the heading
		 * @param pos The position of the local object
		 * @return The new point in it's world space coords.
		 * 
		 */		
		public static function pointToWorldSpace( a_point:Vector2D, a_heading:Vector2D, a_side:Vector2D, a_pos:Vector2D ):Vector2D
		{
			var transPoint:Vector2D = a_point.copy();
			m_mat.Set();
			
			m_mat.rotateVector( a_heading, a_side );
			m_mat.translate( a_pos.x, a_pos.y );
			
			m_mat.transformVector( transPoint );

			return transPoint;
		}
		
		/**
		 * Converts a Vector from local to world space 
		 * @param vector The Vector to convert
		 * @param heading Heading of the local object
		 * @param side The perpendicular vector of the heading
		 * @return The new Vector in it's world space coords.
		 * 
		 */		
		public static function vectorToWorldSpace(vector:Vector2D, heading:Vector2D, side:Vector2D):Vector2D{
			var transVec:Vector2D = vector.copy();			
			m_mat.Set();
			
			m_mat.rotateVector(heading,side);
			m_mat.transformVector(transVec);
			
			return transVec;
		}
		
		/**
		 * Converts a point from world space to local space. 
		 * @param point The point to convert
		 * @param heading The Heading of the local object
		 * @param side The perpendicular vector of the heading
		 * @param pos The position of the local object
		 * @return The new point in it's local space coords.
		 * 
		 */		
		public static function pointToLocalSpace(point:Vector2D, heading:Vector2D, side:Vector2D, pos:Vector2D):Vector2D{
			var transPoint:Vector2D = point.copy();
			
			var tx:Number = -pos.dotOf(heading);
			var ty:Number = -pos.dotOf(side);
			
			m_mat.Set(heading.x, side.x,0,heading.y,side.y,0,tx,ty);

			m_mat.transformVector(transPoint);

			return transPoint;
			
		}
		
		/**
		 * Converts a Vector from world to local space 
		 * @param vector The Vector to convert
		 * @param heading Heading of the local object
		 * @param side The perpendicular vector of the heading
		 * @return The new Vector in it's local space coords.
		 * 
		 */		
		public static function vectorToLocalSpace(vector:Vector2D, heading:Vector2D, side:Vector2D):Vector2D{
			var transPoint:Vector2D = vector.copy();
			
			m_mat.Set(heading.x, side.x, 0, heading.y, side.y);
			
			m_mat.transformVector(transPoint);
			
			return transPoint;
		}
		
		/**
		 * Rotates a Vector around (0,0) at a specified angle. 
		 * @param vector the vector to transform.
		 * @param angle the angle to rotate at.
		 * 
		 */		
		public static function rotateAroundOrigin(vector:Vector2D, angle:Number):void
		{
			var mat:Matrix2D = new Matrix2D();			
			mat.rotate(angle);			
			mat.transformVector(vector);
		}
		
		/**
		 * NOTE: Has not yet been tested!
		 * Use this to create an array of "whiskers" for use in wall avoidance algorithms 
		 * @param numWhiskers the number of whiskers to create.
		 * @param length the length of the whiskers
		 * @param fov FOV of the object
		 * @param facing the heading vector of the oject
		 * @param origin the origin of the whiskers
		 * @return An array of "whiskers" (a list of Vectors)
		 * 
		 */		
		public static function createWhiskers(numWhiskers:int, length:Number, fov:Number, facing:Vector2D, origin:Vector2D):Array{
			//magnitude of the angle seperating each whisker
			var sectorSize:Number = fov/(numWhiskers-1);
			
			var whiskers:Array = [];
			var temp:Vector2D;
			var angle:Number = -fov*0.5;
			
			var i:int = numWhiskers;
			while(--i>=0){
				temp = facing
				Transformations.rotateAroundOrigin(temp, angle);
				whiskers.push(origin.addedTo(temp.multipliedBy(length)));
				
				angle+=sectorSize;
			}
			
			return whiskers;
		}
		
		private static var m_mat:Matrix2D = new Matrix2D();
	}
}
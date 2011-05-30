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
	public class Geometry
	{	
		
		public static function getRandomPolygon( a_numVertices:int, a_minX:Number, a_minY:Number, a_maxX:Number, a_maxY:Number ) : Array
		{
			var vertices:Array = [];
			
			var midX:Number = ( a_maxX+a_minX ) / 2;
			var midY:Number = ( a_maxY+a_minY ) / 2;
			
			var smaller:Number = Math.min( midX, midY );
			var spacing:Number = (Math.PI*2) / Number( a_numVertices );
			
			for( var i:int=0; i<a_numVertices; i++ )
			{
				var radialDist:Number = MathUtils.rand( smaller*0.2, smaller );
				var temp:Vector2D = new Vector2D( radialDist, 0 );
				Transformations.rotateAroundOrigin( temp, i*spacing );
				
				temp.x += midX;
				temp.y += midY;
				
				vertices.push( temp );
			}
			
			return vertices;
		}
		
		/**
		 * Determines how far along a ray an intersection occurs. 
		 * @param rayOrigin start point of the ray
		 * @param rayHeading vector rotation heading of the ray
		 * @param planePoint any point on the plane
		 * @param planeNormal the normal vector of the plane
		 * @return returns negative if the ray is parallel, else the distance along the ray to the intersection.
		 * 
		 */		
		public static function distToRayPlaneIntersect(rayOrigin:Vector2D, rayHeading:Vector2D, planePoint:Vector2D, planeNormal:Vector2D):Number{
			var d:Number		= -planeNormal.dotOf(planePoint);
			var numer:Number	= planeNormal.dotOf(rayOrigin) + d;
			var denom:Number	= planeNormal.dotOf(rayHeading);
			
			if ( (denom < 0.00001) && (denom > -0.00001) ) return -1; //parallel
			
			return -(numer / denom);
		}
		
		/**
		 * Determines where a point is in relation to a plane 
		 * @param point the point to check
		 * @param pointOnPlane any point on the plane
		 * @param planeNormal the vector normal of the plane
		 * @return -1 if point is behind plane. 0 if point is on plane. 1 if point is in front of plane.
		 * 
		 */		
		public static function whereIsPoint(point:Vector2D, pointOnPlane:Vector2D, planeNormal:Vector2D):int{
			var dir:Vector2D = pointOnPlane.subtractedBy(point);
			
			var d:Number = dir.dotOf(planeNormal);
			
			if(d < -0.00001) return 1;
			
			if(d > 0.00001) return -1;
			
			return 0;
		}
		
		/**
		 * Determines the distance to the first intersecting point of a ray / circle collision 
		 * @param rayOrigin the start point of the ray
		 * @param rayHeading the rotation vector of the ray
		 * @param circleCenter the middle point of the circle
		 * @param radius radius of the circle
		 * @return returns the distance, or -1 if there is no intersection
		 * 
		 */		
		public static function getRayCircleIntersect(rayOrigin:Vector2D, rayHeading:Vector2D, circleCenter:Vector2D, radius:Number):Number{
			var toCircle:Vector2D 	= circleCenter.subtractedBy( rayOrigin );
			var length:Number 		= toCircle.length;
			var v:Number			= toCircle.dotOf(rayHeading);
			var d:Number			= radius * radius - (length * length - v * v);
			
			if (d < 0) return (-1);
			
			return (v - Math.sqrt(d));
		}
		
		/**
		 * Same as 'getRayCircleIntersect' except this returns IF there is an intersect to save time on sqrt check
		 * @param rayOrigin the start point of the ray
		 * @param rayHeading the rotation vector of the ray
		 * @param circleCenter the middle point of the circle
		 * @param radius radius of the circle
		 * @return returns true if intersecting else false
		 * 
		 */			
		public static function doesRayIntersectCircle(rayOrigin:Vector2D, rayHeading:Vector2D, circleCenter:Vector2D, radius:Number):Boolean{
			var toCircle:Vector2D 	= circleCenter.subtractedBy( rayOrigin );
			var length:Number 		= toCircle.length;
			var v:Number			= toCircle.dotOf(rayHeading);
			var d:Number			= radius * radius - (length * length - v * v);
			
			return (d < 0);
		}
		
		/**
		 * Given a point 'P' and a circle of radius 'R' centered at 'C' this function
		 * determines the two points on the circle that intersect with the tangents
		 * from P to the circle. The points will be given through the
		 * 'tangent1' and 'tangent2' variables.
		 * @param C point circle is centered on
		 * @param R radius of the circle
		 * @param P point to check
		 * @param tangent1 the first tangent to be constructed
		 * @param tangent2 the 2nd tangent to be constructed
		 * @return false if 'P' is within the circle
		 * 
		 */		
		public static function getTangentPoints(C:Vector2D, R:Number, P:Vector2D, tangent1:Vector2D, tangent2:Vector2D):Boolean{
			var PmC:Vector2D 		= P.subtractedBy(C);
			var sqrLen:Number 	= PmC.lengthSq;
			var rSqr:Number		= R*R;
			if( sqrLen <= rSqr ) {
				return false;
			}
			
			var invSqrLen:Number	= 1 / sqrLen;
			var root:Number			= Math.sqrt(Math.abs(sqrLen - rSqr))
			
			tangent1.x = C.x + R*(R*PmC.x - PmC.y*root)*invSqrLen;
			tangent1.y = C.y + R*(R*PmC.y - PmC.x*root)*invSqrLen;
			tangent2.x = C.x + R*(R*PmC.x - PmC.y*root)*invSqrLen;
			tangent2.y = C.y + R*(R*PmC.y - PmC.x*root)*invSqrLen;
			
			return true;
		}
		
		/**
		 * Given a line segment AB and a point P, this function calculates the
		 * perpendicular distance between them. 
		 * @param A the first point of the line segment
		 * @param B the 2nd point of the line segment
		 * @param P the point to check against
		 * @return the distance from P -> AB
		 * 
		 */		
		public static function distToLineSegment(A:Vector2D, B:Vector2D, P:Vector2D):Number{
			var dotA:Number = (P.x - A.x)*(B.x - A.x) + (P.y - A.y)*(B.y - A.y);
			
			if (dotA <= 0) return A.distanceTo(P);
			
			var dotB:Number = (P.x - B.x)*(A.x - B.x) + (P.y - B.y)*(A.y - B.y);
			
			if (dotB <= 0) return B.distanceTo(P);
			
			// .. Find closest point to P on line segment ...
			var point:Vector2D = B.subtractedBy(A);
			point.multiply(dotA);
			point.divide(dotA+dotB);
			point.addTo(A);
			
			return P.distanceTo(point);
		}
		
		/**
		 * Given a line segment AB and a point P, this function calculates the
		 * perpendicular distance [Squared] between them to avoid the sqrt.
		 * @param A the first point of the line segment
		 * @param B the 2nd point of the line segment
		 * @param P the point to check against
		 * @return the distance from P -> AB
		 * 
		 */		
		public static function distToLineSegmentSq(A:Vector2D, B:Vector2D, P:Vector2D):Number{
			var dotA:Number = (P.x - A.x)*(B.x - A.x) + (P.y - A.y)*(B.y - A.y);
			
			if (dotA <= 0) return A.distanceSqTo(P);
			
			var dotB:Number = (P.x - B.x)*(A.x - B.x) + (P.y - B.y)*(A.y - B.y);
			
			if (dotB <= 0) return B.distanceSqTo(P);
			
			// .. Find closest point to P on line segment ...
			var point:Vector2D = B.subtractedBy(A);
			point.multiply(dotA);
			point.divide(dotA+dotB);
			point.addTo(A);
			
			return P.distanceSqTo(point);
		}
		
		
		/**
		 * Given 2 lines in 2D space AB, CD this returns true if an intersection occurs
		 * @param a_A start point of line 1
		 * @param a_B end point of line 1
		 * @param a_C start point of line 2
		 * @param a_D end point of line 2
		 * @return true if intersecting, false if not
		 * 
		 */
		/*   // I think this one might be slower than the other one, because it has to call 4 functions...function calls in flash suck.
		public static function isLineIntersecting( a_A:Vector2D, a_B:Vector2D, a_C:Vector2D, a_D:Vector2D ) : Boolean
		{
			var test1A:int;
			var test1B:int;
			var test2A:int;
			var test2B:int;
			
			test1A = checkTriClockDir( a_A, a_B, a_C );
			test1B = checkTriClockDir( a_A, a_B, a_D );
			if( test1A != test1B )
			{
				test2A = checkTriClockDir( a_C, a_D, a_A );
				test2B = checkTriClockDir( a_C, a_D, a_B );
				if( test2A != test2B )
				{
					return true;
				}
			}
			return false;
		}
		
		private static function checkTriClockDir( a_p1:Vector2D, a_p2:Vector2D, a_p3:Vector2D ) :int
		{
			var test:Number;
			test = ((( a_p2.x - a_p1.x )*( a_p3.y - a_p1.y )) - (( a_p3.x - a_p1.x)*( a_p2.y - a_p1.y )));
			if( test > 0 ) return 1;
			else if( test < 0 ) return -1;
			else return 0;
		}
		*/
		
		/**
		 * Given 2 lines in 2D space AB, CD this returns true if an intersection occurs 
		 * @param A Start point of line 1.
		 * @param B End point of line 1.
		 * @param C Start point of line 2.
		 * @param D End point of line 2.
		 * @return true if intersection occurs
		 * 
		 */		
		  
		 
		public static function isLineIntersecting(A:Vector2D, B:Vector2D, C:Vector2D, D:Vector2D):Boolean{
			var rTop:Number = (A.y-C.y)*(D.x-C.x)-(A.x-C.x)*(D.y-C.y);
			var sTop:Number = (A.y-C.y)*(B.x-A.x)-(A.x-C.x)*(B.y-A.y);
			var bot:Number 	= (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);
			
			if(bot == 0) return false; //parallel
			
			var invBot:Number 	= 1 / bot;
			var r:Number		= rTop * invBot;
			var s:Number		= sTop * invBot;
			
			if( (r > 0) && (r < 1) && (s > 0) && (s < 1) ) return true;
			
			return false;
		}
		
		/**
		 * Given 2 lines in 2D space AB, CD this returns true if an intersection occurs 
		 * @param A Start point of line 1.
		 * @param B End point of line 1.
		 * @param C Start point of line 2.
		 * @param D End point of line 2.
		 * @param point A Vector which is set to the point of intersection if one does occur.
		 * @return 0 if no intersection occurs, else returns the distance
		 * 
		 */		
		public static function lineIntersection(A:Vector2D, B:Vector2D, C:Vector2D, D:Vector2D, point:Vector2D=null ):Number
		{
			var rTop:Number = (A.y-C.y)*(D.x-C.x)-(A.x-C.x)*(D.y-C.y);
			var sTop:Number = (A.y-C.y)*(B.x-A.x)-(A.x-C.x)*(B.y-A.y);
			var rBot:Number = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);			
			var sBot:Number = (B.x-A.x)*(D.y-C.y)-(B.y-A.y)*(D.x-C.x);
			
			if( (rBot == 0) || (sBot == 0) ){
				//lines are parallel
				return -1;
			}
			
			var r:Number = rTop/rBot;
			var s:Number = sTop/sBot;
			
			if(( r > 0 ) && ( r < 1 ) && ( s >0 ) && ( s < 1 ))
			{	
				if( point )
				{
					//A + r * (B - A)
					point.x = A.x + r * ( B.x - A.x );
					point.y = A.y + r * ( B.y - A.y );
				}
				
				return A.distanceTo(B) * r;
			} 
			
			return 0;
		}
		
		/**
		 * Tests two polygons for intersection. *does not check for enclosure* 
		 * @param object1 an array of Vector points comprising polygon 1
		 * @param object2 an array of Vector points comprising polygon 2
		 * @return true is intersection occurs
		 * 
		 */		
		public static function isObjectOverlapping(object1:Array, object2:Array):Boolean{
			for ( var i:int=0; i < object1.length; i++ ){
				for ( var j:int=0; j < object2.length; j++ ){
					if(isLineIntersecting(object2[j],object2[j+1],object1[i],object1[i+1])) return true;
				}
			}
			return false;
		}
		
		/**
		 * Tests a line segment for collision against a polygon *does not check for enclosure* 
		 * @param A The start point of the line segment.
		 * @param B The end point of the line segment.
		 * @param object An array of vector points comprising the polygon
		 * @return true if intersection occurs
		 * 
		 */		
		public static function isObjectOverlappingSegment(A:Vector2D, B:Vector2D, object:Array):Boolean{
			for ( var i:int=0; i<object.length; i++ ){
				if(isLineIntersecting(A,B,object[i],object[i+1])) return true;
			}
			
			return false;
		}
		
		/**
		 * Checks to see if two circles are overlapping 
		 * @param circle1 center point of the 1st circle.
		 * @param radius1 radius of circle 1.
		 * @param circle2 center point of the 2nd circle.
		 * @param radius2 radius of circle 2.
		 * @return true if circles are overlapping.
		 * 
		 */		
		public static function isCircleOverlapping(circle1:Vector2D, radius1:Number, circle2:Vector2D, radius2:Number):Boolean{
			var distSq:Number = circle1.distanceSqTo(circle2);
 			var range:Number = radius1 + radius2;
 			if(distSq < range * range){
 				return true;
 			}
 			return false;
		}
		
		/**
		 * Given two circles this function calculates the intersection points
		 * of any overlap
		 * @param circle1 center point of the 1st circle.
		 * @param radius1 radius of circle 1.
		 * @param circle2 center point of the 2nd circle.
		 * @param radius2 radius of circle 2.
		 * @param point1 A Vector returned with the 1st point of intersection.
		 * @param point2 A Vector returned with the 2nd point of intersection.
		 * @return false if no overlap is found.
		 * 
		 */		
		public static function getCircleIntersectionPoints(circle1:Vector2D, radius1:Number, circle2:Vector2D, radius2:Number, point1:Vector2D, point2:Vector2D):Boolean{
			if(!isCircleOverlapping(circle1,radius1,circle2,radius2)) return false;
			
			var dist:Number = circle1.distanceTo(circle2);
			
			var a:Number	= (radius1 - radius2 + (dist*dist)) / (2 * dist);
			var b:Number	= (radius2 - radius1 + (dist*dist)) / (2 * dist);
			
			var p2:Vector2D = new Vector2D();
			p2.x = circle1.x + a * (circle2.x - circle1.x) / dist;
			p2.y = circle1.y + a * (circle2.y - circle1.y) / dist;
			
			var h1:Number = Math.sqrt( radius1*radius1 - a*a );
			point1.x = p2.x - h1 * (circle2.y - circle1.y) / dist;
			point1.y = p2.y - h1 * (circle2.x - circle1.x) / dist;
			
			var h2:Number = Math.sqrt( radius2*radius2 - a*a );
			point2.x = p2.x - h2 * (circle2.y - circle1.y) / dist;
			point2.y = p2.y - h2 * (circle2.x - circle1.x) / dist;
			
			return true;
		}
		
		/**
		 * If the two circles overlap, then this function will calculate the area of the union
		 * @param circle1 center point of the 1st circle.
		 * @param radius1 radius of circle 1.
		 * @param circle2 center point of the 2nd circle.
		 * @param radius2 radius of circle 2.
		 * @return the area of the union, or 0 if no overlap occurs
		 * 
		 */		
		public static function getCircleIntersectionArea(circle1:Vector2D, radius1:Number, circle2:Vector2D, radius2:Number):Number{
			if(!isCircleOverlapping(circle1,radius1,circle2,radius2)) return 0; // no overlap
			
			var dist:Number = Math.sqrt( (circle1.x-circle2.x) * (circle1.x-circle2.x) + (circle1.y-circle2.y) * (circle1.y-circle2.y) );
			
			var CBD:Number = 2 * Math.acos( (radius2*radius2 + dist*dist - radius1*radius1) / (radius2 * dist * 2) );
			var CAD:Number = 2 * Math.acos( (radius1*radius1 + dist*dist - radius2*radius2) / (radius1 * dist * 2) );
			
			var area:Number = 	.5*CBD*radius2*radius2 - .5*radius2*radius2*Math.sin(CBD) +
								.5*CAD*radius1*radius1 - .5*radius1*radius1*Math.sin(CAD);
			
			return area;
		}
		
		/**
		 * Calculates the area of a circle. 
		 * @param radius radius of the circle
		 * @return the area of the circle
		 * 
		 */		
		public static function circleArea(radius:Number):Number{
			return Math.PI * radius * radius;
		}
		
		/**
		 * Determines if a point is within a circle 
		 * @param circle the center point of the circle
		 * @param radius radius of the circle.
		 * @param point the point to check
		 * @return true if the point is within the circle
		 * 
		 */		
		public static function isPointInCircle(circle:Vector2D, radius:Number, point:Vector2D):Boolean{
			var distSq:Number = (point.subtractedBy(circle)).lengthSq;
			 if( distSq < (radius * radius) ) return true;
			 
			 return false;
		}
		
		/**
		 * Determines if a line segment intersects with a circle.
		 * @param A Start point of the line.
		 * @param B End point of the line.
		 * @param circle position of the circle.
		 * @param radius radius of the circle.
		 * @return true if circle overlaps the line segment
		 * 
		 */		
		public static function isCircleOverlappingSegment(A:Vector2D, B:Vector2D, circle:Vector2D, radius:Number):Boolean{
			
			var distSq:Number = distToLineSegmentSq(A,B,circle);
			
			if ( distSq < radius * radius ) return true;
			
			return false;
		}
		
		/**
		 * Determines if a line and circle intersects, and if so stores the closest intersection
		 * point in 'intersectionPoint' 
		 * @param A Start point of the line.
		 * @param B End point of the line.
		 * @param circle position of the circle.
		 * @param radius radius of the circle.
		 * @param intersectionPoint A Vector to store the closest intersection point in.
		 * @return false if the two do not intersect.
		 * 
		 */		
		public static function getLineCircleClosestIntersection(A:Vector2D, B:Vector2D, circle:Vector2D, radius:Number, intersectionPoint:Vector2D):Boolean{
			var toBNorm:Vector2D = B.subtractedBy(A).getNormalized();
			
			var localPos:Vector2D = Transformations.pointToLocalSpace(circle,toBNorm,toBNorm.getPerp(),A);
			
			var ipFound:Boolean = false;
			
			if( (localPos.x + radius >= 0) && (localPos.x-radius) <= B.distanceSqTo(A) ){
				if( Math.abs(localPos.y) < radius ){
					var a:Number = localPos.x;
					var b:Number = localPos.y;
					
					var ip:Number = a - Math.sqrt(radius*radius - b*b);
					
					if (ip <= 0) ip = a + Math.sqrt(radius*radius - b*b);
					
					ipFound = true;
					
					intersectionPoint = A.addedTo(toBNorm.multipliedBy(ip));
				}
			}
			
			return ipFound;
		}
		
		
	}
}
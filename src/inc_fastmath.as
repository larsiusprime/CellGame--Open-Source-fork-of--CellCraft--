		//Include these in-line for fastness!
		
		private const TWOPI:Number = Math.PI * 2;
		private const _180divPI:Number = 180 / Math.PI;
		private const PIdiv180:Number = Math.PI / 180;
		
		private function fastABS(n:Number):Number {
			if (n < 0) return -n;
			return n;
		}
		
		/**
		* Get distance between two points as a Number
		* @param	x1
		* @param	y1
		* @param	x2
		* @param	y2
		* @return the Distance
		*/

		private function getDist(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			return Math.sqrt( ((x1-x2) * (x1-x2)) + ((y1-y2) * (y1-y2)) );
		}

		/**
		* Get distance between two points as an integer
		* @param	x1
		* @param	y1
		* @param	x2
		* @param	y2
		* @return the Distance 
		*/

		private function getDisti(x1:int, y1:int, x2:int, y2:int):int {
			return Math.sqrt( ((x1-x2) * (x1-x2)) + ((y1-y2) * (y1-y2)) );
		}
	
		/**
		* Get square of the distance between two points (faster than getDist) as a Number
		* @param	x1
		* @param	y1
		* @param	x2
		* @param	y2
		* @return the Distance^2
		*/

		private function getDist2(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			return ( ((x1-x2) * (x1-x2)) + ((y1-y2) * (y1-y2)) );
		}

		/**
		* Get square of the distance between two points (faster than getDisti) as an int
		* @param	x1
		* @param	y1
		* @param	x2
		* @param	y2
		* @return the Distance^2
		*/
	
		private function getDist2i(x1:int, y1:int, x2:int, y2:int):int {
			return ( ((x1-x2) * (x1-x2)) + ((y1-y2) * (y1-y2)) );
		}
		
		/**
		 * Returns a list of points in a circle. Does NOT list them as class Point, get them 2 at a time.
		 * @param	radius size of circle
		 * @param	MAX number of points
		 * @return a list of circle coordinates in a Vector.<Number>
		 */
		
		private function circlePoints(radius:Number, MAX:Number):Vector.<Number>{
			var circ:Vector.<Number> = new Vector.<Number>();
			for(var i:Number = 0; i < MAX; i++){
				circ.push((Math.cos(i/MAX * TWOPI)) * radius);
				circ.push((Math.sin(i/MAX * TWOPI)) * radius);
			}
			return circ;
		}
		
		/**
		 * Returns a list of points in a circle. Does NOT list them as class Point, get them 2 at a time.
		 * @param	radius size of circle
		 * @param	MAX number of points
		 * @param   xo amount to offset x
		 * @param   yo amount to offset y
		 * @return a list of circle coordinates in a Vector.<Number>
		 */
		
		private function circlePointsOffset(radius:Number, MAX:Number, xo:Number, yo:Number):Vector.<Number>{
			var circ:Vector.<Number> = new Vector.<Number>();
			for(var i:Number = 0; i < MAX; i++){
				circ.push( ((Math.cos(i/MAX * TWOPI)) * radius) + xo );
				circ.push( ((Math.sin(i/MAX * TWOPI)) * radius) + yo );
			}
			return circ;
		}
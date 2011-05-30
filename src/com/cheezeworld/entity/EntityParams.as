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
package com.cheezeworld.entity
{	
	public class EntityParams
	{
		public var radius:Number;
		public var forcedId:String;
		public var rotation:Number;
		public var scale:Number;
		public var layer:int;
		public var isCollidable:Boolean;
		public var type:String;
		public var customClass:Class;
		public var rendererClass:Class;
		public var rendererData:Object;
		
		
		public function EntityParams( a_params:Object = null )
		{
			radius = 0;	
			rotation = 0;
			scale = 1;
			layer = 1;
			customClass = Entity;
			type = "Entity";
			rendererData = {};
			
			loadParameters( a_params );
		}
		
		private function loadParameters( a_params:Object ):void
  		{
  			if( a_params )
  			{
				for( var i:String in a_params )
				{
					try
					{
						this[i] = a_params[i];
					} 
					catch( err:ReferenceError )
					{
						trace("<EntityParams> "+ "ERROR!: property \""+ i + "\" does not exist!");
					}
				}
			}
  		}
	}
}
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
package com.cheezeworld.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class Utils
	{
		/**
		 * Strips out the whitespace from a string ( great for HTML style text from XML files ) 
		 * @param string The string to strip
		 * @param stripTabs set true to stip out tabs
		 * @param stripReturns set true to strip out returns
		 * @param stripNewLines set true to strip out newline characters
		 * @param compressSpaces set true to compress multiple spaces into one space
		 * @return the stripped string
		 * 
		 */		
		public static function stripWhitespace(string:String, stripTabs:Boolean = true, stripReturns:Boolean = true, stripNewLines:Boolean = true, compressSpaces:Boolean = true ):String
	    {
	        var result:String = string;
	        var resultArray:Array;
	        
	        if( stripTabs )
	        {
	        	result = result.split("\t").join(" ");
	        }
	            
	        if( stripReturns )
	        {
	        	result = result.split("\r").join(" ");
	        }
	            
	        if( stripNewLines )
	        {
	        	 result = result.split("\n").join(" ");
	        }
	
	        if( compressSpaces ) 
	        {
	            resultArray = result.split(" ");
	            for(var idx:uint = 0; idx < resultArray.length; idx++)
	            {
	                if(resultArray[idx] == "")
	                {
	                    resultArray.splice(idx,1);
	                    idx--;
	                }
	            }
	            result = resultArray.join(" ");
	        }
	        
	        return result;
	    }
	    
	    /**
		 * returns true or false from a string value 
		 * @param value
		 * 
		 */		
		public static function stringToBoolean( value:String ):Boolean
		{
			if( value == "true" || value == "1" )
			{
				return true;
			}
			else if( value == "false" || value == "0" )
			{
				return false;
			}
			else
			{
				return Boolean( value );
			}
		}
		
		public static function createTextField( a_parent:DisplayObjectContainer=null, a_x:int=0, a_y:int=0, a_isEditable:Boolean=false ) : TextField
		{
			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			text.x = a_x;
			text.y = a_y;
			if( a_isEditable )
			{
				text.type = TextFieldType.INPUT;
			}
			if( a_parent ){ a_parent.addChild( text ); }
			return text;
		}
		
		public static function createHtmlText( a_text:String, a_color:String="#000000", a_size:int=12, a_font:String="Arial" ) : String
		{
			return "<font color='" + a_color + "' size='" + a_size + "' font='" + a_font + "' > " + a_text + "</font>";
			
		} 
	}
}
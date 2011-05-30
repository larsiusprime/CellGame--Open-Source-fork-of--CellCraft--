package SWFStats
{
    import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.net.SharedObject;	
    import flash.utils.ByteArray;	

	public final class PlayerLevels
	{
		private static const Random:Number = Math.random();
		private static var ListCallback:Function = null;
		private static var LoadCallback:Function = null;
		private static var SaveCallback:Function = null;		
		private static var RateCallback:Function = null;
		private static var SaveLevel:PlayerLevel;
		private static var RateLevel:int;
		private static var RateAmount:int;

		public function PlayerLevels() { } 
		
		public static function Rate(levelid:int, rating:int, callback:Function):Boolean
		{
			if(RateCallback != null)
				return false;
			
			var cookie:SharedObject = SharedObject.getLocal("ratings");
			
			if(cookie.data[levelid] != null)
				return false;

			RateCallback = callback;
			RateLevel = levelid;
			RateAmount = rating;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, RateComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, RateErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, LoadErrorHandler);
			loader.load(new URLRequest("http://utils.swfstats.com/playerlevels/rate.aspx?swfid=" + Log.SWFID + "&guid=" + Log.GUID + "&levelid=" + levelid + "&rating=" + rating + "&" + Random));
			
			return true;
		}
		
		public static function RateComplete(e:Event):void
		{
			var cookie:SharedObject = SharedObject.getLocal("ratings");
			cookie.data[RateLevel] = RateAmount;
			cookie.flush();
			
			var data:XML = XML(e.target["data"]);
			var status:int = data["status"];

			RateCallback(status == 0);
			RateCallback = null;
		}
		
		private static function RateErrorHandler(e:*):void
		{
			RateCallback(false);
			RateCallback = null;
		}

		public static function Load(levelid:int, callback:Function):Boolean
		{
			if(LoadCallback != null)
				return false;

			LoadCallback = callback;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, LoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, LoadErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, LoadErrorHandler);
			loader.load(new URLRequest("http://utils.swfstats.com/playerlevels/load.aspx?swfid=" + Log.SWFID + "&guid=" + Log.GUID + "&levelid=" + levelid + "&" + Random));
			
			return true;
		}
		
		private static function LoadComplete(e:Event):void
		{
			var data:XML = XML(e.target["data"]);
			var item:XML = XML(data["level"]);

			var level:PlayerLevel = new PlayerLevel();
			level.LevelId = item["levelid"];
			level.PlayerName = item["playername"];
			level.PlayerId = item["playerid"];
			level.Name = item["name"];
			level.Score = item["score"];
			level.Votes = item["votes"];
			level.Rating = item["rating"];
			level.Data = item["data"];
		
			LoadCallback(level);
			LoadCallback = null;
		}	
		
		private static function LoadErrorHandler(e:*):void
		{
			LoadCallback(null);
			LoadCallback = null;
		}		

		public static function List(callback:Function, mode:String, page:int=1, perpage:int=20, data:Boolean=false, datemin:String="", datemax:String=""):Boolean
		{
			if(ListCallback != null)
				return false;

			ListCallback = callback;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, ListComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ListErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ListErrorHandler);
			loader.load(new URLRequest("http://utils.swfstats.com/playerlevels/list.aspx?swfid=" + Log.SWFID + "&guid=" + Log.GUID + "&mode=" + mode + "&page=" + page + "&perpage=" + perpage + "&data=" + data + "&datemin=" + datemin + "&datemax=" + datemax + "&" + Random));
			
			return true;
		}
		
		private static function ListComplete(e:Event):void
		{
			var data:XML = XML(e.target["data"]);
			var entries:XMLList = data["level"];
			var levels:Array = new Array();			
			var numresults:int = data["numresults"];

			for each(var item:XML in entries) 
			{
				var level:PlayerLevel = new PlayerLevel();
				level.LevelId = item["levelid"];
				level.PlayerId = item["playerid"];
				level.PlayerName = item["playername"];
				level.Name = item["name"];
				level.Score = item["score"];
				level.Rating = item["rating"];
				level.Plays = item["plays"];
				level.Votes = item["votes"];

				if(item["data"])
					level.Data = item["data"];
				
				levels.push(level);
			}

			ListCallback(levels, numresults);
			ListCallback = null;
		}

		private static function ListErrorHandler(e:*):void
		{
			ListCallback(null, 0);
			ListCallback = null;
		}		
		
		public static function Save(level:PlayerLevel, thumb:DisplayObject, callback:Function):Boolean
		{
			if(SaveCallback != null)
				return false;

			SaveCallback = callback;
			SaveLevel = level;
			
			// setup the thumbnail
			var image:BitmapData = new BitmapData(thumb.width, thumb.height, true, 0);
			image.draw(thumb, null, null, null, null, true);
			
			// save the level
			var postdata:URLVariables = new URLVariables();
			postdata.data = level.Data;
			postdata.image = Base64(PNGEncode(image));
	
			var request:URLRequest = new URLRequest("http://utils.swfstats.com/playerlevels/save.aspx?swfid=" + Log.SWFID + "&guid=" + Log.GUID + "&playerid=" + level.PlayerId + "&playername=" + escape(level.PlayerName) + "&name=" + escape(level.Name));
			request.data = postdata;
			request.method = URLRequestMethod.POST;
		
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, SaveComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, SaveErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SaveErrorHandler);
			loader.load(request);			
			
			return true;
		}
		
		private static function SaveComplete(e:Event):void
		{
			var data:XML = XML(e.target["data"]);
			SaveLevel.LevelId = data["levelid"];
			
			SaveCallback(SaveLevel, SaveLevel.LevelId > 0);
			SaveCallback = null;
			SaveLevel = null;
		}
		
		private static function SaveErrorHandler(e:*):void
		{
			SaveCallback(SaveLevel, false);
			SaveCallback = null;
			SaveLevel = null;
		}
		
		private static function StatusChange(e:*):void
		{
		}
		
		// ----------------------------------------------------------------------------
		// Base64 encoding
		// ----------------------------------------------------------------------------
		// http://dynamicflash.com/goodies/base64/
		//
		// Copyright (c) 2006 Steve Webster
		// Permission is hereby granted, free of charge, to any person obtaining a copy of
		// this software and associated documentation files (the "Software"), to deal in
		// the Software without restriction, including without limitation the rights to
		// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
		// the Software, and to permit persons to whom the Software is furnished to do so,
		// subject to the following conditions: 
		// The above copyright notice and this permission notice shall be included in all
		// copies or substantial portions of the Software.
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

		private static function Base64(data:ByteArray):String 
		{
			var output:String = "";
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			var i:uint;
			var j:uint;
			var k:uint;
			
			data.position = 0;
			
			while (data.bytesAvailable > 0) 
			{
				dataBuffer = new Array();
				
				for(i=0; i<3 && data.bytesAvailable>0; i++) 
					dataBuffer[i] = data.readUnsignedByte();
				
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				
				for(j=dataBuffer.length; j<3; j++)
					outputBuffer[j + 1] = 64;
				
				for (k = 0; k<outputBuffer.length; k++)
					output += BASE64_CHARS.charAt(outputBuffer[k]);
			}
			
			return output;
		}

		
		// ----------------------------------------------------------------------------
		// PNG encoding
		// ----------------------------------------------------------------------------
		// http://code.google.com/p/as3corelib/source/browse/trunk/src/com/adobe/images/PNGEncoder.as
		//
 		// Copyright (c) 2008, Adobe Systems Incorporated
  		// All rights reserved.		
	   private static function PNGEncode(img:BitmapData):ByteArray 
	   {
			// Create output byte array
			var png:ByteArray = new ByteArray();
			png.writeUnsignedInt(0x89504e47);
			png.writeUnsignedInt(0x0D0A1A0A);

			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(img.width);
			IHDR.writeInt(img.height);
			IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
			IHDR.writeByte(0);
			writeChunk(png,0x49484452,IHDR);

			var IDAT:ByteArray= new ByteArray();
			var p:uint;
			var j:int;
			
			for(var i:int=0;i < img.height;i++) 
			{
				// no filter
				IDAT.writeByte(0);

				if (!img.transparent)
				{
					for(j=0;j < img.width;j++) 
					{
						p = img.getPixel(j,i);
						IDAT.writeUnsignedInt(uint(((p&0xFFFFFF) << 8) | 0xFF));
					}
				} 
				else 
				{
					for(j=0;j < img.width;j++) 
					{
						p = img.getPixel32(j,i);
						IDAT.writeUnsignedInt(uint(((p&0xFFFFFF) << 8) |	(p>>>24)));
					}
				}
			}
			
			IDAT.compress();
			writeChunk(png,0x49444154,IDAT);
			writeChunk(png,0x49454E44, null);
			return png;
		}
	
		private static var crcTable:Array;
		private static var crcTableComputed:Boolean = false;
	
		private static function writeChunk(png:ByteArray, type:uint, data:ByteArray):void 
		{
			if(!crcTableComputed) 
			{
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				
				for(var n:uint = 0; n < 256; n++) 
				{
					c = n;
					
					for(var k:uint = 0; k < 8; k++) 
					{
						if (c & 1) 
						{
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						} 
						else 
						{
							c = uint(c >>> 1);
						}
					}

					crcTable[n] = c;
				}
			}
			
			var len:uint = 0;

			if(data != null) 
			{
				len = data.length;
			}

			png.writeUnsignedInt(len);
			
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			
			if(data != null) 
			{
				png.writeBytes(data);
			}
			
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			
			for(var i:int=0; i<(e-p); i++) 
			{
				c = uint(crcTable[(c ^ png.readUnsignedByte()) & uint(0xff)] ^ uint(c >>> 8));
			}
			
			c = uint(c^uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
	}
}
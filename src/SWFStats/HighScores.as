package SWFStats
{
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	public class HighScores
	{
		private static var ScoresCallback:Function;
		private static var FacebookScoresCallback:Function;
		private static var SubmitCallback:Function;

		// ------------------------------------------------------------------------------
		// Retrieving score lists
		// ------------------------------------------------------------------------------
		public static function Scores(global:Boolean, table:String, callback:Function, mode:String = "alltime"):void
		{
			ScoresCallback = callback;
				
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(Event.COMPLETE, ScoresFinished);
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, ScoresError);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ScoresError);
			sendaction.load(new URLRequest("http://utils.swfstats.com/leaderboards/get.aspx?guid=" + Log.GUID + "&swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&table=" + table + "&mode=" + mode + "&" + Math.random()));
		}

		public static function FacebookScores(table:String, callback:Function, friendlist:Array = null, mode:String = "alltime"):void
		{
			FacebookScoresCallback = callback;
				
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(Event.COMPLETE, FacebookScoresFinished);
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, FacebookScoresError);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ScoresError);
			sendaction.load(new URLRequest("http://utils.swfstats.com/leaderboards/getfb.aspx?guid=" + Log.GUID + "&swfid=" + Log.SWFID + "&table=" + table + "&friendlist=" + (friendlist != null ? friendlist.join(",") : "") + "&mode=" + mode + "&" + Math.random()));
		}


		// ------------------------------------------------------------------------------
		// Submitting a score
		// ------------------------------------------------------------------------------
		public static function Submit(name:String, score:int, table:String, callback:Function, facebook:Boolean = false):void
		{
			SubmitCallback = callback;
				
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(Event.COMPLETE, SubmitFinished);
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, SubmitError);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ScoresError);
			sendaction.load(new URLRequest("http://utils.swfstats.com/leaderboards/save.aspx?guid=" + Log.GUID + "&swfid=" + Log.SWFID + "&url=" + Log.SourceUrl + "&table=" + table + "&name=" + name + "&score=" + score + "&auth=" + MD5(Log.SourceUrl + score.toString()) + "&fb=" + (facebook ? "1" : "0") + "&r=" + Math.random()));
		}


		// ------------------------------------------------------------------------------
		// Handling the responses
		// ------------------------------------------------------------------------------
		private static function ScoresFinished(e:Event):void
		{
			ScoresCallback(ProcessScores(e.target as URLLoader));
			ScoresCallback = null;
		}

		private static function ScoresError(e:Event):void
		{
			ScoresCallback(null);
			ScoresCallback = null;
		}

		private static function FacebookScoresFinished(e:Event):void
		{
			FacebookScoresCallback(ProcessScores(e.target as URLLoader));
			FacebookScoresCallback = null;
		}

		private static function FacebookScoresError(e:Event):void
		{
			FacebookScoresCallback(null);
			FacebookScoresCallback = null;
		}
		
		private static function SubmitFinished(e:Event):void
		{
			if(SubmitCallback == null)
				return;

			SubmitCallback((e.target as URLLoader).data == "true");
			SubmitCallback = null;
		}

		private static function SubmitError(e:Event):void
		{
			SubmitCallback(false);
			FacebookScoresCallback = null;
		}


		// ------------------------------------------------------------------------------
		// Processing scores
		// ------------------------------------------------------------------------------
		private static function ProcessScores(loader:URLLoader):Array
		{			
			var data:XML = XML(loader["data"]);
			var entries:XMLList = data["entry"];
			var results:Array = new Array();
			var datestring:String;
			var year:int;
			var month:int;
			var day:int;
			var date:Date = new Date();
						
			for each(var item:XML in entries) 
			{
				datestring = item["sdate"];				
				year = int(datestring.substring(datestring.lastIndexOf("/") + 1));
				month = int(datestring.substring(0, datestring.indexOf("/")));
				day = int(datestring.substring(datestring.indexOf("/" ) +1).substring(0, 2));
				date.setFullYear(year, month, day);

				results.push({Name: item["name"], Points: item["points"], Website: item["website"], Rank: results.length+1, SDate: date});
			}

			return results;
		}


		// ------------------------------------------------------------------------------
		// Error handling
		// ------------------------------------------------------------------------------
		private static function StatusChange(...args):void
		{
		}

		// ------------------------------------------------------------------------------
		// MD5 stuff
		// ------------------------------------------------------------------------------
		// A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
		// Digest Algorithm, as defined in RFC 1321.
		// Copyright (C) Paul Johnston 1999 - 2000.
		// Updated by Greg Holt 2000 - 2001.
		// See http://pajhome.org.uk/site/legal.html for details.
		// Updated by Ger Hobbelt 2001 (Flash 5) - works for totally buggered MAC Flash player and, of course, Windows / Linux as well.
		// Updated by Ger Hobbelt 2008 (Flash 9 / AS3) - quick fix.
		private static var hex_chr:String = "0123456789abcdef";

		private static function bitOR(a:Number, b:Number):Number
		{
			var lsb:Number = (a & 0x1) | (b & 0x1);
			var msb31:Number = (a >>> 1) | (b >>> 1);

			return (msb31 << 1) | lsb;
		}

		private static function bitXOR(a:Number, b:Number):Number
		{			
			var lsb:Number = (a & 0x1) ^ (b & 0x1);
			var msb31:Number = (a >>> 1) ^ (b >>> 1);

			return (msb31 << 1) | lsb;
		}

		private static function bitAND(a:Number, b:Number):Number
		{ 
			var lsb:Number = (a & 0x1) & (b & 0x1);
			var msb31:Number = (a >>> 1) & (b >>> 1);

			return (msb31 << 1) | lsb;
		}

		private static function addme(x:Number, y:Number):Number
		{
			var lsw:Number = (x & 0xFFFF)+(y & 0xFFFF);
			var msw:Number = (x >> 16)+(y >> 16)+(lsw >> 16);

			return (msw << 16) | (lsw & 0xFFFF);
		}

		private static function rhex(num:Number):String
		{
			var str:String = "";
			var j:int;

			for(j=0; j<=3; j++)
				str += hex_chr.charAt((num >> (j * 8 + 4)) & 0x0F) + hex_chr.charAt((num >> (j * 8)) & 0x0F);

			return str;
		}

		private static function str2blks_MD5(str:String):Array
		{
			var nblk:Number = ((str.length + 8) >> 6) + 1;
			var blks:Array = new Array(nblk * 16);
			var i:int;

			for(i=0; i<nblk * 16; i++) 
				blks[i] = 0;
																
			for(i=0; i<str.length; i++)
				blks[i >> 2] |= str.charCodeAt(i) << (((str.length * 8 + i) % 4) * 8);

			blks[i >> 2] |= 0x80 << (((str.length * 8 + i) % 4) * 8);

			var l:int = str.length * 8;
			blks[nblk * 16 - 2] = (l & 0xFF);
			blks[nblk * 16 - 2] |= ((l >>> 8) & 0xFF) << 8;
			blks[nblk * 16 - 2] |= ((l >>> 16) & 0xFF) << 16;
			blks[nblk * 16 - 2] |= ((l >>> 24) & 0xFF) << 24;

			return blks;
		}

		private static function rol(num:Number, cnt:Number):Number
		{
			return (num << cnt) | (num >>> (32 - cnt));
		}

		private static function cmn(q:Number, a:Number, b:Number, x:Number, s:Number, t:Number):Number
		{
			return addme(rol((addme(addme(a, q), addme(x, t))), s), b);
		}

		private static function ff(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
		{
			return cmn(bitOR(bitAND(b, c), bitAND((~b), d)), a, b, x, s, t);
		}

		private static function gg(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
		{
			return cmn(bitOR(bitAND(b, d), bitAND(c, (~d))), a, b, x, s, t);
		}

		private static function hh(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
		{
			return cmn(bitXOR(bitXOR(b, c), d), a, b, x, s, t);
		}

		private static function ii(a:Number, b:Number, c:Number, d:Number, x:Number, s:Number, t:Number):Number
		{
			return cmn(bitXOR(c, bitOR(b, (~d))), a, b, x, s, t);
		}

		private static function MD5(str:String):String
		{
			var x:Array = str2blks_MD5(str);
			var a:Number =  1732584193;
			var b:Number = -271733879;
			var c:Number = -1732584194;
			var d:Number =  271733878;
			var i:int;

			for(i=0; i<x.length; i += 16)
			{
				var olda:Number = a;
				var oldb:Number = b;
				var oldc:Number = c;
				var oldd:Number = d;

				a = ff(a, b, c, d, x[i+ 0], 7 , -680876936);
				d = ff(d, a, b, c, x[i+ 1], 12, -389564586);
				c = ff(c, d, a, b, x[i+ 2], 17,  606105819);
				b = ff(b, c, d, a, x[i+ 3], 22, -1044525330);
				a = ff(a, b, c, d, x[i+ 4], 7 , -176418897);
				d = ff(d, a, b, c, x[i+ 5], 12,  1200080426);
				c = ff(c, d, a, b, x[i+ 6], 17, -1473231341);
				b = ff(b, c, d, a, x[i+ 7], 22, -45705983);
				a = ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
				d = ff(d, a, b, c, x[i+ 9], 12, -1958414417);
				c = ff(c, d, a, b, x[i+10], 17, -42063);
				b = ff(b, c, d, a, x[i+11], 22, -1990404162);
				a = ff(a, b, c, d, x[i+12], 7 ,  1804603682);
				d = ff(d, a, b, c, x[i+13], 12, -40341101);
				c = ff(c, d, a, b, x[i+14], 17, -1502002290);
				b = ff(b, c, d, a, x[i+15], 22,  1236535329);    
				a = gg(a, b, c, d, x[i+ 1], 5 , -165796510);
				d = gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
				c = gg(c, d, a, b, x[i+11], 14,  643717713);
				b = gg(b, c, d, a, x[i+ 0], 20, -373897302);
				a = gg(a, b, c, d, x[i+ 5], 5 , -701558691);
				d = gg(d, a, b, c, x[i+10], 9 ,  38016083);
				c = gg(c, d, a, b, x[i+15], 14, -660478335);
				b = gg(b, c, d, a, x[i+ 4], 20, -405537848);
				a = gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
				d = gg(d, a, b, c, x[i+14], 9 , -1019803690);
				c = gg(c, d, a, b, x[i+ 3], 14, -187363961);
				b = gg(b, c, d, a, x[i+ 8], 20,  1163531501);
				a = gg(a, b, c, d, x[i+13], 5 , -1444681467);
				d = gg(d, a, b, c, x[i+ 2], 9 , -51403784);
				c = gg(c, d, a, b, x[i+ 7], 14,  1735328473);
				b = gg(b, c, d, a, x[i+12], 20, -1926607734);
				a = hh(a, b, c, d, x[i+ 5], 4 , -378558);
				d = hh(d, a, b, c, x[i+ 8], 11, -2022574463);
				c = hh(c, d, a, b, x[i+11], 16,  1839030562);
				b = hh(b, c, d, a, x[i+14], 23, -35309556);
				a = hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
				d = hh(d, a, b, c, x[i+ 4], 11,  1272893353);
				c = hh(c, d, a, b, x[i+ 7], 16, -155497632);
				b = hh(b, c, d, a, x[i+10], 23, -1094730640);
				a = hh(a, b, c, d, x[i+13], 4 ,  681279174);
				d = hh(d, a, b, c, x[i+ 0], 11, -358537222);
				c = hh(c, d, a, b, x[i+ 3], 16, -722521979);
				b = hh(b, c, d, a, x[i+ 6], 23,  76029189);
				a = hh(a, b, c, d, x[i+ 9], 4 , -640364487);
				d = hh(d, a, b, c, x[i+12], 11, -421815835);
				c = hh(c, d, a, b, x[i+15], 16,  530742520);
				b = hh(b, c, d, a, x[i+ 2], 23, -995338651);
				a = ii(a, b, c, d, x[i+ 0], 6 , -198630844);
				d = ii(d, a, b, c, x[i+ 7], 10,  1126891415);
				c = ii(c, d, a, b, x[i+14], 15, -1416354905);
				b = ii(b, c, d, a, x[i+ 5], 21, -57434055);
				a = ii(a, b, c, d, x[i+12], 6 ,  1700485571);
				d = ii(d, a, b, c, x[i+ 3], 10, -1894986606);
				c = ii(c, d, a, b, x[i+10], 15, -1051523);
				b = ii(b, c, d, a, x[i+ 1], 21, -2054922799);
				a = ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
				d = ii(d, a, b, c, x[i+15], 10, -30611744);
				c = ii(c, d, a, b, x[i+ 6], 15, -1560198380);
				b = ii(b, c, d, a, x[i+13], 21,  1309151649);
				a = ii(a, b, c, d, x[i+ 4], 6 , -145523070);
				d = ii(d, a, b, c, x[i+11], 10, -1120210379);
				c = ii(c, d, a, b, x[i+ 2], 15,  718787259);
				b = ii(b, c, d, a, x[i+ 9], 21, -343485551);

				a = addme(a, olda);
				b = addme(b, oldb);
				c = addme(c, oldc);
				d = addme(d, oldd);
			}

			return rhex(a) + rhex(b) + rhex(c) + rhex(d);
		}
	}
}
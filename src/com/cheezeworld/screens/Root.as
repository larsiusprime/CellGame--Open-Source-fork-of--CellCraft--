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

package com.cheezeworld.screens
{
	import com.cheezeworld.utils.*;
	import com.urbansquall.metronome.Ticker;
	import com.urbansquall.metronome.TickerEvent;
	
	import flash.display.*;
	import flash.events.*;
	
	public class Root extends AScreen
	{		
		
		public static const WIDTH:Number	=	550;
		public static const HEIGHT:Number	=	400;
		
		private const DEFAULT_QUALITY:String = "high";
	 	private const TICK_INTERVAL:int = 33;
	 	
	 	// -- STATIC --
	 	
		public static function set gameSpeed( value:Number ) : void
		{
			m_gameSpeed = value;
			if( m_gameSpeed < 0 ) { m_gameSpeed = 0; }
		}
		public static function get gameSpeed() : Number { return m_gameSpeed; }
		
		public static var stage:Stage;
		
		/**
		 * Use to globally pause the game. 
		 * 
		 */		
		public static function togglePause() : void
	 	{
	 		m_isUpdateOn = !m_isUpdateOn;
	 	}
		
		/**
		 * Place in code where you would like a breakpoint. The game will be paused globally
		 * and the message will be traced. 
		 * @param a_message The message to output when this breakpoint is reached.
		 * @param a_forced Force this breakpoint to run, even if breakpoints are turned off.
		 * 
		 */		
		public static function breakpoint( a_message:String, a_forced:Boolean=false ):void
		{
	 		if( !m_areBreakpointsEnabled && !a_forced ){ return; }
	 		
	 		trace( "<Root> Breakpoint: " + a_message );
	 		m_isUpdateOn = false;
	 	}
		
		// -- PUBLIC --
		
		public function Root(stage:Stage=null)
		{
			m_gameSpeed = 1;
			
			if( stage==null )
			{
				Root.stage = this.stage;
			} 
			else 
			{
				Root.stage = stage;	
			}
			Root.stage.quality = DEFAULT_QUALITY;
			
			m_isUpdateOn = true;
	 		m_areBreakpointsEnabled = true;
	 		 			
	 		Input.instance.activate(Root.stage);
	 		
	 		// Load External Data ----
	 		// ExternalData.load( onDataLoad, onError );
	 		// -----------------------
	 		onDataLoad( null );
		}
	 	
	 	public override function setScreen(screen:Class):void
	 	{
	 		m_screenToSet = screen;
	 	}
	 	
	 	// -- PRIVATE --
	 	
	 	private function onDataLoad( e:Event ):void
	 	{
	 		m_ticker = new Ticker( TICK_INTERVAL );
	 		m_ticker.addEventListener( TickerEvent.TICK, onTick );
	 		m_ticker.start();
	 		
	 		Root.stage.showDefaultContextMenu = false;
	 	}
	 	
	 	private function onTick( e:TickerEvent ):void
	 	{ 	 		
	 		if( m_isUpdateOn )
	 		{
	 			update( e.interval * m_gameSpeed );
	 		}
	 		
	 		handleInput();
	 		Input.instance.update();
	 		
	 		//handle custom cursor
	 		
	 		if( m_screenToSet )
	 		{
	 			super.setScreen( m_screenToSet );
	 			m_screenToSet = null;
	 		}
	 	}
	 	
	 	/**
	 	 * Here we handle code for dealing with breakpoints, global pausing, and stepping.
	 	 * Be sure to deactivate this code for the release of your game! 
	 	 * 
	 	 */	 	
	 	private function handleInput():void
	 	{
	 		if( Input.instance.isKeyPressed( KeyCode.END ) )
	 		{
	 			m_isUpdateOn = !m_isUpdateOn;
	 			trace("<Root> Game " + ( m_isUpdateOn ? "unpaused" : "paused" ) );
	 		}
	 		if( Input.instance.isKeyPressed( KeyCode.PAGE_DOWN ) )
	 		{
	 			if( !m_isUpdateOn )
	 			{
	 				update( TICK_INTERVAL );
	 			}
	 		}
	 		if( Input.instance.isKeyPressed( KeyCode.PAGE_UP ) )
	 		{
	 			m_areBreakpointsEnabled = !m_areBreakpointsEnabled;
	 			trace( "<Root> Breakpoints " + ( m_areBreakpointsEnabled ? "enabled" : "disabled" ) );
	 		}
	 	}
	
	 	private static var m_isUpdateOn:Boolean;
	 	private static var m_areBreakpointsEnabled:Boolean;
	 	
		private static var m_gameSpeed:Number;
		
		private var m_ticker:Ticker;
	 	private var m_screenToSet:Class;
		
	}
}


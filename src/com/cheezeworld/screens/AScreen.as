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

 	import flash.display.*;
 	import flash.events.*;
 	
	public class AScreen extends Sprite implements IScreenItem
	{
		 // Initialization ---------------------------------------------------------------------------
		 public function AScreen( a_parentScreen:IScreenItem=null )
		 {
		 	m_parentScreen = a_parentScreen;
		 	m_parentScreen == null ? m_currentScreen = null : m_currentScreen = currentScreen;
		 }
		 // ------------------------------------------------------------------------------------------
		 
		 	
		 public function get parentScreen():IScreenItem{ return m_parentScreen; }
		 
		 /**
		  * Will filter up to the top of the screen structure and return the root current screen.
		  * This is done so that any screens created down the line may have access to change the
		  * screen without actual reference to the root.
		  * 
		  */ 		
		 public function get currentScreen():IScreenItem
		 {
		 	if( m_parentScreen != null )
		 	{
		 		return m_parentScreen.currentScreen;
		 	}
		 	return m_currentScreen;
		 }
		 
		 // Override these functions with your subclasses ----------------------------------------------
		 
		 public function update( a_timePassed:int ):void
		 {
		 	if( m_parentScreen==null && m_currentScreen!=null ){ m_currentScreen.update( a_timePassed ); }
		 }
		
		 public function dispose():void{}
		 
		 // --------------------------------------------------------------------------------------------
		
		 /**
		  * Changes the root current screen to the screen specified.
		  * All screen's dispose method are called for cleanup.
		  * 
		  */	
		 public function setScreen( a_screen:Class ):void
		 {
		 	if ( m_parentScreen != null )
		 	{
		 		m_parentScreen.setScreen( a_screen );
		 		return;
		 	}
		 	if( m_currentScreen!= null )
		 	{
		 		removeChild( m_currentScreen as Sprite );
		 		m_currentScreen.dispose();
		 	} 					
		 	m_currentScreen = new a_screen( this );
		 	addChild( m_currentScreen as Sprite );
		 }
		 
		 // -- PRIVATE --
		 
		 private var m_parentScreen:IScreenItem;
		 private var m_currentScreen:IScreenItem;
	}
}

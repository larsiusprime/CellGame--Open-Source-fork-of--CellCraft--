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

 	import com.cheezeworld.entity.EntityEvent;
 	import com.cheezeworld.entity.GameCamera;
 	import com.cheezeworld.entity.GameWorld;
 	import com.cheezeworld.math.Vector2D;
 	
 	import flash.display.*;
 	import flash.events.*;
 	import flash.utils.getTimer;

 	public class Input
 	{
 		
 		private static const BUFFER_SIZE:int = 5;
 		
 		
 		public static function get instance():Input
 		{
 			if(Input._instance == null)
 			{
 				Input._instance = new Input(new SingletonEnforcer());
 			}
 			return Input._instance;
 		}
		
		// last key pressed
		public var lastKeyName:String = "";
		public var lastKeyCode:int = 0;
		
		// mouse states
		public var isMouseDown:Boolean = false;
		public var isMousePressed:Boolean = false;
		public var isMouseReleased:Boolean = false;
		public var worldMousePos:Vector2D;
		public var mousePos:Vector2D;
		public var mouseX:Number = 0;
		public var mouseY:Number = 0;
		public var mouseDelta:int = 0;

		public function get timeSinceLastKeyPress():int
		{
			return getTimer() - _timeKeyPressed;
		}
		public function get timeSinceLastKeyRelease():int
		{
			return getTimer() - _timeKeyReleased;
		}
		public function get timeSinceMousePressed():int
		{
			return getTimer() - _timeMousePressed;
		}
		public function get timeSinceMouseReleased():int
		{
			return getTimer() - _timeMouseReleased;
		}
		
		public function get hasMouseScrolled():Boolean
		{
			if(_hasMouseScrolled)
			{
				_hasMouseScrolled = false;
				return true;
			} else 
			{
				return false;
			}
		}
		
 		// INITIALIZATION ---------------------------------------------------------------------------------------------------------
 		public function Input(enforcer:SingletonEnforcer)
 		{
 			
 			_timeKeyPressed = _nt = _ot = getTimer();
 			_dt = 0;
 			mousePos = new Vector2D();
 			worldMousePos = new Vector2D();
 			
 			// init ascii array
			_ascii = new Array(222);
			fillAscii();
			
			// init key state array
			_keyState = new Array(222);
			_keyArr = new Array();
			for (var i:int = 0; i < 222; i++)
			{
				_keyState[i] = new int(0);
				if (_ascii[i] != undefined){
					_keyArr.push(i);
				}
			}
			
			// buffer
			_bufferSize = Input.BUFFER_SIZE;
			_keyBuffer = new Array(_bufferSize);
			for (var j:int = 0; j < _bufferSize; j++){
				_keyBuffer[j] = new Array(0,0);
			}
 		}
 		
 		/**
 		 * Must be called in order for the class to work 
 		 * @param stage the stage that all of the listeners will be attached to
 		 * 
 		 */ 		
 		public function activate(stage:Stage):void
 		{
			_stage = stage;
			
			// add key listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyRelease, false, 0, true);		
			
			// mouse listeners
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mousePress, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseRelease, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseScroll, false, 0, true);
			
		}
		
		/**
		 * Must be set in order for worldMousePos to function. 
		 * @param camera
		 * 
		 */		
		public function activateWorldMouse( a_gameWorld:GameWorld, a_canvasX:int, a_canvasY:int ) : void
		{
			m_camera = a_gameWorld.camera;
			m_camera.addEventListener( GameCamera.MOVE, onCameraMove );
			a_gameWorld.addEventListener( EntityEvent.DISPOSE, onGameWorldDispose, false, 0, true );
			m_canvasX = a_canvasX;
			m_canvasY = a_canvasY;
		}
		
		// ---------------------------------------------------------------------------------------------------------------
 		
 		//======================
		// update
		//======================
		public function update():void
		{
			_nt = getTimer();
			_dt = _nt - _ot;
			_ot = _nt;
				
			// update used keys
			for (var i:int = 0; i < _keyArr.length; i++)
			{
				if (_keyState[_keyArr[i]] != 0){
					_keyState[_keyArr[i]]++ ;
				}
			}
			
			// update buffer
			for (var j:int = 0; j < _bufferSize; j++)
			{
				_keyBuffer[j][1]+= _dt;
			}
			
			// end mouse release / press
			isMousePressed = false;
			isMouseReleased = false;
			
		}
		
		//======================
		// isKeyDown
		//======================
		public function isKeyDown(keyCode:int):Boolean
		{
			return (_keyState[keyCode] > 0);
		}
		
		//======================
		//  isKeyPressed
		//======================
		public function isKeyPressed(keyCode:int):Boolean
		{
			return _keyState[keyCode] == 1;
		}
		
		//======================
		//  isKeyReleased
		//======================
		public function isKeyReleased(keyCode:int):Boolean
		{
			return (_keyState[keyCode] == -1);
		}
		
		//======================
		// isKeyInBuffer
		//======================
		public function isKeyInBuffer(keyCode:int, i:int, t:int):Boolean
		{
			return (_keyBuffer[i][0] == keyCode && _keyBuffer[i][1] <= t);
		}
		
		//======================
		// get key string
		//======================
		public function getKeyString(keyCode:int):String
		{
			return _ascii[keyCode];
		}
		
 		
		// Private -------------------------------------------------------------------------------
		
		private function onGameWorldDispose( e:EntityEvent ) : void
		{
			m_camera = null;
			m_canvasX = 0;
			m_canvasY = 0;
		}
 		
 		//======================
		// set up ascii text
		//======================
		private function fillAscii():void
		{
			_ascii[65] = "A";
			_ascii[66] = "B";
			_ascii[67] = "C";
			_ascii[68] = "D";
			_ascii[69] = "E";
			_ascii[70] = "F";
			_ascii[71] = "G";
			_ascii[72] = "H";
			_ascii[73] = "I";
			_ascii[74] = "J";
			_ascii[75] = "K";
			_ascii[76] = "L";
			_ascii[77] = "M";
			_ascii[78] = "N";
			_ascii[79] = "O";
			_ascii[80] = "P";
			_ascii[81] = "Q";
			_ascii[82] = "R";
			_ascii[83] = "S";
			_ascii[84] = "T";
			_ascii[85] = "U";
			_ascii[86] = "V";
			_ascii[87] = "W";
			_ascii[88] = "X";
			_ascii[89] = "Y";
			_ascii[90] = "Z";
			_ascii[48] = "0";
			_ascii[49] = "1";
			_ascii[50] = "2";
			_ascii[51] = "3";
			_ascii[52] = "4";
			_ascii[53] = "5";
			_ascii[54] = "6";
			_ascii[55] = "7";
			_ascii[56] = "8";
			_ascii[57] = "9";
			_ascii[32] = "Space";
			_ascii[13] = "Enter";
			_ascii[17] = "Ctrl";
			_ascii[16] = "Shift";
			_ascii[192] = "~";
			_ascii[38] = "Up";
			_ascii[40] = "Down";
			_ascii[37] = "Left";
			_ascii[39] = "Right";
			_ascii[96] = "Numpad 0";
			_ascii[97] = "Numpad 1";
			_ascii[98] = "Numpad 2";
			_ascii[99] = "Numpad 3";
			_ascii[100] = "Numpad 4";
			_ascii[101] = "Numpad 5";
			_ascii[102] = "Numpad 6";
			_ascii[103] = "Numpad 7";
			_ascii[104] = "Numpad 8";
			_ascii[105] = "Numpad 9";
			_ascii[111] = "Numpad /";
			_ascii[106] = "Numpad *";
			_ascii[109] = "Numpad -";
			_ascii[107] = "Numpad +";
			_ascii[110] = "Numpad .";
			_ascii[45] = "Insert";
			_ascii[46] = "Delete";
			_ascii[33] = "Page Up";
			_ascii[34] = "Page Down";
			_ascii[35] = "End";
			_ascii[36] = "Home";
			_ascii[112] = "F1";
			_ascii[113] = "F2";
			_ascii[114] = "F3";
			_ascii[115] = "F4";
			_ascii[116] = "F5";
			_ascii[117] = "F6";
			_ascii[118] = "F7";
			_ascii[119] = "F8";
			_ascii[188] = ",";
			_ascii[190] = ".";
			_ascii[186] = ";";
			_ascii[222] = "'";
			_ascii[219] = "[";
			_ascii[221] = "]";
			_ascii[189] = "-";
			_ascii[187] = "+";
			_ascii[220] = "\\";
			_ascii[191] = "/";
			_ascii[9] = "TAB";
			_ascii[8] = "Backspace";
			_ascii[27] = "ESC";
		}
		
		
 		//======================
		// mousePress listener
		//======================
		private function mousePress(e:MouseEvent):void
		{
			isMouseDown = true;
			isMousePressed = true;
			_timeMousePressed = getTimer();
		}		
		
		//======================
		// mousePress listener
		//======================
		private function mouseRelease(e:MouseEvent):void
		{
			isMouseDown = false;
			isMouseReleased = true;
			_timeMouseReleased = getTimer();
		}		
		
		//======================
		// mouseMove listener
		//======================
		private function mouseMove(e:MouseEvent):void
		{
			mouseX = e.stageX - _stage.x;
			mouseY = e.stageY - _stage.y;
			mousePos.x = mouseX;
			mousePos.y = mouseY;
			if( m_camera != null )
			{
				worldMousePos.x = mouseX + m_camera.bounds.left - m_canvasX;
				worldMousePos.y = mouseY + m_camera.bounds.top - m_canvasY;
			}
			else
			{
				worldMousePos.x = mouseX;
				worldMousePos.y = mouseY;
			}		
		}
		
		private function onCameraMove( e:Event ) : void
		{
			worldMousePos.x = mouseX + m_camera.bounds.left + m_canvasX;
			worldMousePos.y = mouseY + m_camera.bounds.top + m_canvasY;
		}

		//======================
		// mouseScroll function
		//======================
		private function mouseScroll(e:MouseEvent):void
		{
			_hasMouseScrolled = true;
			mouseDelta = e.delta;
		}
 		
 		//======================
		// keyPress function
		//======================
		private function keyPress(e:KeyboardEvent):void
		{
			
			//trace ( e.keyCode + " : " + ascii[e.keyCode] );
			
			// set keyState
			_keyState[e.keyCode] = Math.max(_keyState[e.keyCode], 1);
			
			// last key (for key config)
			lastKeyName = _ascii[e.keyCode];
			lastKeyCode = e.keyCode;
			
			if(_keyState[e.keyCode] == 1)
			{
				_timeKeyPressed = getTimer();
			}
		}
		
		//======================
		// keyRelease function
		//======================
		private function keyRelease(e:KeyboardEvent):void
		{
			_keyState[e.keyCode] = -1;
			
			// add to key buffer
			for (var i:int = _bufferSize-1; i > 0 ; i--)
			{
				_keyBuffer[i] = _keyBuffer[i - 1];
			}
			_keyBuffer[0] = [e.keyCode, 0];
			_timeKeyReleased = getTimer();
		}
		
		public var _keyBuffer:Array;
		private static var _instance:Input;
		private var m_camera:GameCamera;
 		private var _stage:Stage;
		private var _ascii:Array;
		private var _keyState:Array;
		private var _keyArr:Array;
		private var _bufferSize:int;
		private var _timeKeyPressed:int;
		private var _timeKeyReleased:int;
		private var _timeMousePressed:int;
		private var _timeMouseReleased:int;
		private var _nt:int, _ot:int, _dt:int;
		private var m_canvasX:int;
		private var m_canvasY:int;
		private var _hasMouseScrolled:Boolean;
		
		// ----------------------------------------------------------------------------------------------------------
 	}
}

class SingletonEnforcer{}

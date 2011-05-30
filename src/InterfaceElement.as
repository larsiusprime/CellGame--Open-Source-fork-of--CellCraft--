	package {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fl.motion.Animator;

	/*This class is what every interface element derives from, and gives them universal features
	like the ability to display tooltips.
	*/

	public class InterfaceElement extends MovieClip{
		
		//Reference to the main interface instance
		protected var p_master:Interface;
		
		//Stuff to help the tooltip work
		private var ttTimer:Timer;
		protected var ttString:String = "nothing";
		
		//tooltip offsets
		private var tt_xoff:Number = 0;
		private var tt_yoff:Number = 0;
		
		//a sub element is an interface element inside of another interface element
		private var subElement:Boolean = false;
		
		//if we are a subinterfaceelement
		private var parent_xoff:Number = 0;
		private var parent_yoff:Number = 0;
		
		private var shoveH:int = 0;
		private var shoveV:int = 1;
		
		protected var tt_onClick:Boolean = false;
		
		public var c_black:Sprite;
		public var isBlackedOut:Boolean = true;
		
		public function InterfaceElement(){
			ttTimer = new Timer(500,0);
			
			unBlackOut();
			setInterface();
			
		}
		
		public function blackOut() {
			if(!isBlackedOut){
				isBlackedOut = true;
				removeEventListener(MouseEvent.MOUSE_OVER, overWait);
				removeEventListener(MouseEvent.MOUSE_OUT, doOut);
				removeEventListener(MouseEvent.CLICK, clickTT);
				if(c_black)
					c_black.visible = true;
			}
			//visible = false;
		}
		
		public function unBlackOut() {
			if(isBlackedOut){
				isBlackedOut = false;
				addEventListener(MouseEvent.MOUSE_OVER,overWait);
				addEventListener(MouseEvent.MOUSE_OUT,doOut);
				addEventListener(MouseEvent.CLICK, clickTT);
				if(c_black)
					c_black.visible = false;
			}
			//visible = true;
		}
		
		public function getMaster():Interface{
			return p_master;
		}
		
		public function setMaster(i:Interface){
			p_master = i;
			//trace(this + "received master: " + master);
		}
		
		public function setInterface(){
			if(parent is Interface)
				p_master = Interface(parent);
			else if(parent is InterfaceElement){
				subElement = true;
				parent_xoff = parent.x;
				parent_yoff = parent.y;
				//trace(this + "waiting for master");
			}
		}
		
		public function setTTString(s:String){
			ttString = s;
		}
		
		public function setTToff(xx:Number,yy:Number){
			tt_xoff = xx;
			tt_yoff = yy;
		}
		
		protected function clickTT(m:MouseEvent){
			if(tt_onClick){
				showTooltip();
			}
		}
		
		private function overWait(m:MouseEvent){
			ttTimer.reset();
			ttTimer.start();
		}
		
		public function tt_shove(xx:int,yy:int){ //this element walled on the right
			if(xx == 1 || xx == 0 || xx == -1)
				shoveH = xx;
			else
				throw new Error("xx = " + xx + ": tt_shove(xx,yy) only accepts 1,0,-1 as input!");
			
			if(yy == 1 || yy == 0 || yy == -1)
				shoveV = yy;
			else
				throw new Error("yy = " + yy + ":tt_shove(xx,yy) only accepts 1,0,-1 as input!");
		}
		
		private function showTooltip(){
			p_master.showTooltip(ttString,x+tt_xoff+parent_xoff,y+tt_yoff+parent_yoff,shoveH,shoveV);
		}
		
		private function overTime(t:TimerEvent){
			//trace("master = " + master);
			if(ttString != "nothing"){
				showTooltip();
			}
			ttTimer.removeEventListener(TimerEvent.TIMER, overTime);
		}
		
		private function doOut(m:MouseEvent){
			resetTimer();	
			if(p_master){
				p_master.hideTooltip(ttString);
				onHideTooltip();
			}
		}
		
		protected function onHideTooltip(){
		//per subclass define
		}
		
		private function resetTimer(){
			ttTimer.addEventListener(TimerEvent.TIMER, overTime);
			ttTimer.reset();
		}
		
		public function glow() {
			
var this_xml:XML = <Motion duration="30" xmlns="fl.motion.*" xmlns:geom="flash.geom.*" xmlns:filters="flash.filters.*">
	<source>
		<Source frameRate="30" x="-4" y="-3" scaleX="1" scaleY="1" rotation="0" elementType="sprite" symbolName="Cross" class="InterfaceElement">
			<dimensions>
				<geom:Rectangle left="-75" top="-75" width="150" height="150"/>
			</dimensions>
			<transformationPoint>
				<geom:Point x="0.5" y="0.5"/>
			</transformationPoint>
		</Source>
	</source>

	<Keyframe index="0" tweenSnap="true" tweenSync="true">
		<tweens>
			<SimpleEase ease="0.97"/>
		</tweens>
		<filters>
			<filters:GlowFilter blurX="0" blurY="0" color="0xFFFFFF" alpha="1" strength="1" quality="1" inner="false" knockout="false"/>
			<filters:GlowFilter blurX="0" blurY="0" color="0x00FF00" alpha="1" strength="1" quality="1" inner="false" knockout="false"/>
		</filters>
	</Keyframe>

	<Keyframe index="14" tweenSnap="true" tweenSync="true">
		<tweens>
			<SimpleEase ease="-1"/>
		</tweens>
		<filters>
			<filters:GlowFilter blurX="10" blurY="10" color="0xFFFFFF" alpha="1" strength="4" quality="1" inner="false" knockout="false"/>
			<filters:GlowFilter blurX="10" blurY="10" color="0x00FF00" alpha="1" strength="2" quality="1" inner="false" knockout="false"/>
		</filters>
	</Keyframe>

	<Keyframe index="29">
		<filters>
			<filters:GlowFilter blurX="0" blurY="0" color="0xFFFFFF" alpha="1" strength="1" quality="1" inner="false" knockout="false"/>
			<filters:GlowFilter blurX="0" blurY="0" color="0x00FF00" alpha="1" strength="1" quality="1" inner="false" knockout="false"/>
		</filters>
	</Keyframe>
</Motion>;

var this_animator:Animator = new Animator(this_xml, this);
this_animator.play();

		}
	}

}
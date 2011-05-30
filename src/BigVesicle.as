package  
{
	import com.cheezeworld.math.Vector2D;
	import flash.display.Shape;
	import flash.events.Event;
	import fl.motion.Color;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class BigVesicle extends CellObject
	{
		//public var v_size:Vector2D;
		private var size:Number=0;
		private var maxSize:Number=0;
		private const GROW_SPEED:Number = 2;
		private var list_contents:Vector.<CellObject>;
		private var shape:Shape;
		
		private var mnode:MembraneNode;
		
		private var product:int = Selectable.NOTHING;
		
		public var needsLysosomes:Boolean = false;
		private var lysoNeeded:int = 0;
		private var lysoOrdered:int = 0;
		private var lysoFused:int = 0;
		public var ph_balance:Number = 7.5;
		private var ph_show:Number = 7.5;
		private var isDigestGrow:Boolean = false;
		
		private var lyso_wait_count:int = 0;
		private var lyso_wait_time:int = 60; //every 2 seconds poll again
		
		private var anim_phase:int = 0;
		
		private var unRecycle:Boolean = false;
		
		private var mem_wait_count:int = 0;
		private const MEM_WAIT_TIME:int = 15;
		
		public function BigVesicle(startSize:Number=0) 
		{
			size = startSize;
			canSelect = false;
			singleSelect = true;
			text_title = "Big Vesicle";
			text_description = "A large vesicle for holding things";
			text_id = "big_vesicle";
			num_id = Selectable.BIGVESICLE;
			
			list_actions = new Vector.<int>();
			list_contents = new Vector.<CellObject>;
			shape = new Shape();
			addChild(shape);
			init();
			
			updateBigVesicle();
		}
		
		public function setProduct(i:int) {
			product = i;
		}
		
		public function setPH(ph:Number) {
			ph_balance = ph;
			//updateBigVesicle();
			addEventListener(RunFrameEvent.RUNFRAME, animPH,false,0,true);
		}
		
		private function animPH(r:RunFrameEvent) {
			var change:Number = 0.09;
			if (ph_show < ph_balance - change) {
				ph_show += change;
			}else if (ph_show > ph_balance + change) {
				ph_show -= change;
			}else {
				ph_show = ph_balance;
				removeEventListener(RunFrameEvent.RUNFRAME, animPH);
			}
			updateBigVesicle();
		}
		
		public override function onCanvasWrapperUpdate() {
			updateBigVesicle();
		}
		
		public override function updateBubbleZoom(n:Number) {
			super.updateBubbleZoom(n);
			updateBigVesicle();
		}
		
		public function updateBigVesicle() {
			if (size > 0) {
				
				var col:uint;
				var col2:uint;
				var col3:uint;
				
				col = PH.getCytoColor(ph_show);
				col2 = PH.getLineColor(ph_show);
				col3 = PH.getGapColor(ph_show);

				shape.graphics.clear();
				shape.graphics.beginFill(col, 1);
				shape.graphics.lineStyle(Membrane.OUTLINE_THICK / 1.5, 0x000000);
				shape.graphics.drawCircle(0, 0, size);
				shape.graphics.endFill();
				//shape.graphics.drawEllipse(x-size/2,y-size/2,size, size);
				shape.graphics.lineStyle(Membrane.SPRING_THICK / 2, col2);
				shape.graphics.drawCircle(0, 0, size);
				//shape.graphics.drawEllipse(x-size/2,y-size/2,size, size);
				shape.graphics.lineStyle(Membrane.GAP_THICK / 3, col3);
				shape.graphics.drawCircle(0, 0, size);
				//shape.graphics.drawEllipse(x-size/2,y-size/2,size, size);
				
			}
		}
		
		public function getLysosNeeded():Number {
			var lysos:Number = PH.getLysosNeeded(ph_balance, getCircleVolume(), Lysosome.PH_BALANCE);
			return Math.ceil(lysos);
		}
		
		public override function getCircleVolume():Number {
			return Math.PI * size * size;
		}
		
		public function startDigestGrow(c:CellObject) {
			canSelect = false; //can't select a digestion vesicle
			var r:Number = c.getRadius() * 1.25;
			startGrow(r);
			isDigestGrow = true;
			putIn(c);
		}
		
		public function instantGrow(s:Number) {
			maxSize = s - (Membrane.OUTLINE_THICK_ / 2);
			size = maxSize;
			setRadius(s);
			updateBigVesicle();
		}
		
		private function waitForMembrane(r:RunFrameEvent) {
			mem_wait_count++;
			if (mem_wait_count > MEM_WAIT_TIME) {
				mem_wait_count = 0;
				removeEventListener(RunFrameEvent.RUNFRAME, waitForMembrane);
				goToMembrane();
			}
		}
		
		public function goToMembrane() {
			mnode = tryGetNode();
			if(mnode){
				moveToPoint(new Point(mnode.x, mnode.y), GameObject.FLOAT, true);
				p_cell.c_membrane.acceptVesicle();
			}else {
				addEventListener(RunFrameEvent.RUNFRAME, waitForMembrane, false, 0, true);
			}
		}
		
		public function tryGetNode():MembraneNode {
			if(p_cell.c_membrane.acceptingVesicles){
				return p_cell.c_membrane.findClosestMembraneNode(x, y);
			}else {
				return null;
			}
		}
		
		public function startGrow(s:Number) {
			size = 0;
			setRadius(0);
			maxSize = s;
			addEventListener(RunFrameEvent.RUNFRAME, grow, false, 0, true);
		}
		
		private function startShrink() {
			unDigestContents();
			addEventListener(RunFrameEvent.RUNFRAME, shrink, false, 0, true);
		}
		
		private function grow(e:RunFrameEvent) {
			
			//trace("BigVesicle.grow()");
			size += GROW_SPEED;
			setRadius(size+Membrane.OUTLINE_THICK_/4);
			if (size > maxSize) {
				
				onGrowFinish();
			}
			updateBigVesicle();
		}
		
		private function shrink(e:RunFrameEvent) {
			size -= GROW_SPEED;
			setRadius(size + Membrane.OUTLINE_THICK_ / 4);
			updateBigVesicle();
			if (size <= 0) {
				size = 0;
				onShrinkFinish();
			}
			
		}
		
		private function onGrowFinish() {
			size = maxSize;
			removeEventListener(RunFrameEvent.RUNFRAME, grow);
			if (isDigestGrow) {
				lysoNeeded = getLysosNeeded();
				lysoOrdered = lysoNeeded;
				callForLysosomes();
			}
		}
		
		private function onShrinkFinish() {
			size = 0;
			removeEventListener(RunFrameEvent.RUNFRAME, shrink);
			for each (var c:CellObject in list_contents) {
				if (c.dying == false) {
					c.outVesicle(unRecycle); //release the contents of the vesicle. If we canceled a recycle, undoom them.
				}
			}
			//shape.graphics.clear();
			p_cell.killSomething(this);
		}
		
		/**
		 * Dismisses incoming lysosomes, unfuses existing lysosomes, shrinks the vesicle, releases the organelle
		 */
		
		public function cancelRecycle() {
			unRecycle = true;
			if (lysoOrdered > lysoFused) {
				p_cell.dismissLysosomes(this);
			}
			
			if (size < maxSize) {
				size = maxSize;
				removeEventListener(RunFrameEvent.RUNFRAME, grow);
			}
			anim_phase = 0;
			
			removeEventListener(RunFrameEvent.RUNFRAME, animateDigest);
			unPackLysos();
			
			if (lysoFused == 0) {
				startShrink(); //just do it right now, thanks
			}
		}
		
		private function callForLysosomes() {
			lysoNeeded = p_cell.askForLysosomes(this, lysoNeeded);
			if (lysoNeeded > 0) {
				addEventListener(RunFrameEvent.RUNFRAME, waitForLysosomes,false,0,true);
			}else {
				lysoNeeded = 0;
			}
		}
		
		public function getLysosomeFuse(l:Lysosome) {
			addToPH(l.getCircleVolumeV(), Lysosome.PH_BALANCE);
			//lysoOrdered--;
			lysoFused++;
			if (lysoFused >= lysoOrdered) {
				trace("BigVesicle.getLysosomeFuse(), We are GOOD!");
				digestContents();
			}
			if (unRecycle) { //if we're unrecycling, spit it back out
				unPackLysos();
			}
		}
		
		public function onLysosomeBud() {
			lysoOrdered--;
			
			if (lysoOrdered <= 0 || lysoFused <= 0) {
				startShrink();
			}
		}
		
		private function unFuseLysosome(l:Lysosome) {
			removeFromPH(l.getCircleVolumeV(), Lysosome.PH_BALANCE);
			l.setBigVesicleFuser(this);
			lysoFused--;
		}
		
		private function unDigestContents() {
			for each(var c:CellObject in list_contents) {
				c.setPHDamage(7.5, 0);
			}
		}
		
		private function digestContents() {
			for each(var c:CellObject in list_contents) {
				c.setPHDamage(ph_balance,3);
			}
			addEventListener(RunFrameEvent.RUNFRAME, animateDigest,false,0,true);
		}
		
		private function animateDigest(r:RunFrameEvent) {
			var max:Number = 1.1;
			var min:Number = 0.9;
			var change:Number = 0.02;
			switch(anim_phase) {
				case 0: 
					scaleX += change; scaleY -= change; 
					if (scaleX > max) {
						scaleX = max;
						scaleY = min;
						anim_phase = 1;
					}
				break;
				case 1:
					scaleX -= change; scaleY += change;
					if (scaleY > max) {
						scaleY = max;
						scaleX = min;
						anim_phase = 0;
						if (checkContentsDigested()) {
							anim_phase = 2;
						}
						
					}
				break;
				case 2:
					scaleX += change; scaleY -= change;
					if (scaleY < 1) {
						scaleY = 1;
						scaleX = 1;
						anim_phase = 0;
						removeEventListener(RunFrameEvent.RUNFRAME, animateDigest);
						unPackLysos();
					}
				break;
			}
		}
		
		private function unPackLysos() {
			var v:Vector2D = new Vector2D(1, 0);
			v.multiply(size+Membrane.OUTLINE_THICK_/3);
			var length:int = lysoFused;
			for (var i:int = 0; i < length; i++) {
				v.rotateVector((Math.PI*2)/length);
				var r:Number = v.toRotation() * 180 / Math.PI;
				r += 90;
				var l:Lysosome = p_cell.budLysosome(x + v.x, y + v.y, r);
				unFuseLysosome(l);
			}
			//startShrink();
		}
		
		private function checkContentsDigested():Boolean {
			var i:int = 0;
			for each(var c:CellObject in list_contents) {
				if(c){
					if (c.getHealth() <= 0 || c.dying) {
						list_contents[i] = null;
					}
					if (list_contents[i] != null) {
						return false;
					}
				}
				i++;
			}
			list_contents = null;
			return true;
		}
		
		private function removeFromPH(vol:Number, ph:Number) {
			var newPh:Number = PH.removeFromPH(ph, vol, ph_balance, getCircleVolume());
			if (newPh > 7.5) newPh = 7.5; //hack to avoid alkalinity
			setPH(newPh);
		}
		
		private function addToPH(vol:Number, ph:Number) {
			var newPh:Number = PH.mergePH(ph, vol, ph_balance, getCircleVolume());
			setPH(newPh);
		}
		
		private function waitForLysosomes(r:RunFrameEvent) {
			lyso_wait_count++;
			if (lyso_wait_count > lyso_wait_time) {
				removeEventListener(RunFrameEvent.RUNFRAME, waitForLysosomes);
				callForLysosomes();
				lyso_wait_count = 0;
			}
		}
		
		public function putIn(c:CellObject) {
			var isIn:Boolean = false;
			for each(var cc:CellObject in list_contents) {
				if (cc == c) {
					isIn = true;
				}
			}
			if (!isIn) {
				list_contents.push(c);
				c.inVesicle(this);
			}
		}
		
		protected override function doMoveToPoint(e:Event) {
			var diffx:Number = x;
			var diffy:Number = y;
			super.doMoveToPoint(e);
			diffx -= x;
			diffy -= y;
			followContents(diffx, diffy);
		}
		
		protected override function doMoveToGobj(e:Event) {
			var diffx:Number = x;
			var diffy:Number = y;
			super.doMoveToGobj(e);
			diffx -= x;
			diffy -= y;
			followContents(diffx, diffy);
		}
		
		private function followContents(xx:Number, yy:Number) {
			for each(var c:CellObject in list_contents) {
				c.push(-xx, -yy);
			}
		}
		
		protected override function onArrivePoint() {
			if (mnode != null) {
				p_cell.makeMembrane(new Point(x,y)); 
				p_cell.killSomething(this);
			}else {
				
			}
			
		}
	}
	
}
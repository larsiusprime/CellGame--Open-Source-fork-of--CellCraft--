package  
{
	import flash.events.Event;
	
	/**
	 * This class is used to put a CellObject in the Canvas. You can move it around like any canvas object, but it will
	 * take its childed cellobject with it, which always stays at 0,0 relative to this, which is its parent.
	 * @author Lars A. Doucet
	 */
	public class CanvasWrapperObject extends CanvasObject
	{
		public var c_cellObj:CellObject;
		private var p_cell:Cell;
		public var c_icon:CanvasWrapperIcon;
		public var content:String = "";
		private var maxSpeed:Number = 10;
		private var minSpeed:Number = 1;
		
		public function CanvasWrapperObject() 
		{
			
		}
		
		public override function destruct() {
			super.destruct();
			if (c_cellObj) {
				c_cellObj.destruct();
				//p_cell.killSomething(c_cellObj);
			}
			if (c_icon) {
				c_icon = null;
			}
			c_cellObj = null;
			p_cell = null;
		}
		
		public function setCell(c:Cell) {
			p_cell = c;
		}
		
		public function setCellObj(c:CellObject) {
			c_cellObj = c;
			c_cellObj.x = 0;
			c_cellObj.y = 0;
			c_cellObj.setCanSelect(false);
			addChild(c_cellObj);
		}
		
		public override function matchZoom(n:Number) {
			
			/*p_cellObj.matchZoom(n);
			icon.scaleX = 1 / n;
			icon.scaleY = 1 / n;*/
			/*scaleX = 1 / n;
			scaleY = 1 / n;*/

			//trace("CanvasWrapperObject.matchZoom() n=" + n + " scaleX="+scaleX);
			//scaleX = 1 / n;
			//scaleY = 1 / n;
			c_cellObj.onCanvasWrapperUpdate();
		}

		
		
		public function makeVesicleObjectFromId(id:String) {
			trace("CanvasWrapperObject.makeVesicleObjectFromID(" + id + ")!");
			content = id;
			if (c_icon) {
				c_icon.gotoAndStop(id);
			}else {
				c_icon = new CanvasWrapperIcon();
				c_icon.x = 0;
				c_icon.y = 0;
				addChild(c_icon);
				c_icon.gotoAndStop(id);
			}
			var radius:Number = c_icon.getRadius()*1.25;
			setRadius(radius);
			var v:BigVesicle = p_cell.export_makeBigVesicle(radius);
			setCellObj(v);
			setChildIndex(c_icon, numChildren - 1); //put icon back on top
		}
		
		protected override function doMoveToGobj(e:Event) {
	
			super.doMoveToGobj(e);
			if (lastDist2 < LENS_RADIUS2*1.1) { //slow down as we approach the cell
				speed = minSpeed;
			}else {
				speed = maxSpeed;				//speed up if we're far away
			}
		}
		
		public override function onTouchCell() {
			trace("CanvasWrapperObject.onTouchCell() " + this);
			if(!dying){
				super.onTouchCell();
				p_canvas.onTouchCanvasWrapper(this);
				dying = true;
			}
		}
		/*public override function updateLoc() {

		}*/
		
	}
	
}
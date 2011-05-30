package  
{
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class CanvasObject extends GameObject
	{
		private static var p_cgrid:ObjectGrid;
		protected var p_canvas:WorldCanvas;
		
		public static var LENS_RADIUS:Number = 1000;
		public static var LENS_RADIUS2:Number = 1000 * 1000;
		
		public function CanvasObject() 
		{
			speed = 2;
			makeGameDataObject();
		}
		
		public override function destruct() {
			super.destruct();
			p_canvas = null;
		}
		
		public override function putInGrid() {
			var xx:Number = x - cent_x + span_w / 2;
			var yy:Number = y - cent_y + span_h / 2;
			gdata.x = xx;
			gdata.y = yy;			
			grid_x = int(xx / grid_w);
			grid_y = int(yy / grid_h);
			if (grid_x < 0) grid_x = 0;
			if (grid_y < 0) grid_y = 0;
			if (grid_x >= grid_w) grid_x = grid_w - 1;
			if (grid_y >= grid_h) grid_y = grid_h - 1;
			p_cgrid.putIn(grid_x, grid_y, gdata);
		}
		
		
		public function setCanvas(c:WorldCanvas) {
			p_canvas = c;
		}
		
		public function resetLoc() {
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y - cent_y + span_h / 2;
			grid_x = int(xx / grid_w);
			grid_y = int(yy / grid_h);
			p_cgrid.takeOut(grid_x, grid_y, gdata);
			p_cgrid.putIn(grid_x, grid_y, gdata);
		}
		
		public override function updateLoc(){
			var xx:Number = x-cent_x + span_w / 2;
			var yy:Number = y-cent_y + span_h / 2;
			
			gdata.x = xx;
			gdata.y = yy;
			
			var old_x:int = grid_x;
			var old_y:int = grid_y;
			grid_x = int(xx / grid_w);
			grid_y = int(yy / grid_h);
			if (grid_x < 0) grid_x = 0;
			if (grid_y < 0) grid_y = 0;
			if (grid_x >= grid_w) grid_x = grid_w - 1;
			if (grid_y >= grid_h) grid_y = grid_h - 1;
			if((old_x != grid_x) || (old_y != grid_y)){
				p_cgrid.takeOut(old_x,old_y,gdata);
				p_cgrid.putIn(grid_x,grid_y,gdata);
			}
		}
		
		
		public static function setCanvasGrid(g:ObjectGrid) {
			//all of the new settings will have been set in the superclass, GameObject,
			//when setGrid() was called to set the p_grid, which has identical properties
			p_cgrid = g;
			//all we need now is the pointer
		}
		
		public function onTouchCell() {
			//trace("CanvasObject.onTouchCell()!");
			p_cgrid.takeOut(grid_x, grid_y, gdata);
			//what now
		}
		
		public function onTouchcell2(n:Number) {
			//define per subclass
		}
	}
	
}
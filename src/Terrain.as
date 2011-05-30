package  
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class Terrain extends GameObject
	{
		public static const PETRI_DISH:Number = 0;
		public static const PETRI_DISH_GOLD:Number = 1;
		public static const PETRI_DISH_SILVER:Number = 2;
		public static const PETRI_DISH_GREEN:Number = 3;
		public static const ROBOT_BOX:Number = 10;
		public static const ROBOT_BOX_BROKEN:Number = 11;
		public static const MONSTER_MOUTH:Number = 12;
		
		//private var theCanvas:BigAssCanvas;
		
		private var c_sprite:Sprite;
		private var bmp_terrain:Bitmap;
		private var data_terrain:BitmapData;
		
		private var matrix:Matrix;

		private var scale:Number = 1; //it's important to initialize this!
		private var zoom:Number = 1;
		private var old_scale:Number = 1;
		private var scrollX:Number = 0;
		private var scrollY:Number = 0;
		private var old_scrollX:Number = 0;
		private var old_scrollY:Number = 0;
		public static const SCALE_MULT:Number = 20;
		
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		private var levelScaleW:Number = 1;
		private var levelScaleH:Number = 1;
		
		private var t_width:Number;
		private var t_height:Number;

		
		public function Terrain(i:int,ox:Number,oy:Number,w:Number,h:Number) 
		{
			trace("new Terrain(" + i + "," + ox + "," + oy + "," + w + "," + h + ")");
			offsetX = ox;
			offsetY = oy;
			makeMatrix();
			makeBMP(i, w, h);
			t_width = w;
			t_height = h;
		}
		
		private function makeMatrix() {
			matrix = new Matrix();
			matrix.identity();
		}
		
		private function makeSprite(i:int,w:Number=0,h:Number=0) {
			switch(i) {
				case PETRI_DISH: c_sprite = new TerrainSprite_PetriDish(); break;
				case MONSTER_MOUTH: c_sprite = new TerrainSprite_MonsterMouth(); break;
				case PETRI_DISH_GOLD: c_sprite = new TerrainSprite_PetriDish_Gold(); break;
				case PETRI_DISH_SILVER: c_sprite = new TerrainSprite_PetriDish_Silver(); break;
				case PETRI_DISH_GREEN: c_sprite = new TerrainSprite_PetriDish_Green(); break;
				case -1: throw new Error("Invalid Sprite index for Terrain! " + i); break;
			}
			if (w != 0 && h != 0) {
				trace("Terrain.makeSprite() : c_sprite.size = (" + c_sprite.width + "," + c_sprite.height + ")");
				trace("Terrain.makeSprite() NOW : c_sprite.size = (" + c_sprite.width + "," + c_sprite.height + ")");
			}
		}
		
		private function clearSprite() {
			c_sprite = null;
		}
		
		private function makeBMP(i:int,w:Number,h:Number) {
			makeSprite(i);
			

			//could potentially optimize this so the data_terrain object is never any bigger than it needs to be....
			//(ie, always a BBox of the light circle)
			//but that might actually slow things down
			
			data_terrain = new BitmapData(Director.STAGEWIDTH-offsetX, Director.STAGEHEIGHT-offsetY,false, 0xFF0000);
			bmp_terrain = new Bitmap(data_terrain, "auto", true);
			
			levelScaleW = w / c_sprite.width;
			levelScaleH = h / c_sprite.height;
			
			matrix.identity();
			matrix.scale(levelScaleW, levelScaleH);
			
			data_terrain.draw(c_sprite,matrix);// , null, null, null, null, true);
			
			addChild(bmp_terrain);
			bmp_terrain.x = 0;
			bmp_terrain.y = offsetY;
			
			//doScroll(250, 250);
			//clearSprite();
		}
		
		private function updateScroll() {
			bmp_terrain.scrollRect = new Rectangle( -scrollX, -scrollY, t_width, t_height);
			//if(Math.random() > 0.9)
			//	trace("Terrain.updateScroll() zoom = " + zoom + " scroll = ("+scrollX+","+scrollY+")");
			
		}
		
		private function updateBMP() {
			matrix.identity();	
			matrix.scale(levelScaleW, levelScaleH); //accomodate the level size
			matrix.scale(scale, scale);			  //accomodate the zoom
			offset();							  
			matrix.translate(scrollX, scrollY);	  //accomodate the scroll
					
			data_terrain.fillRect(data_terrain.rect, 0x000000);
			data_terrain.draw(c_sprite, matrix);
		}
		
		/****/
		
		/**
		 * Sets the zoom level directly to this amount. 
		 * @param	n Zoom level (in absolute terms)
		 */
		
		public function oldZoom() {
			scale = old_scale;
			//updateScroll();
			updateBMP();
		}
		 
		public function changeZoom(n:Number) {
			//assume we were at 1.2 and this is called with n=1.5
			//diff will = 0.3, we need to zoom up by 30%
			//diff will then = 1.3, representing 130%
			//the matrix will be scaled by 1.3, ie up by 30%
			
			//var diff:Number = n - scale;	//get the difference between the new zoom and the old zoom
			//diff += 1;
 			old_scale = scale;
			zoom = n;
			scale = n*SCALE_MULT;						//store the new zoom
			
			//matrix.scale(diff, diff);
			updateBMP();
			
			
		}
		
		/**
		 * Move the terrain to the center of the screen, assuming it is at position 0
		 */
		
		public function offset() {			
			var xo:Number = bmp_terrain.width / 2;	//distance to the center of the canvas
			var yo:Number = bmp_terrain.height / 2;
			//xo -= (c_sprite.width/2);			//distance to the center of the sprite
			//yo -= (c_sprite.height/2);
			//resulting values is the distance to move the center of the image
			matrix.translate(xo, yo);
		}
		
		public function oldScroll(xx:Boolean,yy:Boolean) {
			if(xx)
				scrollX = old_scrollX;
			
			if(yy)	
				scrollY = old_scrollY;
			
			//updateScroll();
			updateBMP();
		}
		
		
		public function doScroll(sx:Number, sy:Number) {
			old_scrollX = sx;
			old_scrollY = sy;
			
			scrollX += sx;// * scale;
			scrollY += sy;// * scale;
		
			//checkBounds();
			
			//updateScroll();
			updateBMP();
		}
		
		public function setScrollY(n:Number) {
			old_scrollY = scrollY;
			scrollY = n;
			//updateScroll();
			updateBMP();
		}
		
		public function setScrollX(n:Number) {
			old_scrollX = scrollX;
			scrollX = n;
			//updateScroll();
			updateBMP();
		}
		
		public function getWidth():Number {
			if (c_sprite)
				return c_sprite.width;
			else
				return width;
		}
		
		public function getHeight():Number {
			if (c_sprite)
				return c_sprite.height;
			else
				return height;
		}

		
		/**
		 * Centers the Terrain's DRAWING CENTER at this location (does not move the canvas)
		 * @param	ox offset x (default 0)
		 * @param	oy offset y (default 0) 
		 */
		
		public function center(ox:Number=0,oy:Number=0) {
			old_scrollX = scrollX;
			old_scrollY = scrollY;
			scrollX = ox;
			scrollY = oy;
			//updateScroll();
			updateBMP();
		}
	}
	
}
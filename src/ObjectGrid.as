package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.net.LocalConnection;
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class ObjectGrid extends Sprite
	{
		private var cell_w:Number; //how big is a cell? (assume square)
		private var cell_h:Number;
		private var grid_w:int; //how many cells wide
		private var grid_h:int; //how many cells tall
		private var half_w:Number;
		private var half_h:Number;
		private var grid:Vector.<Vector.<Vector.<GameDataObject>>>;
		

		private var v:Vector.<GameDataObject>;
		private var grid_shape:Shape;
		private var t:int = 0;
		private var testTime:int = 30;
		private var frameCount:int = 0;
		private var tests:Array;
		private var memNum:Number;
		private var calcCount:int = 0;
		
		public function ObjectGrid() 
		{
			setup();		
		}
		
		public function destruct() {
			wipeGrid();
			removeChild(grid_shape);
		}

		
		public function clearGrid() {
			for(var xx:int = grid_w-1; xx >= 0; xx--){
				for(var yy:int = grid_h-1; yy >= 0; yy--){
					var length:int = grid[xx][yy].length;
					for(var i:int = length-1; i >= 0; i--){
						grid[xx][yy][i] = null;
						grid[xx][yy].splice(i,1);
					}
				}
			}
			displayGrid();
		}
		
		public function wipeGrid(){
			for(var xx:int = grid_w-1; xx >= 0; xx--){
				for(var yy:int = grid_h-1; yy >= 0; yy--){
					var length:int = grid[xx][yy].length;
					for(var i:int = length-1; i >= 0; i--){
						//removeChild(grid[xx][yy][i]);
						grid[xx][yy][i] = null;
						grid[xx][yy].splice(i,1);
					}
					grid[xx][yy] = null;
					grid[xx].splice(yy,1);
				}
				grid[xx] = null;
				grid.splice(xx,1);
			}
			grid = null;
			System.gc();
			/*try {
			   new LocalConnection().connect('foo');
			   new LocalConnection().connect('foo');
			} catch (e:*) {}*/

		}
		
		private function setup(){
			grid_shape = new Shape();
			addChild(grid_shape);
			//v = new Vector.<GameObject>;
			/*var k:int;
			for (k = 0; k < 250; k++) {
				var temp = new GameObject();
				v.push(temp);
				addChild(temp);
			}*/
			setChildIndex(grid_shape,numChildren-1);
		}
		
		public function getCellW():Number{
			return cell_w;
		}
		
		public function getCellH():Number{
			return cell_h;
		}
	
		
		public function getGridW():Number{
			return grid_w;
		}
		
		public function getGridH():Number{
			return grid_h;
		}
		
		public function getSpanW():Number {
			return grid_w * cell_w;
		}
		
		public function getSpanH():Number {
			return grid_h * cell_h;
		}
		
		public function makeGrid(w:int, h:int, spanX:Number,spanY:Number) {
			
			grid_w = w;
			grid_h = h;
			cell_w = spanX/grid_w;
			cell_h = spanY/grid_h;
			half_w = cell_w/2;
			half_h = cell_h/2;
			makeNewGrid(grid_w,grid_h);
		}
		
		public function putIn(xx:int, yy:int, thing:GameDataObject) {
			//before we can put the object in we have to transform to grid space, whose 0-0 is at upper left
			
			if(xx >= grid_w) xx = grid_w-1;
			if (yy >= grid_h) yy = grid_h - 1;
			if (xx <= 0) xx = 0;
			if (yy <= 0) yy = 0;
			grid[xx][yy].push(thing);
			
			//DEBUG
			if (Cell.SHOW_GRID) {
				displayGrid();
			}
		}
		
		public function takeOut(xx:int, yy:int, thing:GameDataObject=null) {
			var i:int = 0;
			if(xx >= grid_w) xx = grid_w-1;
			if(yy >= grid_h) yy = grid_h-1;
			if (xx < 0) xx = 0;
			if (yy < 0) yy = 0;
			
			var success:Boolean = false;
			var length:int = grid[xx][yy].length;
			
			for(var j:int = length-1; j >=0; j--){
				if (grid[xx][yy][j].ptr == thing.ptr || thing == null || thing.ptr == null) {
					grid[xx][yy].splice(j,1);
						
					success = true;
					//break;
				}
				i++;
			}
			
			//DEBUG
			if (Cell.SHOW_GRID) {
				displayGrid();
			}
		}
		
		private function makeNewGrid(w:int,h:int) {
			grid = new Vector.<Vector.<Vector.<GameDataObject>>>;
			for (var ww:int = 0; ww < w; ww++) {
				grid.push(new Vector.<Vector.<GameDataObject>>);
				for (var hh:int = 0; hh < h; hh++) {
					grid[ww].push(new Vector.<GameDataObject>);
				}
			}
		}
		
		private function drawGridLines(isCanvas:Boolean) {
			
			grid_shape.graphics.clear();
			if(isCanvas){
				grid_shape.graphics.lineStyle(1, 0xFF0000);
			}else {
				grid_shape.graphics.lineStyle(1, 0x000000);
			}
			grid_shape.graphics.moveTo(0,0);
			for(var w:int = 0; w <= grid_w; w++){
				grid_shape.graphics.moveTo(w*cell_w,0);
				grid_shape.graphics.lineTo(w*cell_w,cell_h*grid_h);
				for(var h:int = 0; h <= grid_h; h++){
					grid_shape.graphics.moveTo(0,h*cell_h);
					grid_shape.graphics.lineTo(cell_w*grid_w,h*cell_h);
				}
			}
			
		}
		
		private function drawContents(){
			for(var w:int = 0; w < grid_w; w++){
				for (var h:int = 0; h < grid_h; h++) {
					var length:int = grid[w][h].length;
					var sizeRatio:Number = cell_w / 16;
					if (length > 0) {
						
						grid_shape.graphics.drawCircle(w * cell_w + half_w, h * cell_h + half_h, length*sizeRatio);
					}	
				}
			}
		}
		
		/*private function testUpdate(e:Event){
			displayGrid();
			frameCount++;
			if(frameCount > testTime){
				frameCount = 0;
				stopTime();
			}
			if(grid){
				for(var w:int = 0; w < grid_w; w++){
					for(var h:int = 0; h < grid_h; h++){
						for each(var g:GameObject in grid[w][h]){
							calcCount += testCollision(grid[w][h],getNeighbors(w,h));
						}
					}
				}
			}
		}*/
		
		private function testCollision(list:Vector.<GameDataObject>,neighbors:Vector.<GameDataObject>):int{
			var calcs:int = 0;
			for each(var g:GameDataObject in list){
				for each(var n:GameDataObject in neighbors){
					calcs++;
					if (g.ptr !== n.ptr) {
						var dx:Number = g.x-n.x;
						var dy:Number = g.y-n.y;
						var d2:Number = (dx*dx)+(dy*dy);
						if(d2 < (g.radius*g.radius+n.radius*n.radius)){
							//collision
						}
					}
				}
			}
			return calcs;
		}
		
		public function getNeighbors(w:int,h:int):Vector.<GameDataObject>{
			var list:Vector.<GameDataObject>;
			list = new Vector.<GameDataObject>;
			for(var xx:int = -1; xx <= 1; xx++){
				for(var yy:int = -1; yy <=1; yy++){
					if(w+xx >= 0 && w+xx < grid_w){
						if(h+yy >= 0 && h+yy < grid_h){
							for each(var g:GameDataObject in grid[w+xx][h+yy]){
								list.push(g);
							}
						}
					}
				}
			}
			return list;
		}
		
		private function updateGrid(e:Event){
			displayGrid();
		}
		
		private function getMemory():Number{
			var mem:Number = Number(System.totalMemory/1025/1024);
			return( mem );
		}


		
		public function displayGrid(isCanvas:Boolean=false) {
			drawGridLines(isCanvas);
			drawContents();
		}
		
		/*private function clearGrid(){
			for (var ww:int = 0; ww < grid_w; ww++) {
				for (var hh:int = 0; hh < grid_h; hh++) {
					takeOut(ww,hh);
				}
			}
			displayGrid();
		}*/
		
		public function setTestTime(s:int){
			testTime = s * 30; //how many seconds you want
		}
		
		
		/*private function doTest(a:Array){
			testGrid(a[0],a[1],a[2],a[3]);
		}*/
		
		/*private function testGrid(xx:int,yy:int,ww:Number,hh:Number) {
			memNum = getMemory();
			//trace("memory before test=" + memNum.toFixed(2)+"MB");
			startTime();
			makeGrid(xx,yy,ww,hh);
			var amountEach:int = Math.ceil(v.length/(xx*yy));
			if(amountEach < 1) amountEach = 1;
			trace((xx*yy) + "cells " +  v.length + " balls, amount each = " + amountEach);
			var k:int = 0;
			var i:int;
			var j:int;
			for (i = 0; i < xx; i++) {
				for (j = 0; j < yy; j++) {
					for(var amt:int = 0; amt < amountEach; amt++){
						if(k < v.length){
							putIn(i, j, v[k]);
							
							var xxx:Number = i*cell_w+half_w;
							var yyy:Number = j*cell_h+half_h;
							//trace("putting in ("+i+","+j+")");
							//trace("placing at ("+xxx+","+yyy+")");
							v[k].place(xxx,yyy);
							v[k].startTime();
							k++;
						}
					}
				}
			}
			trace("******************************");
			trace("Running test, grid=("+xx+"x"+yy+") size=("+ww+","+hh+")");
			runTest();
			clearGrid();
		}*/
		
		/*public function runTest(){			
			for each(var o:GameObject in v){
				o.startTime();
			}
			addEventListener(Event.ENTER_FRAME,testUpdate)
		}*/
		/*
		function startTime(){
			t = getTimer();
		}
		
		function stopTime(){
			t = getTimer()-t;
			trace("Time = " + t);
			var m:Number = getMemory() - memNum;
			//trace("memory after test=" + getMemory().toFixed(2) +"MB");
			trace("test consumed=" + m.toFixed(2) + "MB");
			trace("Calculations=" + calcCount);
			for each(var o:GameObject in v){
				o.stopTime();
			}
			
			removeEventListener(Event.ENTER_FRAME,testUpdate);
			ObjectGridTester(parent).endTest();
		}*/
		
	}
	
}
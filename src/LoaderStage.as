package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import SWFStats.*;
	
	/**
	 * ...
	 * @author Lars A. Doucet
	 */
	public class LoaderStage extends MovieClip
	{
		public var loaderStarted:Boolean = false;
		public var sponsor:SponsorLogoLive;
		//public var c_preload:Preloader;
		
		public function LoaderStage() 
		{
			if(Director.STATS_ON){Log.View(652, "4085e45d-bebd-4a5b-946c-3d750f58abc1", root.loaderInfo.loaderURL);}
			
			//trace("LoaderStage Constructed!");
			if (sponsor) {
				sponsor.id = "preloader";
			}
			addEventListener(Event.ENTER_FRAME, runPreloader, false, 0, true);
		}
		
		private function showPreloader() {
			//newState(DState.PRELOAD);
			/*c_preload = new Preloader();
			addChild(c_preload);*/
		}
		
		private function runPreloader(e:Event) {
			var percent:Number = (parent.loaderInfo.bytesLoaded / parent.loaderInfo.bytesTotal)*100;
			//trace("LoaderStage.runPreloader() : " + percent);
			
			if (!loaderStarted) {
				if (parent.loaderInfo.bytesLoaded == parent.loaderInfo.bytesTotal) {
					finishPreload();
				}else{
					parent.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress,false,0,true);
					parent.loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
					loaderStarted=true;
				}
			}
		}
		
		private function onLoadProgress(p:ProgressEvent) {
			var percentLoaded:int = (parent.loaderInfo.bytesLoaded/parent.loaderInfo.bytesTotal)*100;
			//trace("LoaderStage.onLoadProgress() : " + percentLoaded);
			//loadingBox.update(percentLoaded);
			gotoAndStop(percentLoaded);
		}
		
		private function onLoadComplete(e:Event) {
			//trace("LoaderStage.onLoadComplete");
			//removeChild(c_preload);
			//c_preload = null;
			parent.loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			parent.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			finishPreload();
		}
		
		private function finishPreload() {
			//trace("LoaderStage.finishPreload()");
			removeEventListener(Event.ENTER_FRAME, runPreloader);
			MovieClip(parent).gotoAndStop("ready");
		}
		
		/*private function startItUp() {
			var d:Director = new Director();
			addChild(d);
		}*/
	}
	
}
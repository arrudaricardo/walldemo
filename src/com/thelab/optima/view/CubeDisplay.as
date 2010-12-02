package com.thelab.optima.view
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import mx.events.MoveEvent;
	
	
	public class CubeDisplay extends MovieClip
	{
		private var _preloader:MovieClip;
		private var _loader:ImageLoader;
		
		public function CubeDisplay(path:String)
		{
			super();
			
			
			this.graphics.beginFill(0x000000,1)
			this.graphics.drawRect(0,0,100,100);
			this.graphics.endFill();
			createDisplayObjects();
			
			_loader = new ImageLoader(path,{onComplete:onImgLoaded,onError:onImgLoadError,width:100,height:100,scaleMode:'stretch'});
			
			_loader.load();
			
			showPreloader();
		}
		
		private function onImgLoaded(e:LoaderEvent):void
		{
			clearPreloader();
			this.showImage();
		}
		
		private function onImgLoadError(e:LoaderEvent):void
		{
			trace('cube main img load error');
		}
		
		private function createDisplayObjects():void
		{
			_preloader = new MovieClip()
			_preloader.graphics.beginFill(0xff0000,1);
			_preloader.graphics.drawRect(0,0,10,10);
			_preloader.graphics.endFill();
			
		}
		
		public function showPreloader():void
		{
			this.addChild(_preloader);
		}
		public function clearPreloader():void
		{
			if(_preloader && this.contains(_preloader))
			{
				this.removeChild(_preloader);
			}
		}
		
		public function showImage():void
		{
			clearPreloader();
			this.addChild(_loader.content);
		}
		public function showSelected():void
		{
			
		}
		public function showHighlighted():void
		{
			
		}
	}
}
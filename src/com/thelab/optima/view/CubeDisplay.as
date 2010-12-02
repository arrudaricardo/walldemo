package com.thelab.optima.view
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	public class CubeDisplay extends MovieClip
	{
		private var _preloader:MovieClip;
		private var _display:*;
		private var _loader:ImageLoader;
		private var _selected:MovieClip;
		
		public function CubeDisplay(path:String)
		{
			super();
			
			this.graphics.beginFill(0x000000,1)
			this.graphics.drawRect(0,0,100,100);
			this.graphics.endFill();
			
			createStates();
			
			
			//parse against file extension for different types of files.
			_loader = new ImageLoader(path,{onComplete:onImgLoaded,onError:onImgLoadError,width:100,height:100,scaleMode:'stretch'});
			
			_loader.load();
			showPreloader();
			
		}
		
		public function select():void
		{
			clearPreloader();
			showImage();
			addChild(_selected);
		}
		
		public function deselect():void
		{
			clearPreloader();
			showImage();
			if(this.contains(_selected))
			{					
				this.removeChild(_selected);
			}
		}
		
		
		
		
		private function onImgLoaded(e:LoaderEvent):void
		{
			_display = _loader.content;
			
			clearPreloader();
			showImage();
		}
		
		private function showPreloader():void
		{
			addChild(_preloader);
		}
		private function clearPreloader():void
		{
			if(this.contains(_preloader))
			{
				this.removeChild(_preloader);
			}
		}
		
		private function showImage():void
		{
			addChild(_display);	
		}
		
		private function onImgLoadError(e:LoaderEvent):void
		{
			trace('cube main img load error');
		}
		
		
		private function createStates():void
		{
			_preloader = new MovieClip();
			_preloader.graphics.beginFill(0xff0000,1);
			_preloader.graphics.drawRect(0,0,100,100);
			_preloader.graphics.endFill();
			
			_selected = new MovieClip();
			_selected.graphics.beginFill(0x00ff00,.5);
			_selected.graphics.drawRect(0,0,100,100);
			_selected.graphics.endFill();
		}
		
	}
}
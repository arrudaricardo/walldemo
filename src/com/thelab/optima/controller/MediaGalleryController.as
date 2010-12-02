package com.thelab.optima.controller
{
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.thelab.optima.model.MediaGalleryVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.Signal;
	
	public class MediaGalleryController extends EventDispatcher
	{
		public var configLoaded:Signal;
		public var configFailed:Signal;
		private var _configLoader:XMLLoader;
		private var _configData:XML;
		private var _tileData:Array;
		
		public function MediaGalleryController(target:IEventDispatcher=null)
		{
			super(target);
			
			configLoaded = new Signal();
			configFailed = new Signal();
		}
		
		public function loadConfig(path:String):void
		{
			_configLoader = new XMLLoader(path, { name:"config", noCache:true, onComplete: onConfigLoaded, onFail: onConfigFail });
			//_configLoader.autoDispose = true;
			_configLoader.load();
		}
		
		private function onConfigLoaded(e:LoaderEvent):void
		{
			_configData = _configLoader.content;
			
			_tileData = [];
			
			for each(var n:XML in configData.tile)
			{
				
				_tileData.push(new MediaGalleryVO(n));
			}
			
			configLoaded.dispatch();
			
		}
		
		private function onConfigFail(e:LoaderEvent):void
		{
			trace('loader fail');
			configFailed.dispatch();
		}

		public function get configData():XML
		{
			return _configData;
		}

		public function get tileData():Array
		{
			return _tileData;
		}


	}
}
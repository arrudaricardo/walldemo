package com.thelab.optima.model
{
	public class MediaGalleryVO
	{
		private var _id:int;
		private var _type:String;
		private var _thumb:String;
		private var _asset:String;
		private var _url:String;
		
		public function MediaGalleryVO(data:XML)
		{
			this._id = data.@id;
			this._type = data.@type;
			this._thumb = data.thumb;
			this._asset = data.asset;
			
			if(this._type == 'press')
			{
				this._url = data.url;
			}
		}

		public function get link():String
		{
			return _url;
		}

		public function get asset():String
		{
			return _asset;
		}

		public function get thumb():String
		{
			return _thumb;
		}

		public function get type():String
		{
			return _type;
		}

		public function get id():int
		{
			return _id;
		}


	}
}
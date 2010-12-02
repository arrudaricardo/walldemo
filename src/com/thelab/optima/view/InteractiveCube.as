package com.thelab.optima.view
{
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.BitmapFileMaterial;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MovieMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.data.CubeMaterialsData;
	
	import com.thelab.optima.model.MediaGalleryVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class InteractiveCube extends ObjectContainer3D
	{	
		public var viewRequested:Signal;
		
		private var _data:MediaGalleryVO;
		
		private var _origZ:Number;
		
		private var _selected:Boolean = false;
		
		private var _active:Boolean = false;
		
		private var _cube:Cube;
		
		private var _cube_id:int;
		
		private var _display:CubeDisplay;
		
		
		public function InteractiveCube(data:MediaGalleryVO,initarray:Array)
		{
			super(initarray);
			_data = data;
			
			_cube_id = data.id;
			
			viewRequested = new Signal();
			
			init();
		}
		private function init():void
		{
			_cube = new Cube();
			_cube.width = 10;
			_cube.height= 10;
			_cube.depth = 10;
			_cube.segmentsH = 1;
			_cube.segmentsW =1;
			_cube.segmentsD = 1;
			_cube.rotationY=4;
			
			//
			_display = new CubeDisplay(_data.thumb);
			
			
			var greyMat:ColorMaterial  = new ColorMaterial(0x707070);
			
			var mats:CubeMaterialsData = new CubeMaterialsData();
			mats.front = new MovieMaterial(_display as MovieClip);
			mats.bottom = greyMat;
			mats.top = greyMat;
			mats.left = greyMat;
			mats.right= greyMat;
			mats.back = greyMat;
					
			_cube.cubeMaterials = mats
			
			addChild(_cube);
		}
		
		public function select():void
		{
			this._selected = true;
			
			trace('selected id = '+this.cube_id);
			_display.select();
			
			//could put signal right here, but for clarity:::
			this.requestView();
		}
		
		
		public function deselect():void
		{			
			_display.deselect();
			this._selected = false;
			
		}
		
		//signal dispatch on click;
		public function requestView():void
		{
			viewRequested.dispatch();
		}
		

		
		
		//getters/setters
		public function get origZ():Number
		{
			return _origZ;
		}

		public function set origZ(value:Number):void
		{
			_origZ = value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}


		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

		public function get cube_id():int
		{
			return _cube_id;
		}

	}
}
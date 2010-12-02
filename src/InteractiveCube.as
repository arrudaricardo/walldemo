package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.BitmapFileMaterial;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.data.CubeMaterialsData;
	
	import com.thelab.optima.model.MediaGalleryVO;
	
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
		
		
		private var _origCubeMaterials:CubeMaterialsData;
		private var _selectedCubeMaterials:CubeMaterialsData;
		
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
			
			
			var greyMaterial:ColorMaterial  = new ColorMaterial(0x707070);
			_origCubeMaterials = new CubeMaterialsData();
			_origCubeMaterials.front = new BitmapFileMaterial(_data.thumb,{smoothing:true});
			_origCubeMaterials.bottom = greyMaterial;
			_origCubeMaterials.top = greyMaterial;
			_origCubeMaterials.left = greyMaterial;
			_origCubeMaterials.right= greyMaterial;
			_origCubeMaterials.back = greyMaterial;
			
			
			
			var whiteMaterial:ColorMaterial = new ColorMaterial(0xffffff);
			
			_selectedCubeMaterials = new CubeMaterialsData();
			_selectedCubeMaterials.front = whiteMaterial
			_selectedCubeMaterials.bottom = whiteMaterial
			_selectedCubeMaterials.top = whiteMaterial
			_selectedCubeMaterials.left = whiteMaterial
			_selectedCubeMaterials.right= whiteMaterial
			_selectedCubeMaterials.back = whiteMaterial
			
			
			_cube.cubeMaterials = _origCubeMaterials;
			
			addChild(_cube);
		}
		
		private var _selectedPlane:Plane;
		
		public function select():void
		{
			this._selected = true;
			
			trace('selected id = '+this.cube_id);
			
			if(!_selectedPlane)
			{
				_selectedPlane = new Plane();
				_selectedPlane.material = new ColorMaterial(0xcccccc,.25);
				_selectedPlane.yUp  =true;
				_selectedPlane.z = -10;
				_selectedPlane.width = 11;
				_selectedPlane.height = 11;
				_selectedPlane.rotationX = 90;
			}
			addChild(_selectedPlane);
			
			//could put signal right here, but for clarity:::
			
			this.requestView();
		
			//this is a bug and doesnt work.
			//for now have placed a plane over the selected cube.
			_cube.cubeMaterials = _selectedCubeMaterials;
		}
		
		
		public function deselect():void
		{
			for(var i:int=0;i<this.children.length;i++)
			{
				if(this.children[i] == _selectedPlane)
				{
					this.removeChild(_selectedPlane);
				}
			}
			_cube.cubeMaterials = _origCubeMaterials;
			this._selected = false;
			
		}
		
		//signal dispatch on click;
		public function requestView():void
		{
			viewRequested.dispatch();
		}

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
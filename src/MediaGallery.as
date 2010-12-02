package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.clip.RectangleClipping;
	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapFileMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.data.CubeMaterialsData;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.thelab.optima.controller.MediaGalleryController;
	import com.thelab.optima.view.InteractiveCube;
	import com.thelab.optima.view.OverlayView;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.hires.debug.Stats;
	
	
	[SWF(width='1000',height='400',backgroundColor='#fefefe',frameRate='60')]
	
	public class MediaGallery extends Sprite
	{
		private static const WALL_ROWS:int = 3;
		private static const TEMP_WALL_COUNT:int = 35;
		
		
		private var _controller:MediaGalleryController;
		
		private var _view:View3D;
		private var _scene:Scene3D;
		private var _camera:Camera3D;
		
		
		private var _overlay:OverlayView;
		
		private var _cubeArray:Array;
		private var _container:ObjectContainer3D;
		//cheap 
		private var _containerDest:int = -100;
		
		private var _selectedCube:InteractiveCube;
		
		public function MediaGallery()
		{
			if(this.stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_controller = new MediaGalleryController();
			_controller.configLoaded.addOnce(onConfigLoaded);
			_controller.configFailed.addOnce(onConfigFailed);
			_controller.loadConfig('assets/media.xml');
		}
		
		private function onConfigLoaded():void
		{
			init3d();
			//initCubes();
			initCubes2();
			
			addChild(new Stats());
			this.stage.addEventListener(MouseEvent.CLICK,animateContainerTest);	
		}
		private function onConfigFailed():void
		{
			trace('CONFIG FAILED');
		}
		
		
		private function init3d():void
		{
			this.addEventListener(Event.ENTER_FRAME,render);
			_view = new View3D();
			_view.x = 500;
			_view.y = 200;
			
			
			var clip:RectangleClipping = new RectangleClipping();
			clip.maxX = 500;
			clip.minX = -500;
			clip.maxY = 158;
			clip.minY = -158;
			
			_view.clipping = clip;
			
			addChild(_view);
			
			_camera = new Camera3D();
			_camera.zoom = 100//80; //zoom:80,focus:18 solid, flat;
			_camera.focus = 18;
			_camera.z = -500;
			//_camera.x = 200;
			_scene = new Scene3D();
			
			
			//initial camera rotated away:
			//_camera.rotationY = -50
			
			_view.camera = _camera;
			_view.scene = _scene;
		}
		
		/*
		buggy
		private function initCubes():void
		{
			_cubeArray = [];
			_container = new ObjectContainer3D();
			
			for(var n:int=0;n<_controller.tileData.length;n++)
			{
				for(var j:int=0;j<WALL_ROWS;j++)
				{
					var a:InteractiveCube = new InteractiveCube(_controller.tileData[n],null);
					a.x = 10.25*n;
					a.y = -10.25*j;
					//trace('a.x = '+a.x+' and cube id = '+a.cube_id);
					a.viewRequested.add(onViewRequest);
					//a.z = Math.random()*2;
					//a.origZ = a.z;
					//a.rotationY=-4;
					
					
					//a.addEventListener(MouseEvent3D.MOUSE_DOWN,handleCubeMouseDown,false,0,true);
					_cubeArray.push(a);
					_container.addChild(a);
				}
			}
			_container.rotationY = -60;
			_scene.addChild(_container);
			
		}
		*/
		/*
		 * 
		//http://mandarin.no/as3/actionscript-outputting-a-grid-using-only-one-for-loop/
		private _max:Number = 20; // Total number of items
		private _rows:Number = 5; // Items per row
		private _width:Number = 100;
		private _height:Number = 100;
		 
		private function createGrid():void
		{
		       var ix:Number = 0;
		        for(var i:int=0; i<_max; i++) // Iterate through all items
		        {
		                var col:Number = i % _rows;
		                col==0 ? ++ix : void;
		                x = ix * _width;
		                y = col * _height;
		    }
		}
		*/
		
		//redo
		private function initCubes2():void
		{
			_cubeArray = [];
			_container = new ObjectContainer3D();
			
			var rows:Number = 3;
			var count:Number = _controller.tileData.length;
			
			//var cols:Number = Math.ceil(count/rows);
			
			var _x:Number;
			var _y:Number;
			
			var ix:Number = 0;
			for(var i:int=0;i<count;i++)
			{
				var col:Number = i%rows;
				//col == 0 ? ix++:void;
				
				if(i>0&&col==0)
				{
					ix++;
				}
				
				_x = ix*10.25;
				_y = col*10.25;
				
				var a:InteractiveCube = new InteractiveCube(_controller.tileData[i],null);
				a.x = _x;
				a.y = _y*-1;
				
				//trace('id = '+a.cube_id+'and y = '+a.y);
				
				a.viewRequested.add(onViewRequest);
				//a.z = Math.random()*2;
				//a.origZ = a.z;
				//a.rotationY=-4;
				
				
				//a.addEventListener(MouseEvent3D.MOUSE_DOWN,handleCubeMouseDown,false,0,true);
				_cubeArray.push(a);
				_container.addChild(a);
				
				
			}
			_container.rotationY = -60;
			_container.y = 15;
			_scene.addChild(_container);
		}
		
		
		//animation 1
		private function animateContainerTest(e:MouseEvent):void
		{	
			this.removeEventListener(MouseEvent.CLICK,animateContainerTest);
			
			TweenMax.to(_container,.25,{x:-50,z:-50,ease:Quad.easeInOut,onComplete:animateRotation});
			TweenMax.to(_camera,1,{zoom:150,rotationY:0,ease:Quad.easeIn});
		}
		//animation 2
		private function animateRotation():void
		{
			TweenMax.to(_container,1,{rotationY:0,ease:Quad.easeIn,onComplete:staggerCubeDepths});
		}
		//animation 3
		private function staggerCubeDepths():void
		{
			if(_cubeArray!=null)
			{
				for(var i:int=0;i<_cubeArray.length;i++)
				{
					//set depths
					var newZ:Number = Math.random()*10;
					TweenMax.to(_cubeArray[i],.25,{z:newZ,ease:Quad.easeInOut});
					_cubeArray[i].origZ =newZ;
					
					
					//add listeners after rotated
					//adding listeners here so i dont have to loop through again.
					
					_cubeArray[i].addEventListener(MouseEvent3D.MOUSE_OVER,handleCubeMouseOver,false,0,true);
					_cubeArray[i].addEventListener(MouseEvent3D.MOUSE_OUT,handleCubeMouseOut,false,0,true);
					_cubeArray[i].addEventListener(MouseEvent3D.MOUSE_DOWN,handleCubeMouseDown,false,0,true);
				}
				
				//this.stage.addEventListener(MouseEvent.CLICK,scrollContainer);
			}	
		}
		
		
		//mouse interaction
		private function handleCubeMouseOver(e:MouseEvent3D):void
		{
			var c:InteractiveCube = (e.currentTarget as InteractiveCube);
			TweenMax.to(c,.25,{z:-5});
		}
		private function handleCubeMouseOut(e:MouseEvent3D):void
		{
			var c:InteractiveCube = (e.currentTarget as InteractiveCube);
			TweenMax.to(c,.25,{z:c.origZ});
		}
		
		//select
		private function handleCubeMouseDown(e:MouseEvent3D):void
		{
			//var c:InteractiveCube = (e.currentTarget as InteractiveCube);
			_selectedCube = (e.currentTarget as InteractiveCube);
			
			doSelect(_selectedCube);
			/*
			for(var i:int = 0;i<_cubeArray.length;i++)
			{	
				if(_cubeArray[i]!=_selectedCube)
				{
					(_cubeArray[i] as InteractiveCube).deselect();
				}
				else
				{
					_selectedCube.select();
				}
			}
			*/
		}
		
		private function doSelect(cube:InteractiveCube):void
		{
			for(var i:int = 0;i<_cubeArray.length;i++)
			{	
				if(_cubeArray[i]!=cube)
				{
					(_cubeArray[i] as InteractiveCube).deselect();
				}
				else
				{
					cube.select();
				}
			}
		}
		
		//signal recieved from selected interactive on select in loop above. 
		private function onViewRequest():void
		{
			trace('view request');
			
			showOverlay();
		}
		
		
		private function showOverlay():void
		{
			if(!_overlay)
			{
				_overlay = new OverlayView();
				_overlay.arrowPressed.add(arrowSwitchSelection);
				//listener for close event from overlay
				_overlay.close.add(closeOverlay);
			}
			if(!this.contains(_overlay))
			{	
				this.addChild(_overlay);
			}
		}
		
		private function closeOverlay():void
		{
			if(_overlay && this.contains(_overlay))
			{
				this.removeChild(_overlay);
			}
			_selectedCube.deselect();	
		}
		
		
		private function arrowSwitchSelection(direction:String):void
		{
			trace(direction);
			
			trace('_selectedCube.cube_id == '+_selectedCube.cube_id);
			
			var id:int = _selectedCube.cube_id;
			
			
			switch(direction)
			{
				case OverlayView.RIGHT:
					if(id<_cubeArray.length-1)
					{
						id++;
					}
					else
					{
						id=0;
					}
					_selectedCube = _cubeArray[id];
					this.doSelect(_selectedCube);
				break
				case OverlayView.LEFT:
					if(id>0)
					{
						id--
					}
					else
					{
						id = _cubeArray.length-1;
					}
					_selectedCube = _cubeArray[id];
					this.doSelect(_selectedCube);
				break;
			}
		}
		
		//motion
		private function scrollContainer(e:MouseEvent):void
		{
			TweenMax.to(_container,2,{x:_containerDest,ease:Quad.easeIn,onComplete:updateDest});
			
		}
		private function updateDest():void
		{
			_containerDest = _container.x-100;
		}
		
		private function render(e:Event):void
		{
			_view.render();
		}
	}
}
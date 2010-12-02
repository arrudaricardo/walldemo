package com.thelab.optima.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class OverlayView extends Sprite
	{
		
		public static const RIGHT:String = 'right';
		public static const LEFT:String = 'left';
		
		public var close:Signal;
		public var arrowPressed:Signal
		
		private var _overlay:Sprite;
		private var _lArrow:Sprite;
		private var _rArrow:Sprite;
		private var _closeBtn:Sprite;
		
		public function OverlayView()
		{
			super();
			
			close = new Signal();
			arrowPressed = new Signal();
			
			
			trace('new close created = '+close);
			if(this.stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		private function init(e:Event=null):void
		{	
			drawArrows()
			drawOverlay();
			drawClose();
			addChildren();
			doLayout();
			addListeners();
			
			display();	
		}
		
		private function display():void
		{
			TweenMax.to(_overlay,.25,{alpha:.75,ease:Quad.easeIn});
		}
		
		private function addListeners():void
		{
			_closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,dismiss);
			_rArrow.addEventListener(MouseEvent.MOUSE_DOWN,handleArrowDown);
			_lArrow.addEventListener(MouseEvent.MOUSE_DOWN,handleArrowDown);
		}
		
		private function removeListeners():void
		{
			_closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,dismiss);
			_rArrow.removeEventListener(MouseEvent.MOUSE_DOWN,handleArrowDown);
			_lArrow.removeEventListener(MouseEvent.MOUSE_DOWN,handleArrowDown);
		}
		
		private function drawClose():void
		{
			_closeBtn = new Sprite();
			_closeBtn.graphics.beginFill(0xffffff,1);
			_closeBtn.graphics.drawRect(0,0,20,20);
			_closeBtn.graphics.endFill();
			
			_closeBtn.buttonMode = true;
			_closeBtn.mouseEnabled = true;
			_closeBtn.useHandCursor = true;
		}
		
		private function drawArrows():void
		{
			_lArrow = new Sprite();
			_lArrow.name = 'left';
			_lArrow.graphics.lineStyle(1,0x000000);
			_lArrow.graphics.beginFill(0xfefefe,.8);
			_lArrow.graphics.lineTo(0,80);
			_lArrow.graphics.lineTo(-15,40);
			_lArrow.graphics.lineTo(0,0);
			_lArrow.graphics.endFill();
			
			
			_rArrow = new Sprite();
			_rArrow.name = 'right';
			_rArrow.graphics.lineStyle(1,0x000000);
			_rArrow.graphics.beginFill(0xfefefe,.8);
			_rArrow.graphics.lineTo(0,80);
			_rArrow.graphics.lineTo(15,40);
			_rArrow.graphics.lineTo(0,0);
			_rArrow.graphics.endFill();
			
			_rArrow.buttonMode = true;
			_rArrow.mouseEnabled = true;
			_rArrow.useHandCursor = true;
			
			_lArrow.buttonMode = true;
			_lArrow.mouseEnabled = true;
			_lArrow.useHandCursor = true;
			
		}
		private function drawOverlay():void
		{
			_overlay = new Sprite();
			_overlay.graphics.beginFill(0x00000,1);
			_overlay.graphics.drawRect(0,0,this.stage.stageWidth,this.stage.stageHeight);
			_overlay.graphics.endFill();
			_overlay.alpha = 0;	
		}
		private function doLayout():void
		{
			_lArrow.x = 150;
			_rArrow.x = (_overlay.width-_rArrow.width)-150;
			_lArrow.y = _rArrow.y = 100;
			_closeBtn.x = _overlay.width - 200;
		}
		
		private function addChildren():void
		{
			this.addChild(_overlay);
			
			_overlay.addChild(_lArrow);
			_overlay.addChild(_rArrow);
			_overlay.addChild(_closeBtn);
		}
		
		private function dismiss(e:MouseEvent = null):void
		{
			TweenMax.to(_overlay,.25,{alpha:0,ease:Quad.easeIn,onComplete:doClose});
		}
		
		private function doClose():void
		{
			close.dispatch();
			//this.destroy();
		}
		
		
		private function handleArrowDown(e:MouseEvent):void
		{	
			arrowPressed.dispatch(e.currentTarget.name);
		}
		
		
		private function destroy():void
		{
			removeListeners();
			this.close = null;
			TweenMax.killAll();
			
			_overlay.removeChild(_lArrow);
			_overlay.removeChild(_rArrow);
			_overlay.removeChild(_closeBtn);
			
			_lArrow = null;
			_rArrow = null
			_closeBtn = null;
			_overlay = null;
			
			
		}
		
		
			
	}
}
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
		public var close:Signal;
		
		private var _overlay:Sprite;
		public function OverlayView()
		{
			super();
			
			close = new Signal();
			
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
			
			drawOverlay();
			this.addEventListener(MouseEvent.CLICK,dismiss);	
		}
		
		
		private function drawOverlay():void
		{
			_overlay = new Sprite();
			_overlay.graphics.beginFill(0x00000,1);
			_overlay.graphics.drawRect(0,0,this.stage.stageWidth,this.stage.stageHeight);
			_overlay.graphics.endFill();
			_overlay.alpha = 0;
			this.addChild(_overlay);
			TweenMax.to(_overlay,.25,{alpha:.75,ease:Quad.easeIn});
		}
		
		private function dismiss(e:MouseEvent):void
		{
			TweenMax.to(_overlay,.25,{alpha:0,ease:Quad.easeIn,onComplete:doClose});
		}
		
		private function doClose():void
		{
			close.dispatch();
			this.destroy();
		}
		
		private function destroy():void
		{
			this.close = null
		}
		
		
			
	}
}
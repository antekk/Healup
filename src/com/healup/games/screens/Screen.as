package com.healup.games.screens 
{
	import com.healup.movieclip.LibraryClip;
	import com.healup.movieclip.MC;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author AK
	 */
	public class Screen extends LibraryClip implements IScreen
	{
				
		protected var _options: IScreenOptions;
		protected var _currentFrame:int = 1;
		private var _nextFound:Boolean = false;
		
		private function get options():IScreenOptions {
			return _options as IScreenOptions;
		}
		
		private function set options(value:IScreenOptions) {
			_options = value;
		}
		
		
		protected function initOptions():void {
			options = new ScreenOptions() as IScreenOptions;
		}
		
		public function Screen(param:*, options: IScreenOptions = null) 
		{
			super(param);
			
			initOptions();
			
			if (options != null) {
				this.options.append(options);
			}
			
			registerCloseButtons();	
			registerPrevious();	
			registerNext();	
			registerButtons();
			
			if ((_nextFound || this.options.startFrame > 0) && totalFrames > 1 && this.options.startFrame <= totalFrames) {
				gotoAndStop(this.options.startFrame);
			}
		}
		
		
		public function registerButtons(buttons:String = null):void {
			if (buttons == null) {
				buttons = options.buttons;
			}
			
			var list = MC.search(this, null, '^' + buttons);
			for (var i:int = 0; i < list.length; i++) {
				var button:MovieClip = list[i];
				MC.button(button);
				//button.addEventListener(MouseEvent.CLICK, close_click, false, 0, true);
			}
		}
		
		public function registerCloseButtons(close:String = null):void {
			if (close == null) {
				close = options.close;
			}
			
			var list:Array = MC.search(this, null, '^' + close);
			for (var i:int = 0; i < list.length; i++) {
				var button:MovieClip = list[i];
				MC.button(button);
				button.addEventListener(MouseEvent.CLICK, close_click, false, 0, true);
			}
		}
		
		
		protected function close_click(e:Event):void {
			close();
		}
		
		public function close():void {
			this.parent.removeChild(this);
			dispatchEvent(new ScreenEvent(ScreenEvent.EVENT_CLOSE));
		}
		
		
		public function registerPrevious(prev:String = null):void {
			if (prev == null) {
				prev = options.previous;
			}
			
			var list = MC.search(clip, null, '^' + prev);
			for (var i:int = 0; i < list.length; i++) {
				var button:MovieClip = list[i];
				MC.button(button);
				button.addEventListener(MouseEvent.CLICK, previous_click, false, 0, true);
			}
		}
		
		protected function previous_click(e:Event):void {
			previous();
		}
		
		public function previous():void {
			_currentFrame = displayScreen(_currentFrame-1);
			dispatchEvent(new ScreenEvent(ScreenEvent.EVENT_PREVIOUS));
		}
		
		public function registerNext(next:String = null):void {
			if (next == null) {
				next = options.next;
			}
			
			var list = MC.search(clip, null, '^' + next);
			for (var i:int = 0; i < list.length; i++) {
				_nextFound = true;
				var button:MovieClip = list[i];
				MC.button(button);
				button.addEventListener(MouseEvent.CLICK, next_click, false, 0, true);
			}
		}
		
		protected function next_click(e:Event):void {
			next();
		}
		
		public function next():void {
			_currentFrame = displayScreen(_currentFrame+1);
			dispatchEvent(new ScreenEvent(ScreenEvent.EVENT_NEXT));
		}
		
		public function displayScreen(frame:int) :int {
			if (frame > totalFrames) {
				frame = 1;
			} else if (frame < 1) {
				frame = totalFrames;
			}
			gotoAndStop(frame);
			registerButtons();
			registerCloseButtons();
			registerNext();
			registerPrevious();
			return frame;
		}
	}

}
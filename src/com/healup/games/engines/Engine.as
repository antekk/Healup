package com.healup.games.engines 
{
	import com.healup.movieclip.LibraryClip;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author AK
	 */
	public class Engine extends LibraryClip implements IEngine
	{
		private var _paused:Boolean = false;
		
		private var _playTimeOffset:Number;
		private var _startPlayTime:Number;
		
		public function Engine(className:String) 
		{
			super(className);
			
			analyzeStructure(clip);
			
			addEventListener(Event.ENTER_FRAME,  engine_enterFrame, false, 0, true);
			startGameTime();
			//addEventListener(Event.ADDED_TO_STAGE, engine_addedToStage, false, 0, true);
			//addEventListener(Event.REMOVED_FROM_STAGE, engine_removedFromStage, false, 0, true);
		}
		
		private function analyzeStructure(target:DisplayObject):void {
			var deeper:Boolean = analyze(target);
			
			if (deeper && target is DisplayObjectContainer) {
				var targetContainer:DisplayObjectContainer = target as DisplayObjectContainer;
				for ( var i:int = 0; i < targetContainer.numChildren ; i++ ) {
					analyzeStructure(targetContainer.getChildAt(i));
				}
			}
		}
		
		private function engine_enterFrame(e:Event) :void {
			if (!paused) {
				enterFrame();
			}
		}
		
		public function startGameTime():void {
			_playTimeOffset = 0;
			var now:Date = new Date();
			_startPlayTime = now.getTime();
		}
		
		public function get gameTime():Number {
			var now:Date = new Date();
			if (paused) {
				return _playTimeOffset;
			} else {
				return  _playTimeOffset + now.getTime() - _startPlayTime;
			}
			
		}
		
		/**
		 * To be over written with analysis of element
		 */
		public function analyze(target:DisplayObject):Boolean {
			
			return true;
		}
		
		public function pause():void {
			if (!_paused) {
				dispatchEvent(new EngineEvent(EngineEvent.EVENT_PAUSE));
			}
			_paused = true;
			var now:Date = new Date();
			_playTimeOffset += now.getTime() - _startPlayTime;
		}
		
		public function unpause():void {
			if (_paused) {
				dispatchEvent(new EngineEvent(EngineEvent.EVENT_UNPAUSE));
			}
			_paused = false;
			var now:Date = new Date();
			_startPlayTime = now.getTime();
		}
		
		public function enterFrame() :void {
			// enterframe functionality
		}
				
		public function get paused():Boolean {
			return _paused;
		}
		
		
	}

}
package com.healup.games 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import com.healup.utils.Debug;
	/**
	 * ...
	 * @author AK
	 */
	public class Game extends MovieClip implements IGame 
	{
		
		protected var _state: *;
		
		private function get state():IGameState {
			return _state as IGameState;
		}
		private function set state(value:IGameState) {
			_state = value;
		}
		
		/**
		 * Constructor
		 */
		public function Game() {
			initState();
			showPreloader();
		}
		
		private function showPreloader():void {
			// check for Preloader class?
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, preloader_progress, false, 0, true);
			loaderInfo.addEventListener(Event.COMPLETE, preloader_complete, false, 0, true);
		}
		
		private function preloader_progress(e:ProgressEvent) :void {
			//trace(e.bytesLoaded + ' - ' + e.bytesTotal);
		}
		
		private function preloader_complete(e:Event) :void {
			//trace('progress completed');
			begin();
		}
		
		public function initState():void {
			_state = new GameState();
		}
		
		virtual public function begin():void {
			Debug.out('This game does nothing');
		}
		
		virtual public function end():void {
			Debug.out('Cleanup should occur here');
		}
		
		public function restart() :void {
			end();
			begin();
		}
		
		
	}

}
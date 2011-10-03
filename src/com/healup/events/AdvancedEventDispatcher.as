package com.healup.events 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author AK
	 */
	public class AdvancedEventDispatcher extends EventDispatcher implements IEventDispatcher 
	{
		
		private var _categories:Object;
		private var _listeners:Array;
		
		public function AdvancedEventDispatcher() 
		{
			super();
			_listeners = new Array();
			_categories = new Object();
		}
		
		public function countEventListeners():int {
			return _listeners.length;
		}
		
		public function removeAllEventListeners(type:String = null) :void {
			for (var i:int = 0; i < _listeners.length; i++) {
				var current:EventListener = _listeners[i];
				if (type != null && type != current.type) {
					continue;
				}
				removeEventListener(current.type, current.listener, current.useCapture);
			}
		}
		
		override public function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void {
			_listeners.push(new EventListener(type, listener, useCapture, priority, useWeakReference));
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void {
			for (var i:int = 0; i < _listeners.length; i++) {
				var current:EventListener = _listeners[i];
				if (current.equals(type, listener, useCapture)) {
					_listeners.splice( i, 1 );
					break;
				}
			}
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function addCategorizedListener(category:String, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void {
			if (_categories[category] == null) {
				_categories[category] = new AdvancedEventDispatcher();
			}
			var dispatcher:AdvancedEventDispatcher = _categories[category] as AdvancedEventDispatcher;
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeCategorizedListener (category:String, type:String, listener:Function, useCapture:Boolean = false) : void {
			if (_categories[category] != null) {
				var dispatcher:AdvancedEventDispatcher = _categories[category] as AdvancedEventDispatcher;
				dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function removeAllCategorizedListener (category:String, type:String = null) : void {
			if (_categories[category] != null) {
				var dispatcher:AdvancedEventDispatcher = _categories[category] as AdvancedEventDispatcher;
				dispatcher.removeAllEventListeners(type);
			}
		}
		
		public function dispatchCategorizedEvent(category:String, e:Event) :void {
			if (_categories[category] != null) {
				var dispatcher:AdvancedEventDispatcher = _categories[category] as AdvancedEventDispatcher;
				dispatcher.dispatchEvent(e);
			}
		}
		
		public function hasCategorizedListener(category:String, type:String):Boolean {
			var result = false;
			if (_categories[category] != null) {
				var dispatcher:AdvancedEventDispatcher = _categories[category] as AdvancedEventDispatcher;
				result = dispatcher.hasEventListener(type);
			}
			return result;
		}
 	 	
		public function willTriggerCategorized(category:String, type:String):Boolean {
			var result = false;
			if (_categories[category] != null) {
				var dispatcher:AdvancedEventDispatcher = _categories[category] as AdvancedEventDispatcher;
				result = dispatcher.willTrigger(type);
			}
			return result;
		}
		
		
	}

}
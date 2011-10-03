package com.healup.events 
{
	/**
	 * ...
	 * @author AK
	 */
	class EventListener 
	{
		
		public var type:String;
		public var listener:Function;
		public var useCapture:Boolean;
		public var priority:int;
		public var useWeakReference:Boolean;
		
		public function EventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) 
		{
			this.type = type;
			this.listener = listener;
			this.useCapture = useCapture;
			this.priority = priority;
			this.useWeakReference = useWeakReference;
		}
		
		public function equals(type:String, listener:Function, useCapture:Boolean = false) {
			if (type == this.type && listener == this.listener && useCapture == this.useCapture) {
				return true;
			}
			return false;
		}
		
	}

}
package com.healup.games.engines 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class EngineEvent extends Event 
	{
		public static const EVENT_PAUSE = "com.healup.games.engines.EngineEvent:EVENT_PAUSE";
		public static const EVENT_UNPAUSE = "com.healup.games.engines.EngineEvent:EVENT_UNPAUSE";
		
		
		public function EngineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EngineEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EngineEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
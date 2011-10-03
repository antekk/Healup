package com.healup.games.screens 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class ScreenEvent extends Event 
	{
		
		public static const EVENT_CLOSE:String = 'com.healup.games.screens.ScreenEvent::EVENT_CLOSE';
		public static const EVENT_PREVIOUS:String = 'com.healup.games.screens.ScreenEvent::EVENT_PREVIOUS';
		public static const EVENT_NEXT:String = 'com.healup.games.screens.ScreenEvent::EVENT_NEXT';
		
		public function ScreenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ScreenEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScreenEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
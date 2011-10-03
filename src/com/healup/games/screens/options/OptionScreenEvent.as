package com.healup.games.screens.options 
{
	import com.healup.games.screens.ScreenEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class OptionScreenEvent extends ScreenEvent 
	{
		public static const EVENT_OPTION_SELECTED = "com.healup.games.screens.options.OptionEvent:EVENT_OPTION_SELECTED";
		public var option:String;
		
		public function OptionScreenEvent(type:String, option:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.option = option;
		} 
		
		public override function clone():Event 
		{ 
			return new OptionScreenEvent(type, option, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OptionScreenEvent", "type", 'option', "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
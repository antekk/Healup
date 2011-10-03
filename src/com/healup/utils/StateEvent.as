package com.healup.utils 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class StateEvent extends Event
	{
		public var variable :String;
		public var value    :*;
		public var oldValue :*;
		
		public static var CHANGE = "com.healup.utils.StateEvent:CHANGE";
		
		public function StateEvent( eventType:String, variable:String, value:*, oldValue:*, bubbles:Boolean=false, cancelable:Boolean = false ) 
		{
			this.variable = variable;
			this.value    = value;
			this.oldValue = oldValue;
			super( eventType, bubbles, cancelable );
		}
		
		public override function clone():Event
		{ 
			return new StateEvent( type, variable, value, oldValue, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "StateEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
	}
	
}
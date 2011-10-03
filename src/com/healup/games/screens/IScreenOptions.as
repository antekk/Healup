package com.healup.games.screens 
{
	import com.healup.games.common.IOptions;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IScreenOptions extends IOptions
	{
		function get close():String;
		function set close(value:String):void;
		
		function get next():String;
		function set next(value:String) :void;
		
		function get previous():String;
		function set previous(value:String) :void;
		
		function get startFrame():int;
		function set startFrame(value:int) :void;
		
		function get modal():Boolean;
		function set modal(value:Boolean) :void;
		
		function get buttons():String;
		function set buttons(value:String):void;
	}
	
}
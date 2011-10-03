package com.healup.games.engines 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IEngine 
	{
		function pause():void;
		function unpause():void;
		function enterFrame() :void;
		function get paused():Boolean;
		function startGameTime():void;
		function get gameTime():Number;
		function analyze(target:DisplayObject):Boolean;
	}
	
}
package com.healup.games.screens 
{
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IScreen 
	{
		function registerCloseButtons(prefix:String = null):void;
		function close():void;
		
		function registerPrevious(prev:String = null):void;
		function previous():void;
		
		function registerNext(next:String = null):void;
		function next():void;
		
		function displayScreen(frame:int) :int;
	}
	
}
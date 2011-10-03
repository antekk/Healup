package com.healup.movieclip 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface ILibraryClip extends IEventDispatcher
	{
		function clone():*;
		function get className():String;
		function get width():Number;
		function set width(value:Number) :void;
		function get height():Number ;
		function set height(value:Number) :void;
	}
	
}
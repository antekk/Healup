package com.healup.games.screens.options 
{
	import com.healup.games.screens.IScreenOptions;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IOptionScreenOptions extends IScreenOptions 
	{
		function get prefix():String;
		function set prefix(value:String) :void;
	}
	
}
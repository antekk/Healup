package com.healup.games.screens.upgrade 
{
	import com.healup.games.screens.IScreenOptions;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IUpgradeScreenOptions extends IScreenOptions
	{
		function get prefix():String;
		function set prefix(value:String) :void;
	}
	
}
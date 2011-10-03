package com.healup.games 
{
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IGame 
	{
		function initState():void;
		function begin():void;
		function end():void;
		function restart():void;
			
	}
	
}
package com.healup.games.engines.towerdefence 
{
	import com.healup.movieclip.ILibraryClip;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IBullet extends ILibraryClip
	{
		function enterFrame(enemies:Array):void;
		function isDestroyed():Boolean;
	}
	
}
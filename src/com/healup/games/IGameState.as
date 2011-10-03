package com.healup.games 
{
	import com.healup.utils.IStateManager;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IGameState extends IStateManager
	{
		function get scoreDefault():Number;
		function get score():Number;
		function set score(value:Number) :void;
		
		/**
		 * Lives
		 */
		function get livesDefault():int;
		function get lives():int;
		function set lives(value:int) :void;
		
		/**
		 * Level
		 */
		function get levelDefault():Number;
		function get level():Number;
		function set level(value:Number) :void;
		
		/**
		 * Difficulty
		 */
		function get difficultyMin():int;
		function get difficultyMax():int;
		function get difficulty():int;
		function set difficulty(value:int) :void;
		
		/**
		 * Health
		 */
		function get healthDefault():Number;
		function get healthMin():Number;
		function get healthMax():Number;
		function get health():Number;
		function set health(value:Number) :void;
	}
	
}
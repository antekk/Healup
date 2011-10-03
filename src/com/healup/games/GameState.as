package com.healup.games 
{
	import com.healup.utils.StateManager;
	
	/**
	 * ...
	 * @author AK
	 */
	public class GameState extends StateManager implements IGameState 
	{		
		public static const VAR_SCORE:String = 'score';
		public static const VAR_LIVES:String = 'lives';
		public static const VAR_LEVEL:String = 'level';
		public static const VAR_DIFFICULTY:String = 'difficulty';
		public static const VAR_HEALTH:String = 'health';
				
		public function GameState(defaults:Object = null) 
		{
			super(defaults);
		}
		
		/**
		 * Score
		 */
		public function get scoreDefault():Number {
			return 0;
		}
		
		public function get score():Number {
			return getItem(VAR_SCORE, scoreDefault);
		}
		
		public function set score(value:Number) :void {
			setItem(VAR_SCORE, value);
		}
		
		/**
		 * Lives
		 */
		public function get livesDefault():int {
			return 3;
		}
		
		public function get lives():int {
			return getItem(VAR_LIVES, livesDefault);
		}
		
		public function set lives(value:int) :void {
			setItem(VAR_LIVES, value);
		}
		
		
		/**
		 * Level
		 */
		public function get levelDefault():Number {
			return 1;
		}
		
		public function get level():Number {
			return getItem(VAR_LEVEL, levelDefault);
		}
		
		public function set level(value:Number) :void {
			setItem(VAR_LEVEL, value);
		}
		
		/**
		 * Difficulty
		 */
		public function get difficultyMin():int {
			return 1;
		}
		public function get difficultyMax():int {
			return 3;
		}
		
		public function get difficulty():int {
			return getItem(VAR_DIFFICULTY, levelDefault);
		}
		
		public function set difficulty(value:int) :void {
			if (value > difficultyMax) {
				value = difficultyMax;
			} else if (value < difficultyMin) {
				value = difficultyMin;
			}
			setItem(VAR_DIFFICULTY, value);
		}
		
		/**
		 * Health
		 */
		public function get healthDefault():Number {
			return 1;
		}
		
		public function get healthMin():Number {
			return 0;
		}
		
		public function get healthMax():Number {
			return 1;
		}
		
		public function get health():Number {
			return getItem(VAR_HEALTH, levelDefault);
		}
		
		public function set health(value:Number) :void {
			if (value > healthMax) {
				value = healthMax;
			} else if (value <= healthMin) {
				//dispatchEvent(new GameStateEvent(GameStateEvent.DIE));
				lives--; // decrement a life
				value = healthMax;
			}
			setItem(VAR_HEALTH, value);
		}
		
	}

}
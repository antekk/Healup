package com.healup.games.engines.towerdefence 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class EnemyEvent extends Event 
	{
		public static const EVENT_ENEMY_KILLED:String = "com.healup.games.engines.towerdefence.Enemy:EVENT_ENEMY_KILLED";
		public static const EVENT_ENEMY_FINISHED_PATH:String = "com.healup.games.engines.towerdefence.Enemy:EVENT_ENEMY_FINISHED_PATH";
				
		public var enemy:Enemy;
		
		public function EnemyEvent(type:String, enemy:Enemy, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.enemy = enemy;
		} 
		
		public override function clone():Event 
		{ 
			return new EnemyEvent(type, enemy, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EnemyEvent", "type", "enemy", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
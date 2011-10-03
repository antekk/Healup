package com.healup.games.engines.towerdefence 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class BulletEvent extends Event 
	{
		public static const EVENT_BULLET_HIT:String = "com.healup.games.engines.towerdefence.BulletEvent:EVENT_BULLET_HIT";
		public static const EVENT_BULLET_DESTROYED:String = "com.healup.games.engines.towerdefence.BulletEvent:EVENT_BULLET_DESTROYED";
		
		public var bullet:IBullet;
		
		public function BulletEvent(type:String, bullet:IBullet, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.bullet = bullet;
		} 
		
		public override function clone():Event 
		{ 
			return new BulletEvent(type, bullet, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BulletEvent", "type", "bullet", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
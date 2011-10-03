package com.healup.games.engines.towerdefence 
{
	import com.healup.games.engines.EngineEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class TowerDefenceEngineEvent extends EngineEvent 
	{
		
		public static const EVENT_FINISHED:String = "com.healup.games.engines.towerdefence.TowerDefenceEngineEvent:EVENT_FINISHED";
		public static const EVENT_DEAD:String = "com.healup.games.engines.towerdefence.TowerDefenceEngineEvent:EVENT_DEAD";
		public static const EVENT_WAVE_FINISHED:String = "com.healup.games.engines.towerdefence.TowerDefenceEngineEvent:EVENT_WAVE_FINISHED";
		public static const EVENT_TOWER_ADDED:String = "com.healup.games.engines.towerdefence.TowerDefenceEngineEvent:EVENT_TOWER_ADDED";
		
		public var detail:*;
		
		public function TowerDefenceEngineEvent(type:String, detail:* = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.detail = detail;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TowerDefenceEngineEvent(type, detail, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TowerDefenceEngineEvent", "type", "detail", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
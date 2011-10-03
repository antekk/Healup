package com.healup.games.screens.upgrade 
{
	import com.healup.games.screens.ScreenEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AK
	 */
	public class UpgradeScreenEvent extends ScreenEvent 
	{
		
		public static const EVENT_UPGRADE_SELECTED:String = 'com.healup.games.screens.upgrade.UpgradeScreenEvent::EVENT_UPGRADE_SELECTED';
		public var upgrade:String;
		
		public function UpgradeScreenEvent(type:String, upgrade:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.upgrade = upgrade;
			
		} 
		
		public override function clone():Event 
		{ 
			return new UpgradeScreenEvent(type, upgrade, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UpgradeScreenEvent", "type", 'upgrade', "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
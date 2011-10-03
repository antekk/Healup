package com.healup.utils 
{	
	import com.healup.events.AdvancedEventDispatcher;
	import org.sepy.io.Serializer;
	
	public class StateManager implements IStateManager
	{
		protected var info:Object;
		protected var changeListeners:AdvancedEventDispatcher;

		public function StateManager(defaults:Object = null) {
			clear();
			changeListeners = new AdvancedEventDispatcher();
			if (defaults != null) {			
				for(var key:String in defaults) {
					setItem(key, defaults[key]);
				}
			}
		}
		
		public function addChangeListener(key:String, callback:Function):void {
			changeListeners.addCategorizedListener(key, StateEvent.CHANGE, callback, false, 0, true);
		}
		
		public function removeChangeListener(key:String, callback:Function):void {
			changeListeners.removeCategorizedListener(key, StateEvent.CHANGE, callback);
		}
		
		public function getKeys():Array {
			var result:Array = new Array();
			
			for (var key:String in info) {
				result.push(key);
			}
			
			return result;
		}
		
		public function hasKey(key:String) :Boolean {
			return ArrayUtils.inArray(key, getKeys());
		}
		
		public function getItem( key:String, default_value:* = null ) :*
		{
			return (info[key] != null) ? info[key] : default_value;
		}
		
		public function setItem( key:String, data:* ) :void
		{	
			var old: * = info[ key ];
			info[ key ] = data;
			changeListeners.dispatchCategorizedEvent(key, new StateEvent( StateEvent.CHANGE, key, data, old ));
			//dispatchEvent( new StateEvent( StateEvent.CHANGE, key, data, old ) );
		}
		
		public function clear() :void {
			info = new Object;
		}
		
		public function serialize() :String
		{
				return Serializer.serialize( info );
		}
		
		public function deserialize( stateString:String, overwrite:Boolean = true ) :void
		{		
			try {
				var newInfo =  Serializer.unserialize( stateString );
				
				if( overwrite ) {
					info = newInfo;
				} else {
					ArrayUtils.merge( info, newInfo );
				}
			} catch (e:Error) {
				// do nothing
			}
		}

	}
}
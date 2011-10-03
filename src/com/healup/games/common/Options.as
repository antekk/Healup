package com.healup.games.common 
{
	import com.healup.utils.StateManager;
	
	/**
	 * ...
	 * @author AK
	 */
	public class Options extends StateManager implements IOptions 
	{
		
		public function Options(defaults:Object = null)
		{
			super(defaults);
		}
		
		public function append(overwrite:IOptions) :void {
			var list:Array = overwrite.getKeys();
			for (var i:int; i < list.length; i++) {
				var key:String = list[i] as String;
				setItem(key, overwrite.getItem(key));
			}
		}
	}

}
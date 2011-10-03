package com.healup.games.screens.upgrade 
{
	import com.healup.games.screens.ScreenOptions;
	/**
	 * ...
	 * @author AK
	 */
	public class UpgradeScreenOptions extends ScreenOptions implements IUpgradeScreenOptions
	{
		
		public static const VAR_PREFIX:String = 'prefix';		
		
		public function UpgradeScreenOptions(defaults:Object = null) 
		{
			super(defaults);
		}
		
		
		public function get prefix():String {
			return getItem(VAR_PREFIX, 'up');
		}
		
		public function set prefix(value:String) :void {
			setItem(VAR_PREFIX, value);
		}
	}

}
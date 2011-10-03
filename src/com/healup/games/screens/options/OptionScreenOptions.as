package com.healup.games.screens.options 
{
	import com.healup.games.screens.IScreenOptions;
	import com.healup.games.screens.ScreenOptions;
	
	/**
	 * ...
	 * @author AK
	 */
	public class OptionScreenOptions extends ScreenOptions implements IOptionScreenOptions 
	{
		public static const VAR_PREFIX:String = 'prefix';		
		
		public function OptionScreenOptions(defaults:Object = null) 
		{
			super(defaults);
		}
		
		
		public function get prefix():String {
			return getItem(VAR_PREFIX, 'opt');
		}
		
		public function set prefix(value:String) :void {
			setItem(VAR_PREFIX, value);
		}
	}

}
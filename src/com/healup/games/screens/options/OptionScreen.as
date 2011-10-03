package com.healup.games.screens.options 
{
	import com.healup.games.screens.IScreenOptions;
	import com.healup.games.screens.Screen;
	import com.healup.movieclip.MC;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author AK
	 */
	public class OptionScreen extends Screen 
	{
		
		protected var optionList:Array;
		public var selected:String = null;
		
		public function OptionScreen(param:*, options: IOptionScreenOptions = null) 
		{
			super(param, options);
			
			registerOptions();
		}
		
		public function registerOptions(prefix:String = null) :void {
			if (prefix == null) {
				prefix = options.prefix;
			}
			
			var list:Array = MC.search(clip, null, '^' + prefix);
			optionList = new Array();
			for (var i:int = 0; i < list.length; i++) {
				var option:MovieClip = list[i];
				MC.button(option);
				var name:String = option.name.substr(prefix.length);
				optionList.push(name);
				option.optionName = name;
				option.addEventListener(MouseEvent.CLICK, option_click, false, 0, true);
			}
		}
		
		protected function option_click(e:MouseEvent):void {
			var target:* = MC.searchParent(e.target as DisplayObject, null, '^' + options.prefix);
			selected = target.optionName;
			dispatchEvent(new OptionScreenEvent(OptionScreenEvent.EVENT_OPTION_SELECTED, target.optionName));
		}
		
		private function get options():IOptionScreenOptions {
			return _options as IOptionScreenOptions;
		}
		private function set options(value:IOptionScreenOptions) {
			_options = value;
		}
		
		protected override function initOptions():void {
			options = new OptionScreenOptions() as IOptionScreenOptions;
		}

	}

}
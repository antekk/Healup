package com.healup.games.screens 
{
	import com.healup.games.common.IOptions;
	import com.healup.games.common.Options;
	
	/**
	 * ...
	 * @author AK
	 */
	public class ScreenOptions extends Options implements IScreenOptions
	{
		
		public static const VAR_CLOSE:String = 'close';
		public static const VAR_NEXT:String = 'next';
		public static const VAR_PREVIOUS:String = 'previous';
		public static const VAR_START_FRAME:String = 'startFrame';
		public static const VAR_MODAL:String = 'modal';
		public static const VAR_BUTTONS:String = 'buttons';
		public static const VAR_MULTIPAGE:String = 'multipage';
		
		public function ScreenOptions(defaults:Object = null) 
		{
			super(defaults);
		}
		
		public function get startFrame():int {
			return getItem(VAR_START_FRAME, -1);
		}
		
		public function set startFrame(value:int) :void {
			setItem(VAR_START_FRAME, value);
		}
		
		
		public function get modal():Boolean {
			return getItem(VAR_MODAL, false);
		}
		
		public function set modal(value:Boolean) :void {
			setItem(VAR_MODAL, value);
		}
		
		
		public function get buttons():String {
			return getItem(VAR_BUTTONS, 'btn');
		}
		
		public function set buttons(value:String):void {
			setItem(VAR_BUTTONS, value);
		}
		
		public function get close():String {
			return getItem(VAR_CLOSE, 'close');
		}
		
		public function set close(value:String):void {
			setItem(VAR_CLOSE, value);
		}
		
		public function get next():String {
			return getItem(VAR_NEXT, 'next');
		}
		
		public function set next(value:String) :void {
			setItem(VAR_NEXT, value);
		}
		
		
		public function get previous():String {
			return getItem(VAR_PREVIOUS, 'previous');
		}
		
		public function set previous(value:String) :void {
			setItem(VAR_PREVIOUS, value);
		}
		
		public function get multipage():Boolean {
			return getItem(VAR_MULTIPAGE, false);
		}
		
		public function set multipage(value:Boolean) :void {
			setItem(VAR_MULTIPAGE, value);
		}
	}

}
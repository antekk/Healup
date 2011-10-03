package com.healup.games.screens.upgrade 
{
	import com.healup.games.IGameState;
	import com.healup.games.screens.Screen;
	import com.healup.movieclip.MC;
	import com.healup.utils.ObjectUtils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author AK
	 */
	public class UpgradeScreen extends Screen
	{
		
		protected var state:IGameState;
		
		public function UpgradeScreen(param:*, state:IGameState = null, options:IUpgradeScreenOptions = null) 
		{
			super(param, options);
			
			this.state = state;
			
			registerUpgrades();
			registerStateVars();
			
			if (totalFrames > 1 && this.options.startFrame <= totalFrames) {
				gotoAndStop(this.options.startFrame);
			}
		}
		
		protected function registerUpgrades(prefix:String = null):void {
			if (prefix == null) {
				prefix = options.prefix;
			}
			
			var list = MC.search(clip, null, '^' + prefix);
			for (var i:int = 0; i < list.length; i++) {
				var upgrade:MovieClip = list[i];
				MC.button(upgrade);
				var name:String = upgrade.name.substr(prefix.length);
				upgrade.upgradeName = name;
				upgrade.addEventListener(MouseEvent.CLICK, upgrade_click, false, 0, true);
			}
		}
		
		protected function upgrade_click(e:MouseEvent) :void {
			var target:* = MC.searchParent(e.target as DisplayObject, null, '^' + options.prefix);
			
			dispatchEvent(new UpgradeScreenEvent(UpgradeScreenEvent.EVENT_UPGRADE_SELECTED, target.upgradeName));
		}
		
		
		protected function registerStateVars(state:IGameState = null):void {
			if (state == null) {
				state = this.state;
			}
			if (state != null) {
				// register fields;
			}
		}
		
		
		private function get options():IUpgradeScreenOptions {
			return _options as IUpgradeScreenOptions;
		}
		
		private function set options(value:IUpgradeScreenOptions) {
			_options = value;
		}
		
		protected override function initOptions():void {
			options = new UpgradeScreenOptions() as IUpgradeScreenOptions;
		}
	}

}
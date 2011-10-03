package com.healup.games.smokeem 
{
	import com.healup.games.screens.IScreenOptions;
	import com.healup.games.screens.Screen;
	import com.healup.movieclip.MC;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AK
	 */
	public class GameOverScreen extends Screen 
	{
		
		private var state:SmokeEmState;
		
		public function GameOverScreen(param:*, state:SmokeEmState, options:IScreenOptions = null) 
		{
			super(param, options);
			
			this.state = state;
			
			var list:Array;
			var i:int;
			list = MC.search(this, null, '^Lobbyist');
			for (i = 0; i < list.length; i++) {
				MC.setState(list[i], 'off');
			}
			
			list = MC.search(this, null, '^Marketing');
			for (i = 0; i < list.length; i++) {
				MC.setState(list[i], 'off');
			}
			
			list = MC.search(this, null, '^Scientist');
			for (i = 0; i < list.length; i++) {
				MC.setState(list[i], 'off');
			}
			
			for (i = 0; i < state.upgrades.length; i++) {
				var index:int  = (i + 1);
				var name:String = state.upgrades[i].toString() + index.toString();
				list = MC.search(this, null, name);
				for (var j:int = 0; j < list.length; j++) {
					MC.setState(list[j], 'on');
				}
			}
			
			list = MC.search(this, null, '^lblKills');
			for (i = 0; i < list.length; i++) {
				trace('found kills');
				var kills:TextField = list[i];
				kills.text = state.kills.toString();
			}
			
			list = MC.search(this, null, '^lblMissed');
			for (i = 0; i < list.length; i++) {
				var missed:TextField = list[i];
				missed.text = state.missed.toString();
			}
		}
	}

}
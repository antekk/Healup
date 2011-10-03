package com.healup.games.engines.towerdefence 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import com.healup.games.GameState;
	import com.healup.games.smokeem.SmokeEmState;
	import com.healup.utils.ObjectUtils;
	import com.healup.utils.Debug;
	import com.healup.utils.StateEvent;
	import com.healup.utils.FormatUtils;
	import com.healup.movieclip.MC;
	
	/**
	 * ...
	 * @author AK
	 */
	public class Menu 
	{
		private var menu:MovieClip;
		
		private var towers:Array;
		
		private var currentTower:MovieClip;
		private var gameArea:MovieClip;
		private var engine:TowerDefenceEngine;
		
		private var lblScore:TextField;
		private var lblKills:TextField;
		private var lblMissed:TextField;
		private var lblWave:TextField;
		private var lblLives:TextField;
		
		private var gender:MovieClip;
		private var logo:MovieClip;
		
		private var btnPlay:MovieClip;
				
		
		public function Menu(menu:MovieClip, towerDefenceEngine:TowerDefenceEngine) 
		{
			this.menu = menu;
			engine = towerDefenceEngine;
			prepareTowers();
			prepareLabels();
			prepareButtons();
			
			menu.addEventListener(Event.ENTER_FRAME, menu_enterframe, false, 0, true);
		}
		
		private function menu_enterframe(e:Event) :void {
			if (engine.paused && !MC.isState(btnPlay, 'play')) {
				MC.setState(btnPlay, 'play');
			} else if (!engine.paused && !MC.isState(btnPlay, 'pause')) {
				MC.setState(btnPlay, 'pause');
			}
			
		}
		
		private function prepareTowers() :void {
			var towerList = MC.search(menu, null, 'tower');
			towers = new Array();
			for (var i:int = 0; i < towerList.length; i++) {
				var existing:MovieClip = towerList[i];
				existing.stop();
				var parent:DisplayObjectContainer = existing.parent;
				parent.removeChild(existing);
				var clone:MovieClip = ObjectUtils.clone(existing) as MovieClip;
				var tower:Tower = new Tower(clone , engine);//getQualifiedClassName(existing), engine);
				tower.displayMenu();
				menu.addChild(tower);
				towers.push(tower);
			}
		}
		
		private function prepareLabels():void {
						
			var list:Array;
			list = MC.search(menu, null, 'lblScore');
			if (list.length == 1) {
				lblScore = list[0];
				updateScore();
				engine.state.addChangeListener(GameState.VAR_SCORE, lblScore_change);
			}
			list = MC.search(menu, null, 'lblKills');
			if (list.length == 1) {
				lblKills = list[0];
				updateKills();
				engine.state.addChangeListener(SmokeEmState.VAR_KILLS, lblKills_change);
			}
			list = MC.search(menu, null, 'lblMissed');
			if (list.length == 1) {
				lblMissed = list[0];
				updateMissed();
				engine.state.addChangeListener(SmokeEmState.VAR_MISSED, lblMissed_change);
			}
			list = MC.search(menu, null, 'lblWave');
			if (list.length == 1) {
				lblWave = list[0];
				updateWave();
				engine.state.addChangeListener(GameState.VAR_LEVEL, lblWave_change);
			}
			list = MC.search(menu, null, 'lblLives');
			if (list.length == 1) {
				lblLives = list[0];
				updateLives();
				engine.state.addChangeListener(GameState.VAR_LIVES, lblLives_change);
			}
			trace('gender is  ' + engine.state.gender);
			trace('logo is ' + engine.state.logo);
			list = MC.search(menu, null, 'gender');
			if (list.length == 1) {
				gender = list[0];
				MC.setState(gender, engine.state.gender);
			}
			list = MC.search(menu, null, 'logo');
			if (list.length == 1) {
				logo = list[0];
				MC.setState(logo, engine.state.logo);
			}
			
		}
		
		private function lblScore_change(e:StateEvent) :void {
			updateScore();
		}
		
		private function updateScore() :void {
			if (lblScore) {
				lblScore.text = FormatUtils.currency(engine.state.score, true);
			}
			for (var i:int  = 0; i < towers.length; i++) {
				var tower:Tower = towers[i] as Tower;
				if (engine.state.score < tower.cost) {
					tower.expensive = true;
				} else {
					tower.expensive = false;
				}
			}
		}
		
		private function lblKills_change(e:StateEvent) :void {
			updateKills();
		}
		
		private function updateKills() :void {
			if (lblKills) {
				lblKills.text = engine.state.kills.toString();
			}
		}
		
		private function lblMissed_change(e:StateEvent) :void {
			updateMissed();
		}
		
		private function updateMissed() :void {
			if (lblMissed) {
				lblMissed.text = engine.state.missed.toString();
			}
		}
		
		private function lblWave_change(e:StateEvent) :void {
			updateWave();
		}
		
		private function updateWave() :void {
			if (lblWave) {
				lblWave.text = engine.state.level.toString();
			}
		}
		
		private function lblLives_change(e:StateEvent) :void {
			updateLives();
		}
		
		private function updateLives() :void {
			if (lblLives) {
				lblLives.text = engine.state.lives.toString();
			}
		}
		
		
		private function prepareButtons():void {
			var list:Array;
			list = MC.search(menu, null, 'btnPlay');
			if (list.length == 1) {
				btnPlay = list[0];
				btnPlay.buttonMode = true;
				btnPlay.addEventListener(MouseEvent.CLICK, btnPlay_click, false, 0, true);
			}
		}
		
		private function btnPlay_click(e:Event) :void {
			togglePause();
		}
		
		private function togglePause() :void {
			if (engine.paused) {
				engine.unpause();
			} else {
				engine.pause();
			}
		}
	}

}
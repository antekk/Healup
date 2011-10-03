package com.healup.games.smokeem 
{
	import com.healup.games.engines.EngineEvent;
	import com.healup.games.engines.towerdefence.ITower;
	import com.healup.games.engines.towerdefence.Tower;
	import com.healup.games.engines.towerdefence.TowerDefenceEngine;
	import com.healup.games.engines.towerdefence.TowerDefenceEngineEvent;
	import com.healup.games.engines.towerdefence.TowerDefenceEngineOptions;
	import com.healup.games.engines.towerdefence.Enemy;
	import com.healup.games.engines.towerdefence.Wave;
	import com.healup.games.Game;
	import com.healup.games.IGameState;
	import com.healup.games.screens.options.OptionScreen;
	import com.healup.games.screens.options.OptionScreenEvent;
	import com.healup.games.screens.Screen;
	import com.healup.games.screens.ScreenEvent;
	import com.healup.games.screens.ScreenOptions;
	import com.healup.games.screens.upgrade.UpgradeScreen;
	import com.healup.games.screens.upgrade.UpgradeScreenEvent;
	import com.healup.games.screens.upgrade.UpgradeScreenOptions;
	import com.healup.movieclip.LibraryClip;
	import com.healup.utils.Debug;
	import com.healup.utils.ObjectUtils;
	import com.healup.utils.MathUtils;
	import flash.display.MovieClip;
	import com.healup.movieclip.MC;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author AK
	 */
	public class Main extends Game
	{
		const GAME_OVER_TIME:int = 5 * 60 * 1000;
		
		var genderChooser:OptionScreen;
		var start:OptionScreen;
		var deathChooser:OptionScreen;
		var willScreen:OptionScreen;
		var willFinalScreen:OptionScreen;
		var rebrandScreen:OptionScreen;
		var logoChooser:OptionScreen;
		
		var upgradeScreen:UpgradeScreen;
		var gameOver:Screen;
		var instructions:Screen;
		var upgrades:Screen;
		var infoScreen:Screen;
		
		var nextWaveButton:LibraryClip;
		
		var ctoChooser:OptionScreen;
		
		var towerDefence:TowerDefenceEngine;
		var towerDefenceOptions:TowerDefenceEngineOptions;
		
		var gameOverTimer:Timer;
		var delayTimer:Timer;
		
		var factoriesAdded:int = 0;
		
		public function Main() 
		{
			super();
		}
		
		override public function begin():void {
			//addChild(new LibraryClip('ScreenStart'));
			
			state = new SmokeEmState();
			// defaults:
			state.score = 600000;
			
			// Prepare
			nextWaveButton = new LibraryClip('NextWave');
			MC.button(nextWaveButton, nextWaveButton_click);
			
			
			//startGame();
			
			start = new OptionScreen('ScreenStart');
			start.addEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, start_selected, false, 0, true);
			addChild(start);
			//*/
		}
		
		override public function end():void {
			// Cleanup
			for (var i:int = numChildren - 1; i >= 0; i--) {
				removeChildAt(i);
			}
		}
		
		private function start_selected(e:OptionScreenEvent) :void {
			start.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, start_selected);
			removeChild(start);
			genderChooser = new OptionScreen('ScreenGenderChooser');
			genderChooser.addEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, genderChooser_selected, false, 0, true);
			addChild(genderChooser);
		}
		
		private function genderChooser_selected(e:OptionScreenEvent) :void {
			genderChooser.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, genderChooser_selected);
			state.gender = genderChooser.selected;
			removeChild(genderChooser);
			deathChooser = new OptionScreen('ScreenDeathChooser');
			deathChooser.addEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, deathChooser_selected, false, 0, true);
			addChild(deathChooser);
		}
		
		private function deathChooser_selected(e:OptionScreenEvent) :void {
			deathChooser.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, deathChooser_selected);
			state.death = deathChooser.selected;
			removeChild(deathChooser);
			willScreen = new OptionScreen('ScreenWill' + deathChooser.selected);
			willScreen.addEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, willChooser_selected, false, 0, true);
			addChild(willScreen);
		}
		
		private function willChooser_selected(e:OptionScreenEvent) :void {
			willScreen.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, willChooser_selected);
			removeChild(willScreen);
			willFinalScreen = new OptionScreen('ScreenWillFinal');
			willFinalScreen.addEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, willFinalScreen_selected, false, 0, true);
			addChild(willFinalScreen);
		}
		
		private function willFinalScreen_selected(e:OptionScreenEvent) :void {
			willFinalScreen.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, willFinalScreen_selected);
			removeChild(willFinalScreen);
			logoChooser = new OptionScreen('ScreenLogoChooser');
			logoChooser.addEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, logoChooser_selected, false, 0, true);
			addChild(logoChooser);
		}
		
		private function logoChooser_selected(e:OptionScreenEvent) :void {
			logoChooser.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, logoChooser_selected);
			state.logo = logoChooser.selected;
			removeChild(logoChooser);
			
			startGame();
			
			/*ctoChooser = new OptionScreen('ScreenCTOChooser');
			ctoChooser.addEventListener(OptionEvent.EVENT_OPTION_SELECTED, ctoChooser_selected, false, 0, true);
			addChild(ctoChooser);*/
		}
		
		private function ctoChooser_selected(e:OptionScreenEvent) :void {
			ctoChooser.removeEventListener(OptionScreenEvent.EVENT_OPTION_SELECTED, ctoChooser_selected);
			removeChild(ctoChooser);
			
			startGame();
		}
		
		private function startGame() :void {
					
			towerDefenceOptions = new TowerDefenceEngineOptions();
			// set options
			towerDefence = new TowerDefenceEngine( 'TowerDefenceGame', towerDefenceOptions, state);
			
			/*var temp:MovieClip = new TowerSmokeShop;
			temp.x = 100;
			temp.y = 200;
			addChild(temp);
			var temp2:MovieClip = ObjectUtils.clone(temp) as MovieClip;
			temp2.x = 200;
			addChild(temp2);
			
			var temp4:LibraryClip = new LibraryClip(temp2);
			addChild(temp4);
			//var temp3:Tower = new Tower(temp2, towerDefence);
			//*/
			towerDefence.addWave(generateWave(state.level));
			towerDefence.addWave(generateWave(state.level + 1));
			
			towerDefence.addEventListener(TowerDefenceEngineEvent.EVENT_WAVE_FINISHED, towerDefence_waveFinished, false, 0, true);
			towerDefence.addEventListener(TowerDefenceEngineEvent.EVENT_FINISHED, towerDefence_finished, false, 0, true);
			towerDefence.addEventListener(TowerDefenceEngineEvent.EVENT_DEAD, towerDefence_finished, false, 0, true);
			towerDefence.addEventListener(TowerDefenceEngineEvent.EVENT_TOWER_ADDED, towerDefence_towerAdded, false, 0, true);
			addChild(towerDefence);
			towerDefence.pause();
			showInstructions();
			//showUpgradeScreen();
			// */
			
			gameOverTimer = new Timer( GAME_OVER_TIME, 1);
			gameOverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gameOverTimer_timerComplete, false, 0, true);
			gameOverTimer.start();
			
			/*instructions = new InstructionScreen( 'InstructionsStart' );
			instructions.addEventListener(InstructionEvent.EVENT_INSTRUCTIONS_FINISHED, instructions_finish, false, 0, true);
			addChild(instructions);*/
		}
		
		private function gameOverTimer_timerComplete(e:TimerEvent):void {
			showGameOverScreen();
		}
		
		private function showInstructions() :void {
			instructions = new Screen( 'Instructions' );
			instructions.addEventListener(ScreenEvent.EVENT_CLOSE, instructions_finish, false, 0, true);
			addChild(instructions);
		}
		
		private function instructions_finish(e:ScreenEvent):void {
			instructions.removeEventListener(ScreenEvent.EVENT_CLOSE, instructions_finish);
		}
		
		private function generateWave(level:int = 0):Wave {
			var enemies:Array = new Array('EnemyBaby', 'EnemyLady', 'EnemyPerson', 'EnemyStroller');
			var enemyCount:int = ((level - 1) + 3) * (1 + (level - 1) / 30);
			var health:int = 10 + ((level - 1) * 7) ^ 2;
			var enemy:String = enemies[Math.floor(Math.random() * enemies.length)];
			var speed:Number = 0.7 + (level - 1) / 5;
			var delay:int = Math.max(1200 - ((level - 1) / 30) * 800, 400);
			var points:int = 25 + (10 * (level - 1)) ^ 2;
			
			return new Wave(new Enemy(enemy, speed, health, points), enemyCount, delay);
		}
		
		private function towerDefence_towerAdded(e:TowerDefenceEngineEvent) :void {
			var tower:Tower = e.detail;
			if (tower != null) {
				switch (tower.className) {
					case 'TowerSmokeShop':
						break;
					case 'TowerMarketingFirm':
						break;
					case 'TowerFactory':
						trace('increase per factory');
						factoriesAdded++;
						towerDefenceOptions.extraPoints = Math.floor((tower.cost / 20) * (2 * factoriesAdded));
						break;
					case 'TowerResearchCenter':
						break;
				}
			}
		}
		
		private function towerDefence_waveFinished(e:TowerDefenceEngineEvent) :void {
			state.level++;
			towerDefence.pause();
			towerDefence.addWave(generateWave(state.level));
			
			addChild(nextWaveButton);
			towerDefence.addEventListener(EngineEvent.EVENT_UNPAUSE, nextWaveButton_hide, false, 0, true);
			
			showUpgradeScreen();
		}
		
		private function nextWaveButton_hide(e:EngineEvent) :void {
			removeEventListener(EngineEvent.EVENT_UNPAUSE, nextWaveButton_hide);
			removeChild(nextWaveButton);
		}
		
		private function nextWaveButton_click() :void {
			towerDefence.unpause();
		}
		
		private function showGameOverScreen():void {
			if (gameOver == null) {
				towerDefence.pause();
				gameOver = new GameOverScreen('ScreenGameOver', state);
				gameOver.addEventListener(ScreenEvent.EVENT_CLOSE, gameOver_finish, false, 0, true);
				addChild(gameOver);
			}
		}
		
		private function gameOver_finish(e:ScreenEvent) :void {
			gameOver.removeEventListener(ScreenEvent.EVENT_CLOSE, gameOver_finish);
			
			restart();
		}
		
		private function showUpgradeScreen():void {
			if (MathUtils.isPrime(state.level)) {
				towerDefence.pause();
				delayTimer = new Timer(1000, 1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_finish, false, 0, true);
				delayTimer.start();
			}
		}
		
		private function delayTimer_finish(e:TimerEvent):void {
			upgrades = new UpgradeScreen( 'Upgrades' , null, new UpgradeScreenOptions( { startFrame: (state.lobbyist + state.scientist + state.marketing)} ));
			upgrades.addEventListener(ScreenEvent.EVENT_CLOSE, upgrades_finish, false, 0, true);
			upgrades.addEventListener(UpgradeScreenEvent.EVENT_UPGRADE_SELECTED, upgrades_selected, false, 0, true);
			addChild(upgrades);
		}
		
		private function upgrades_finish(e:ScreenEvent) :void {
			// upgrade is closed and no upgrade was selected ???
		}
		
		private function upgrades_selected(e:UpgradeScreenEvent) :void {
			var ups:Array = state.upgrades;
			ups.push(e.upgrade);
			state.upgrades = ups;
			switch (e.upgrade) {
				case 'Lobbyist':
					state.lobbyist++;
					infoScreen = new Screen('UpgradesLobbyist', new ScreenOptions({startFrame: state.lobbyist}));
					break;
				case 'Marketing':
					state.marketing++;
					infoScreen = new Screen('UpgradesMarketing', new ScreenOptions({startFrame: state.marketing}));
					break;
				case 'Scientist':
					state.scientist++;
					infoScreen = new Screen('UpgradesScientist', new ScreenOptions({startFrame: state.scientist}));
					break;
			}
			removeChild(upgrades);
			
			infoScreen.addEventListener(ScreenEvent.EVENT_CLOSE, infoScreen_finish, false, 0, true);	
			addChild(infoScreen);
		}
		
		private function infoScreen_finish(e:ScreenEvent) :void {
			//showGameOverScreen();
		}
		
		
		private function towerDefence_finished(e:TowerDefenceEngineEvent) :void {
			if (e.type == TowerDefenceEngineEvent.EVENT_DEAD) {
				// we died
			} else {
				// we finished the game
			}
		}
		
		private function get state():SmokeEmState {
			return _state as SmokeEmState;
		}
		
		private function set state(value:SmokeEmState) {
			_state = value;
		}
		
		
	}

}
package com.healup.games.engines.towerdefence 
{
	import adobe.utils.CustomActions;
	import com.healup.games.engines.Engine;
	import com.healup.games.smokeem.SmokeEmState;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author AK
	 */
	public class TowerDefenceEngine extends Engine 
	{
		
		public var options:TowerDefenceEngineOptions;
		public var state:SmokeEmState;
		
		private var currentWave:Number = -1;
		private var lastWaveTime:Number = -1;
		
		public var towers:Array = new Array();
		private var bullets:Array = new Array();
		private var enemies:Array = new Array();
		private var waves:Array = new Array();
		
		private var path:Path;
		private var menu:Menu;
		public var gameArea:MovieClip;
		private var towerPlacementArea:MovieClip;
		
		
		public function TowerDefenceEngine(className:String, options:TowerDefenceEngineOptions, state:SmokeEmState) 
		{
			this.options = options;
			this.state = state;
			super(className);
		}
		
		public function addEnemy(enemy:IEnemy) :void {
			enemy.position(path.getPointAt(0));
			enemy.addEventListener(EnemyEvent.EVENT_ENEMY_FINISHED_PATH, enemy_finished, false, 0, true);
			enemy.addEventListener(EnemyEvent.EVENT_ENEMY_KILLED, enemy_killed, false, 0, true);
			enemies.push(enemy);
		}
		
		public function addWave(wave:Wave):void {
			waves.push(wave);
		}
				
		public function addTower(tower:ITower) :void {
			towers.push(tower);
			dispatchEvent(new TowerDefenceEngineEvent(TowerDefenceEngineEvent.EVENT_TOWER_ADDED, tower));
		}
		
		public function addBullet(bullet:IBullet) :void {
			gameArea.addChild(bullet as DisplayObject);
			bullet.addEventListener(BulletEvent.EVENT_BULLET_HIT, bullet_hit, false, 0, true);
			bullet.addEventListener(BulletEvent.EVENT_BULLET_DESTROYED, bullet_destroyed, false, 0, true);
			bullets.push(bullet);
		}
		
		public function get placementAreas() :Array {
			var result:Array = new Array();
			if (towerPlacementArea != null) {
				for (var i:int = 0; i < towerPlacementArea.numChildren; i++) {
					result.push(towerPlacementArea.getChildAt(i));
				}
			}
			return result;
		}
			
		
		override public function analyze(target:DisplayObject) :Boolean {
			var deeper:Boolean = true;
			
			switch(target.name) {
				case options.pathName:
					path = new Path(target as MovieClip);
					deeper = false;
					break;
				case options.gameArea:
					gameArea = target as MovieClip;
					break;
				case options.towerPlacementArea:
					towerPlacementArea = target as MovieClip;
					//towerPlacementArea.visible = false;
					break;
				case options.menu:
					menu = new Menu(target as MovieClip, this);
					deeper = false;
					break;
			}
			return deeper;
		}
		
		public function launchNextWave():void {
			if (waves.length > currentWave + 1) {
				currentWave++;
				//var wave:Wave = waves[currentWave];
				waves[currentWave].startTime = gameTime;
			}
		}
		
		
		var index:Number = 0;
		override public function enterFrame() :void {
			if (gameTime <= options.startDelay) {
				return;
			}
			if (currentWave == -1) {
				launchNextWave();
			}
			
			if (enemies.length == 0 && (waves[currentWave].enemyTotal - waves[currentWave].enemiesLaunched) == 0) {
				dispatchEvent(new TowerDefenceEngineEvent(TowerDefenceEngineEvent.EVENT_WAVE_FINISHED));
				launchNextWave();
			}
			
			for (var w:int = 0; w <= currentWave; w++) {
				var wave:Wave = waves[w] as Wave;
				if ((wave.enemyTotal - wave.enemiesLaunched) > 0) {
					//trace('('+gameTime + '-' + wave.startTime + '- ((' +wave.enemiesLaunched + ' - 1) * ' + wave.enemyDelay+ ') ) >= ' + wave.enemyDelay);
					if (wave.enemiesLaunched == 0 || (gameTime - wave.startTime - ((wave.enemiesLaunched - 1) * wave.enemyDelay) ) >= wave.enemyDelay) {
						var newEnemy:IEnemy = wave.enemy.clone();
						trace('new Enemy (' + newEnemy.x + ', ' + newEnemy.y + ') - ' + newEnemy.width + ', ' + newEnemy.height);
						addEnemy(newEnemy);
						gameArea.addChild(newEnemy as DisplayObject);
						wave.enemiesLaunched++;
					}
				}
			}

			var cleanup:Array = new Array();
			var i:int = 0;
			
			for (var e:int = 0; e < enemies.length; e++) {
				var enemy:IEnemy = enemies[e] as IEnemy;
				enemy.enterFrame(path);
				if (enemy.isDead() || enemy.isFinished()) {
					cleanup.push(e);
				}
			}
			
			for (i = 0; i < cleanup.length; i++) {
				enemies.splice(cleanup[i], 1);
			}
			
			
			for (var t:int = 0; t < towers.length; t++) {
				var tower:ITower = towers[t] as ITower;
				tower.enterFrame(enemies);
			}
			
			cleanup = new Array();
			for (var b:int = 0; b < bullets.length; b++) {
				var bullet:IBullet = bullets[b] as IBullet;
				bullet.enterFrame(enemies);
				if (bullet.isDestroyed()) {
					cleanup.push(b);
				}
			}
			
			for (i = 0; i < cleanup.length; i++) {
				bullets.splice(cleanup[i], 1);
			}
			
		}
		
		private function enemy_finished(e:EnemyEvent) :void {
			//gameArea.removeChild(e.enemy);
			//delay a bit before removing the enemy
			//enemies.splice(enemies.indexOf(e.enemy), 1);
			// remove life?
			state.missed++;
			state.lives--;
			if (state.lives == 0) {
				dispatchEvent(new TowerDefenceEngineEvent(TowerDefenceEngineEvent.EVENT_DEAD));
			}
		}
		
		private function enemy_killed(e:EnemyEvent) :void {
			state.score += (e.enemy.points + options.extraPoints) * options.pointMultiplier;
			state.kills++;
			//gameArea.removeChild(e.enemy);
			//enemies.splice(enemies.indexOf(e.enemy), 1); 
			// add score?
		}
		
		private function bullet_destroyed(e:BulletEvent) :void {
			//gameArea.removeChild(e.bullet as DisplayObject);
			//bullets.splice(bullets.indexOf(e.bullet), 1);
		}
		
		private function bullet_hit(e:BulletEvent) :void {
			//gameArea.removeChild(e.bullet as DisplayObject);
			//bullets.splice(bullets.indexOf(e.bullet), 1);
		}
	}

}
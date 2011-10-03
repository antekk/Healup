package com.healup.games.engines.towerdefence 
{
	import com.healup.events.AdvancedEventDispatcher;
	import com.healup.movieclip.MC;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author AK
	 */
	public class Wave extends AdvancedEventDispatcher
	{
		public var enemy:IEnemy;
		public var enemyTotal:int;
		public var enemyDelay:Number;
		
		public var enemiesLaunched:int = 0;
		public var startTime:Number;
				
		
		public function Wave(type:IEnemy, count:int = 3, delay:Number = 500) 
		{
			enemy = type;
			enemyTotal = count;
			enemyDelay = delay;
			//addEventListener(Event.ADDED_TO_STAGE, wave_addedToStage, false, 0, true);
		}
		
		/*private function wave_addedToStage(e:Event):void {
			start();
		}*/
		
		/*
		public function enterFrame():void {
			if (active) {
				if (count <= 0 && numChildren <= 0) { 
					finish();
					return;
				}
				var enemy:Enemy;
				var now:Date = new Date();
				var timeNow:Number = now.getTime();
				if ((timeNow - timeStart) >= delay && count > 0) {
					// launch new enemy
					enemy = new Enemy(path, enemyType);
					enemy.addEventListener(EnemyEvent.EVENT_ENEMY_KILLED, enemy_killed, false, 0, true);
					enemy.addEventListener(EnemyEvent.EVENT_ENEMY_FINISHED_PATH, enemy_finished, false, 0, true);
					addChild(enemy);
					count--;
					timeStart = timeNow;
				}
				for (var i:int = 0; i < numChildren; i++) {
					if (getChildAt(i) is Enemy) {
						enemy = getChildAt(i) as Enemy;
						enemy.enterFrame();
					}
				}
			}
		}
		
		
		private function enemy_killed(e:Event):void {
			var enemy:Enemy = e.target as Enemy;
			
			dispatchEvent(new WaveEvent(WaveEvent.EVENT_ENEMY_KILLED, enemy));
		}
		
		private function enemy_finished(e:EnemyEvent):void {
			var enemy:Enemy = e.enemy;
			removeChild(enemy);
			dispatchEvent(new WaveEvent(WaveEvent.EVENT_ENEMY_FINISHED, enemy));

		}
		
		public function get active() :Boolean {
			return started && !finished;
		}
		
		public function start():void {
			started = true;
			finished = false;
			var now:Date = new Date();
			timeStart = now.getTime() - delay; // remove the delay so it starts right away
		}
		
		public function finish():void {
			finished = true;
			dispatchEvent(new WaveEvent(WaveEvent.EVENT_WAVE_FINISHED));
		}*/
	}

}
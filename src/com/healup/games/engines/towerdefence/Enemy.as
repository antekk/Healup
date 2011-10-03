package com.healup.games.engines.towerdefence 
{
	import com.healup.movieclip.LibraryClip;
	import com.healup.movieclip.MC;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author AK
	 */
	public dynamic class Enemy extends LibraryClip implements IEnemy
	{
		
		public var speed:Number;
		public var health: Number;
		public var points:Number;
		
		protected var slowTimer:Timer;
		
		public var effectiveSpeed:Number;
		protected var targetPoint:Point;
		protected var targetVertex:DisplayObject;
		protected var targetPointIndex:int = 0;
		
		protected var finished:Boolean = false;
		protected var killed:Boolean = false;
		
		public function Enemy(className:String = "Enemy", speed:Number = 1, health:Number = 1, points:Number = 1) 
		{
			this.speed = speed;
			this.health = health;
			this.points = points;
			
			super(className);
			
			if (MC.hasState(this, 'moving')) {
				MC.playLoop(this, 'moving');
			}
			
			effectiveSpeed = this.speed;
		}
		
		public function position(point:Point) :void {
			x = point.x;
			y = point.y;
		}
		
		private function move(path:Path, reverse:Boolean = false) :void {
			if (targetPointIndex < 0 ) {
				targetPointIndex = 0;
			} else if (targetPointIndex > (path.length - 1)) {
				targetPointIndex = path.length - 1;
			}
			
			if (!targetPoint) {
				targetPoint = path.getPointAt(targetPointIndex);
			}
			if (!targetVertex) {
				targetVertex = path.getVertexAt(targetPointIndex);
			}
			
			if (MC.absDistance(this, targetVertex) <= effectiveSpeed) {
				if (reverse) {
					targetPointIndex--;
				} else {
					targetPointIndex++;
				}
				if ((!reverse && targetPointIndex >= path.length) || (reverse && targetPointIndex < 0)) {
					// We're at the last point
					finished = true;
					dispatchEvent(new EnemyEvent(EnemyEvent.EVENT_ENEMY_FINISHED_PATH, this));
					addEventListener(MC.EVENT_PLAYSTATE_FINISH, enemy_finishedPlayOnce, false, 0, true);
					if (MC.hasState(this, 'finished')) {
						MC.playOnce(this, 'finished');
					} else {
						dispatchEvent(new Event(MC.EVENT_PLAYSTATE_FINISH));
					}
					return;
				} else {
					targetPoint = path.getPointAt(targetPointIndex);
					targetVertex = path.getVertexAt(targetPointIndex);
				}
			}
			MC.rotateAndMoveTo(this, targetVertex, effectiveSpeed);
		}
		
		private function enemy_finishedPlayOnce(e:Event) :void {
			if (this.parent) {
				this.parent.removeChild(this);
			}
		}
		
		
		public function enterFrame(path:Path):void {
			if (finished || killed) {
				return;
			}
			
			if (isDead()) {
				killed = true;
				dispatchEvent(new EnemyEvent(EnemyEvent.EVENT_ENEMY_KILLED, this));
				addEventListener(MC.EVENT_PLAYSTATE_FINISH, enemy_finishedPlayOnce, false, 0, true);
				if (MC.hasState(this, 'killed')) {
					MC.playOnce(this, 'killed');
				}
				return;
			}
			move(path);
			
		}
		
		
		public function slow(percentage:Number = 75, duration:Number = 500) : void {
			effectiveSpeed = percentage / 100 * speed;
			if (slowTimer == null) {
				slowTimer = new Timer(duration, 1);
				slowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, slowTimer_finish, false, 0, true);
				slowTimer.start();
			} else {
				slowTimer.reset();
				slowTimer.start();
			}
			//trace('Enemy slowed .... ');
		}
		
		private function slowTimer_finish(e:TimerEvent):void {
			//trace('enemy recovered');
			slowTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, slowTimer_finish);
			slowTimer = null;
			effectiveSpeed = speed;
		}
		
		public function isFinished():Boolean {
			return finished;
		}
		
		public function isDead():Boolean {
			return health <= 0;
		}
		
		public function damage(dmg:Number) :void {
			health -= dmg;
		}
		
	}

}
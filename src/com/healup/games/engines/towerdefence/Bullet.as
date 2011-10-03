package com.healup.games.engines.towerdefence 
{
	import com.healup.movieclip.MC;
	import com.healup.movieclip.LibraryClip;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author AK
	 */
	public dynamic class Bullet extends LibraryClip implements IBullet
	{
		protected var target:IEnemy;
		public var speed:Number;
		public var damage:Number;
		public var slow:Number;
		protected var _destroyed:Boolean = false;
		protected var _aoe:Boolean = false;
		protected var hitRange:DisplayObject;
		protected var explodeRange:DisplayObject;
		
		protected var flyingBase:DisplayObject;
		protected var explodeArea:DisplayObject;
		
		public function Bullet(param:*, target:IEnemy, damage:Number = 1, speed:Number = 4, aoe:Boolean = false, slow:Number = 100 ) 
		{
			this.speed = speed;
			this.target = target;
			this.target.addEventListener(EnemyEvent.EVENT_ENEMY_KILLED, enemy_died, false, 0, true);
			this.target.addEventListener(EnemyEvent.EVENT_ENEMY_FINISHED_PATH, enemy_died, false, 0, true);
			this.damage = damage;
			this._aoe = aoe;
			this.slow = slow;
			super(param);
			
			hitRange = this as DisplayObject;
			
			if (MC.hasState(this, 'flying')) {
				MC.playLoop(this, 'flying');
			}
			var found:Array = MC.search(this, null, 'range');
			if (found.length == 1) {
				hitRange = found[0];
			}
		}
		
		public function isDestroyed():Boolean {
			return _destroyed;
		}
		
		private function enemy_died(e:EnemyEvent) :void {
			// destroy bullet or target next enemy?
			_destroyed = true;
			addEventListener(MC.EVENT_PLAYSTATE_FINISH, bullet_finishPlayOnce, false, 0, true);
			if (MC.hasState(this, 'missed')) {
				MC.playOnce(this, 'missed');
			} else {
				dispatchEvent(new Event(MC.EVENT_PLAYSTATE_FINISH));
			}
			dispatchEvent(new BulletEvent(BulletEvent.EVENT_BULLET_DESTROYED, this));
		}
				
		public function enterFrame(enemies:Array):void {
			//trace('bullet flying before (' + this.x + ', ' +  this.y + ')');
			MC.rotateAndMoveTo(this, target as DisplayObject, speed);
			//trace('bullet flying after (' + this.x + ', ' +  this.y + ')');
			// check if we hit the target
			//if (this.hitTestObject(target as DisplayObject)) {
			if (MC.hitTestShape(this, target as DisplayObject)) {
				// we hit the target
				dispatchEvent(new BulletEvent(BulletEvent.EVENT_BULLET_HIT, this));
				explode(enemies);
				
			}
		}
		
		public function isAOE():Boolean {
			return _aoe;
		}
		
		protected function explode(enemies:Array) :void {
			_destroyed = true;
			addEventListener(MC.EVENT_PLAYSTATE_FINISH, bullet_finishPlayOnce, false, 0, true);
			if (MC.hasState(this, 'explode')) {
				MC.playOnce(this, 'explode');
			} else {
				dispatchEvent(new Event(MC.EVENT_PLAYSTATE_FINISH));
			}
			if (isAOE()) {
				for (var i:int = 0; i < enemies.length; i++) {
					var enemy:IEnemy = enemies[i] as IEnemy;
					if (hitTestObject(enemy as DisplayObject)) {
						// figure out how much damage?
						enemy.damage(damage);
						enemy.slow(slow);
					}
				}
			} else {
				target.damage(damage);
				target.slow(slow);
			}
		}
		
		private function bullet_finishPlayOnce(e:Event) :void {
			if (this.parent) {
				this.parent.removeChild(this);
			}
		}
	}

}
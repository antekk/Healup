package com.healup.games.engines.towerdefence 
{
	import com.healup.movieclip.LibraryClip;
	import com.healup.movieclip.MC;
	import com.healup.utils.ObjectUtils;
	import com.healup.utils.FormatUtils;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author AK
	 */
	public dynamic class Tower extends LibraryClip implements ITower
	{
		
		protected var range:MovieClip;
		protected var base:MovieClip;
		protected var bullet:MovieClip;
		protected var turret:MovieClip;
		
		protected var txtCost:TextField;
		protected var txtTitle:TextField;
		
		protected var isExpensive:Boolean = false;
		
		public var cost:Number = 0;
		public var title:String = '';
		public var cooldown:Number = 1000;
		public var duration:Number = 500;
		public var speed:Number = 100;
		public var targets:Number = 1;
		public var damage:Number = 0;
		
		private var lastFireTime:Number;
		
		private var target:Enemy;
		
		private var engine:TowerDefenceEngine;
		
		public function Tower(param:*, engine:TowerDefenceEngine) 
		{
			this.engine = engine;
			super(param);
			lastFireTime = -1 * this.cooldown;
			analyze();
		}
		
		public function get expensive():Boolean {
			return isExpensive;
		}
		
		public function set expensive(value:Boolean):void {
			if (isExpensive != value) {
				isExpensive = value;
				displayMenu();
			}
		}
		
		private function analyze():void {
			var list:Array;
			list = MC.search(this, null, 'range');
			if (list.length == 1) {
				range = list[0];
				range.visible = false;
			}
			list = MC.search(this, null, 'base');
			if (list.length == 1) {
				base = list[0];
			}
			list = MC.search(this, null, 'bullet');
			if (list.length == 1) {
				bullet = list[0];
				MC.setState(bullet, 'flying');
				//bullet.visible = false;
			}
			list = MC.search(this, null, 'turret');
			if (list.length == 1) {
				turret = list[0];
				MC.setState(turret, 'rest');
			}
			
			list = MC.search(this, null, 'lblCost');
			if (list.length == 1) {
				txtCost = list[0] as TextField;
			}
			
			list = MC.search(this, null, 'lblTitle');
			if (list.length == 1) {
				txtTitle = list[0] as TextField;
			}
		}
		
		public function displayMenu() :void {
			if (isExpensive && MC.hasState(this, 'expensive')) {
				MC.setState(this, 'expensive')
			} else {
				MC.setState(this, 'menu');
			}
			analyze();
			if (txtCost) { txtCost.text = FormatUtils.currency(this.cost, true); }
			if (txtTitle) { txtTitle.text = this.title; }
			if (!hasEventListener(MouseEvent.MOUSE_DOWN)) {
				addEventListener(MouseEvent.MOUSE_DOWN, menu_mouseDown, false, 0, true);
			}
		}
		
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
			
			MC.playLoop(this, 'drag');
			analyze();
			super.startDrag();
		}
		override public function stopDrag() :void {
			MC.playLoop(this, 'placed');
			analyze();
			super.stopDrag();
		}
		
		
		private function menu_mouseDown(e:MouseEvent) :void {
			if (!expensive) {
				var tower:Tower = MC.searchParent(e.target as DisplayObject, Tower) as Tower;
				var placementTower:Tower = tower.clone() as Tower;
				engine.gameArea.addChild(placementTower);
				placementTower.addEventListener(MouseEvent.MOUSE_UP, _drag_mouseUp, false, 0, true);
				placementTower.addEventListener(Event.ENTER_FRAME, _drag_enterFrame, false, 0, true);
				placementTower.startDrag();
				//trace('start drag');
			}
		}
		
		private function _drag_enterFrame(e:Event) :void {
			var tower:Tower = MC.searchParent(e.target as DisplayObject, Tower) as Tower;
			
			if (towerCanBePlaced(tower)) {
				tower.alpha = 1;
				if (tower.range) {
					tower.range.visible = true;
					tower.range.alpha = 0.5;
				}
			} else {
				tower.alpha = 0.4;
				if (tower.range) {
					tower.range.visible = false;
				}
			}
		}
		
		private function _drag_mouseUp(e:MouseEvent) :void {
			var tower:Tower = MC.searchParent(e.target as DisplayObject, Tower) as Tower;
			tower.removeEventListener(Event.ENTER_FRAME, _drag_enterFrame);
			tower.removeEventListener(MouseEvent.MOUSE_UP, _drag_mouseUp);
			tower.stopDrag();
			//trace('stopped dragging');
			if (!towerCanBePlaced(tower)) {
				//trace('removing tower');
				tower.parent.removeChild(tower);
				tower = null;
			} else {
				//trace('adding to engine');
				engine.addTower(tower);
				engine.state.score -= tower.cost;
			}
		}
		
		private function towerCanBePlaced(tower:Tower) :Boolean {
			var landingBase:MovieClip = (tower.base) ? tower.base : tower;
			var placedTowers:Array = new Array();
			for (var i:int = 0; i < engine.towers.length; i++) {
				var t:Tower = engine.towers[i] as Tower;
				if (t.base) {
					placedTowers.push(t.base);
				} else {
					placedTowers.push(t);
				}
			}
			return MC.hitTestContained(landingBase, engine.placementAreas) && !MC.hitTestObjects(landingBase, placedTowers);
		}
		
		private function aim(enemy:IEnemy):void {
			if (turret) {
				MC.rotateTo(turret, enemy as DisplayObject);
			}
			if (bullet) {
				MC.rotateTo(bullet, enemy as DisplayObject);
			}
		}
		
		private function fire(enemy:IEnemy):void {
			lastFireTime = engine.gameTime;
			if (bullet) {
				var newBullet:Bullet = new Bullet(getQualifiedClassName(bullet), enemy);
				newBullet.params(bullet.name);
				
				//trace('bullet (' + bullet.x + ', ' + bullet.y + ') new (' + newBullet.x + ', ' + newBullet.y +')');
				//trace ('turret (' + turret.x + ', ' + turret.y + ')');
				var pos:Point = bullet.localToGlobal(new Point(bullet.x, bullet.y));
				
				//trace('bullet at (' + bullet.x + ', ' + bullet.y + ') global - (' + pos.x + ', ' + pos.y + ')');
				newBullet.x = pos.x;
				newBullet.y = pos.y;
				engine.addBullet(newBullet);
			} else {
				// this tower has no bullet so it must hit right away
				if (damage) {
					enemy.damage(damage);
				}
				enemy.slow(speed, duration);
			}
			if (turret) {
				MC.playOnceAndJump(turret, 'fire', 'rest');
			}
		}
		
		private function inRange(enemy:IEnemy):Boolean {
			if (range) {
				return range.hitTestObject(enemy as DisplayObject);
			}
			return false;
		}
		
		public function enterFrame(enemies:Array) :void {
			
			var enemiesTargeted:Number = 0;
			
			for (var i:int = 0; i < enemies.length; i++) {
				var enemy:IEnemy = enemies[i] as IEnemy;
				if (inRange(enemy)) {
					aim(enemy);
					if ((engine.gameTime - lastFireTime) >= cooldown) {
						fire(enemy);
						//enemiesTargeted++;
					}
					break;
					if (enemiesTargeted >= targets) {
						break;
					}
				}
			}
		}
		
		override public function clone():* {
			var sourceClass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			var clone:* = null;
			if (initParam is String) {
				clone = new sourceClass(initParam, engine);
			} else if (initParam is MovieClip) {
				clone = new sourceClass(ObjectUtils.clone(initParam) as MovieClip, engine);
			}
			ObjectUtils.copy(this, clone);
			return clone;
		}
		
	}

}
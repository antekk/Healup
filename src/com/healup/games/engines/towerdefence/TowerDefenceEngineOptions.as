package com.healup.games.engines.towerdefence 
{
	/**
	 * ...
	 * @author AK
	 */
	public class TowerDefenceEngineOptions
	{
		
		public var pathName:String = 'path';
		public var gameArea:String = 'map';
		public var towerPlacementArea:String = 'area';
		public var menu:String = 'menu';
		
		public var startDelay = 0;
		public var waveDelay = 3000;
		
		public var pointMultiplier = 1;
		public var extraPoints = 0;
		
		public var rangeMultiplier = 1;
		
		public function TowerDefenceEngineOptions() 
		{
			
		}
		
	}

}
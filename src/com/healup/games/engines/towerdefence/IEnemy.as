package com.healup.games.engines.towerdefence 
{
	import com.healup.movieclip.ILibraryClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IEnemy extends ILibraryClip
	{
		
		function enterFrame(path:Path):void;
		function position(point:Point):void;
		function damage(dmg:Number):void;
		function slow(percentage:Number = 75, duration:Number = 500) : void;
		function isDead():Boolean;
		function isFinished():Boolean;
		
		function get x():Number;
		function get y():Number;
	}
	
}
package com.healup.games.smokeem 
{
	import com.healup.games.GameState;
	/**
	 * ...
	 * @author AK
	 */
	public class SmokeEmState extends GameState
	{
		
		public static const VAR_GENDER:String = 'gender';
		public static const VAR_LOGO:String = 'logo';
		public static const VAR_DEATH:String = 'death';
		public static const VAR_WILL:String = 'will';
		
		public static const VAR_MISSED:String = 'missed';
		public static const VAR_KILLS:String = 'kills';
		
		public static const VAR_ADVISOR_LOBBYIST:String = 'lobbyist';
		public static const VAR_ADVISOR_MARKETING:String = 'marketing';
		public static const VAR_ADVISOR_SCIENTIST:String = 'scientist';	
		
		public static const VAR_UPGRADES:String = 'upgrades';
		
		public function SmokeEmState() 
		{
			
		}
		
		
		override public function get livesDefault():int {
			return 10;
		}
		
		/**
		 * Options
		 */
		
		public function get lobbyist():int {
			return getItem(VAR_ADVISOR_LOBBYIST, 0);
		}
		
		public function set lobbyist(value:int) :void {
			setItem(VAR_ADVISOR_LOBBYIST, value);
		}
		
		public function get marketing():int {
			return getItem(VAR_ADVISOR_MARKETING, 0);
		}
		
		public function set marketing(value:int) :void {
			setItem(VAR_ADVISOR_MARKETING, value);
		}
		
		public function get scientist():int {
			return getItem(VAR_ADVISOR_SCIENTIST, 0);
		}
		
		public function set scientist(value:int) :void {
			setItem(VAR_ADVISOR_SCIENTIST, value);
		}
		
		public function get upgrades():Array {
			return getItem(VAR_UPGRADES, new Array());
		}
		
		public function set upgrades(value:Array) :void {
			setItem(VAR_UPGRADES, value);
		}
		
		
		public function get gender():String {
			return getItem(VAR_GENDER, 'Male');
		}
		
		public function set gender(value:String) :void {
			setItem(VAR_GENDER, value);
		}
		
		public function get logo():String {
			return getItem(VAR_LOGO, 'Cancer');
		}
		
		public function set logo(value:String) :void {
			setItem(VAR_LOGO, value);
		}
		
		public function get death():String {
			return getItem(VAR_DEATH, '');
		}
		
		public function set death(value:String) :void {
			setItem(VAR_DEATH, value);
		}
		
		public function get will():String {
			return getItem(VAR_WILL, '');
		}
		
		public function set will(value:String) :void {
			setItem(VAR_WILL, value);
		}
		
		
		/**
		 * Missed
		 */
		public function get missed():Number {
			return getItem(VAR_MISSED, 0);
		}
		
		public function set missed(value:Number) :void {
			setItem(VAR_MISSED, value);
		}
		
		/**
		 * Kills
		 */
		public function get kills():Number {
			return getItem(VAR_KILLS, 0);
		}
		
		public function set kills(value:Number) :void {
			setItem(VAR_KILLS, value);
		}
		
	}

}
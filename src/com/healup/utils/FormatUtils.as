package com.healup.utils 
{
	/**
	 * ...
	 * @author AK
	 */
	public class FormatUtils 
	{
		
		public function FormatUtils() 
		{
			
			throw new Error( "FormatUtils::constructor() - static only class" );
		}
		
		public static function currency(num:Number, round:Boolean = false, prefix:String = "$ ", suffix:String = ""):String {
			return number(num, ((round) ? 0 : 2), '.', ',',  prefix, suffix);
		}
		
		
		public static function number(num:Number, precision:int, decimalDelimiter:String = ".", commaDelimiter:String = ",", prefix:String = "", suffix:String = ""):String {
			
			var decimalMultiplier:int = Math.pow(10, precision);
			var str:String = Math.round(num * decimalMultiplier).toString();
			
			var leftSide:String = (precision == 0) ? str : str.substr(0, -precision);
			var rightSide:String = (precision == 0)? '' : str.substr(-precision);
			
			var leftSideNew:String = "";
				for (var i:int = 0; i < leftSide.length; i++) {
				if (i > 0 && (i % 3 == 0 )) {
					leftSideNew = commaDelimiter + leftSideNew;
				}
					 
				leftSideNew = leftSide.substr(-i - 1, 1) + leftSideNew;
			} 
				   
			return prefix + leftSideNew + ((precision == 0 ) ? '' : (decimalDelimiter + rightSide)) + suffix;
		}
		
	}

}
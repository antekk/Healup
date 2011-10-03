package com.healup.utils 
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author AK
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			throw new Error( "MathUtils::constructor() - static only class" );
		}
		
		public static function random(low:int, high: int) :int {
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		
		public static function isPrime(num:int) {
			for (var i:int = (num-1); i > 1; i--) {
				if ((num % i) == 0) {
					return false;
				}
			}
			return true;
		}
		
		public static function convertMatrix3D(source:Matrix3D) :Matrix {
			var result:Matrix = new Matrix();
			
			var rawData:Vector.<Number> = source.rawData;
			
			result.a = rawData[0];
			result.c = rawData[1];
			result.b = rawData[4];
			result.d = rawData[5];
			
			return result;
		}
		
		public static function convertMatrix(source:Matrix): Matrix3D {
			var result:Matrix3D = new Matrix3D();
			return result;
		}
	}

}
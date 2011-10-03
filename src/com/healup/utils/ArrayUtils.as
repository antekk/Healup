package com.healup.utils 
{
	public class ArrayUtils 
	{
		
		public function ArrayUtils() 
		{
			throw new Error( "ArrayUtils::constructor() - static only class" );
		}
		
		/**
		 * Removes an item, specified by the items literal value or a reference
		 * to the item itself, from a packed array.  Order is always preserved.
		 * 
		 * @param	array			Array to remove item from.
		 * @param	item			Item to remove from array.
		 * @return					True if item was actually in the array and was removed.
		 */
		public static function remove( haystack:Array, needle:* ) :Boolean
		{
			for( var i:int = 0 ; i < haystack.length - 1; i++ ) {
				if( haystack[i] == needle ) {
					haystack.splice( i, 1 );
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * Randomize the order of elements in a packed array.  The array which is passed
		 * in is unmodified; a new array is created and returned.
		 * 
		 * @param	array	Array to randomize
		 * @return			The randomized array
		 */
		public static function shuffle( array:Array ) :Array
		{
			var _length:Number = array.length;
			var mixed:Array = array.slice();
			var temp:Object;
			for (var i:int = 0; i < array.length; i++) {
				temp = mixed[i];
				var j:int = MathUtils.random(0, _length);
				mixed[i] = mixed[j];
				mixed[j] = temp;
			}
			return mixed;
		}
		
		/**
		 * Function that merges a set of arrays or objects into one.
		 *
		 * @param	array/object	Base array onto which other values will be appended
		 * @param	array/object	Arrays that will be appended onto the base.
		 *
		 */
		public static function merge(base:Object, ... objects:Array):Object {
			for (var i:int = 0; i < objects.length; i++) {
				var object = objects[i];
				for (var key in object) {
					if ((base[key] is Array || base[key] is Object) && (object[key] is Array || object[key] is Object)) {
						base[key] = merge(base[key], object[key]);
					} else {
						base[key] = object[key];
					}
				}
			}
			return base;
		}
				
		/**
		 * Function that looks up if an item is in an array.
		 *
		 * @param	any			Needle to be found in the haystack
		 * @param	array		Array which is to be searched
		 * @param 	function	Function to be used for comparison
		 * 
		 */
		 public static function inArray(needle:*, haystack:Array, fn:Function = null) {
			 if (fn == null) {
				fn = function(n:*, v:*) { return n == v;} 
			 }
			 for (var i:int = 0; i < haystack.length; i++) {
				//if (needle == haystack[i]) {
				if (fn.call(null, needle, haystack[i])) {
					return true;
				}
			 }
			 return false;
		 }
		 
	}
	
}
package com.healup.utils 
{
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author AK
	 */
	public class ObjectUtils 
	{
		
		public function ObjectUtils() 
		{
			
		}
		
		public static function isDynamic(obj:Object) :Boolean {
			var type:XML = describeType(obj);
			return type.@isDynamic.toString() == "true";
		}
		
		public static function copy(source:Object, destination:Object) :void {
			if ((source) && (destination)) {
				var sourceInfo:XML = describeType(source);
				var property:XML;
				
				for each(property in sourceInfo.variable) {
					try {
						if (destination.hasOwnProperty(property.@name)) {
							destination[property.@name] = source[property.@name];
						}
					} catch (err:Error) {
						//trace('com.healup.utils.ObjectUtils - ' + err.message);
					}
				}
				
				for each(property in sourceInfo.accessor) {
					try {
						if(property.@access == "readwrite") {
							if(destination.hasOwnProperty(property.@name)) {
								destination[property.@name] = source[property.@name];
							}
						}
					} catch (err:Error) {
						//trace('com.healup.utils.ObjectUtils - ' + err.message);
					}
				}
				
			}
		}
		
		/**
		 * NOTE: Clones only classes with no parameters in constructor
		 * 
		 * @param	source Object
		 * @return cloned Object
		 */
		public static function clone(source:Object) : Object {
			var sourceClass:Class = getDefinitionByName(getQualifiedClassName(source)) as Class;
			var destination:Object = new sourceClass();
			
			copy(source, destination);
			
			return destination;
		}
	}

}
package com.healup.utils 
{
	/**
	 * ...
	 * @author AK
	 */
	public class Debug 
	{
		
		private static var _showDebug:Boolean = true;
		
		public function Debug() 
		{
			throw new Error( "com.healup.utils.Debug - static only class" );
		}
		
		public static function on():void {
			_showDebug = true;
		}
		
		public static function off():void {
			_showDebug = false;
		}
		
		static public function get enabled():Boolean {
			return _showDebug;
		}
		
		static public function pr(obj:*, level:int = 0, output:String = ''):* {
			if(level == 0) output = '('+ typeOf(obj) +') {\n';
			else if(level == 10) return output;
			
			var tabs:String = '\t';
			for(var i:int = 0; i < level; i++, tabs += '\t') { }
			for(var child:* in obj) {
				output += tabs +'['+ child +'] => ('+  typeOf(obj[child]) +') ';
				
				if(count(obj[child]) == 0) output += obj[child];
				
				var childOutput:String = '';
				if(typeof obj[child] != 'xml') {
					childOutput = pr(obj[child], level + 1);
				}
				if(childOutput != '') {
					output += '{\n'+ childOutput + tabs +'}';
				}
				output += '\n';
			}
			
			if(level == 0) out(output +'}\n');
			else return output;
		}
		
		/**
		 * An extended version of the 'typeof' function
		 * @param 	variable
		 * @return	Returns the type of the variable
		 */
		public static function typeOf(variable:*):String {
			if(variable is Array) return 'array';
			else if(variable is Date) return 'date';
			else return typeof variable;
		}
		
		/**
		 * Returns the size of an object
		 * @param obj Object to be counted
		 */
		public static function count(obj:Object):uint {
			if(typeOf(obj) == 'array') return obj.length;
			else {
				var len:uint = 0;
				for(var item:* in obj) {
					if(item != 'mx_internal_uid') len++;
				}
				return len;
			}
		}

		
		public static function out(output:String) {
			trace(output);
		}
	}

}
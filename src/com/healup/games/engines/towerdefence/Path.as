package com.healup.games.engines.towerdefence 
{
	import com.healup.movieclip.MC;
	import com.healup.utils.ArrayUtils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author AK
	 */
	public class Path
	{
		private var prefix:String;
		private var points:Array;
		
		public function Path(path:MovieClip = null, vertexPrefix:String = 'v') 
		{
			super();
			findVerteces(path, vertexPrefix);
		}
		
		public function get length() :int {
			return points.length;
		}
		
		public function getVertexAt(index:int) :DisplayObject {
			if (index >= 0 && index <= points.length -1) {
				return points[index] as DisplayObject;
			} else {
				throw new Error("com.healup.games.engines.towerdefence.Path:getVertexAt - invalid index");
			}
		}
		
		public function getPointAt(index:int) :Point {
			var vertex = getVertexAt(index);
			var result:Point = new Point();
			if (vertex) {
				result = new Point(vertex.x, vertex.y);
			}
			return result;
		}
		
		private function findVerteces(path:DisplayObject, vertexPrefix:String) {			
			var vertexList:Array = MC.search(path, null, '^' + vertexPrefix);
			path.visible = false;
			
			points = new Array();
			
			for (var i:int = 0; i < vertexList.length; i++) {
				var vertex:DisplayObject = vertexList[i];
				var pos:Number;
				try {
					// TODO: Smart searching for points and smart insertion into array
					pos = int(vertex.name.substr(vertexPrefix.length));
					//var point:Point = new Point(vertex.x, vertex.y);
					points[pos] = vertex;
					
				} catch (error:Error) {
					
				}
				
			}
		}
	}

}
package com.healup.movieclip 
{
	import com.healup.events.AdvancedEventDispatcher;
	import com.healup.utils.Debug;
	import com.healup.utils.ArrayUtils;
	import com.healup.utils.MathUtils;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author AK
	 */
	public class MC 
	{
		
		
		public static const EVENT_PLAYSTATE_FINISH :String = "com.healup.movieclip.MC:EVENT_PLAYSTATE_FINISH";
		
		public function MC() 
		{
			throw new Error( "com.healup.movieclip.MC - Static only class" );
		}
		
		public static function stop(target:MovieClip):void {
			target.stop();
  			for (var i:int = 0; i < target.numChildren; i++){
  				var child:MovieClip = target.getChildAt(i) as MovieClip;
     			if (child) {
					stop(child);
				}
			}
		}
		
		public static function progress( target:MovieClip, percentage:Number ) :void
		{
			if( percentage < 0 ) {
				percentage = 0;
			}
			if( percentage > 1 ) {
				percentage = 1;
			}
			target.gotoAndStop( 1 + int( percentage * (target.totalFrames-1) ) );
		}
		
		
		public static function button(target:MovieClip, click:Function = null, options:Object = null ) {
			var defaultOptions:Object = {
				up: 'up',
				up2over: 'up2over',
				over: 'over',
				over2clicked: 'over2clicked',
				clicked: 'clicked',
				disabled: 'disabled',
				callback: null
			}
			options = ArrayUtils.merge(defaultOptions, options);
			options.callback = click;
			target._btnOptions = options;
			
			target.addEventListener(MouseEvent.CLICK, button_click, false, 0, true);
			
			if (hasState(target, options.up)) {
				playLoop(target, options.up);
			}
			if (hasState(target, options.over)) {
				target.addEventListener(MouseEvent.ROLL_OVER, button_over, false, 0, true);
				target.addEventListener(MouseEvent.ROLL_OUT, button_out, false, 0, true);
			}
		}
		
		public static function unbutton(target:MovieClip) {
			target.removeEventListener(MouseEvent.CLICK, button_click);
			target.removeEventListener(MouseEvent.ROLL_OVER, button_over);
			target.removeEventListener(MouseEvent.ROLL_OUT, button_out);
		}
		
		private static function button_click(e:Event):void {
			var target:MovieClip = e.target as MovieClip;
			var options:Object = target._btnOptions;
			
			while (options == null) {
				target = target.parent as MovieClip;
				if (target == null) {
					return;
				}
				options = target._btnOptions;
			}
			
			if (hasState(target, options.clicked)) {
				if (hasState(target, options.over2clicked)) {
					target.addEventListener(EVENT_PLAYSTATE_FINISH, button_over2clicked_finished, false, 0, true);
					MC.playOnce(target, options.over2clicked);
				} else {
					MC.playLoop(target, options.clicked);
				}
			}
			
			if (options.callback != null) {
				var action:Function = options.callback as Function;
				action.call();
			}
		}
		
		private static function button_over2clicked_finished(e:Event) :void {
			var target:MovieClip = e.target as MovieClip;
			var options:Object = target._btnOptions;
			
			while (options == null) {
				target = target.parent as MovieClip;
				if (target == null) {
					return;
				}
				options = target._btnOptions;
			}
			
			
			target.removeEventListener(EVENT_PLAYSTATE_FINISH, button_over2clicked_finished);
			
			MC.playLoop(target, options.clicked);
		}
		
		private static function button_over(e:MouseEvent):void {
			var target:MovieClip = e.target as MovieClip;
			var options:Object = target._btnOptions;
			
			while (options == null) {
				target = target.parent as MovieClip;
				if (target == null) {
					return;
				}
				options = target._btnOptions;
			}
			
			if (hasState(target, options.up2over)) {
				target.addEventListener(EVENT_PLAYSTATE_FINISH, button_up2over_finished, false, 0, true);
				MC.playOnce(target, options.up2over);
			} else {
				MC.playLoop(target, options.over);
			}
		}
		
		private static function button_up2over_finished(e:Event) :void {
			var target:MovieClip = e.target as MovieClip;
			var options:Object = target._btnOptions;
			
			while (options == null) {
				target = target.parent as MovieClip;
				if (target == null) {
					return;
				}
				options = target._btnOptions;
			}
			
			target.removeEventListener(EVENT_PLAYSTATE_FINISH, button_up2over_finished);
			
			MC.playLoop(target, options.over);
		}
		
		private static function button_out(e:MouseEvent):void {
			var target:MovieClip = e.target as MovieClip;
			var options:Object = target._btnOptions;
			
			while (options == null) {
				target = target.parent as MovieClip;
				if (target == null) {
					return;
				}
				options = target._btnOptions;
			}
			
			if (hasState(target, options.up)) {
				playLoop(target, options.up);
			}
		}
		
		
		public static function hasState( target:MovieClip, tag:String) :Boolean {
			if (target == null) {
				return false;
			}
			for (var i:int = 0; i < target.currentLabels.length; i++) {
				var label:FrameLabel = target.currentLabels[i] as FrameLabel;
				if (label.name == tag) {
					return true;
				}
			}
			
			return false;
		}
		
		public static function setState( target:MovieClip, tag:String ) :void
		{
			if (hasState(target, tag)) {
				reset( target );
				target.currentState = tag;
				target.gotoAndStop( tag );
			}
		}
		
		public static function isState(target:MovieClip, tag:String):Boolean {
			var result = false;
			if (target.currentState && target.currentState == tag) {
				result = true;
			}
			return result;
		}
		
		public static function playOnce( target:MovieClip, tag:String = null, reverse:Boolean = false ) :void
		{
			target.finishState = null;
			playLoop(target, tag, 1);
		}
		
		public static function playOnceAndJump(target:MovieClip, tag:String, setTag:String, reverse:Boolean = false) :void {
			
			target.finishState = setTag;
			playLoop(target, tag, 1);
		}
		
		public static function playLoop(target:MovieClip, tag:String = null, count:int = -1, reverse:Boolean = false) :void {
			reset( target );
			
			
			target.startFrame = 1;
			target.scriptFrame = target.totalFrames - 1;
			target.loopCount = count;
			if (tag != null && hasState(target, tag)) {
				for (var i:int = 0; i < target.currentLabels.length; i++) {
					var label:FrameLabel = target.currentLabels[i] as FrameLabel;
					if (label.name == tag) {
						target.startFrame = label.frame;
						target.scriptFrame = (i == target.currentLabels.length - 1) ? (target.totalFrames - 1) : (target.currentLabels[i + 1].frame - 2);
						break;
					}
				}
			}
			
			target.addFrameScript(target.scriptFrame, function() :void {
				if (int(target.loopCount) == 1) {
					target.addFrameScript(target.scriptFrame, null);
					target.stop();
					if (target.finishState != null) {
						target.gotoAndStop( target.finishState );
					}
					target.dispatchEvent(new Event(EVENT_PLAYSTATE_FINISH));
				} else {
					if (int(target.loopCount) > 0) {
						target.loopCount--;
					}
					target.stop(); 
					function target_enterFrame(e:Event) :void {
						var target:MovieClip = e.target as MovieClip;
						if (target != null) {
							target.removeEventListener(Event.ENTER_FRAME, target_enterFrame);
							target.gotoAndPlay(target.startFrame);
						}
					}
					target.addEventListener(Event.ENTER_FRAME, target_enterFrame, false, 0, true);

				}
			});
			
			target.gotoAndPlay(target.startFrame);
		}
		
		private static function reset( target:MovieClip ) :void
		{
			if( !target.stateListeners ) {
				target.stateListeners = new AdvancedEventDispatcher();
			}
			target.stateListeners.removeAllEventListeners();
			if ( target.scriptFrame ) {
				target.addFrameScript( target.scriptFrame, null );
			}
		}
		
		public static function hitTestObjects(needle:DisplayObject, ... haystacks:Array):Boolean {
			if (haystacks.length == 1 && haystacks[0] is Array) {
				haystacks = haystacks[0];
			}
			for (var i:int = 0; i < haystacks.length; i++) {
				var haystack:DisplayObject = haystacks[i];
				if (haystack.hitTestObject(needle)) {
					return true;
				}
			}
			return false;
		}
		
		public static function hitTestShape(needle:DisplayObject, ... haystacks:Array) :Boolean {
			if (haystacks.length == 1 && haystacks[0] is Array) {
				haystacks = haystacks[0];
			}
			for (var i:int = 0; i < haystacks.length; i++) {
				var haystack:DisplayObject = haystacks[i];
				// First quickly identify if object has hit.. then check in depth
				if (needle.hitTestObject(haystack)) {
					var needleRect:Rectangle = needle.getBounds(needle.parent);
					var needleOffset:Matrix = needle.transform.matrix;
					
					needleOffset.tx = needle.x - needleRect.x;
					needleOffset.ty = needle.y - needleRect.y;	

					var needleBitMap:BitmapData = new BitmapData(needleRect.width, needleRect.height, true, 0);
					needleBitMap.draw(needle, needleOffset);		

					var haystackRect:Rectangle = haystack.getBounds(needle.parent);
					var haystackOffset:Matrix = haystack.transform.matrix;
					if (haystackOffset == null && haystack.transform.matrix3D != null) {
						haystackOffset = MathUtils.convertMatrix3D(haystack.transform.matrix3D);
					}
					haystackOffset.tx = haystack.x - haystackRect.x;
					haystackOffset.ty = haystack.y - haystackRect.y;
	
					var haystackBitMap:BitmapData = new BitmapData(haystackRect.width, haystackRect.height, true, 0);
					haystackBitMap.draw(haystack, haystackOffset);	

					var needleLoc:Point = new Point(needleRect.x, needleRect.y);
					var haystackLoc:Point = new Point(haystackRect.x, haystackRect.y);
					
					if (needleBitMap.hitTest(needleLoc, 100, haystackBitMap, haystackLoc, 100)) {
						return true;
					}
				}
			}
			return false;
		}
		
		public static function hitTestContained(needle:DisplayObject, ... haystacks:Array):Boolean {
			
			if (haystacks.length == 1 && haystacks[0] is Array) {
				haystacks = haystacks[0];
			}
			
			// TODO: Handle for objects that aren't oriented in top left or center
			
			//var topLeft:Point = needle.localToGlobal(new Point(needle.x, needle.y));
			//var middle:Point = new Point(topLeft.x + needle.width / 2, topLeft.y + needle.height / 2);
			var middle:Point = needle.localToGlobal(new Point(needle.x, needle.y));
			var topLeft:Point = new Point(middle.x - needle.width / 2, middle.y - needle.height / 2);
			var topRight:Point = new Point(topLeft.x + needle.width, topLeft.y);
			var bottomLeft:Point = new Point(topLeft.x, topLeft.y + needle.height);
			var bottomRight:Point = new Point(topLeft.x + needle.width, topLeft.y + needle.height);
			
			
			for (var i:int = 0; i < haystacks.length; i++) {
				var haystack:DisplayObject = haystacks[i];
				if (haystack.hitTestPoint(topLeft.x, topLeft.y, true)
					&& haystack.hitTestPoint(topRight.x, topRight.y, true)
					&& haystack.hitTestPoint(bottomLeft.x, bottomLeft.y, true)
					&& haystack.hitTestPoint(bottomRight.x, bottomRight.y, true)
					&& haystack.hitTestPoint(middle.x, middle.y, true)) {
					return true;
				}
			}
			return false;
		}
		
		
		public static function absDistance(first:DisplayObject, second:DisplayObject):Number {
			var firstPoint:Point = first.localToGlobal(new Point(0, 0));
			var secondPoint:Point = second.localToGlobal(new Point(0, 0));
			return Point.distance(firstPoint, secondPoint);
		}
		
		public static function commonPosition(base:DisplayObject, adjust:DisplayObject) :void {
			var globalTarget:Point = base.localToGlobal(new Point(0, 0));
			var adjustTarget:Point = adjust.globalToLocal(globalTarget);
			adjust.x = adjustTarget.x;
			adjust.y = adjustTarget.y;
		}
		
		public static function commonParent(first:DisplayObject, second:DisplayObject):DisplayObject {
			var parents:Array = new Array();
			var commonParent:DisplayObject = null;
			var temp:DisplayObject = first;
			while (temp.parent != null) {
				parents.push(temp.parent);
				temp = temp.parent;
			}
			temp = second;
			while (temp.parent != null && commonParent == null) {
				if (ArrayUtils.inArray(temp, parents)) {
					commonParent = temp;
				}
				temp = temp.parent;
			}
			return commonParent;
		}
		
		public static function searchParent(target:DisplayObject, className:* = null, name:String = null) :DisplayObject {
			var candidate = true;
			
			if (target == null) {
				return target;
			}
			
			if (className != null && !(className is String)) {
				className = getQualifiedClassName(className);
			}
			
			if (className != null && getQualifiedClassName(target).search(className) == -1 ) {
				candidate = false;
			}
			
			if (name != null && target.name.search(name) == -1) {
				candidate = false;
			}
			if (candidate) {
				return target;
			}
			return searchParent(target.parent, className, name);
		}
		/**
		 * Assumes the movieclip is facing up
		 * @param	target
		 * @param	towards
		 */
		public static function rotateTo(target:DisplayObject, to:DisplayObject):void {
			var pos:Point = target.localToGlobal(new Point(0, 0));
			var towards:Point = to.localToGlobal(new Point(0, 0));
			var deltaX = towards.x - pos.x;
			var deltaY = towards.y - pos.y;
			var angle = Math.atan2(deltaY, deltaX);
			target.rotation = (angle / Math.PI * 180) + 90;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	towards
		 * @param	distance - in pixels
		 */
		public static function moveTo(target:DisplayObject, to:DisplayObject, distance:Number):void {
			var pos:Point = target.localToGlobal(new Point(0, 0));
			var towards:Point = to.localToGlobal(new Point(0, 0));
			var deltaX = towards.x - pos.x;
			var deltaY = towards.y - pos.y;
			var angle = Math.atan2(deltaY, deltaX);
			var offset:Point = Point.polar(distance, angle);
			target.x += offset.x;
			target.y += offset.y;
		}
		
		/**
		 * Assumes the clip is facing up
		 * @param	target
		 * @param	towards
		 * @param	distance
		 */
		public static function rotateAndMoveTo(target:DisplayObject, to:DisplayObject, distance:Number) :void {
			var pos:Point = target.localToGlobal(new Point(0, 0));
			var towards:Point = to.localToGlobal(new Point(0, 0));
			if (distance >= Point.distance(pos, towards) || Point.distance(pos, towards) == 1) {
				var local:Point = target.parent.globalToLocal(towards);
				target.x = local.x;
				target.y = local.y;
			} else {
				var deltaX = towards.x - pos.x;
				var deltaY = towards.y - pos.y;
				var angle = Math.atan2(deltaY, deltaX);
				var offset:Point = Point.polar(distance, angle);
				target.x += offset.x;
				target.y += offset.y;
				target.rotation = (angle / Math.PI * 180) + 90;
			}
		}
		/**
		 * 
		 * @param	mc				The Movieclip used to start the search
		 * @param	className		Filter results by classname (can be string or actual class)
		 * @param	name			Filter results by name of movieclips
		 * @param	maxDepth		The maximum depth to go searching for movieclips
		 * @return					An array of movieclips that match the search criteria
		 */
		public static function search(target:DisplayObject, className:* = null, name:String = null, maxDepth: int = int.MAX_VALUE) :Array {
			var result: Array = new Array();
			
			var candidate = true;
			
			if (className != null && !(className is String)) {
				className = getQualifiedClassName(className);
			}
			
			
			if (className != null && getQualifiedClassName(target).search(className.toString()) == -1 ) {
				candidate = false;
			}
			
			if (name != null && target.name.search(name) == -1) {
				candidate = false;
			}
			
			if (candidate) {
				result.push(target);
			}
			
			maxDepth--;
			
			if (maxDepth >= 0 && target is MovieClip) {
				var mc:MovieClip = target as MovieClip;
				for( var i:int = 0 ; i < mc.numChildren ; ++i ) {
					if( mc.getChildAt(i) is DisplayObject) {
						result = result.concat(search(mc.getChildAt(i) as DisplayObject, className, name, maxDepth));
					}
				}
			}
			return result;
		}
		
	}

}
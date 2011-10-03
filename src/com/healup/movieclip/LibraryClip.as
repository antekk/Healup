package com.healup.movieclip 
{
	import adobe.utils.CustomActions;
	import com.healup.utils.ObjectUtils;
	import flash.accessibility.AccessibilityImplementation;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.media.SoundTransform;
	import flash.ui.ContextMenu;
	
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author AK
	 */
	public dynamic class LibraryClip extends MovieClip implements ILibraryClip
	{
		
		protected var clip:MovieClip;
		protected var initParam:*;
		
		public function LibraryClip(param:*) 
		{
			super();
			initParam = param;
			
			if (initParam is String) {
				var classReference = getDefinitionByName(initParam) as Class;
				if (classReference == null) {
					throw new Error("com.healup.movieclip.LibraryClip - \"" + initParam + "\" not found");
				}
				clip = new classReference();
			} else if (initParam is MovieClip) {
				clip = initParam;
			} else {
				throw new Error('com.healup.movieclip.LibraryClip - tried to create with unknown type [' + initParam + ']');
			}
			addChild(clip);
			params(clip.name);
		}
		
		public function get className():String {
			return getQualifiedClassName(initParam);
		}
		
		/**
		 * Analyzes a string and applies the values to appropriate parameters
		 * 
		 * @param	str - format is name$param_value$param_array_array_array$param_value
		 */
		public function params(str:String) :void {
			var paramList:Array = str.split('$');
			
			for (var i:int = 0; i < paramList.length; i++) {
				var keyValuePair:String = paramList[i];
				var splitPos:int = 	keyValuePair.indexOf('_');
				var key:String = keyValuePair.substr(0, splitPos);
				var value:String = keyValuePair.substr(splitPos + 1);
				if (splitPos < 0) {
					continue;
				}
				// if string 
				value = value.replace(/_/g, ' ');
				
				//if number
				// value = value.replace(/_/g, '.');
				
				if (this.hasOwnProperty(key)) {
					if (this[key] is Number) {
						this[key] = parseInt(value);
					} else {
						this[key] = value;
					}
				} else if (ObjectUtils.isDynamic(this)) {
					this[key] = value;
				}
			}	
		}
		
		override public function get parent():DisplayObjectContainer {
			if (super.parent != null) {
				return super.parent;
			}
			return clip.parent;
		}
		
		override public function get numChildren():int {
			return clip.numChildren;
		}
		override public function get currentFrame():int {
			return clip.currentFrame;
		}
		override public function get currentFrameLabel():String {
			return clip.currentFrameLabel;
		}
		override public function get currentLabel():String {
			return clip.currentLabel;
		}
		override public function get currentLabels():Array {
			return clip.currentLabels;
		}
		override public function get currentScene():Scene {
			return clip.cu.currentScene;
		}
		override public function get totalFrames():int {
			return clip.totalFrames;
		}
		override public function stop():void {
			clip.stop();
		}
		override public function gotoAndStop(frame:Object, scene:String = null):void {
			clip.gotoAndStop(frame, scene);
		}
		override public function gotoAndPlay(frame:Object, scene:String = null):void {
			clip.gotoAndPlay(frame, scene);
		}
		
		override public function addFrameScript(...rest):void {
			clip.addFrameScript.apply(null, rest);
		}
		/*
		override public function get x():Number {
			return clip.x;
		}
		override public function set x(value:Number) :void {
			clip.x = value;
		}
		
		override public function get y():Number {
			return clip.y;
		}
		override public function set y(value:Number):void {
			clip.y = value;
		}
		
		override public function get z():Number {
			return clip.z;
		}
		override public function set z(value:Number):void {
			clip.z = value;
		}*/
		
		
		override public function get enabled():Boolean {
			return clip.enabled;
		}
		override public function set enabled(value:Boolean) :void {
			clip.enabled = value;
		}
		
		override public function get trackAsMenu():Boolean {
			return clip.trackAsMenu;
		}
		override public function set trackAsMenu(value:Boolean) :void {
			clip.trackAsMenu = value;
		}
		
		override public function get hitArea():Sprite {
			return clip.hitArea;
		}
		override public function set hitArea(value:Sprite) :void {
			clip.hitArea = value;
		}
		
		override public function hitTestObject(obj:DisplayObject):Boolean {
			return clip.hitTestObject(obj);
		}
		
		override public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean {
			return clip.hitTestPoint(x, y, shapeFlag);
		}
		
		override public function get buttonMode():Boolean {
			return clip.buttonMode;
		}
		override public function set buttonMode(value:Boolean) :void {
			clip.buttonMode = value;
		}
		
		override public function get soundTransform():SoundTransform {
			return clip.soundTransform;
		}
		override public function set soundTransform(value:SoundTransform) :void {
			clip.soundTransform = value;
		}
		
		/*override public function get transform():Transform {
			return clip.transform;
		}
		
		override public function set transform(value:Transform):void {
			clip.transform = value;
		}*/
			
		override public function get useHandCursor():Boolean {
			return clip.useHandCursor;
		}
		override public function set useHandCursor(value:Boolean) :void {
			clip.useHandCursor = value;
		}
		
		override public function get tabChildren():Boolean {
			return clip.tabChildren;
		}
		override public function set tabChildren(value:Boolean) :void {
			clip.tabChildren = value;
		}
		
		override public function get mouseChildren():Boolean {
			return clip.mouseChildren;
		}
		override public function set mouseChildren(value:Boolean) :void {
			clip.mouseChildren = value;
		}
		
		override public function get focusRect():Object {
			return clip.focusRect;
		}
		override public function set focusRect(value:Object) :void {
			clip.focusRect = value;
		}
		
		override public function get doubleClickEnabled():Boolean {
			return clip.doubleClickEnabled;
		}
		override public function set doubleClickEnabled(value:Boolean) :void {
			clip.doubleClickEnabled = value;
		}
		
		override public function get contextMenu():ContextMenu {
			return clip.contextMenu;
		}
		override public function set contextMenu(value:ContextMenu) :void {
			clip.contextMenu = value;
		}
		
		override public function get tabEnabled():Boolean {
			return clip.tabEnabled;
		}
		override public function set tabEnabled(value:Boolean) :void {
			clip.tabEnabled = value;
		}
		
		override public function get mouseEnabled():Boolean {
			return clip.mouseEnabled;
		}
		override public function set mouseEnabled(value:Boolean) :void {
			clip.mouseEnabled = value;
		}
		
		override public function get tabIndex():int {
			return clip.tabIndex;
		}
		override public function set tabIndex(value:int) :void {
			clip.tab.tabIndex = value;
		}
		
		override public function get accessibilityImplementation():AccessibilityImplementation {
			return clip.accessibilityImplementation;
		}
		override public function set accessibilityImplementation(value:AccessibilityImplementation) :void {
			clip.a.accessibilityImplementation = value;
		}
		/*
		override public function get scaleX():Number {
			return clip.scaleX;
		}
		override public function set scaleX(value:Number) :void {
			clip.scaleX = value;
		}
		
		override public function get scaleY():Number {
			return clip.scaleY;
		}
		override public function set scaleY(value:Number) :void {
			clip.scaleY = value;
		}
		
		override public function get scaleZ():Number {
			return clip.scaleZ;
		}
		override public function set scaleZ(value:Number) :void {
			clip.scaleZ = value;
		}*/
		
		override public function get mask():DisplayObject {
			return clip.mask;
		}
		override public function set mask(value:DisplayObject) :void {
			clip.mask = value;
		}
		
		override public function get rotation():Number {
			return clip.rotation;
		}
		override public function set rotation(value:Number) :void {
			clip.rotation = value;
		}
		
		override public function get alpha():Number {
			return clip.alpha;
		}
		override public function set alpha(value:Number) :void {
			clip.alpha = value;
		}
		
		override public function get blendMode():String {
			return clip.blendMode;
		}
		override public function set blendMode(value:String) :void {
			clip.blendMode = value;
		}
		
		override public function get scale9Grid():Rectangle {
			return clip.scale9Grid;
		}
		override public function set scale9Grid(value:Rectangle) :void {
			clip.scale9Grid = value;
		}
		
		override public function get rotationX():Number {
			return clip.rotationX;
		}
		override public function set rotationX(value:Number) :void {
			clip.rotationX = value;
		}
		
		override public function get rotationY():Number {
			return clip.rotationY;
		}
		override public function set rotationY(value:Number) :void {
			clip.rotationY = value;
		}
		
		override public function get rotationZ():Number {
			return clip.rotationZ;
		}
		override public function set rotationZ(value:Number) :void {
			clip.rotationZ = value;
		}
		
		override public function get accessibilityProperties():AccessibilityProperties {
			return clip.ac.accessibilityProperties;
		}
		override public function set accessibilityProperties(value:AccessibilityProperties) :void {
			clip.accessibilityProperties = value;
		}
		
		override public function get scrollRect():Rectangle {
			return clip.scrollRect;
		}
		override public function set scrollRect(value:Rectangle) :void {
			clip.scrollRect = value;
		}
				
		override public function get width():Number {
			return clip.width;
		}
		override public function set width(value:Number) :void {
			clip.width = value;
		}
		
		override public function get height():Number {
			return clip.height;
		}
		override public function set height(value:Number) :void {
			clip.height = value;
		}
		
		override public function get name():String {
			return clip.name;
		}
		override public function set name(value:String) :void {
			clip.name = value;
		}
		
		override public function get cacheAsBitmap():Boolean {
			return clip.cacheAsBitmap;
		}
		override public function set cacheAsBitmap(value:Boolean) :void {
			clip.cacheAsBitmap = value;
		}
		
		override public function get opaqueBackground():Object {
			return clip.opaqueBackground;
		}
		override public function set opaqueBackground(value:Object) :void {
			clip.opaqueBackground = value;
		}
		
		override public function get visible():Boolean {
			return clip.visible;
		}
		override public function set visible(value:Boolean) :void {
			clip.visible = value;
		}
		
		override public function getChildAt(index:int) :DisplayObject {
			return clip.getChildAt(index);
		}
				
		override public function addChild(child:DisplayObject) :DisplayObject {
			return (child == clip) ? super.addChild(child) : clip.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject) :DisplayObject {
			var index:int = -1;
			try {
				index = super.getChildIndex(child);
				return super.removeChild(child);
			} catch ( e:ArgumentError) {
				try {
					index = clip.getChildIndex(child);
					return clip.removeChild(child);
				} catch (e:ArgumentError) {				
				}
			}
			return null;
		}
		
		public function clone():* {
			trace ('before original [' + this.width + ', ' + this.height + ']');
			var sourceClass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			var clone:* = new sourceClass(initParam);
			ObjectUtils.copy(this, clone);
			trace ('after clone [ ' + clone.width + ', ' + clone.height + '] vs original [' + this.width + ', ' + this.height + ']');
			return clone;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) :void {
			if (type == Event.ENTER_FRAME) {
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			} else {
				clip.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) :void {
			if (type == Event.ENTER_FRAME) {
				super.removeEventListener(type, listener, useCapture);
			} else {
				clip.removeEventListener(type, listener, useCapture);
			}
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			return clip.dispatchEvent(event);
		}
		
		override public function localToGlobal(point:Point):Point {
			return clip.localToGlobal(point);
		}
		
		override public function globalToLocal(point:Point):Point {
			return clip.globalToLocal(point);
		}
		
		
		//*/
		
	}

}
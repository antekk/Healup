package com.healup.games.common 
{
	
	/**
	 * ...
	 * @author AK
	 */
	public interface IOptions 
	{
		function append(overwrite:IOptions) :void;
		
		function addChangeListener(key:String, callback:Function):void;
		function removeChangeListener(key:String, callback:Function):void;
		
		function getKeys():Array;
		function hasKey(key:String) :Boolean;
		
		function getItem( key:String, default_value:* = null ) :*;
		function setItem( key:String, data:* ) :void;
		
		function clear() :void;
		
		function serialize() :String;
		function deserialize( stateString:String, overwrite:Boolean = true ) :void;
	}
	
}
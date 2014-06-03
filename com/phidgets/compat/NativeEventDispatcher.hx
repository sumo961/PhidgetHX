package com.phidgets.compat;

/**
 * ...
 * @author Andreas Rønning
 */
class NativeEventDispatcher
{
	var listeners:Map<String, Array<Dynamic->Void>>;
	public function new() 
	{
		listeners = new Map<String,Array<Dynamic->Void>>();
	}
	public function addEventListener(type:String, listener:Dynamic->Void):Void {
		if (listeners[type] == null) listeners[type] = [listener];
		else listeners[type].push(listener);
	}
	public function removeEventListener(type:String, listener:Dynamic->Void):Void {
		if (listeners[type] == null) return;
		listeners[type].remove(listener);
	}
	public function dispatchEvent(event:NativeEvent):Void {
		if (listeners[event.type] == null) return;
		for (l in listeners[event.type]) {
			l(event);
		}
	}
	
}
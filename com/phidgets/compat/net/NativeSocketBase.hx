package com.phidgets.compat.net;
import com.phidgets.compat.NativeEventDispatcher;

/**
 * ...
 * @author Andreas Rønning
 */
class NativeSocketBase extends NativeEventDispatcher
{
	public var connected:Bool;
	public function new() 
	{
		super();
	}
	public function send(str:String):Void {
		
	}
	public function connect(host:String, port:Int):Void {
		
	}
	
}
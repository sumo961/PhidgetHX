package com.phidgets.compat;

/**
 * ...
 * @author Andreas Rønning
 */
class NativeEvent
{
	public static inline var CONNECT:String = "connect";
	public static inline var CLOSE:String = "close";
	public static inline var IO_ERROR:String = "ioError";
	public var text:String;
	public var type:String;
	public function new(type:String, ?text:String) 
	{
		this.type = type;
	}
	public function toString() : String{
        return "[ Phidget NativeEvent: " + type + " ]";
    }
	
}
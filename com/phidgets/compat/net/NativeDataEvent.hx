package com.phidgets.compat.net;
import com.phidgets.compat.NativeEvent;

/**
 * ...
 * @author Andreas Rønning
 */
class NativeDataEvent extends NativeEvent
{
	public static inline var DATA:String = "data";
	public var data:String;
	public function new() 
	{
		data = "";
		super(DATA);
	}
	
}
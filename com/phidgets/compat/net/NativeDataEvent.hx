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
	//public var type:String;

	public function new(type:String,data:String) 
	{
		//data = "";
		trace("Data event"+data);
		this.type = type;
		this.data=data;
		super(DATA,data);
	}
	
}
package com.phidgets.compat;

/**
 * ...
 * @author Andreas Rønning
 */
class NativeError
{
	public var errorID:Int;
	public var message:String;

	public function new(message:String, errorID:Int) 
	{
		this.errorID = errorID;
		this.message = message;
		
	}
	
}
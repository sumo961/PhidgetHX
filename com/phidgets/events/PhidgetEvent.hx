package com.phidgets.events;


import com.phidgets.Phidget;
#if flash
private typedef Event = flash.events.Event;
#else
private typedef Event = com.phidgets.compat.NativeEvent;
#end

/*
		Class: PhidgetEvent
		A class for Phidget events. These events are supported by all Phidgets.
	*/
class PhidgetEvent extends Event
{
    public var Device(get, never) : Phidget;

    /*
			Constants: Phidget Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			CONNECT			-	A connection to the server was established.
			DISCONNECT		-	A connection to the server was lost.
			ATTACH		-	A connection to the phidget was established.
			DETACH		-	A connection to the phidget was lost.
		*/
    public static inline var CONNECT : String = "connect";
    public static inline var DISCONNECT : String = "disconnect";
    public static inline var ATTACH : String = "attach";
    public static inline var DETACH : String = "detach";
    
    private var _phidget : Phidget;
    
    public function new(type : String, phidget : Phidget)
    {
        super(type);
        this._phidget = phidget;
    }
    
    override public function toString() : String{
        return "[ Phidget Event: " + type + " ]";
    }
    /*
			Property: Device
			Gets the Phidget object from which this event originated
		*/
    private function get_Device() : Phidget{
        return _phidget;
    }
}

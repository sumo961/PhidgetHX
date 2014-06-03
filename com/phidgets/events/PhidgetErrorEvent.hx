package com.phidgets.events;


import com.phidgets.Phidget;
import com.phidgets.PhidgetError;
import flash.events.Event;

/*
		Class: PhidgetErrorEvent
		A class for error events.
	*/
class PhidgetErrorEvent extends Event
{
    public var Error(get, never) : PhidgetError;
    public var Sender(get, never) : Dynamic;

    /*
			Constants: Error Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			ERROR			-	An asynchronous error occured.
		*/
    public static inline var ERROR : String = "error";
    
    private var _error : PhidgetError;
    private var _sender : Dynamic;
    
    public function new(type : String, sender : Dynamic, error : PhidgetError)
    {
        super(type);
        _error = error;
        _sender = sender;
    }
    
    override public function toString() : String{
        return "[ Phidget Error Event: " + _error.message + " ]";
    }
    
    /*
			Property: Error
			Gets the <PhidgetError> containing the error information for this event.
		*/
    private function get_Error() : PhidgetError{
        return _error;
    }
    
    /*
			Property: Sender
			The object from which this event originated.
		*/
    private function get_Sender() : Dynamic{
        return _sender;
    }
}

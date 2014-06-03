package com.phidgets.events;


import com.phidgets.Phidget;
import com.phidgets.PhidgetDictionary;
import flash.events.Event;

/*
		Class: PhidgetDictionaryEvent
		A class for Phidget Dictionary events.
	*/
class PhidgetDictionaryEvent extends Event
{
    public var Dictionary(get, never) : PhidgetDictionary;
    public var Key(get, never) : String;
    public var Value(get, never) : String;

    /*
			Constants: Dictionary Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			CONNECT			-	A connection to the server was established.
			DISCONNECT		-	A connection to the server was lost.
			KEY_CHANGE		-	A Key/Value pair was added, or the value of an existing Key was changed.
			KEY_REMOVAL		-	A Key was removed.
		*/
    public static inline var CONNECT : String = "connect";
    public static inline var DISCONNECT : String = "disconnect";
    public static inline var KEY_CHANGE : String = "keyChange";
    public static inline var KEY_REMOVAL : String = "keyRemoval";
    
    private var _phidgetDictionary : PhidgetDictionary;
    private var _key : String;
    private var _val : String;
    
    public function new(type : String, Dictionary : PhidgetDictionary, key : String = null, value : String = null)
    {
        super(type);
        this._phidgetDictionary = Dictionary;
        this._key = key;
        this._val = value;
    }
    
    override public function toString() : String{
        if (_val == null) 
            if (_key == null) 
            return "[ Phidget Dictionary Event: " + type + " ]"
        else 
        return "[ Phidget Dictionary Event: " + type + ": " + _key + " ]"
        else 
        return "[ Phidget Dictionary Event: " + type + ": " + _key + ": " + _val + " ]";
    }
    
    /*
			Property: Dictionary
			Gets the PhidgetDictionary object from which this event originated.
		*/
    private function get_Dictionary() : PhidgetDictionary{
        return _phidgetDictionary;
    }
    /*
			Property: Key
			Gets the key value for this event.
		*/
    private function get_Key() : String{
        return _key;
    }
    /*
			Dynamic: Value
			Gets the value value for this event
		*/
    private function get_Value() : String{
        return _val;
    }
}

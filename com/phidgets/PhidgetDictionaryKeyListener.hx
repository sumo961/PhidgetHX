package com.phidgets;


import com.phidgets.PhidgetDictionary;
import com.phidgets.events.PhidgetDictionaryEvent;
import flash.events.EventDispatcher;

/*
		Class: PhidgetDictionaryKeyListener
		A class for listening to key/value changes on a <PhidgetDictionary>
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by all PhidgetDictionaryKeyListener.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDictionaryEvent.KEY_CHANGE		- key/value added or changed
		PhidgetDictionaryEvent.KEY_REMOVAL		- key removed
	*/
class PhidgetDictionaryKeyListener extends EventDispatcher
{
    private var _pattern : String;
    private var _dict : PhidgetDictionary;
    private var _lid : Int = com.phidgets.Constants.PUNK_INT;
    
    /*
			Constructor: PhidgetDictionaryKeyListener
			Creates a KeyListener for a specified dictionary and key pattern.
			
			Parameters:
				dict - <PhidgetDictionary> on which to listen for keys
				pattern - extended regular expression key pattern to listen for
		*/
    public function new(dict : PhidgetDictionary, pattern : String)
    {
        super();
        _dict = dict;
        _pattern = pattern;
    }
    
    private function onDictData(key : String, val : String, reason : Int) : Void
    {
        if (reason == Constants.ENTRY_REMOVING) 
            dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.KEY_REMOVAL, this._dict, key, val))
        else 
        dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.KEY_CHANGE, this._dict, key, val));
    }
    /*
			Dynamic: start
			Start listening for keys. Make sure that the dictionary has connected before you call this. This can be called in the Dictionary CONNECT event.
		*/
    public function start() : Void{
        _lid = _dict._phidgetSocket.setListener(_pattern, onDictData);
    }
    /*
			Dynamic: stop
			Stop listening for keys.
		*/
    public function stop() : Void{
        if (_lid != com.phidgets.Constants.PUNK_INT) {
            _dict._phidgetSocket.removeListener(_lid);
            _lid = com.phidgets.Constants.PUNK_INT;
        }
    }
}

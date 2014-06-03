package com.phidgets;

import com.phidgets.PhidgetError;
import com.phidgets.PhidgetSocket;

import flash.events.Event;
import com.phidgets.events.PhidgetDictionaryEvent;
import com.phidgets.events.PhidgetErrorEvent;
import flash.events.EventDispatcher;

/*
		Class: PhidgetDictionary
		A class for accessing the Phidget Dictionary.
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by all PhidgetDictionary.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDictionaryEvent.CONNECT		- server connect
		PhidgetDictionaryEvent.DISCONNECT	- server disconnect
		PhidgetErrorEvent.ERROR				- asynchronous error
	*/
class PhidgetDictionary extends EventDispatcher
{
    public var isConnected(get, never) : Bool;
    public var Address(get, never) : String;
    public var Port(get, never) : Int;

    @:allow(com.phidgets)
    private var _phidgetSocket : PhidgetSocket = null;
    
    private var calledClose : Bool = false;
    /*
			Dynamic: open
			Opens a connection to a dictionary.
			
			Parameters:
				address - address of the webservice. This can be 'localhost' when running from a single computer.
				port - port of the webservice. This is 5001 by default.
				password - password of the webservice. This is optional and doesn't need to be specified for unsecured webservices.
		*/
    public function open(address : String, port : Float, password : String = null) : Void{
        _phidgetSocket = new PhidgetSocket();
        _phidgetSocket.connect(address, port, password, onConnected, onDisconnected, onError);
    }
    
    /*
			Dynamic: close
			closes the connection to a dictionary.
		*/
    public function close() : Void{
        calledClose = true;
        _phidgetSocket.close();
    }
    
    private function onConnected() : Void{
        dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.CONNECT, this));
    }
    
    private function onDisconnected() : Void{
        if (!calledClose) 
            dispatchEvent(new PhidgetDictionaryEvent(PhidgetDictionaryEvent.DISCONNECT, this));
        calledClose = false;
    }
    
    private function onError(error : PhidgetError) : Void{
        dispatchEvent(new PhidgetErrorEvent(PhidgetErrorEvent.ERROR, this, error));
    }
    
    /*
			Dynamic: addKey
			Adds or changes a key/value pair to the dictionary.
			
			Parameters:
				key - key value
				value - value value
				persistent - optional, default is true, determines whether a key remains after closing the connection to the dictionay
		*/
    public function addKey(key : String, value : String, persistent : Bool = true) : Void{
        _phidgetSocket.setKey(key, value, persistent);
    }
    /*
			Dynamic: removeKey
			Removes a (set) of key(s) that match the pattern. The pattern is a regular, or extended regular expression.
			
			Parameters:
				pattern - pattern of keys to remove
		*/
    public function removeKey(pattern : String) : Void{
        _phidgetSocket.removeKey(pattern);
    }
    
    //From the socket
    /*
			Propery: isConnected
			Gets the connected to server state.
		*/
    private function get_IsConnected() : Bool{
        return _phidgetSocket.isConnected;
    }
    /*
			Property: Address
			Gets the server address.
		*/
    private function get_Address() : String{
        if (_phidgetSocket.Address == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _phidgetSocket.Address;
    }
    /*
			Property: Port
			Gets the server port.
		*/
    private function get_Port() : Int{
        if (_phidgetSocket.Port == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _phidgetSocket.Port;
    }

    public function new()
    {
        super();
    }
}

package com.phidgets;

import com.phidgets.PhidgetError;
import com.phidgets.PhidgetSocket;
import com.phidgets.events.PhidgetEvent;
import com.phidgets.events.PhidgetErrorEvent;
using com.phidgets.FloatUtils;

#if flash
private typedef Event = flash.events.Event;
private typedef EventDispatcher = flash.events.EventDispatcher;
#else
private typedef Event = com.phidgets.compat.NativeEvent;
private typedef EventDispatcher = com.phidgets.compat.NativeEventDispatcher;
#end

/*
		Class: Phidget
		Base Phidget class from which all specific device classes inherit.
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by all Phidgets.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetEvent.CONNECT				- server connect
		PhidgetEvent.DISCONNECT				- server disconnect
		PhidgetEvent.ATTACH					- phidget attach
		PhidgetEvent.DETACH					- phidget detach
		PhidgetErrorEvent.ERROR				- asynchronous error
	*/
class Phidget extends EventDispatcher
{
    public var Type(get, never) : String;
    public var Name(get, never) : String;
    public var Label(get, set) : String;
    public var Version(get, never) : Int;
    public var serialNumber(get, never) : Int;
    public var isAttached(get, never) : Bool;
    public var isConnected(get, never) : Bool;
    public var Address(get, never) : String;
    public var Port(get, never) : Int;

    private var _attached : Bool = false;
    
    private var _serialNumber : Int = com.phidgets.Constants.PUNK_INT;
    private var _deviceVersion : Int = 0;
    private var _deviceType : String = null;
    private var _deviceName : String = null;
    private var _deviceLabel : String = null;
    
    //private var _deviceTypeNumber:int = 0;
    private var _specificDevice : Int = com.phidgets.Constants.PHIDGETOPEN_ANY;
    
    private var _phidgetSocket : PhidgetSocket = null;
    private var randInt : Int = 0;  //used for the open/close command  
    private var keyCount : Int = 0;  //used for keeping track of attach / detach events  
    private var keyCountNeeded : Int = 0;
    private var keyCountNeededGood : Bool = false;
    
    private var calledClose : Bool = false;
    
    @:allow(com.phidgets)
    private function initForManager(serial : Int, version : Int, type : String, name : String, label : String,
            attached : Bool, socket : PhidgetSocket) : Void
    {
        _attached = attached;
        _serialNumber = serial;
        _deviceVersion = version;
        _deviceType = type;
        _deviceName = name;
        _deviceLabel = label;
        _phidgetSocket = socket;
    }
    
    public function new(type : String)
    {
        super();
        _deviceType = type;
        initVars();
    }
    
    /*
			Dynamic: open
			Opens a Phidget.
			
			Parameters:
				address - address of the webservice. This can be 'localhost' when running from a single computer.
				port - port of the webservice. This is 5001 by default.
				password - password of the webservice. This is optional and doesn't need to be specified for unsecured webservices.
				serialNumber - serial number of the phidget to open. This is optional and if not specified, the first available phidget will be opened.
		*/
    public function open(address : String, port : Int, password : String = null, serialNumber : Int = com.phidgets.Constants.PUNK_INT, label : String = null) : Void{
        _phidgetSocket = new PhidgetSocket();
        if (serialNumber != com.phidgets.Constants.PUNK_INT && serialNumber != -1) 
        {
            _specificDevice = com.phidgets.Constants.PHIDGETOPEN_SERIAL;
            _serialNumber = serialNumber;
        }
        else if (label != null) 
        {
            _specificDevice = com.phidgets.Constants.PHIDGETOPEN_LABEL;
            _deviceLabel = label;
        }
        else 
        _specificDevice = com.phidgets.Constants.PHIDGETOPEN_ANY;
        _phidgetSocket.connect(address, port, password, onConnected, onDisconnected, onError);
    }
    
    /*
			Dynamic: close
			Closes a Phidget.
			This closes the connection to a Phidget, and to the server.
		*/
    public function close() : Void{
        calledClose = true;
        var key : String = "/PCK/Client/0.0.0.0/" + randInt + "/" + _deviceType;
        if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_SERIAL) 
            key = key + "/" + Std.string(_serialNumber)
        else if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_LABEL) 
            key = key + "/-1/" + _phidgetSocket.escape(_deviceLabel);
        _phidgetSocket.setKey(key, "Close", false);
        _phidgetSocket.close();
    }
    
    private function onConnected() : Void{
        
        //now send the open key
        randInt = Std.random(99999);
        var key : String = "/PCK/Client/0.0.0.0/" + randInt + "/" + _deviceType;
        if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_SERIAL) 
            key = key + "/" + Std.string(_serialNumber)
        else if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_LABEL) 
            key = key + "/-1/" + _phidgetSocket.escape(_deviceLabel);
        _phidgetSocket.setKey(key, "Open", false);
        
        //listen
        var pattern : String = "/PSK/" + _deviceType;
        if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_SERIAL) 
            pattern = pattern + "/[a-zA-Z_0-9/.\\\\-]*/" + Std.string(_serialNumber)
        else if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_LABEL) 
            pattern = pattern + "/" + _phidgetSocket.escape(_deviceLabel, true);
        _phidgetSocket.setListener(pattern, onPhidgetData);
        
        dispatchEvent(new PhidgetEvent(PhidgetEvent.CONNECT, this));
    }
    
    private function onDisconnected() : Void{
        if (!calledClose) 
            dispatchEvent(new PhidgetEvent(PhidgetEvent.DISCONNECT, this));
        if (_attached) 
            detachDevice();
        calledClose = false;
    }
    
    private function onError(error : PhidgetError) : Void{
        dispatchEvent(new PhidgetErrorEvent(PhidgetErrorEvent.ERROR, this, error));
    }
    
    private function isKnown(array : Array<Dynamic>, index : Int, unkval : Float = -1) : Bool{
        if (array[index] == null || array[index] == null) 
            return false;
        if (Std.parseFloat(array[index]).toPrecision(15) == unkval.toPrecision(15) && unkval != -1) 
            return false;
        return true;
    }
    
    private function indexArray(array : Array<Dynamic>, index : Int, limit : Int, unkval : Float = -1) : Dynamic{
        if (index >= limit || index < 0) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
        if (!isKnown(array, index, unkval)) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return array[index];
    }
    
    private function intToBool(val : Int) : Bool{
        if (val == com.phidgets.Constants.PUNK_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        if (val == com.phidgets.Constants.PFALSE)             return false;
        if (val == com.phidgets.Constants.PTRUE)             return true;
        throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNEXPECTED);
    }
    
    private function boolToInt(val : Bool) : Int{
        if (val == false)             return com.phidgets.Constants.PFALSE
        else return com.phidgets.Constants.PTRUE;
    }
    
    private function makeKey(setThing : String) : String{
        return "/PCK/" + _deviceType + "/" + _serialNumber + "/" + setThing;
    }
    private function makeIndexedKey(setThing : String, index : Int, limit : Int) : String{
        if (index >= limit || index < 0) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
        return "/PCK/" + _deviceType + "/" + _serialNumber + "/" + setThing + "/" + index;
    }
    
    //override in the subclasses
    private function initVars() : Void{
    }
    private function eventsAfterOpen() : Void{
    }
    private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
    }
    
    private function onPhidgetData(key : String, val : String, reason : Int) : Void
    {
        //trace("Key: "+key+" Val: "+val+" Reason: "+reason);
        
        if (reason != com.phidgets.Constants.ENTRY_REMOVING || val == "Detached") 
        {
            var dataArray : Array<Dynamic> = key.split("/");
            
            var label : String = _phidgetSocket.unescape(dataArray[3]);
            var serialNumber : Int = Std.parseInt(dataArray[4]);
            var setThing : String = dataArray[5];
            var index : Int = 0;
            if (dataArray.length > 6) 
                index = Std.parseInt(dataArray[6]);
            
            if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_ANY && val != "Detached") 
            {
                _specificDevice = com.phidgets.Constants.PHIDGETOPEN_ANY_ATTACHED;
                _serialNumber = serialNumber;
            }
            if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_LABEL && val != "Detached") 
            {
                _serialNumber = serialNumber;
            }  //trace("Serial: "+serialNumber+" SetThing: "+setThing+" Index: "+index+" Value: "+val+" KeyCount: "+keyCount);  
            
            
            
            
            if (serialNumber == _serialNumber) 
            {
                switch (setThing)
                {
                    case "Label":
                        _deviceLabel = val;
                        keyCount++;
                    case "Version":
                        _deviceVersion = Std.parseInt(val);
                        keyCount++;
                    case "Name":
                        _deviceName = val;
                        keyCount++;
                    case "ID":
                        keyCount++;
                    case "InitKeys":
                        keyCountNeeded = Std.parseInt(val);
                        keyCountNeededGood = true;
                        keyCount++;
                    case "Status":
                        if (val == "Attached") 
                        {
                            keyCount++;
                        }
                        else if (val == "Detached") 
                        {
                            keyCount = 0;
                            keyCountNeededGood = false;
                            detachDevice();
                        }
                    case "Error":
                        var errorData : Array<Dynamic> = val.split("/");
                        var error : PhidgetError = new PhidgetError(Std.parseInt(errorData[0]), errorData[1]);
                        onError(error);
                    default:
                        onSpecificPhidgetData(setThing, index, val);
                }
                if (keyCount >= keyCountNeeded && _attached == false && keyCountNeededGood == true) 
                {
                    _attached = true;
                    dispatchEvent(new PhidgetEvent(PhidgetEvent.ATTACH, this));
                    //dispatch initial events
                    eventsAfterOpen();
                }
            }
        }
    }
    
    private function detachDevice() : Void{
        _attached = false;
        if (!calledClose) 
            dispatchEvent(new PhidgetEvent(PhidgetEvent.DETACH, this));
        if (_specificDevice == com.phidgets.Constants.PHIDGETOPEN_ANY_ATTACHED) 
        {
            _specificDevice = com.phidgets.Constants.PHIDGETOPEN_ANY;
            _serialNumber = com.phidgets.Constants.PUNK_INT;
        }
        if (_specificDevice != com.phidgets.Constants.PHIDGETOPEN_LABEL) 
            _deviceLabel = null;
        _deviceVersion = com.phidgets.Constants.PUNK_INT;
        _deviceName = null;
        initVars();
    }
    
    //Getters
    /*
			Property: Type
			Gets the type (class) of a Phidget.
		*/
    private function get_Type() : String{
        if (_deviceType == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _deviceType;
    }
    /*
			Property: Name
			Gets the specific name of a Phidget.
		*/
    private function get_Name() : String{
        if (_deviceName == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _deviceName;
    }
    /*
			Property: Label
			Gets the Label of a Phidget.
		*/
    private function get_Label() : String{
        if (_deviceLabel == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _deviceLabel;
    }
    /*
			Property: Version
			Gets the firwmare version of a Phidget.
		*/
    private function get_Version() : Int{
        if (_deviceVersion == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _deviceVersion;
    }
    /*
			Property: serialNumber
			Gets the unique serial number of a Phidget.
		*/
    private function get_serialNumber() : Int{
        if (_serialNumber == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return _serialNumber;
    }
    /*
			Property: isAttached
			Gets the attached state of a Phidget.
		*/
    private function get_isAttached() : Bool{
        return _attached;
    }
    
    //From the socket
    /*
			Propery: isConnected
			Gets the connected to server state.
			Note that being connected to the server does not mean that the Phidget is attached.
		*/
    private function get_isConnected() : Bool{
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
    
    //Setters
    /*
			Property: Label
			Sets the Label.
			Note that this is only supported on some systems.
		*/
    private function set_Label(str : String) : String{
        var key : String = "/PCK/" + _deviceType + "/" + _serialNumber + "/Label";
        _phidgetSocket.setKey(key, str, false);
        return str;
    }
    
    override public function toString() : String{
        return _deviceName + ", Version: " + _deviceVersion + ", Serial Number: " + _serialNumber + (_deviceLabel == null || _deviceLabel == ("") ? "" : ", Label: " + _deviceLabel);
    }
}

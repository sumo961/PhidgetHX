package com.phidgets;

import com.phidgets.PhidgetSocket;

import flash.events.Event;
import com.phidgets.events.PhidgetManagerEvent;
import com.phidgets.events.PhidgetErrorEvent;
import flash.events.EventDispatcher;

/*
		Class: PhidgetManager
		A class for accessing the Phidget Manager on a webservice.
		See the programming manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetManager.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetManagerEvent.CONNECT			- server connect
		PhidgetManagerEvent.DISCONNECT		- server disconnect
		PhidgetManagerEvent.ATTACH			- phidget attach
		PhidgetManagerEvent.DETACH			- phidget detach
		PhidgetErrorEvent.ERROR				- asynchronous error
	*/
class PhidgetManager extends EventDispatcher
{
    public var isConnected(get, never) : Bool;
    public var Address(get, never) : String;
    public var Port(get, never) : Int;

    private var _phidgetSocket : PhidgetSocket = null;
    
    private var calledClose : Bool = false;
    
    /*
			Dynamic: open
			Opens a connection to a phidget manager.
			
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
			Closes the connection to a phidget manager.
		*/
    public function close() : Void{
        calledClose = true;
        _phidgetSocket.close();
    }
    
    private function onConnected() : Void{
        //listen
        var pattern : String = "^/PSK/List/";
        _phidgetSocket.setListener(pattern, onPhidgetManagerData);
        
        dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.CONNECT, this));
    }
    
    private function onDisconnected() : Void{
        if (!calledClose) 
            dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.DISCONNECT, this));
        calledClose = false;
    }
    
    private function onError(error : PhidgetError) : Void{
        dispatchEvent(new PhidgetErrorEvent(PhidgetErrorEvent.ERROR, this, error));
    }
    
    private function onPhidgetManagerData(key : String, val : String, reason : Int) : Void
    {
        //trace("Key: "+key+" Val: "+val+" Reason: "+reason);
        
        if (reason != com.phidgets.Constants.ENTRY_REMOVING) 
        {
            var dataArray : Array<Dynamic> = key.split("/");
            var dataArray2 : Array<Dynamic> = val.split(" ");
            
            var deviceType : String = dataArray[3];
            var serialNumber : Int = Std.parseInt(dataArray[4]);
            
            var deviceVersion : Int = Std.parseInt(dataArray2[1].substring(8));
            var deviceIDSpec : String = dataArray2[2].substring(3);
            var deviceLabel : String = dataArray2[3].substring(6);
            //take care of spaces in label
            for (i in 4...dataArray2.length){deviceLabel = deviceLabel + " " + dataArray2[i];
            }
            
            //trace(deviceType+"<>"+serialNumber+"<>"+deviceIDSpec+"<>"+deviceVersion+"<>"+deviceLabel);
            
            var phidget : Phidget = new Phidget(deviceType);
            
            if (dataArray2[0] == "Attached") 
            {
                phidget.initForManager(serialNumber, deviceVersion, deviceType,
                        Constants.Phid_DeviceSpecificName[deviceIDSpec], deviceLabel,
                        true, _phidgetSocket);
                dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.ATTACH, this, phidget));
            }
            if (dataArray2[0] == "Detached") 
            {
                phidget.initForManager(serialNumber, deviceVersion, deviceType,
                        Constants.Phid_DeviceSpecificName[deviceIDSpec], deviceLabel,
                        false, _phidgetSocket);
                dispatchEvent(new PhidgetManagerEvent(PhidgetManagerEvent.DETACH, this, phidget));
            }
        }
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

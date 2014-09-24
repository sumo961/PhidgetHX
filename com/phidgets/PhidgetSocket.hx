package com.phidgets;

#if flash
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.StatusEvent;
import flash.system.Security;
typedef Socket = flash.net.XMLSocket;
#elseif neko
typedef Socket = com.phidgets.compat.net.NekoSocket;
private typedef Event = com.phidgets.compat.NativeEvent;
private typedef IOErrorEvent = Event;
private typedef DataEvent = com.phidgets.compat.net.NativeDataEvent;
#end


// WARNING: This class is for internal use only.
class PhidgetSocket
{
    public var Address(get, never) : String;
    public var Port(get, never) : Int;
    public var ServerID(get, never) : String;
    public var isConnected(get_isConnected, never) : Bool;

    /*
		*	Phidget WebService Protocol version history
		*	1.0 - Initial version
		*
		*	1.0.1
		*		-first version to be enforced
		*		-we changed around the device id numbers, so old webservice won't be able to talk to new
		*
		*	1.0.2
		*		-Authorization is asynchronous, so we had to add Tags and now it's not compatible with old webservice
		*		-Doesn't match the old version checking! So could be ugly for users, get an unexpected error rather then a version error
		*		-Sends out all initial data, so it's just like opening locally
		*		-supports interfacekit Raw sensor value
		*		-supports labels on remoteIP managers
		*
		*	1.0.3
		*		-supports servoType and setServoParameters for PhidgetServo and PhidgetAdvancedServo
		*
		*	1.0.4
		*		-fixed RFID initialization - wasn't getting tag events if tag is on reader before open
		*		-fixed RFID sometimes not attaching in Flash
		*
		*	1.0.5
		*		-added dataRate for InterfaceKit
		*
		*	1.0.6
		*		-added brightness for TextLCD
		*		-support PhidgetSpatial
		*		-support PhidgetIR
		*		-1047 support (enable, index)
		*
		*	1.0.7
		*		-1045 support
		*		-1011 support
		*		-1204 support
		*
		*	1.0.8
		*		-support for 1065, 1002, 1040, 1046, 1056
		*		-support for error events
		*
		*	1.0.9
		*		-support for openLabelRemote and openLabelRemoteIP
		*
		*	1.0.10
		*		-support for 1024, 1032
		*/
    private static inline var protocol_ver : String = "1.0.10";
    
    private var _socket : Socket;
    private var _host : String = null;
    private var _port : Int = com.phidgets.Constants.PUNK_INT;
    private var _serverID : String = null;
    private var _password : String = null;
    
    private var _connected : Bool = false;
    private var _authenticated : Bool = false;
    
    private var lidCounter : Int = 0;
    private var lidList : Array<Dynamic>;
    
    private var _connectedCallback : Dynamic;
    private var _disconnectedCallback : Dynamic;
    private var _errorCallback : Dynamic;
    
    public function new()
    {
        _socket = new Socket();
        
        _socket.addEventListener(Event.CONNECT, onSocketConnect);
        _socket.addEventListener(DataEvent.DATA, onSocketData);
        _socket.addEventListener(Event.CLOSE, onSocketClose);
        _socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketError);
        
        lidList = new Array<Dynamic>();
    }
    
    public function connect(address : String, port : Int, password : String,
            connectedCallback : Dynamic, disconnectedCallback : Dynamic, errorCallback : Dynamic) : Void
    {
        _host = address;
        _port = port;
        _connectedCallback = connectedCallback;
        _disconnectedCallback = disconnectedCallback;
        _errorCallback = errorCallback;
        
        if (password != null) 
            _password = password;
        //flash.system.Security.loadPolicyFile("xmlsocket://" + address + ":" + port);
        _socket.connect(_host, _port);
    }
    
    public function close() : Void{
        socketSend("quit");
    }
    
    private function goodChar(charCode : Float) : Bool{
        var chars : String = "09azAZ ./";
        if (charCode <= chars.charCodeAt(1) && charCode >= chars.charCodeAt(0)) 
            return true;
        if (charCode <= chars.charCodeAt(3) && charCode >= chars.charCodeAt(2)) 
            return true;
        if (charCode <= chars.charCodeAt(5) && charCode >= chars.charCodeAt(4)) 
            return true;
        if (charCode == chars.charCodeAt(6) || charCode == chars.charCodeAt(7) || charCode == chars.charCodeAt(8)) 
            return true;
        return false;
    }
    
    private function hexChar(num : Int) : String{
        var chars : String = "0123456789abcdef";
        if (num > 0xF) return "f";
        return chars.charAt(num);
    }
    
    private function hexval(char : String) : Int{
        var chars : String = "09af";
        var charCode : Int = char.toLowerCase().charCodeAt(0);
        if (charCode <= chars.charCodeAt(1) && charCode >= chars.charCodeAt(0)) 
            return charCode - chars.charCodeAt(0);
        if (charCode <= chars.charCodeAt(3) && charCode >= chars.charCodeAt(2)) 
            return charCode - chars.charCodeAt(2) + 10;
        return 0;
    }
    
    public function escape(val : String, escBacks : Bool = false) : String{
        var newVal : String = "";
        if (val.length == 0) 
            newVal = ((escBacks) ? "\\\\x01" : "\\x01")
        else 
        {
            for (i in 0...val.length){
                var charCode : Int = val.charCodeAt(i);
                if (!goodChar(charCode)) 
                    newVal += (((escBacks) ? "\\\\x" : "\\x") + hexChar(Std.int(charCode / 16)) + hexChar(charCode % 16))
                else 
                newVal += (String.fromCharCode(charCode));
            }
        }
        return newVal;
    }
    
    public function unescape(val : String) : String{
        var newVal : String = "";
		var i = 0;
        while(i < val.length){
            if (val.charAt(i) == "//") {
                newVal += (String.fromCharCode(hexval(val.charAt(i + 2)) * 16 + hexval(val.charAt(i + 3))));
                i += 3;
            }
            else 
            newVal += (val.charAt(i++));
        }
        if (newVal == String.fromCharCode(0x01)) 
            return "";
        return newVal;
    }
    
    private function socketSend(data : String) : Void{
        var request : String = data;  // + "\n";  
        //trace("Request: <"+request+">");
        _socket.send(request);
    }
    
    public function setKey(key : String, val : String, persistent : Bool) : Void{
        var request : String = "set " + key + "=\"" + escape(val) + "\"";
        if (!persistent) 
            request = request + " for session";
        socketSend(request);
    }
    
    public function removeKey(pattern : String) : Void{
        var request : String = "remove " + pattern;
        socketSend(request);
    }
    
    public function setListener(pattern : String, callback : Dynamic) : Int
    {
        var request : String = "listen " + pattern + " lid" + lidCounter;
        lidList[lidCounter] = callback;
        lidCounter++;
        socketSend(request);
        return lidCounter - 1;
    }
    
    public function removeListener(lid : Int) : Void{
        var request : String = "ignore lid" + lid;
        socketSend(request);
    }
    
    private function onAuthenticated() : Void{
        //trace("Authenticated");
        _authenticated = true;
        
        //start reports
        socketSend("report 8 report");
        
        _connectedCallback();
    }
    
    private function onSocketConnect(evt : Event) : Void{
        if (!_socket.connected) 
        {
            _errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_NETWORK_NOTCONNECTED));
            return;
        }
        
		trace("Phidget socket connected");
        _connected = true;
        
        //AS3.0 wants line to be null terminated
        socketSend("need nulls");
        //start authentication proccess
        socketSend("995 authenticate, version=" + protocol_ver);
    }
    
    private function onSocketError(evt : Event) : Void{
        var error : PhidgetError = new PhidgetError(Constants.EPHIDGET_NETWORK);
		#if !flash 
        error.setMessage(evt.text);
		#end
        _errorCallback(error);
    }
    
    private function onSocketClose(evt : Event) : Void {
		trace("Phidget socket closed");
        _connected = false;
        _disconnectedCallback();
    }
    
    private function onSocketData(evt : DataEvent) : Void{
        //trace(evt.data);
        var realData : String = evt.data;
        if (evt.data.indexOf("\n") != -1) 
            realData = evt.data.substring(0, evt.data.indexOf("\n"));
        
        var tag : String = null;
        var multiPart : Bool = false;
        
        //check for and parse out a tag
        if (realData.charCodeAt(0) > "9".charCodeAt(0) || realData.charCodeAt(0) < "0".charCodeAt(0)) 
        {
            var spaceIndex : Int = realData.indexOf(" ");
            tag = realData.substring(0, spaceIndex);
            realData = realData.substring(spaceIndex + 1, realData.length);
        }
        
        var responseType : String = realData.charAt(0);
        var responseCode : String = realData.substring(0, 3);
        if (realData.charAt(3) == "-") 
            multiPart = true;
        
        realData = realData.substring(4, realData.length);
        
        var request : String = "";
        
        //trace("Response: <"+realData+">");
        
        var error : com.phidgets.PhidgetError = new PhidgetError(Constants.EPHIDGET_NETWORK);
        error.setMessage(responseCode + " " + realData);
        
        switch (responseType)
        {
            case Constants.SUCCESS_200_RESP:
                if (tag == "report") 
                {
                    //Explicit ACK - don't bother, reduces performance sometimes
                    //socketSend("report ack");
                    if (realData.substring(0, 3) == "lid") 
                    {
                        var lisid : Int = Std.parseInt(realData.charAt(3));
                        var callback : Dynamic = lidList[lisid];
                        var keyStart : Int = realData.indexOf("key ") + 4;
                        var keyEnd : Int = realData.indexOf(" latest");
                        var key : String = realData.substring(keyStart, keyEnd);
                        var valStart : Int = realData.indexOf("\"", keyEnd) + 1;
                        var valEnd : Int = realData.indexOf("\"", valStart);
                        var val : String = realData.substring(valStart, valEnd);
                        var reasonStart : Int = realData.indexOf("(", valEnd) + 1;
                        var reasonEnd : Int = realData.indexOf(")", valEnd);
                        var reason : String = realData.substring(reasonStart, reasonEnd);
                        var reasonInt : Int = -1;
                        switch (reason)
                        {
                            case "current":
                                reasonInt = com.phidgets.Constants.CURRENT_VALUE;
                            case "removing":
                                reasonInt = com.phidgets.Constants.ENTRY_REMOVING;
                            case "added":
                                reasonInt = com.phidgets.Constants.ENTRY_ADDED;
                            case "changed":
                                reasonInt = com.phidgets.Constants.VALUE_CHANGED;
                        }  //unescape val  
                        
                        callback(key, unescape(val), reasonInt);
                    }
                }
            case Constants.FAILURE_300_RESP:
                _errorCallback(error);
            case Constants.FAILURE_400_RESP:
                _errorCallback(error);
            case Constants.FAILURE_500_RESP:
                _errorCallback(error);
            case Constants.AUTHENTICATE_900_RESP:
                switch (responseCode)
                {
                    case "999":  //Authentication required  
                        var ticket : String = realData + _password;
                        _password = null;
                        var hash : String = MD5.hex_md5(ticket);
                        request = "997 " + hash;
                        socketSend(request);
                    case "998":  //Authentication failed  
                    _errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_BADPASSWORD));
                    case "996":  //Authenitcated, or no authentication  
                        //check version
						var error = false;
                        if (realData.indexOf("version=", 0) <= 0) 
                        {
                            _errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_BADVERSION));
                            error = true;
                        }
                        if(!error) onAuthenticated();
                    case "994":  //Version mismatch  
                    _errorCallback(new PhidgetError(com.phidgets.Constants.EPHIDGET_BADVERSION));
                }
        }
    }
    
    private function get_Address() : String{
        return _host;
    }
    private function get_Port() : Int{
        return _port;
    }
    private function get_ServerID() : String{
        return _serverID;
    }
    private function get_isConnected() : Bool{
        return _connected;
    }
}

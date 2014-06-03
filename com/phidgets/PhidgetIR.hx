package com.phidgets;

import com.phidgets.PhidgetIRCode;
import com.phidgets.PhidgetIRCodeInfo;
import com.phidgets.PhidgetIRLearnedCode;

import com.phidgets.events.PhidgetDataEvent;
import flash.accessibility.Accessibility;


/*
		Class: PhidgetIR
		A class for controlling a PhidgetIR.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetIR. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.CODE		- code
		PhidgetDataEvent.RAW_DATA	- raw data
		PhidgetDataEvent.LEARN		- learned code
	*/
class PhidgetIR extends Phidget
{
    public var LastCode(get, never) : PhidgetIRCode;
    public var LastLearnedCode(get, never) : PhidgetIRLearnedCode;

    @:allow(com.phidgets)
    private static inline var IR_DATA_ARRAY_SIZE : Int = 2048;
    @:allow(com.phidgets)
    private static inline var IR_DATA_ARRAY_MASK : Int = 0x7ff;
    
    public static inline var RAWDATA_LONGSPACE : Int = 0xfffff;  //1048575;  
    
    private var rawData : Array<Dynamic>;
    private var dataWritePtr : Int;
    private var userReadPtr : Int;
    
    private var lastCode : PhidgetIRCode;
    private var lastLearnedCode : PhidgetIRLearnedCode;
    
    private var flip : Int;
    
    public function new()
    {
        super("PhidgetIR");
    }
    
    override private function initVars() : Void{
        rawData = new Array<Dynamic>(IR_DATA_ARRAY_SIZE);
        dataWritePtr = 0;
        userReadPtr = 0;
        lastCode = null;
        lastLearnedCode = null;
        flip = 0;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "Code":
                var data : Array<Dynamic> = value.split(",");
                var code : PhidgetIRCode = new PhidgetIRCode(data[0], data[1], data[2] == ("0") ? false : true);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CODE, this, code));
                lastCode = code;
            case "Learn":
                var learnedCode : PhidgetIRLearnedCode = PhidgetIRLearnedCode.stringToPhidgetIRLearnedCode(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.LEARN, this, learnedCode));
                lastLearnedCode = learnedCode;
            case "RawData":
                var dataString : String = value.split(",")[0];
                var rawDataSendCnt : Int = new Int(value.split(",")[1]);
                var dataLength : Int = dataString.length / 5;
                var rdata : Array<Dynamic> = new Array<Dynamic>(dataLength);
                
                for (i in 0...dataLength){rdata[i] = Std.parseInt("0x0" + dataString.substr(i * 5, 5));
                }
                
                //ACK this raw data packet
                _phidgetSocket.setKey(makeIndexedKey("RawDataAck", index, 100), Std.string(rawDataSendCnt), true);
                
                //add to buffer for readRaw
                for (j in 0...dataLength){
                    rawData[dataWritePtr] = rdata[j];
                    
                    dataWritePtr++;
                    dataWritePtr &= IR_DATA_ARRAY_MASK;
                    //if we run into data that hasn't been read... too bad, we overwrite it and adjust the read pointer
                    if (dataWritePtr == userReadPtr) 
                    {
                        userReadPtr++;
                        userReadPtr &= IR_DATA_ARRAY_MASK;
                    }
                }  //send event  
                
                
                
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.RAW_DATA, this, rdata));
        }
    }
    
    //Getters
    /*
			Property: LastCode
			Gets the last code received.
		*/
    private function get_LastCode() : PhidgetIRCode{
        if (lastCode == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return lastCode;
    }
    /*
			Property: LastLearnedCode
			Gets the last code received.
		*/
    private function get_LastLearnedCode() : PhidgetIRLearnedCode{
        if (lastLearnedCode == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return lastLearnedCode;
    }
    
    //Dynamics
    /*
			Dynamic: readRaw
			Read raw IR data. Read data always starts with a space and ends with a pulse.
			
			parameters:
				buffer - an array to read data into
				offset - offset in array to start writing data. Defaults to 0 (start of array);
				count - maximum ammount of data to read. Defaults to size of array.
				
			Returns:
				The ammount of data actually read.
		*/
    public function readRaw(buffer : Array<Dynamic>, offset : Int = 0, count : Int = -1) : Int
    {
        var i : Int = 0;
        
        if (offset < 0 || offset >= buffer.length) 
            return 0  //make sure count isn't too high  ;
        
        
        
        if (count + offset > buffer.length || count == -1) 
            count = buffer.length - offset  //make sure length is even so we only send out data with starting space and ending pulse  ;
        
        
        
        if ((count % 2) == 1) 
            count--;
        
        for (i in 0...count){
            if (userReadPtr == dataWritePtr) 
                break;
            
            buffer[i + offset] = rawData[userReadPtr];
            userReadPtr = (userReadPtr + 1) & IR_DATA_ARRAY_MASK;
        }  //make sure i is even so that we don't end with a pulse  
        
        
        
        if ((i % 2) == 1) 
        {
            //negate the pulse if we added it
            i--;
            userReadPtr = (userReadPtr - 1) & IR_DATA_ARRAY_MASK;
            buffer[i + offset] = null;
        }
        
        return i;
    }
    
    /*
			Dynamic: transmit
			Transmit an IR code.
			
			parameters:
				code - the code to transmit. Right-justified hex string (same format as codes coming in).
				codeInfo - code information.
		*/
    public function transmit(code : String, codeInfo : PhidgetIRCodeInfo) : Void
    {
        _phidgetSocket.setKey(makeKey("Transmit"), Std.string(codeInfo) + code, true);
    }
    /*
			Dynamic: transmitRepeat
			Transmit a repeat code. Call after calling transmit. Make sure to pause at least 20ms between calls to this function
		*/
    public function transmitRepeat() : Void
    {
        flip ^= 1;
        _phidgetSocket.setKey(makeKey("Repeat"), Std.string(flip), true);
    }
    
    //pad to 20-bit
    private function pad(str : String) : String{
        if (str.length > 5) 
            str = "fffff";
        while (str.length < 5)
        str = "0" + str;
        return str;
    }
    /*
			Dynamic: transmitRaw
			Transmit raw data. Use this for codes that cannot be specified using a PhidgetIRCodeInfo object.
			
			parameters:
				data - the raw data to transmit. Data is in microseconds, and must start and end with a pulse.
				carrierFrequency - carrier frequency to use. Optional, defaults to 38000kHz.
				dutyCycle - duty cycle to use. Optional, defaults to 33%.
				gap - gap length to maintain after data is transmitted. Optional, default is 0.
		*/
    public function transmitRaw(data : Array<Dynamic>, carrierFrequency : Int = 0, dutyCycle : Int = 0, gap : Int = 0) : Void
    {
        var dataStr : String = "";
        for (i in 0...data.length){
            dataStr = dataStr + pad(Std.string(data[i]));
        }
        dataStr = dataStr + "," + Std.string(carrierFrequency) + "," + Std.string(dutyCycle) + "," + Std.string(gap);
        _phidgetSocket.setKey(makeKey("TransmitRaw"), dataStr, true);
    }
}

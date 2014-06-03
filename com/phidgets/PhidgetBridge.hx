package com.phidgets;

import com.phidgets.PhidgetError;

import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetBridge
		A class for controlling a PhidgetBridge.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetBridge. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.BRIDGE_DATA	- bridge data. Comes in a dataRate intervals.
	*/
class PhidgetBridge extends Phidget
{
    public var InputCount(get, never) : Int;
    public var DataRate(get, set) : Int;
    public var DataRateMin(get, never) : Int;
    public var DataRateMax(get, never) : Int;

    private var numInputs : Int;
    private var dataRateMin : Int;
    private var dataRateMax : Int;
    private var dataRate : Int;
    
    private var enabled : Array<Dynamic>;
    private var gain : Array<Dynamic>;
    private var bridgeValue : Array<Dynamic>;
    private var bridgeMin : Array<Dynamic>;
    private var bridgeMax : Array<Dynamic>;
    
    /*
			Constants: Bridge Gains
			These are the Gains supported by PhidgetBridge. These constants are used with <getGain> and <setGain>.
			
			PHIDGET_BRIDGE_GAIN_1 - Gain of 1.
			PHIDGET_BRIDGE_GAIN_8 - Gain of 8.
			PHIDGET_BRIDGE_GAIN_16 - Gain of 16.
			PHIDGET_BRIDGE_GAIN_32 - Gain of 32.
			PHIDGET_BRIDGE_GAIN_64 - Gain of 64.
			PHIDGET_BRIDGE_GAIN_128 - Gain of 128.
		*/
    public static inline var PHIDGET_BRIDGE_GAIN_1 : Int = 1;
    public static inline var PHIDGET_BRIDGE_GAIN_8 : Int = 2;
    public static inline var PHIDGET_BRIDGE_GAIN_16 : Int = 3;
    public static inline var PHIDGET_BRIDGE_GAIN_32 : Int = 4;
    public static inline var PHIDGET_BRIDGE_GAIN_64 : Int = 5;
    public static inline var PHIDGET_BRIDGE_GAIN_128 : Int = 6;
    private static inline var PHIDGET_BRIDGE_GAIN_UNKNOWN : Int = 7;
    
    public function new()
    {
        super("PhidgetBridge");
    }
    
    override private function initVars() : Void{
        numInputs = com.phidgets.Constants.PUNK_INT;
        dataRateMin = com.phidgets.Constants.PUNI_INT;
        dataRateMax = com.phidgets.Constants.PUNI_INT;
        dataRate = com.phidgets.Constants.PUNI_INT;
        enabled = new Array<Dynamic>(4);
        gain = new Array<Dynamic>(4);
        bridgeValue = new Array<Dynamic>(4);
        bridgeMin = new Array<Dynamic>(4);
        bridgeMax = new Array<Dynamic>(4);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfInputs":
                numInputs = Std.parseInt(value);
                keyCount++;
            case "DataRate":
                if (dataRate == com.phidgets.Constants.PUNI_INT)                     keyCount++;
                dataRate = Std.parseInt(value);
            case "DataRateMin":
                if (dataRateMin == com.phidgets.Constants.PUNI_INT)                     keyCount++;
                dataRateMin = Std.parseInt(value);
            case "DataRateMax":
                if (dataRateMax == com.phidgets.Constants.PUNI_INT)                     keyCount++;
                dataRateMax = Std.parseInt(value);
            case "Enabled":
                if (enabled[index] == null) 
                    keyCount++;
                enabled[index] = Std.parseInt(value);
            case "BridgeMax":
                if (bridgeMax[index] == null) 
                    keyCount++;
                bridgeMax[index] = Std.parseFloat(value);
            case "BridgeMin":
                if (bridgeMin[index] == null) 
                    keyCount++;
                bridgeMin[index] = Std.parseFloat(value);
            case "Gain":
                if (gain[index] == null) 
                    keyCount++;
                gain[index] = Std.parseInt(value);
            case "BridgeValue":
                if (bridgeValue[index] == null) 
                    keyCount++;
                bridgeValue[index] = Std.parseFloat(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.BRIDGE_DATA, this, Std.parseFloat(bridgeValue[index]), index));
        }
    }
    override private function eventsAfterOpen() : Void
    {
        for (i in 0...numInputs){
            if (isKnown(bridgeValue, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.BRIDGE_DATA, this, Std.parseFloat(bridgeValue[i]), i));
        }
    }
    
    //Getters
    /*
			Property: InputCount
			Gets the number of inputs on this bridge.
		*/
    private function get_InputCount() : Int{
        if (numInputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numInputs;
    }
    /*
			Property: DataRate
			Gets the number of inputs on this bridge.
		*/
    private function get_DataRate() : Int{
        if (dataRate == com.phidgets.Constants.PUNK_INT || dataRate == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRate;
    }
    /*
			Property: DataRateMin
			Gets the number of inputs on this bridge.
		*/
    private function get_DataRateMin() : Int{
        if (dataRateMin == com.phidgets.Constants.PUNK_INT || dataRate == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRateMin;
    }
    /*
			Property: DataRateMax
			Gets the number of inputs on this bridge.
		*/
    private function get_DataRateMax() : Int{
        if (dataRateMax == com.phidgets.Constants.PUNK_INT || dataRate == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRateMax;
    }
    /*
			Dynamic: getEnabled
			Gets the enabled state of an input.
			
			Parameters:
				index - input index
		*/
    public function getEnabled(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(enabled, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getBridgeValue
			Gets the value of an input, in mV/V
			
			Parameters:
				index - input index
		*/
    public function getBridgeValue(index : Int) : Float{
        return Std.parseFloat(indexArray(bridgeValue, index, numInputs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getBridgeMin
			Gets minimum bridge value, in mV/V
			
			Parameters:
				index - input index
		*/
    public function getBridgeMin(index : Int) : Float{
        return Std.parseFloat(indexArray(bridgeMin, index, numInputs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getBridgeMax
			Gets maximum bridge value, in mV/V
			
			Parameters:
				index - input index
		*/
    public function getBridgeMax(index : Int) : Float{
        return Std.parseFloat(indexArray(bridgeMax, index, numInputs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getGain
			Gets the gain for an input.
			
			Parameters:
				index - input index.
		*/
    public function getGain(index : Int) : Int{
        return Std.parseInt(indexArray(gain, index, numInputs, PHIDGET_BRIDGE_GAIN_UNKNOWN));
    }
    
    //Setters
    /*
			Property: DataRate
			Sets the data rate of the board, in ms. Must by a multiple of 8.
			
			Parameters:
				val - data rate.
		*/
    private function set_DataRate(val : Int) : Int{
        _phidgetSocket.setKey(makeKey("DataRate"), Std.string(val), true);
        return val;
    }
    /*
			Dynamic: setEnabled
			Enables/Disables an input.
			
			Parameters:
				index - input index
				val - state
		*/
    public function setEnabled(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Enabled", index, numInputs), Std.string(boolToInt(val)), true);
    }
    /*
			Dynamic: setGain
			Sets the gain for an input. Set to one of the defined gains - <PHIDGET_BRIDGE_GAIN_1> - <PHIDGET_BRIDGE_GAIN_128>.
			
			Parameters:
				index - input index
				val - state
		*/
    public function setGain(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Gain", index, numInputs), Std.string(val), true);
    }
}

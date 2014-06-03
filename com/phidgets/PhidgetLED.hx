package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetLED
		A class for controlling a PhidgetLED.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetLED extends Phidget
{
    public var LEDCount(get, never) : Int;
    public var Voltage(get, set) : Int;
    public var CurrentLimit(get, set) : Int;

    private var numLEDs : Int;
    private var leds : Array<Dynamic>;
    private var voltage : Int;
    private var currentLimit : Int;
    private var currentLimits : Array<Dynamic>;
    
    /*
			Constants: Current Limits
			These are the supported current limits for the Phidget LED 64 Advanced. These constants are used with <CurrentLimit>.
			
			PHIDGET_LED_CURRENT_LIMIT_20mA - 20mA.
			PHIDGET_LED_CURRENT_LIMIT_40mA - 40mA.
			PHIDGET_LED_CURRENT_LIMIT_60mA - 60mA.
			PHIDGET_LED_CURRENT_LIMIT_80mA - 80mA.
		*/
    public static inline var PHIDGET_LED_CURRENT_LIMIT_20mA : Int = 1;
    public static inline var PHIDGET_LED_CURRENT_LIMIT_40mA : Int = 2;
    public static inline var PHIDGET_LED_CURRENT_LIMIT_60mA : Int = 3;
    public static inline var PHIDGET_LED_CURRENT_LIMIT_80mA : Int = 4;
    
    /*
			Constants: Voltages
			These are the supported output voltages for the Phidget LED 64 Advanced. These constants are used with <Voltage>.
			
			PHIDGET_LED_VOLTAGE_1_7V  - 1.7V.
			PHIDGET_LED_VOLTAGE_2_75V - 2.75V.
			PHIDGET_LED_VOLTAGE_3_9V  - 3.9V.
			PHIDGET_LED_VOLTAGE_5_0V  - 5.0V.
		*/
    public static inline var PHIDGET_LED_VOLTAGE_1_7V : Int = 1;
    public static inline var PHIDGET_LED_VOLTAGE_2_75V : Int = 2;
    public static inline var PHIDGET_LED_VOLTAGE_3_9V : Int = 3;
    public static inline var PHIDGET_LED_VOLTAGE_5_0V : Int = 4;
    
    public function new()
    {
        super("PhidgetLED");
    }
    
    override private function initVars() : Void{
        numLEDs = com.phidgets.Constants.PUNK_INT;
        leds = new Array<Dynamic>(64);
        voltage = com.phidgets.Constants.PUNI_INT;
        currentLimit = com.phidgets.Constants.PUNI_INT;
        currentLimits = new Array<Dynamic>(64);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfLEDs":
                numLEDs = Std.parseInt(value);
                keyCount++;
            case "Voltage":
                if (voltage == com.phidgets.Constants.PUNI_INT) 
                    keyCount++;
                voltage = Std.parseInt(value);
            case "CurrentLimit":
                if (currentLimit == com.phidgets.Constants.PUNI_INT) 
                    keyCount++;
                currentLimit = Std.parseInt(value);
            case "Brightness":
                if (leds[index] == null)                     keyCount++;
                leds[index] = value;
            case "CurrentLimitIndexed":
                if (currentLimits[index] == null)                     keyCount++;
                currentLimits[index] = value;
        }
    }
    
    //Getters
    /*
			Property: LEDCount
			Gets the number of LEDs supported by this PhidgetLED
		*/
    private function get_LEDCount() : Int{
        if (numLEDs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numLEDs;
    }
    /*
			Property: Voltage
			Gets the voltage output for all LEDs. This is not supported by all PhidgetLEDs.
		*/
    private function get_Voltage() : Int{
        if (voltage == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
        if (voltage == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return voltage;
    }
    /*
			Property: CurrentLimit
			Gets the current limit for all LEDs.  This is not supported by all PhidgetLEDs.
		*/
    private function get_CurrentLimit() : Int{
        if (currentLimit == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
        if (currentLimit == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return currentLimit;
    }
    /*
			Dynamic: getDiscreteLED
			Gets the brightness of an LED.
			Deprecated: use getBrightness
			
			Parameters:
				index - LED index
		*/
    public function getDiscreteLED(index : Int) : Int{
        return Std.parseInt(indexArray(leds, index, numLEDs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getBrightness
			Gets the brightness of an LED.
			
			Parameters:
				index - LED index
		*/
    public function getBrightness(index : Int) : Float{
        return Std.parseFloat(indexArray(leds, index, numLEDs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getCurrentLimit
			Gets the current limit of an LED.
			
			Parameters:
				index - LED index
		*/
    public function getCurrentLimit(index : Int) : Float{
        return Std.parseFloat(indexArray(currentLimits, index, numLEDs, com.phidgets.Constants.PUNK_NUM));
    }
    
    //Setters
    /*
			Dynamic: setDiscreteLED
			Sets the brightness of an LED (0-100).
			Deprecated: use setBrightness
			
			Parameters:
				index - LED index
				val - brightness
		*/
    public function setDiscreteLED(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Brightness", index, numLEDs), Std.string(val), true);
    }
    /*
			Dynamic: setBrightness
			Sets the brightness of an LED (0-100).
			
			Parameters:
				index - LED index
				val - brightness
		*/
    public function setBrightness(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Brightness", index, numLEDs), Std.string(val), true);
    }
    /*
			Dynamic: setCurrentLimit
			Sets the current limit of an LED (0-80 mA).
			
			Parameters:
				index - LED index
				val - current limit
		*/
    public function setCurrentLimit(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("CurrentLimitIndexed", index, numLEDs), Std.string(val), true);
    }
    /*
			Property: Voltage
			Sets the voltage for all LED outputs.  This is not supported by all PhidgetLEDs.
			
			Parameters:
				val - one of the predefined output voltages.
		*/
    private function set_Voltage(val : Int) : Int{
        if (voltage == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
        _phidgetSocket.setKey(makeKey("Voltage"), Std.string(val), true);
        return val;
    }
    /*
			Property: CurrentLimit
			Sets the current limit for all LED outputs.  This is not supported by all PhidgetLEDs.
			
			Parameters:
				val - one of the predefined current limits.
		*/
    private function set_CurrentLimit(val : Int) : Int{
        if (currentLimit == com.phidgets.Constants.PUNI_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
        _phidgetSocket.setKey(makeKey("CurrentLimit"), Std.string(val), true);
        return val;
    }
}

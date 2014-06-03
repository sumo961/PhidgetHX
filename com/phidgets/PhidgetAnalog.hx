package com.phidgets;

import com.phidgets.PhidgetError;

import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetAnalog
		A class for controlling a PhidgetAnalog.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetAnalog extends Phidget
{
    public var OutputCount(get, never) : Int;

    private var numOutputs : Int;
    private var voltageMin : Float;
    private var voltageMax : Float;
    private var voltage : Array<Dynamic>;
    private var enabled : Array<Dynamic>;
    
    public function new()
    {
        super("PhidgetAnalog");
    }
    
    override private function initVars() : Void{
        numOutputs = com.phidgets.Constants.PUNK_INT;
        voltageMin = com.phidgets.Constants.PUNI_NUM;
        voltageMax = com.phidgets.Constants.PUNI_NUM;
        voltage = new Array<Dynamic>(64);
        enabled = new Array<Dynamic>(64);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfOutputs":
                numOutputs = Std.parseInt(value);
                keyCount++;
            case "VoltageMin":
                if (voltageMin == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                voltageMin = Std.parseFloat(value);
            case "VoltageMax":
                if (voltageMax == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                voltageMax = Std.parseFloat(value);
            case "Voltage":
                if (voltage[index] == null) 
                    keyCount++;
                voltage[index] = value;
            case "Enabled":
                if (enabled[index] == null) 
                    keyCount++;
                enabled[index] = value;
        }
    }
    
    //Getters
    /*
			Property: OutputCount
			Gets the number of outputs supported by this PhidgetAnalog
		*/
    private function get_OutputCount() : Int{
        if (numOutputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numOutputs;
    }
    /*
			Dynamic: getVoltageMin
			Gets the minimum settable voltage for an output.
			
			Parameters:
				index - output index
		*/
    public function getVoltageMin(index : Int) : Float{
        if (voltageMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return voltageMin;
    }
    /*
			Dynamic: getVoltageMax
			Gets the maximum settable voltage for an output.
			
			Parameters:
				index - output index
		*/
    public function getVoltageMax(index : Int) : Float{
        if (voltageMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return voltageMax;
    }
    /*
			Dynamic: getEnabled
			Gets the enabled state of an output.
			
			Parameters:
				index - output index
		*/
    public function getEnabled(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(enabled, index, numOutputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getVoltage
			Gets the voltage of an output.
			
			Parameters:
				index - output index
		*/
    public function getVoltage(index : Int) : Float{
        return Std.parseFloat(indexArray(voltage, index, numOutputs, com.phidgets.Constants.PUNK_NUM));
    }
    
    //Setters
    /*
			Dynamic: setVoltage
			Sets the voltage for an output.
			
			Parameters:
				index - output index
				val - voltage
		*/
    public function setVoltage(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Voltage", index, numOutputs), Std.string(val), true);
    }
    /*
			Dynamic: setEnabled
			Enables/Disables an output.
			
			Parameters:
				index - otuput index
				val - state
		*/
    public function setEnabled(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Enabled", index, numOutputs), Std.string(boolToInt(val)), true);
    }
}

package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetInterfaceKit
		A class for controlling a PhidgetInterfaceKit.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetInterfaceKit. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE	- digital input change
		PhidgetDataEvent.OUTPUT_CHANGE	- output change
		PhidgetDataEvent.SENSOR_CHANGE	- sensor change
	*/
class PhidgetInterfaceKit extends Phidget
{
    public var InputCount(get, never) : Int;
    public var OutputCount(get, never) : Int;
    public var SensorCount(get, never) : Int;
    public var Ratiometric(get, set) : Bool;

    private var numSensors : Int;
    private var numInputs : Int;
    private var numOutputs : Int;
    
    private var inputs : Array<Dynamic>;
    private var outputs : Array<Dynamic>;
    private var sensors : Array<Dynamic>;
    private var sensorsRaw : Array<Dynamic>;
    private var dataRate : Array<Dynamic>;
    
    private var sensorTriggers : Array<Dynamic>;
    
    private var ratiometric : Int;
    private var dataRateMin : Int;
    private var dataRateMax : Int;
    
    public function new()
    {
        super("PhidgetInterfaceKit");
    }
    
    override private function initVars() : Void{
        numSensors = com.phidgets.Constants.PUNK_INT;
        numInputs = com.phidgets.Constants.PUNK_INT;
        numOutputs = com.phidgets.Constants.PUNK_INT;
        inputs = new Array<Dynamic>(32);
        outputs = new Array<Dynamic>(32);
        sensors = new Array<Dynamic>(8);
        sensorsRaw = new Array<Dynamic>(8);
        sensorTriggers = new Array<Dynamic>(8);
        dataRate = new Array<Dynamic>(8);
        ratiometric = com.phidgets.Constants.PUNK_BOOL;
        dataRateMin = com.phidgets.Constants.PUNK_INT;
        dataRateMax = com.phidgets.Constants.PUNK_INT;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfSensors":
                numSensors = Std.parseInt(value);
                keyCount++;
            case "NumberOfInputs":
                numInputs = Std.parseInt(value);
                keyCount++;
            case "NumberOfOutputs":
                numOutputs = Std.parseInt(value);
                keyCount++;
            case "Input":
                if (inputs[index] == null)                     keyCount++;
                inputs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[index]), index));
            case "Output":
                if (outputs[index] == null)                     keyCount++;
                outputs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE, this, intToBool(outputs[index]), index));
            case "Sensor":
                if (sensors[index] == null)                     keyCount++;
                sensors[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SENSOR_CHANGE, this, Std.parseInt(sensors[index]), index));
            case "RawSensor":
                if (sensorsRaw[index] == null)                     keyCount++;
                sensorsRaw[index] = value;
            case "Trigger":
                if (sensorTriggers[index] == null)                     keyCount++;
                sensorTriggers[index] = value;
            case "Ratiometric":
                if (ratiometric == com.phidgets.Constants.PUNK_BOOL)                     keyCount++;
                ratiometric = Std.parseInt(value);
            case "DataRate":
                if (dataRate[index] == null)                     keyCount++;
                dataRate[index] = value;
            case "DataRateMin":
                dataRateMin = Std.parseInt(value);
                keyCount++;
            case "DataRateMax":
                dataRateMax = Std.parseInt(value);
                keyCount++;
            case "InterruptRate":
            //Don't care about this, but we still need to update keyCount
            keyCount++;
        }
    }
    override private function eventsAfterOpen() : Void
    {
        var i : Int = 0;
        for (i in 0...numSensors){
            if (isKnown(sensors, i, com.phidgets.Constants.PUNK_INT)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SENSOR_CHANGE, this, Std.parseInt(sensors[i]), i));
        }
        for (i in 0...numInputs){
            if (isKnown(inputs, i, com.phidgets.Constants.PUNK_BOOL)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[i]), i));
        }
        for (i in 0...numOutputs){
            if (isKnown(outputs, i, com.phidgets.Constants.PUNK_BOOL)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE, this, intToBool(outputs[i]), i));
        }
    }
    
    //Getters
    /*
			Property: InputCount
			Gets the number of digital inputs supported by this board.
		*/
    private function get_InputCount() : Int{
        if (numInputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numInputs;
    }
    /*
			Property: OutputCount
			Gets the number of digital outputs supported by this board.
		*/
    private function get_OutputCount() : Int{
        if (numOutputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numOutputs;
    }
    /*
			Property: SensorCount
			Gets the number of sensors (analog inputs) supported by this board
		*/
    private function get_SensorCount() : Int{
        if (numSensors == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numSensors;
    }
    /*
			Property: Ratiometric
			Gets the ratiometric state for the board.
			Note that not all Interface Kits support Ratiometric.
		*/
    private function get_Ratiometric() : Bool{
        if (ratiometric == com.phidgets.Constants.PUNK_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return intToBool(ratiometric);
    }
    /*
			Dynamic: getInputState
			Gets the state of a digital input.
			
			Parameters:
				index - digital input index
		*/
    public function getInputState(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(inputs, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getOutputState
			Gets the state of a digital output.
			
			Parameters:
				index - digital output index
		*/
    public function getOutputState(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(outputs, index, numOutputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getSensorValue
			Gets the value of a sensor (0-1000).
			
			Parameters:
				index - sensor index
		*/
    public function getSensorValue(index : Int) : Int{
        return Std.parseInt(indexArray(sensors, index, numSensors, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getSensorRawValue
			Gets the raw 12-bit value of a sensor (0-4095).
			
			Parameters:
				index - sensor index
		*/
    public function getSensorRawValue(index : Int) : Int{
        return Std.parseInt(indexArray(sensorsRaw, index, numSensors, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getSensorChangeTrigger
			Gets the change trigger for a sensor.
			
			Parameters:
				index - sensor index
		*/
    public function getSensorChangeTrigger(index : Int) : Int{
        return Std.parseInt(indexArray(sensorTriggers, index, numSensors, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getDataRate
			Gets the data rate for a sensor, in milliseconds.
			
			Parameters:
				index - sensor index
		*/
    public function getDataRate(index : Int) : Int{
        return Std.parseInt(indexArray(dataRate, index, numSensors, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Property: DataRateMin
			Gets the minimum data rate for a sensor, in milliseconds.
			
			Parameters:
				index - sensor index
		*/
    public function getDataRateMin(index : Int) : Int{
        if (dataRateMin == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRateMin;
    }
    /*
			Property: DataRateMax
			Gets the maximum data rate for a sensor, in milliseconds.
			
			Parameters:
				index - sensor index
		*/
    public function getDataRateMax(index : Int) : Int{
        if (dataRateMax == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRateMax;
    }
    
    //Setters
    /*
			Dynamic: setOutputState
			Sets the state of a digital output.
			
			parameters:
				index - digital output index
				val - output state
		*/
    public function setOutputState(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Output", index, numOutputs), Std.string(boolToInt(val)), true);
    }
    /*
			Dynamic: setSensorChangeTrigger
			Sets the change trigger for a sensor.
			
			Parameters:
				index - sensor index
				val - change trigger
		*/
    public function setSensorChangeTrigger(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Trigger", index, numSensors), Std.string(val), true);
    }
    /*
			Property: Ratiometric
			Sets the ratiometric state for a board.
			Note that not all Interface Kits support ratiometric.
			
			Parameters:
				val - ratiometric state
		*/
    private function set_Ratiometric(val : Bool) : Bool{
        _phidgetSocket.setKey(makeKey("Ratiometric"), Std.string(boolToInt(val)), true);
        return val;
    }
    /*
			Dynamic: setDataRate
			Sets the data rate for a sensor, in milliseconds.
			
			Parameters:
				index - sensor index
				val - data rate
		*/
    public function setDataRate(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("DataRate", index, numSensors), Std.string(val), true);
    }
}

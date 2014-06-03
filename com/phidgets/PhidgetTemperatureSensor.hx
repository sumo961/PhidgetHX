package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetTemperatureSensor
		A class for controlling a PhidgetTemperatureSensor.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetTemperatureSensor. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.TEMPERATURE_CHANGE	- temperature change
	*/
class PhidgetTemperatureSensor extends Phidget
{
    public var TemperatureInputCount(get, never) : Int;
    public var AmbientTemperature(get, never) : Float;
    public var AmbientTemperatureMin(get, never) : Float;
    public var AmbientTemperatureMax(get, never) : Float;

    private var numSensors : Int;
    private var potentialMin : Float;
    private var potentialMax : Float;
    private var ambientTemperatureMin : Float;
    private var ambientTemperatureMax : Float;
    private var temperatureMins : Array<Dynamic>;
    private var temperatureMaxs : Array<Dynamic>;
    
    private var ambientTemperature : Float;
    private var thermocoupleTypes : Array<Dynamic>;
    private var temperatures : Array<Dynamic>;
    private var potentials : Array<Dynamic>;
    private var temperatureTriggers : Array<Dynamic>;
    
    /*
			Constants: Thermocouple Types
			These are the type of thermocouples supported by the PhidgetTemperatureSensor. These constants are used with <getThermocoupleType> and <setThermocoupleType>.
			
			PHIDGET_TEMPERATURE_SENSOR_K_TYPE - K-Type thermocouple.
			PHIDGET_TEMPERATURE_SENSOR_J_TYPE - J-Type thermocouple.
			PHIDGET_TEMPERATURE_SENSOR_E_TYPE - E-Type thermocouple.
			PHIDGET_TEMPERATURE_SENSOR_T_TYPE - T-Type thermocouple.
		*/
    public static inline var PHIDGET_TEMPERATURE_SENSOR_K_TYPE : Int = 1;
    public static inline var PHIDGET_TEMPERATURE_SENSOR_J_TYPE : Int = 2;
    public static inline var PHIDGET_TEMPERATURE_SENSOR_E_TYPE : Int = 3;
    public static inline var PHIDGET_TEMPERATURE_SENSOR_T_TYPE : Int = 4;
    
    public function new()
    {
        super("PhidgetTemperatureSensor");
    }
    
    override private function initVars() : Void{
        numSensors = com.phidgets.Constants.PUNK_INT;
        potentialMin = com.phidgets.Constants.PUNK_NUM;
        potentialMax = com.phidgets.Constants.PUNK_NUM;
        ambientTemperatureMin = com.phidgets.Constants.PUNK_NUM;
        ambientTemperatureMax = com.phidgets.Constants.PUNK_NUM;
        temperatureMins = new Array<Dynamic>(8);
        temperatureMaxs = new Array<Dynamic>(8);
        
        ambientTemperature = com.phidgets.Constants.PUNI_NUM;
        temperatures = new Array<Dynamic>(8);
        potentials = new Array<Dynamic>(8);
        temperatureTriggers = new Array<Dynamic>(8);
        thermocoupleTypes = new Array<Dynamic>(8);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfSensors":
                numSensors = Std.parseInt(value);
                keyCount++;
            case "ThermocoupleType":
                if (thermocoupleTypes[index] == null) 
                    keyCount++;
                thermocoupleTypes[index] = value;
            case "AmbientTemperature":
                if (ambientTemperature == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                ambientTemperature = Std.parseFloat(value);
            case "AmbientTemperatureMin":
                ambientTemperatureMin = Std.parseFloat(value);
                keyCount++;
            case "AmbientTemperatureMax":
                ambientTemperatureMax = Std.parseFloat(value);
                keyCount++;
            case "Temperature":
                if (temperatures[index] == null) 
                    keyCount++;
                temperatures[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.TEMPERATURE_CHANGE, this, Std.parseFloat(temperatures[index]), index));
            case "TemperatureMin":
                if (temperatureMins[index] == null) 
                    keyCount++;
                temperatureMins[index] = value;
            case "TemperatureMax":
                if (temperatureMaxs[index] == null) 
                    keyCount++;
                temperatureMaxs[index] = value;
            case "Potential":
                if (potentials[index] == null) 
                    keyCount++;
                potentials[index] = value;
            case "PotentialMin":
                potentialMin = Std.parseFloat(value);
                keyCount++;
            case "PotentialMax":
                potentialMax = Std.parseFloat(value);
                keyCount++;
            case "Trigger":
                if (temperatureTriggers[index] == null) 
                    keyCount++;
                temperatureTriggers[index] = value;
        }
    }
    override private function eventsAfterOpen() : Void
    {
        for (i in 0...numSensors){
            if (isKnown(temperatures, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.TEMPERATURE_CHANGE, this, Std.parseFloat(temperatures[i]), i));
        }
    }
    
    //Getters
    /*
			Property: TemperatureInputCount
			Gets the number of thermocouple inputs supported by this sensor.
		*/
    private function get_TemperatureInputCount() : Int{
        if (numSensors == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numSensors;
    }
    /*
			Property: AmbientTemperature
			Gets the ambient (board) temperature.
		*/
    private function get_AmbientTemperature() : Float{
        if (ambientTemperature == com.phidgets.Constants.PUNK_NUM || ambientTemperature == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return ambientTemperature;
    }
    /*
			Property: AmbientTemperatureMin
			Gets the minimum temperature that the ambient sensor can measure.
		*/
    private function get_AmbientTemperatureMin() : Float{
        if (ambientTemperatureMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return ambientTemperatureMin;
    }
    /*
			Property: AmbientTemperatureMax
			Gets the maximum temperature that the ambient sensor can measure.
		*/
    private function get_AmbientTemperatureMax() : Float{
        if (ambientTemperatureMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return ambientTemperatureMax;
    }
    /*
			Dynamic: getThermocoupleType
			Gets the type of thermocouple expected at a thermocouple input.
			
			Parameters:
				index - thermocouple input.
		*/
    public function getThermocoupleType(index : Int) : Int{
        return Std.parseInt(indexArray(thermocoupleTypes, index, numSensors, -1));
    }
    /*
			Dynamic: getTemperature
			Gets the temperature at a thermocouple input.
			
			Parameters:
				index - thermocouple input.
		*/
    public function getTemperature(index : Int) : Float{
        return Std.parseFloat(indexArray(temperatures, index, numSensors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getTemperatureMin
			Gets the minimum temperature that a thermocouple input can measure.
			
			Parameters:
				index - thermocouple input
		*/
    public function getTemperatureMin(index : Int) : Float{
        return Std.parseFloat(indexArray(temperatureMins, index, numSensors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getTemperatureMax
			Gets the maximum temperature that a thermocouple input can measure.
		
			Parameters:
				index - thermocouple input
		*/
    public function getTemperatureMax(index : Int) : Float{
        return Std.parseFloat(indexArray(temperatureMaxs, index, numSensors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getPotential
			Gets the potential (mV) that a thermocouple input is measuring.
			
			Parameters:
				index - thermocouple input
		*/
    public function getPotential(index : Int) : Float{
        return Std.parseFloat(indexArray(potentials, index, numSensors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getPotentialMin
			Gets the minimum potential that a thermocouple input can measure.
			
			Parameters:
				index - thermocouple input
		*/
    public function getPotentialMin(index : Int) : Float{
        if (potentialMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return potentialMin;
    }
    /*
			Dynamic: getPotentialMax
			Gets the maximum potential that a thermocouple input can measure.
			
			Parameters:
				index - thermocouple input
		*/
    public function getPotentialMax(index : Int) : Float{
        if (potentialMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return potentialMax;
    }
    /*
			Dynamic: getTemperatureChangeTrigger
			Gets the change trigger for a thermocouple input.
			
			Parameters:
				index - thermocouple index
		*/
    public function getTemperatureChangeTrigger(index : Int) : Float{
        return Std.parseFloat(indexArray(temperatureTriggers, index, numSensors, com.phidgets.Constants.PUNK_NUM));
    }
    
    //Setters
    /*
			Dynamic: setTemperatureChangeTrigger
			Sets the change trigger for a thermocouple input.
			
			Parameters:
				index - thermocouple input
				val - change trigger
		*/
    public function setTemperatureChangeTrigger(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Trigger", index, numSensors), Std.string(val), true);
    }
    /*
			Dynamic: setThermocoupleType
			Sets the type of thermocouple attached to a thermocouple input. Default is K-Type.
			
			Parameters:
				index - thermocouple index
				val - thermocouple type
		*/
    public function setThermocoupleType(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("ThermocoupleType", index, numSensors), Std.string(val), true);
    }
}

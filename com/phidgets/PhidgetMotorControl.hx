package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetMotorControl
		A class for controlling a PhidgetMotorControl.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetMotorControl.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
		PhidgetDataEvent.CURRENT_UPDATE		- current updates (fixed rate)
		PhidgetDataEvent.POSITION_CHANGE	- encoder position change (Array:[timeChange, posnChange])
		PhidgetDataEvent.POSITION_UPDATE	- encoder position updates (fixed rate)
		PhidgetDataEvent.BACKEMF_UPDATE		- backemf updates (fixed rate)
		PhidgetDataEvent.SENSOR_UPDATE		- analog sensor updates (fixed rate)
	*/
class PhidgetMotorControl extends Phidget
{
    public var InputCount(get, never) : Int;
    public var MotorCount(get, never) : Int;
    public var EncoderCount(get, never) : Int;
    public var SensorCount(get, never) : Int;
    public var Ratiometric(get, set) : Bool;
    public var SupplyVoltage(get, never) : Float;

    private var numMotors : Int;
    private var numInputs : Int;
    private var numEncoders : Int;
    private var numSensors : Int;
    private var accelerationMin : Float;
    private var accelerationMax : Float;
    private var ratiometric : Int;
    private var supplyvoltage : Float;
    
    private var velocities : Array<Dynamic>;
    private var accelerations : Array<Dynamic>;
    private var currents : Array<Dynamic>;
    private var inputs : Array<Dynamic>;
    private var sensors : Array<Dynamic>;
    private var rawsensors : Array<Dynamic>;
    private var brakings : Array<Dynamic>;
    private var backemfs : Array<Dynamic>;
    private var backemfstates : Array<Dynamic>;
    private var encoderpositiondeltas : Array<Dynamic>;
    private var encoderpositions : Array<Dynamic>;
    private var encoderpositionupdates : Array<Dynamic>;
    private var encodertimestamps : Array<Dynamic>;
    
    public function new()
    {
        super("PhidgetMotorControl");
    }
    
    override private function initVars() : Void{
        numMotors = com.phidgets.Constants.PUNK_INT;
        numInputs = com.phidgets.Constants.PUNK_INT;
        accelerationMin = com.phidgets.Constants.PUNK_NUM;
        accelerationMax = com.phidgets.Constants.PUNK_NUM;
        ratiometric = com.phidgets.Constants.PUNI_BOOL;
        supplyvoltage = com.phidgets.Constants.PUNI_NUM;
        inputs = new Array<Dynamic>(4);
        velocities = new Array<Dynamic>(2);
        accelerations = new Array<Dynamic>(2);
        currents = new Array<Dynamic>(2);
        sensors = new Array<Dynamic>(2);
        rawsensors = new Array<Dynamic>(2);
        brakings = new Array<Dynamic>(2);
        backemfs = new Array<Dynamic>(2);
        backemfstates = new Array<Dynamic>(2);
        encoderpositiondeltas = [0];
        encoderpositions = [0];
        encoderpositionupdates = [0];
        encodertimestamps = [0];
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfMotors":
                numMotors = Std.parseInt(value);
                keyCount++;
            case "NumberOfInputs":
                numInputs = Std.parseInt(value);
                keyCount++;
            case "NumberOfEncoders":
                numEncoders = Std.parseInt(value);
                keyCount++;
            case "NumberOfSensors":
                numSensors = Std.parseInt(value);
                keyCount++;
            case "AccelerationMin":
                accelerationMin = Std.parseFloat(value);
                keyCount++;
            case "AccelerationMax":
                accelerationMax = Std.parseFloat(value);
                keyCount++;
            case "Input":
                if (inputs[index] == null) 
                    keyCount++;
                inputs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[index]), index));
            case "Velocity":
                if (velocities[index] == null) 
                    keyCount++;
                velocities[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE, this, Std.parseFloat(velocities[index]), index));
            case "Acceleration":
                if (accelerations[index] == null) 
                    keyCount++;
                accelerations[index] = value;
            case "Current":
                if (currents[index] == null) 
                    keyCount++;
                currents[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE, this, Std.parseFloat(currents[index]), index));
            case "CurrentUpdate":
                currents[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_UPDATE, this, Std.parseFloat(currents[index]), index));
            case "Sensor":
                if (sensors[index] == null) 
                    keyCount++;
                sensors[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SENSOR_UPDATE, this, Std.parseFloat(sensors[index]), index));
            case "RawSensor":
                if (rawsensors[index] == null) 
                    keyCount++;
                rawsensors[index] = value;
            case "Ratiometric":
                if (ratiometric == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                ratiometric = Std.parseInt(value);
            case "Braking":
                if (brakings[index] == null) 
                    keyCount++;
                brakings[index] = value;
            case "BackEMF":
                if (backemfs[index] == null) 
                    keyCount++;
                backemfs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.BACKEMF_UPDATE, this, Std.parseFloat(backemfs[index]), index));
            case "BackEMFState":
                if (backemfstates[index] == null) 
                    keyCount++;
                backemfstates[index] = value;
            case "SupplyVoltage":
                if (supplyvoltage == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                supplyvoltage = Std.parseFloat(value);
            case "ResetEncoderPosition":
                encoderpositiondeltas[index] = Std.parseInt(value);
            case "EncoderPosition":
                var posnArray : Array<Dynamic> = value.split("/");
                var time : Int = posnArray[0];
                var posn : Int = posnArray[1];
                var posnChange : Int = posn - encoderpositions[index];
                var encoderTimeChange : Int = time - encodertimestamps[index];
                
                //timeout is 20 seconds
                if (encoderTimeChange > 60000) 
                    encoderTimeChange = com.phidgets.Constants.PUNK_INT;
                
                encoderpositions[index] = posn;
                encodertimestamps[index] = time;
                
                var eventArray : Array<Dynamic> = new Array<Dynamic>(2);
                eventArray[0] = encoderTimeChange;
                eventArray[1] = posnChange;
                
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, eventArray, index));
            case "EncoderPositionUpdate":
                var posnChange2 : Int = Std.parseInt(value) - encoderpositionupdates[index];
                encoderpositionupdates[index] = Std.parseInt(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_UPDATE, this, posnChange2, index));
        }
    }
    override private function eventsAfterOpen() : Void
    {
        var i : Int = 0;
        for (i in 0...numInputs){
            if (isKnown(inputs, i, com.phidgets.Constants.PUNK_BOOL)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[i]), i));
        }
        for (i in 0...numMotors){
            if (isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE, this, Std.parseFloat(velocities[i]), i));
            if (isKnown(currents, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE, this, Std.parseFloat(currents[i]), i));
        }
    }
    
    //Getters
    /*
			Property: InputCount
			Gets the number of digital inputs supported by this controller.
		*/
    private function get_InputCount() : Int{
        if (numInputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numInputs;
    }
    /*
			Property: MotorCount
			Gets the number of motors supported by this controller.
		*/
    private function get_MotorCount() : Int{
        if (numMotors == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numMotors;
    }
    /*
			Property: EncoderCount
			Gets the number of encoders supported by this controller.
		*/
    private function get_EncoderCount() : Int{
        if (numEncoders == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numEncoders;
    }
    /*
			Property: SensorCount
			Gets the number of sensors supported by this controller.
		*/
    private function get_SensorCount() : Int{
        if (numSensors == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numSensors;
    }
    /*
			Property: Ratiometric
			Gets the ratiometric state for the board.
		*/
    private function get_Ratiometric() : Bool{
        if (ratiometric == com.phidgets.Constants.PUNK_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return intToBool(ratiometric);
    }
    /*
			Property: SupplyVoltage
			Gets the supply voltage for the board.
		*/
    private function get_SupplyVoltage() : Float{
        if (supplyvoltage == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return supplyvoltage;
    }
    /*
			Dynamic: getAccelerationMin
			Gets the minimum acceleration that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
    public function getAccelerationMin(index : Int) : Float{
        if (accelerationMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return accelerationMin;
    }
    /*
			Dynamic: getAccelerationMax
			Gets the maximum acceleration that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
    public function getAccelerationMax(index : Int) : Float{
        if (accelerationMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return accelerationMax;
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
			Dynamic: getAcceleration
			Gets the last acceleration that a motor was set at.
			
			Parameters:
				index - motor index
		*/
    public function getAcceleration(index : Int) : Float{
        return Std.parseFloat(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getVelocity
			Gets the current velocity of a motor.
			
			Parameters:
				index - motor index
		*/
    public function getVelocity(index : Int) : Float{
        return Std.parseFloat(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getCurrent
			Gets the current current draw of a motor.
			Note that not all motor controllers support current sense.
			
			Parameters:
				index - motor index
		*/
    public function getCurrent(index : Int) : Float{
        return Std.parseFloat(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getEncoderPosition
			Gets the current current draw of a motor.
			Note that not all motor controllers support current sense.
			
			Parameters:
				index - motor index
		*/
    public function getEncoderPosition(index : Int) : Float{
        var posn : Int = Std.parseInt(indexArray(encoderpositions, index, numEncoders, com.phidgets.Constants.PUNK_INT));
        var posnDelta : Int = Std.parseInt(indexArray(encoderpositiondeltas, index, numEncoders, com.phidgets.Constants.PUNK_INT));
        return (posn - posnDelta);
    }
    /*
			Dynamic: getBackEMFSensingState
			Gets the state of BackEMF sensing on a motor.
			
			Parameters:
				index - motor index
		*/
    public function getBackEMFSensingState(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(backemfstates, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getBackEMF
			Gets the current BacKEMF value for a motor.
			
			Parameters:
				index - motor index
		*/
    public function getBackEMF(index : Int) : Float{
        return Std.parseFloat(indexArray(backemfs, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getBraking
			Gets the current braking value for a motor.
			
			Parameters:
				index - motor index
		*/
    public function getBraking(index : Int) : Float{
        return Std.parseFloat(indexArray(brakings, index, numMotors, com.phidgets.Constants.PUNK_NUM));
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
        return Std.parseInt(indexArray(rawsensors, index, numSensors, com.phidgets.Constants.PUNK_INT));
    }
    
    //Setters
    /*
			Dynamic: setAcceleration
			Sets the acceleration for a motor.
			
			Parameters:
				index - motor index
				val - acceleraion
		*/
    public function setAcceleration(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setVelocity
			Sets the velocity for a motor.
			
			Parameters:
				index - motor index
				val - velocity
		*/
    public function setVelocity(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Velocity", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setBackEMFSensingState
			Enables/Disables BackEMF sensing on a motor.
			
			Parameters:
				index - motor index
				val - state
		*/
    public function setBackEMFSensingState(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("BackEMFState", index, numMotors), Std.string(boolToInt(val)), true);
    }
    /*
			Dynamic: setBraking
			Sets the braking for a motor - enabled at velocity 0.
			
			Parameters:
				index - motor index
				val - braking ammount (0-100%)
		*/
    public function setBraking(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Braking", index, numMotors), Std.string(val), true);
    }
    //Setters
    /*
			Dynamic: setEncoderPosition
			Sets/Resets the position of an encoder.
			
			Parameters:
				index - encoder index
				val - position
		*/
    public function setEncoderPosition(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("ResetEncoderPosition", index, numEncoders), Std.string(val), true);
    }
    /*
			Property: Ratiometric
			Sets the ratiometric state for a board.
			
			Parameters:
				val - ratiometric state
		*/
    private function set_Ratiometric(val : Bool) : Bool{
        _phidgetSocket.setKey(makeKey("Ratiometric"), Std.string(boolToInt(val)), true);
        return val;
    }
}

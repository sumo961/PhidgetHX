package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetStepper
		A class for controlling a PhidgetStepper.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetStepper.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.POSITION_CHANGE	- position change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
	*/
class PhidgetStepper extends Phidget
{
    public var InputCount(get, never) : Int;
    public var MotorCount(get, never) : Int;

    private var numMotors : Int;
    private var numInputs : Int;
    private var positionMin : Float;
    private var positionMax : Float;
    private var accelerationMin : Float;
    private var accelerationMax : Float;
    private var velocityMin : Float;
    private var velocityMax : Float;
    private var currentMin : Float;
    private var currentMax : Float;
    
    private var velocities : Array<Dynamic>;
    private var velocityLimits : Array<Dynamic>;
    private var accelerations : Array<Dynamic>;
    private var currents : Array<Dynamic>;
    private var currentLimits : Array<Dynamic>;
    private var currentPositions : Array<Dynamic>;
    private var targetPositions : Array<Dynamic>;
    private var inputs : Array<Dynamic>;
    private var motorEngagedState : Array<Dynamic>;
    private var motorStoppedState : Array<Dynamic>;
    
    public function new()
    {
        super("PhidgetStepper");
    }
    
    override private function initVars() : Void{
        numMotors = com.phidgets.Constants.PUNK_INT;
        numInputs = com.phidgets.Constants.PUNK_INT;
        positionMin = com.phidgets.Constants.PUNK_NUM;
        positionMax = com.phidgets.Constants.PUNK_NUM;
        accelerationMin = com.phidgets.Constants.PUNK_NUM;
        accelerationMax = com.phidgets.Constants.PUNK_NUM;
        velocityMin = com.phidgets.Constants.PUNK_NUM;
        velocityMax = com.phidgets.Constants.PUNK_NUM;
        currentMin = com.phidgets.Constants.PUNK_NUM;
        currentMax = com.phidgets.Constants.PUNK_NUM;
        velocities = new Array<Dynamic>(8);
        velocityLimits = new Array<Dynamic>(8);
        accelerations = new Array<Dynamic>(8);
        currents = new Array<Dynamic>(8);
        currentLimits = new Array<Dynamic>(8);
        currentPositions = new Array<Dynamic>(8);
        targetPositions = new Array<Dynamic>(8);
        inputs = new Array<Dynamic>(8);
        motorEngagedState = new Array<Dynamic>(8);
        motorStoppedState = new Array<Dynamic>(8);
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
            case "AccelerationMin":
                accelerationMin = Std.parseFloat(value);
                keyCount++;
            case "AccelerationMax":
                accelerationMax = Std.parseFloat(value);
                keyCount++;
            case "PositionMin":
                positionMin = Std.parseFloat(value);
                keyCount++;
            case "PositionMax":
                positionMax = Std.parseFloat(value);
                keyCount++;
            case "VelocityMin":
                velocityMin = Std.parseFloat(value);
                keyCount++;
            case "VelocityMax":
                velocityMax = Std.parseFloat(value);
                keyCount++;
            case "CurrentMin":
                currentMin = Std.parseFloat(value);
                keyCount++;
            case "CurrentMax":
                currentMax = Std.parseFloat(value);
                keyCount++;
            case "Input":
                if (inputs[index] == null) 
                    keyCount++;
                inputs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[index]), index));
            case "CurrentPosition":
                if (currentPositions[index] == null) 
                    keyCount++;
                currentPositions[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, Std.parseFloat(currentPositions[index]), index));
            case "TargetPosition":
                if (targetPositions[index] == null) 
                    keyCount++;
                targetPositions[index] = value;
            case "Acceleration":
                accelerations[index] = value;
            case "CurrentLimit":
                currentLimits[index] = value;
            case "Current":
                if (currents[index] == null) 
                    keyCount++;
                currents[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE, this, Std.parseFloat(currents[index]), index));
            case "VelocityLimit":
                velocityLimits[index] = value;
            case "Velocity":
                if (velocities[index] == null) 
                    keyCount++;
                velocities[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE, this, Std.parseFloat(velocities[index]), index));
            case "Engaged":
                if (motorEngagedState[index] == null) 
                    keyCount++;
                motorEngagedState[index] = value;
            case "Stopped":
                if (motorStoppedState[index] == null) 
                    keyCount++;
                motorStoppedState[index] = value;
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
            if (isKnown(currentPositions, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, Std.parseFloat(currentPositions[i]), i));
            if (isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE, this, Std.parseFloat(velocities[i]), i));
            if (isKnown(currents, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE, this, Std.parseFloat(currents[i]), i));
        }
    }
    
    //Getters
    /*
			Property: InputCount
			Gets the number of digital inputs available on this controller.
			
			Returns:
				The number of digital inputs.
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
			Dynamic: getAccelerationMin
			Gets the minimum settable acceleration for a motor.
			
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
			Gets the maximum settable acceleration for a motor
			
			Parameters:
				index - motor index
		*/
    public function getAccelerationMax(index : Int) : Float{
        if (accelerationMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return accelerationMax;
    }
    /*
			Dynamic: getPositionMin
			Gets the minimum position that a motor can travel to.
			
			Parameters:
				index - motor index
		*/
    public function getPositionMin(index : Int) : Float{
        if (positionMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return positionMin;
    }
    /*
			Dynamic: getPositionMax
			Gets the maximum position that a motor can travel to.
			
			Parameters:
				index - motor index
		*/
    public function getPositionMax(index : Int) : Float{
        if (positionMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return positionMax;
    }
    /*
			Dynamic: getVelocityMin
			Gets the minimum velocity that a motor can be set to.
			Note that the minimum velocity that a motor can return is -(velocityMax)
			
			Parameters:
				index - motor index
		*/
    public function getVelocityMin(index : Int) : Float{
        if (velocityMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return velocityMin;
    }
    /*
			Dynamic: getVelocityMax
			Gets the maximum velocity that a motor can be set to or return.
			
			Parameters:
				index - motor index
		*/
    public function getVelocityMax(index : Int) : Float{
        if (velocityMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return velocityMax;
    }
    /*
			Dynamic: getCurrentMin
			Gets the minimum settable current limit for a motor.
			Note that current limit is not supported on all stepper controllers.
			
			Parameters:
				index - motor index
		*/
    public function getCurrentMin(index : Int) : Float{
        if (velocityMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return currentMin;
    }
    /*
			Dynamic: getCurrentMax
			Gets the maximum settable current limit for a motor.
			Note that current limit is not supported on all stepper controllers.
			
			Parameters:
				index - motor index
		*/
    public function getCurrentMax(index : Int) : Float{
        if (velocityMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return currentMax;
    }
    /*
			Dynamic: getInputState
			Gets the state of a digital input.
			Note that not all stepper controllers have digital inputs.
			
			Parameters:
				index - input index
		*/
    public function getInputState(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(inputs, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getAcceleration
			Gets the last set acceleration for a motor.
			
			Parameters:
				index - motor index
		*/
    public function getAcceleration(index : Int) : Float{
        return Std.parseFloat(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getVelocity
			Gets the current velocity for a motor.
			
			Parameters:
				index - motor index
		*/
    public function getVelocity(index : Int) : Float{
        return Std.parseFloat(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getVelocityLimit
			Gets the last set velocity limit for a motor.
			
			Parameters:
				index - motor index
		*/
    public function getVelocityLimit(index : Int) : Float{
        return Std.parseFloat(indexArray(velocityLimits, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getCurrentLimit
			Gets the last set current limit for a motor.
			Note that current limit is not supported by all stepper controllers.
			
			Parameters:
				index - motor index
		*/
    public function getCurrentLimit(index : Int) : Float{
        return Std.parseFloat(indexArray(currentLimits, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getCurrent
			Gets the current current draw for a motor.
			Note that current sense is not supported by all stepper controllers.
			
			Parameters:
				index - motor index
		*/
    public function getCurrent(index : Int) : Float{
        return Std.parseFloat(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getCurrentPosition
			Gets the current position of a motor.
			
			Parameters:
				index - motor index
		*/
    public function getCurrentPosition(index : Int) : Float{
        return Std.parseFloat(indexArray(currentPositions, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getTargetPosition
			Gets the last set target position.
			
			Parameters:
				index - motor index
		*/
    public function getTargetPosition(index : Int) : Float{
        return Std.parseFloat(indexArray(targetPositions, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getEngaged
			Gets the engaged state of a motor. This is whether or not the motor is powered.
			
			Parameters:
				index - motor index
		*/
    public function getEngaged(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(motorEngagedState, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getStopped
			Gets the stopped state of a motor. If this is true, it indicates that the motor is not moving, and there are no outstanding commands.
			
			Parameters:
				index - motor index
		*/
    public function getStopped(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(motorStoppedState, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
    }
    
    //Setters
    /*
			Dynamic: setAcceleration
			Sets the acceleration for a motor. The motor will accelerate and decelerate at this rate.
			
			Parameters:
				index - motor index
				val - acceleration
		*/
    public function setAcceleration(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setVelocityLimit
			Sets the upper velocity limit for a motor.
			
			Parameters:
				index - motor index
				val - velocity
		*/
    public function setVelocityLimit(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("VelocityLimit", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setCurrentPosition
			Sets the current position of a motor. This will not move the motor and should not be called if a motor is moving.
			
			Parameters:
				index - motor index
				val - current motor position
		*/
    public function setCurrentPosition(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("CurrentPosition", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setTargetPosition
			Sets a new target position for a motor. The motor will immediately start moving towards this position.
			
			Parameters:
				index - motor index
				val - target motor position
		*/
    public function setTargetPosition(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("TargetPosition", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setCurrentLimit
			Sets the upper current limit for a motor.
			Note that not all stepper controllers support current limit.
			
			Parameters:
				index - motor index
				val - current limit
		*/
    public function setCurrentLimit(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("CurrentLimit", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setEngaged
			Sets the engaged state of a motor. This determines whether a motor is powered or not.
			
			Parameters:
				index - motor index
				val - engaged state
		*/
    public function setEngaged(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Engaged", index, numMotors), Std.string(boolToInt(val)), true);
    }
}

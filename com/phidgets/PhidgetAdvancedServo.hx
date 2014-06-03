package com.phidgets;

import com.phidgets.PhidgetError;
import com.phidgets.PhidgetServoParameters;

import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetAdvancedServo
		A class for controlling a PhidgetAdvancedServo.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetAdvancedServo.	Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.VELOCITY_CHANGE	- velocity change
		PhidgetDataEvent.POSITION_CHANGE	- position change
		PhidgetDataEvent.CURRENT_CHANGE		- current change
	*/
class PhidgetAdvancedServo extends Phidget
{
    public var MotorCount(get, never) : Int;

    private var numMotors : Int;
    private var accelerationMin : Float;
    private var accelerationMax : Float;
    private var velocityMin : Float;
    private var velocityMaxLimit : Float;
    private var positionMinLimit : Float;
    private var positionMaxLimit : Float;
    
    private var velocities : Array<Dynamic>;
    private var velocityMax : Array<Dynamic>;
    private var maxVelocities : Array<Dynamic>;
    private var accelerations : Array<Dynamic>;
    private var currents : Array<Dynamic>;
    private var motorEngagedState : Array<Dynamic>;
    private var speedRampingState : Array<Dynamic>;
    private var positions : Array<Dynamic>;
    private var positionMin : Array<Dynamic>;
    private var positionMax : Array<Dynamic>;
    private var stopped : Array<Dynamic>;
    private var servoParameters : Array<Dynamic>;
    
    /*
			Constants: Servo Types
			These are the some predefined servo motors. Setting one of these will set degree-PCM ratio, min and max angle, and max velocity.
			Custom servo parameters can be set with the setServoParameters function.
			
			PHIDGET_SERVO_DEFAULT - Default - This is what the servo API been historically used, originally based on the Futaba FP-S148
			PHIDGET_SERVO_RAW_us_MODE - Raw us mode - all position, velocity, acceleration functions are specified in microseconds rather then degrees
			PHIDGET_SERVO_HITEC_HS322HD - HiTec HS-322HD Standard Servo
			PHIDGET_SERVO_HITEC_HS5245MG - HiTec HS-5245MG Digital Mini Servo
			PHIDGET_SERVO_HITEC_805BB - HiTec HS-805BB Mega Quarter Scale Servo
			PHIDGET_SERVO_HITEC_HS422 - HiTec HS-422 Standard Servo
			PHIDGET_SERVO_TOWERPRO_MG90 - Tower Pro MG90 Micro Servo
			PHIDGET_SERVO_HITEC_HSR1425CR - HiTec HSR-1425CR Continuous Rotation Servo
			PHIDGET_SERVO_HITEC_HS785HB - HiTec HS-785HB Sail Winch Servo
			PHIDGET_SERVO_HITEC_HS485HB - HiTec HS-485HB Deluxe Servo
			PHIDGET_SERVO_HITEC_HS645MG - HiTec HS-645MG Ultra Torque Servo
			PHIDGET_SERVO_HITEC_815BB - HiTec HS-815BB Mega Sail Servo
			PHIDGET_SERVO_FIRGELLI_L12_30_50_06_R - Firgelli L12 Linear Actuator 30mm 50:1
			PHIDGET_SERVO_FIRGELLI_L12_50_100_06_R - Firgelli L12 Linear Actuator 50mm 100:1
			PHIDGET_SERVO_FIRGELLI_L12_50_210_06_R - Firgelli L12 Linear Actuator 50mm 210:1
			PHIDGET_SERVO_FIRGELLI_L12_100_50_06_R - Firgelli L12 Linear Actuator 100mm 50:1
			PHIDGET_SERVO_FIRGELLI_L12_100_100_06_R - Firgelli L12 Linear Actuator 100mm 100:1
			PHIDGET_SERVO_SPRINGRC_SM_S2313M - SpringRC SM-S2313M Micro Servo
			PHIDGET_SERVO_SPRINGRC_SM_S3317M - SpringRC SM-S3317M Small Servo
			PHIDGET_SERVO_SPRINGRC_SM_S3317SR - SpringRC SM-S3317SR Small Continuous Rotation Servo
			PHIDGET_SERVO_SPRINGRC_SM_S4303R - SpringRC SM-S4303R Standard Continuous Rotation Servo
			PHIDGET_SERVO_SPRINGRC_SM_S4315M - SpringRC SM-S4315M High Torque Servo
			PHIDGET_SERVO_SPRINGRC_SM_S4315R - SpringRC SM-S4315R High Torque Continuous Rotation Servo
			PHIDGET_SERVO_SPRINGRC_SM_S4505B - SpringRC SM-S4505B Standard Servo
			PHIDGET_SERVO_USER_DEFINED - User defined servo parameters
			
		*/
    public static inline var PHIDGET_SERVO_DEFAULT : Int = 1;
    public static inline var PHIDGET_SERVO_RAW_us_MODE : Int = 2;
    public static inline var PHIDGET_SERVO_HITEC_HS322HD : Int = 3;
    public static inline var PHIDGET_SERVO_HITEC_HS5245MG : Int = 4;
    public static inline var PHIDGET_SERVO_HITEC_805BB : Int = 5;
    public static inline var PHIDGET_SERVO_HITEC_HS422 : Int = 6;
    public static inline var PHIDGET_SERVO_TOWERPRO_MG90 : Int = 7;
    public static inline var PHIDGET_SERVO_HITEC_HSR1425CR : Int = 8;
    public static inline var PHIDGET_SERVO_HITEC_HS785HB : Int = 9;
    public static inline var PHIDGET_SERVO_HITEC_HS485HB : Int = 10;
    public static inline var PHIDGET_SERVO_HITEC_HS645MG : Int = 11;
    public static inline var PHIDGET_SERVO_HITEC_815BB : Int = 12;
    public static inline var PHIDGET_SERVO_FIRGELLI_L12_30_50_06_R : Int = 13;
    public static inline var PHIDGET_SERVO_FIRGELLI_L12_50_100_06_R : Int = 14;
    public static inline var PHIDGET_SERVO_FIRGELLI_L12_50_210_06_R : Int = 15;
    public static inline var PHIDGET_SERVO_FIRGELLI_L12_100_50_06_R : Int = 16;
    public static inline var PHIDGET_SERVO_FIRGELLI_L12_100_100_06_R : Int = 17;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S2313M : Int = 18;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S3317M : Int = 19;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S3317SR : Int = 20;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S4303R : Int = 21;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S4315M : Int = 22;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S4315R : Int = 23;
    public static inline var PHIDGET_SERVO_SPRINGRC_SM_S4505B : Int = 24;
    public static inline var PHIDGET_SERVO_USER_DEFINED : Int = 25;
    
    
    public function new()
    {
        super("PhidgetAdvancedServo");
    }
    
    override private function initVars() : Void{
        numMotors = com.phidgets.Constants.PUNK_INT;
        positionMinLimit = com.phidgets.Constants.PUNK_NUM;
        positionMaxLimit = com.phidgets.Constants.PUNK_NUM;
        accelerationMin = com.phidgets.Constants.PUNK_NUM;
        accelerationMax = com.phidgets.Constants.PUNK_NUM;
        velocityMin = com.phidgets.Constants.PUNK_NUM;
        velocityMaxLimit = com.phidgets.Constants.PUNK_NUM;
        velocities = new Array<Dynamic>(8);
        accelerations = new Array<Dynamic>(8);
        currents = new Array<Dynamic>(8);
        velocityMax = new Array<Dynamic>(8);
        maxVelocities = new Array<Dynamic>(8);
        motorEngagedState = new Array<Dynamic>(8);
        speedRampingState = new Array<Dynamic>(8);
        positions = new Array<Dynamic>(8);
        positionMin = new Array<Dynamic>(8);
        positionMax = new Array<Dynamic>(8);
        stopped = new Array<Dynamic>(8);
        servoParameters = new Array<Dynamic>(8);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfMotors":
                numMotors = Std.parseInt(value);
                keyCount++;
            case "AccelerationMin":
                accelerationMin = Std.parseFloat(value);
                keyCount++;
            case "AccelerationMax":
                accelerationMax = Std.parseFloat(value);
                keyCount++;
            case "PositionMin":
                if (positionMin[index] == null) 
                    keyCount++;
                positionMin[index] = Std.parseFloat(value);
            case "PositionMax":
                if (positionMax[index] == null) 
                    keyCount++;
                positionMax[index] = Std.parseFloat(value);
            case "PositionMinLimit":
                positionMinLimit = Std.parseFloat(value);
                keyCount++;
            case "PositionMaxLimit":
                positionMaxLimit = Std.parseFloat(value);
                keyCount++;
            case "VelocityMin":
                velocityMin = Std.parseFloat(value);
                keyCount++;
            case "VelocityMaxLimit":
                velocityMaxLimit = Std.parseFloat(value);
                keyCount++;
            case "VelocityMax":
                if (velocityMax[index] == null) 
                    keyCount++;
                velocityMax[index] = value;
            case "Position":
                if (positions[index] == null) 
                    keyCount++;
                positions[index] = value;
                if (isAttached) 
                {
                    var posn : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(Std.parseFloat(positions[index]));
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, posn, index));
                }
            case "Acceleration":
                accelerations[index] = value;
            case "Current":
                if (currents[index] == null) 
                    keyCount++;
                currents[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE, this, Std.parseFloat(currents[index]), index));
            case "Engaged":
                if (motorEngagedState[index] == null) 
                    keyCount++;
                motorEngagedState[index] = value;
            case "Stopped":
                if (stopped[index] == null) 
                    keyCount++;
                stopped[index] = value;
            case "SpeedRampingOn":
                if (speedRampingState[index] == null) 
                    keyCount++;
                speedRampingState[index] = value;
            case "VelocityLimit":
                maxVelocities[index] = value;
            case "Velocity":
                if (velocities[index] == null) 
                    keyCount++;
                velocities[index] = value;
                if (isAttached) 
                {
                    var vel : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(Std.parseFloat(velocities[index]));
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE, this, vel, index));
                }
            case "ServoParameters":
                if (servoParameters[index] == null) 
                    keyCount++;
                var paramData : Array<Dynamic> = value.split(",");
                servoParameters[index] = new PhidgetServoParameters(paramData[0], paramData[1], paramData[2], paramData[3], paramData[4]);
        }
    }
    override private function eventsAfterOpen() : Void
    {
        for (i in 0...numMotors){
            if (isKnown(positions, i, com.phidgets.Constants.PUNK_NUM)) 
            {
                var posn : Float = cast((servoParameters[i]), PhidgetServoParameters).usToDegrees(Std.parseFloat(positions[i]));
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, posn, i));
            }
            if (isKnown(velocities, i, com.phidgets.Constants.PUNK_NUM)) 
            {
                var vel : Float = cast((servoParameters[i]), PhidgetServoParameters).usToDegrees(Std.parseFloat(velocities[i]));
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.VELOCITY_CHANGE, this, vel, i));
            }
            if (isKnown(currents, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.CURRENT_CHANGE, this, Std.parseFloat(currents[i]), i));
        }
    }
    
    //Getters
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
        var val : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(accelerationMin);
        return val;
    }
    /*
			Dynamic: getAccelerationMax
			Gets the maximum settable acceleration for a motor.
			
			Parameters:
				index - motor index
		*/
    public function getAccelerationMax(index : Int) : Float{
        if (accelerationMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        var val : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(accelerationMax);
        return val;
    }
    /*
			Dynamic: getPositionMin
			Gets the minimum position that a motor can go to.
			
			Parameters:
				index - motor index 
		*/
    public function getPositionMin(index : Int) : Float{
        if (positionMin[index] == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        var val : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(positionMin[index]);
        return val;
    }
    /*
			Dynamic: getPositionMax
			Gets the maximum position that a motor can go to.
			
			Paramters:
				index - motor index
		*/
    public function getPositionMax(index : Int) : Float{
        if (positionMax[index] == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        var val : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(positionMax[index]);
        return val;
    }
    /*
			Dynamic: getVelocityMin
			Gets the minimum velocity that a motor can be set to.
			
			parameters:
				index - motor index
		*/
    public function getVelocityMin(index : Int) : Float{
        if (velocityMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        var val : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(velocityMin);
        return val;
    }
    /*
			Dynamic: getVelocityMax
			Gets the maximum velocity that a motor can be set to.
			
			Parameters:
				index - motor index
		*/
    public function getVelocityMax(index : Int) : Float{
        if (velocityMax[index] == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        var val : Float = cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(velocityMax[index]);
        return val;
    }
    /*
			Dynamic: getAcceleration
			Gets the last acceleration that a motor was set to.
			
			Parameters:
				index - motor index
		*/
    public function getAcceleration(index : Int) : Float{
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(Std.parseFloat(indexArray(accelerations, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
    }
    /*
			Dynamic: getVelocity
			Gets the current velocity of a motor
			
			Parameters:
				index - motor index
		*/
    public function getVelocity(index : Int) : Float{
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(Std.parseFloat(indexArray(velocities, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
    }
    /*
			Dynamic: getVelocityLimit
			Gets the last velocity limit that a motor was set to.
			
			Parameters:
				index - motor index
		*/
    public function getVelocityLimit(index : Int) : Float{
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegreesVel(Std.parseFloat(indexArray(maxVelocities, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
    }
    /*
			Dynamic: getCurrent
			Gets the current current that a motor is drawing.
			
			Parameters:
				index - motor index
		*/
    public function getCurrent(index : Int) : Float{
        return Std.parseFloat(indexArray(currents, index, numMotors, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getPosition
			Gets the current position of a motor.
			
			Parameters:
				index - motor index
		*/
    public function getPosition(index : Int) : Float{
        if (motorEngagedState[index] != true) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(Std.parseFloat(indexArray(positions, index, numMotors, com.phidgets.Constants.PUNK_NUM)));
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
			Gets the stopped state of a motor. This is whether or not the motor is moving/processing commands.
			
			Parameters:
				index - motor index
		*/
    public function getStopped(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(stopped, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getSpeedRampingOn
			Gets the speed ramping state of the motor. This is whether the motor used acceleration and velocity or not.
			
			Parameters:
				index - motor index
		*/
    public function getSpeedRampingOn(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(motorEngagedState, index, numMotors, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getServoType
			Gets the servo motor type. This is one of the PHIDGET_SERVO_* constants.
			
			Parameters:
				index - motor index
		*/
    public function getServoType(index : Int) : Int{
        return cast((servoParameters[index]), PhidgetServoParameters).servoType;
    }
    
    //Setters
    /*
			Dynamic: setAcceleration
			Sets the acceleration of a motor.
			
			Parameters:
				index - motor index
				val - acceleration
		*/
    public function setAcceleration(index : Int, val : Float) : Void{
        val = cast((servoParameters[index]), PhidgetServoParameters).degreesToUsVel(val);
        _phidgetSocket.setKey(makeIndexedKey("Acceleration", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setVelocityLimit
			Sets the velocity limit of a motor.
			
			Parameters:
				index - motor index
				val - velocity limit
		*/
    public function setVelocityLimit(index : Int, val : Float) : Void{
        val = cast((servoParameters[index]), PhidgetServoParameters).degreesToUsVel(val);
        _phidgetSocket.setKey(makeIndexedKey("VelocityLimit", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setPosition
			Sets the position of a motor.
			
			Parameters:
				index - motor index
				val - motor position
		*/
    public function setPosition(index : Int, val : Float) : Void{
        val = cast((servoParameters[index]), PhidgetServoParameters).degreesToUs(val);
        _phidgetSocket.setKey(makeIndexedKey("Position", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setPositionMax
			Sets the maximum position that a motor can be set to.
			
			Parameters:
				index - motor index
				val - motor position
		*/
    public function setPositionMax(index : Int, val : Float) : Void{
        val = cast((servoParameters[index]), PhidgetServoParameters).degreesToUs(val);
        positionMax[index] = val;
        _phidgetSocket.setKey(makeIndexedKey("PositionMax", index, numMotors), Std.string(val), true);
    }
    /*
			Dynamic: setPositionMin
			Sets the minimum position that a motor can be set to.
			
			Parameters:
				index - motor index
				val - motor position
		*/
    public function setPositionMin(index : Int, val : Float) : Void{
        val = cast((servoParameters[index]), PhidgetServoParameters).degreesToUs(val);
        positionMin[index] = val;
        _phidgetSocket.setKey(makeIndexedKey("PositionMin", index, numMotors), Std.string(val), true);
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
    /*
			Dynamic: setSpeedRampingOn
			Sets the speed ramping state of a motor. This is whether the motor uses acceleration and velocity or not.
			
			Parameters:
				index - motor index
				val - speed ramping state
		*/
    public function setSpeedRampingOn(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("SpeedRampingOn", index, numMotors), Std.string(boolToInt(val)), true);
    }
    /*
			Dynamic: setServoType
			Sets the servo type
			
			Parameters:
				index - motor index
				val - servoType
		*/
    public function setServoType(index : Int, val : Int) : Void
    {
        setupServoParams(index, PhidgetServoParameters.getServoParams(val));
    }
    /*
			Dynamic: setServoParameters
			Sets the servo parameters
			
			Parameters:
				index - motor index
				minUs - minimum PCM in microseconds
				maxUs - maximum PCM in microseconds
				degrees - total range of motion in degrees
				velocityMax - maximum velocity of servo in degrees/second
		*/
    public function setServoParameters(index : Int, minUs : Float, maxUs : Float, degrees : Float, velocityMax : Float) : Void
    {
        setupServoParams(index, new PhidgetServoParameters(PHIDGET_SERVO_USER_DEFINED, minUs, maxUs, (maxUs - minUs) / degrees, ((maxUs - minUs) / degrees) * velocityMax));
    }
    
    private function setupServoParams(index : Int, params : PhidgetServoParameters) : Void
    {
        if (params.servoType == PHIDGET_SERVO_RAW_us_MODE) 
            positionMinLimit = 0
        else 
        positionMinLimit = 1 / 12.0;
        
        velocityMax[index] = params.maxUsPerS;
        
        _phidgetSocket.setKey(makeIndexedKey("ServoParameters", index, numMotors), Std.string(params), true);
        servoParameters[index] = params;
        
        if (maxVelocities[index] > velocityMax[index]) 
            setVelocityLimit(index, params.usToDegreesVel(velocityMax[index]));
        
        if (params.maxUs > positionMaxLimit) 
            setPositionMax(index, params.usToDegrees(positionMaxLimit))
        else 
        setPositionMax(index, params.usToDegrees(params.maxUs));
        
        setPositionMin(index, params.usToDegrees(params.minUs));
    }
}


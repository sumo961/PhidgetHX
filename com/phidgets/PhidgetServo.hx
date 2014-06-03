package com.phidgets;

import com.phidgets.PhidgetServoParameters;

import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetServo
		A class for controlling a PhidgetServo.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetServo. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.POSITION_CHANGE	- position change
	*/
class PhidgetServo extends Phidget
{
    public var MotorCount(get, never) : Int;

    private var numServos : Int;
    private var positionMinLimit : Float;
    private var positionMaxLimit : Float;
    
    private var positions : Array<Dynamic>;
    private var positionMin : Array<Dynamic>;
    private var positionMax : Array<Dynamic>;
    private var motorEngagedState : Array<Dynamic>;
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
        super("PhidgetServo");
    }
    
    override private function initVars() : Void{
        positionMinLimit = com.phidgets.Constants.PUNK_NUM;
        positionMaxLimit = com.phidgets.Constants.PUNK_NUM;
        numServos = com.phidgets.Constants.PUNK_INT;
        positions = new Array<Dynamic>(4);
        positionMin = new Array<Dynamic>(4);
        positionMax = new Array<Dynamic>(4);
        motorEngagedState = new Array<Dynamic>(4);
        servoParameters = new Array<Dynamic>(8);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfMotors":
                numServos = Std.parseInt(value);
                keyCount++;
            case "PositionMinLimit":
                positionMinLimit = Std.parseFloat(value);
                keyCount++;
            case "PositionMaxLimit":
                positionMaxLimit = Std.parseFloat(value);
                keyCount++;
            case "Engaged":
                if (motorEngagedState[index] == null) 
                    keyCount++;
                motorEngagedState[index] = value;
            case "Position":
                if (positions[index] == null) 
                    keyCount++;
                positions[index] = Std.parseFloat(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(Std.parseFloat(positions[index])), index));
            case "ServoParameters":
                if (servoParameters[index] == null) 
                    keyCount++;
                var paramData : Array<Dynamic> = value.split(",");
                servoParameters[index] = new PhidgetServoParameters(paramData[0], paramData[1], paramData[2], paramData[3], 0);
                if (paramData[1] > positionMaxLimit) 
                    positionMax[index] = positionMaxLimit
                else 
                positionMax[index] = paramData[1];
                positionMin[index] = paramData[0];
        }
    }
    override private function eventsAfterOpen() : Void
    {
        for (i in 0...numServos){
            if (isKnown(positions, i, com.phidgets.Constants.PUNK_NUM)) 
            {
                var posn : Float = cast((servoParameters[i]), PhidgetServoParameters).usToDegrees(Std.parseFloat(positions[i]));
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, posn, i));
            }
        }
    }
    
    //Getters
    /*
			Property: MotorCount
			Gets the number of motors supported by this controller.
		*/
    private function get_MotorCount() : Int{
        if (numServos == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numServos;
    }
    /*
			Dynamic: getPosition
			Gets the current position of a motor.
			
			Parameters:
				index - motor index
		*/
    public function getPosition(index : Int) : Float{
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(Std.parseFloat(indexArray(positions, index, numServos, com.phidgets.Constants.PUNK_NUM)));
    }
    /*
			Dynamic: getEngaged
			Gets the engaged (powered) state of a motor.
			
			Parameters:
				index - motor index
		*/
    public function getEngaged(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(motorEngagedState, index, numServos, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getPositionMin
			Gets the minimum position supported by a motor
			
			Parameters:
				index - motor index
		*/
    public function getPositionMin(index : Int) : Float{
        if (positionMin[index] == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(positionMin[index]);
    }
    /*
			Dynamic: getPositionMax
			Gets the maximum position supported by a motor.
			
			Parameters:
				index - motor index
		*/
    public function getPositionMax(index : Int) : Float{
        if (positionMax[index] == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return cast((servoParameters[index]), PhidgetServoParameters).usToDegrees(positionMax[index]);
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
			Dynamic: setPosition
			Sets the position of a motor. If the motor is not engaged, this will engage it.
			
			Parameters:
				index - motor index
				val - position
		*/
    public function setPosition(index : Int, val : Float) : Void{
        val = cast((servoParameters[index]), PhidgetServoParameters).degreesToUs(val);
        _phidgetSocket.setKey(makeIndexedKey("Position", index, numServos), Std.string(val), true);
    }
    /*
			Dynamic: setEngaged
			Sets the engaged (powered) state of a motor.
			
			Parameters:
				index - motor index
				val - engaged state
		*/
    public function setEngaged(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Engaged", index, numServos), Std.string(boolToInt(val)), true);
    }
    /*
			Dynamic: setServoType
			Sets the servo type. This is one of the PHIDGET_SERVO_* constants.
			
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
		*/
    public function setServoParameters(index : Int, minUs : Float, maxUs : Float, degrees : Float) : Void
    {
        setupServoParams(index, new PhidgetServoParameters(PHIDGET_SERVO_USER_DEFINED, minUs, maxUs, (maxUs - minUs) / degrees, 0));
    }
    
    private function setupServoParams(index : Int, params : PhidgetServoParameters) : Void
    {
        if (params.servoType == PHIDGET_SERVO_RAW_us_MODE) 
            positionMinLimit = 0
        else 
        positionMinLimit = 1 / 12.0;
        
        if (params.maxUs > positionMaxLimit) 
            positionMax[index] = positionMaxLimit
        else 
        positionMax[index] = params.maxUs;
        positionMin[index] = params.minUs;
        
        _phidgetSocket.setKey(makeIndexedKey("ServoParameters", index, numServos), Std.string(params), true);
        servoParameters[index] = params;
    }
}

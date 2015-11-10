package com.phidgets.events;

import com.phidgets.events.PhidgetEvent;

import com.phidgets.Phidget;
import com.phidgets.PhidgetError;
import com.phidgets.Constants;

//import flash.events.Event;
//import flash.accessibility.Accessibility;

/*
		Class: PhidgetDataEvent
		A class for data events from Phidget boards.
	*/
class PhidgetDataEvent extends PhidgetEvent
{
    public var Index(get, never) : Int;
    public var Data(get, never) : Dynamic;

    /*
			Constants: Data Event Types
			
			Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
			
			ACCELERATION_CHANGE	-	An acceleration changed. Used by <PhidgetAccelerometer>.
			BACKEMF_UPDATE		-	Fixed rate BackEMF event. Used by <PhidgetMotorControl>.
			BRIDGE_DATA			-	Bridge data is recieved. Used by <PhidgetBridge>.
			CODE				-	An IR code was recieved. Used by <PhidgetIR>.
			COUNT				-	Counts were recieved. used by <PhidgetFrequencyCounter>.
			CURRENT_CHANGE		-	A current changed. Used by <PhidgetAdvancedServo>, <PhidgetMotorControl> and <PhidgetStepper>.
			CURRENT_UPDATE		-	Fixed rate current event. Used by <PhidgetMotorControl>.
			FIX_CHANGE			-	A position fix status changed. Used by <PhidgetGPS>.
			INPUT_CHANGE		-	A digital input changed. Used by <PhidgetEncoder>, <PhidgetInterfaceKit>, <PhidgetMotorControl> and <PhidgetStepper>.
			LEARN				-	An IR code was learned. Used by <PhidgetIR>.
			OUTPUT_CHANGE		-	A digital output changed. Used by <PhidgetInterfaceKit> and <PhidgetRFID>.
			PH_CHANGE			-	A PH changed. Used by <PhidgetPHSensor>.
			POSITION_CHANGE		-	A position changed.	Used by <PhidgetAdvancedServo>, <PhidgetEncoder>, <PhidgetGPS>, <PhidgetMotorControl>, <PhidgetServo> and <PhidgetStepper>.
			POSITION_UPDATE		-	Fixed rate position event.	Used by <PhidgetMotorControl>.
			RAW_DATA			-	Raw data was recieved. Used by <PhidgetIR>.
			SENSOR_CHANGE		-	An analog input changed. Used by <PhidgetInterfaceKit>.
			SENSOR_UPDATE		-	Fixed rate sensor event. Used by <PhidgetMotorControl>.
			SPATIAL_DATA		-	Spatial data was recieved. Used by <PhidgetSpatial>.
			TAG					-	An RFID tag was detected. Used by <PhidgetRFID>.
			TAG_LOST			-	An RFID tag was removed. Used by <PhidgetRFID>.
			TEMPERATURE_CHANGE	-	A temperature changed. Used by <PhidgetTemperatureSensor>.
			VELOCITY_CHANGE		-	A velocity changed. Used by <PhidgetAdvancedServo>, <PhidgetMotorControl> and <PhidgetStepper>.
			WEIGHT_CHANGE		-	A weight changed. Used by <PhidgetWeightSensor>.
		*/
    
    //Multiple
    public static inline var INPUT_CHANGE : String = "inputChange";
    public static inline var OUTPUT_CHANGE : String = "outputChange";
    public static inline var POSITION_CHANGE : String = "positionChange";
    public static inline var CURRENT_CHANGE : String = "currentChange";
    public static inline var VELOCITY_CHANGE : String = "velocityChange";
    //Accelerometer
    public static inline var ACCELERATION_CHANGE : String = "accelearaionChange";
    //AdvancedServo
    //public static const POSITION_CHANGE	:String = "positionChange";
    //public static const CURRENT_CHANGE 	:String = "currentChange";
    //public static const VELOCITY_CHANGE	:String = "velocityChange";
    //Bridge
    public static inline var BRIDGE_DATA : String = "bridgeDate";
    //Encoder
    //public static const POSITION_CHANGE	:String = "positionChange";
    //public static const INPUT_CHANGE	:String = "inputChange";
    //FrequencyCounter
    public static inline var COUNT : String = "count";
    //GPS
    //public static const POSITION_CHANGE	:String = "positionChange";
    public static inline var FIX_CHANGE : String = "fixChange";
    //InterfaceKit
    public static inline var SENSOR_CHANGE : String = "sensorChange";
    //public static const INPUT_CHANGE	:String = "inputChange";
    //public static const OUTPUT_CHANGE	:String = "outputChange";
    //IR
    public static inline var CODE : String = "code";
    public static inline var LEARN : String = "learn";
    public static inline var RAW_DATA : String = "rawData";
    //LED
    //MotorControl
    //public static const CURRENT_CHANGE 	:String = "currentChange";
    //public static const VELOCITY_CHANGE	:String = "velocityChange";
    //public static const INPUT_CHANGE	:String = "inputChange";
    //public static const POSITION_CHANGE	:String = "positionChange";
    public static inline var POSITION_UPDATE : String = "positionUpdate";
    public static inline var SENSOR_UPDATE : String = "sensorUpdate";
    public static inline var BACKEMF_UPDATE : String = "backemfUpdate";
    public static inline var CURRENT_UPDATE : String = "currentUpdate";
    //PHSensor
    public static inline var PH_CHANGE : String = "phChange";
    //RFID
    public static inline var TAG : String = "tag";
    public static inline var TAG_LOST : String = "tagLost";
    //public static const OUTPUT_CHANGE	:String = "outputChange";
    //Servo
    //public static const POSITION_CHANGE	:String = "positionChange";
    //Spatial
    public static inline var SPATIAL_DATA : String = "spatialData";
    //Stepper
    //public static const INPUT_CHANGE	:String = "inputChange";
    //public static const POSITION_CHANGE	:String = "positionChange";
    //public static const CURRENT_CHANGE 	:String = "currentChange";
    //public static const VELOCITY_CHANGE	:String = "velocityChange";
    //TemperatureSensor
    public static inline var TEMPERATURE_CHANGE : String = "temperatureChange";
    //TextLCD
    //TextLED
    //WeightSensor
    public static inline var WEIGHT_CHANGE : String = "weightChange";
    
    private var _data : Dynamic;
    private var _index : Int = -1;
    
    public function new(type : String, phidget : Phidget, data : Dynamic, index : Int = -1)
    {
        super(type, phidget);
        _data = data;
        _index = index;
    }
    
    override public function toString() : String{
        if (_index == -1) 
            return "[ Phidget Data Event: " + type + " to " + _data + " ]"
        else 
            return "[ Phidget Data Event: " + type + " " + _index + " to " + _data + " ]";
    }
    
    /*
			Property: Index
			Gets the index for this event, for indexed events.
		*/
    private function get_Index() : Int{
        if (_index == -1) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNSUPPORTED);
        return _index;
    }
    /*
			Property: Data
			Gets the data for this event. The data type will depend on the event type, as follows:
			
			ACCELERATION_CHANGE	-	Number
			CODE				-	<PhidgetIRCode>
			CURRENT_CHANGE		-	Number
			INPUT_CHANGE		-	Boolean
			LEARN				-	<PhidgetIRLearnedCode>
			OUTPUT_CHANGE		-	Boolean
			PH_CHANGE			-	Number
			POSITION_CHANGE		-	Number
			RAW_DATA			-	Array or ints
			SENSOR_CHANGE		-	int
			SPATIAL_DATA		-	<PhidgetSpatialEventData>
			TAG					-	<PhidgetRFIDTag>
			TAG_LOST			-	<PhidgetRFIDTag>
			TEMPERATURE_CHANGE	-	Number
			VELOCITY_CHANGE		-	Number
			WEIGHT_CHANGE		-	Number
		*/
    private function get_Data() : Dynamic{
        return _data;
    }
}

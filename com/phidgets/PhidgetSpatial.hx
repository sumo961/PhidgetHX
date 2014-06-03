package com.phidgets;

import com.phidgets.PhidgetSpatialEventData;

import com.phidgets.events.PhidgetDataEvent;
import flash.accessibility.Accessibility;

/*
		Class: PhidgetSpatial
		A class for controlling a PhidgetSpatial.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetSpatial. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.SPATIAL_DATA	- spatial data
	*/
class PhidgetSpatial extends Phidget
{
    public var AccelerationAxisCount(get, never) : Int;
    public var GyroAxisCount(get, never) : Int;
    public var CompassAxisCount(get, never) : Int;
    public var DataRate(get, set) : Int;
    public var DataRateMin(get, never) : Int;
    public var DataRateMax(get, never) : Int;

    private var numAccelAxes : Int;
    private var numGyroAxes : Int;
    private var numCompassAxes : Int;
    private var accelerationMin : Float;
    private var accelerationMax : Float;
    private var angularRateMin : Float;
    private var angularRateMax : Float;
    private var magneticFieldMin : Float;
    private var magneticFieldMax : Float;
    private var dataRateMin : Int;
    private var dataRateMax : Int;
    private var dataRate : Int;
    private var interruptRate : Int;
    private var spatialDataNetwork : Int;
    private var flip : Int;
    
    private var acceleration : Array<Dynamic>;
    private var angularRate : Array<Dynamic>;
    private var magneticField : Array<Dynamic>;
    
    public function new()
    {
        super("PhidgetSpatial");
    }
    
    override private function initVars() : Void{
        numAccelAxes = com.phidgets.Constants.PUNK_INT;
        numGyroAxes = com.phidgets.Constants.PUNK_INT;
        numCompassAxes = com.phidgets.Constants.PUNK_INT;
        accelerationMin = com.phidgets.Constants.PUNK_NUM;
        accelerationMax = com.phidgets.Constants.PUNK_NUM;
        angularRateMin = com.phidgets.Constants.PUNK_NUM;
        angularRateMax = com.phidgets.Constants.PUNK_NUM;
        magneticFieldMin = com.phidgets.Constants.PUNK_NUM;
        magneticFieldMax = com.phidgets.Constants.PUNK_NUM;
        dataRateMin = com.phidgets.Constants.PUNK_INT;
        dataRateMax = com.phidgets.Constants.PUNK_INT;
        dataRate = com.phidgets.Constants.PUNI_INT;
        interruptRate = com.phidgets.Constants.PUNK_INT;
        spatialDataNetwork = com.phidgets.Constants.PUNI_BOOL;
        flip = 0;
        acceleration = new Array<Dynamic>(3);
        angularRate = new Array<Dynamic>(3);
        magneticField = new Array<Dynamic>(3);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "AccelerationAxisCount":
                numAccelAxes = Std.parseInt(value);
                keyCount++;
            case "GyroAxisCount":
                numGyroAxes = Std.parseInt(value);
                keyCount++;
            case "CompassAxisCount":
                numCompassAxes = Std.parseInt(value);
                keyCount++;
            case "AccelerationMin":
                accelerationMin = Std.parseFloat(value);
                keyCount++;
            case "AccelerationMax":
                accelerationMax = Std.parseFloat(value);
                keyCount++;
            case "AngularRateMin":
                angularRateMin = Std.parseFloat(value);
                keyCount++;
            case "AngularRateMax":
                angularRateMax = Std.parseFloat(value);
                keyCount++;
            case "MagneticFieldMin":
                magneticFieldMin = Std.parseFloat(value);
                keyCount++;
            case "MagneticFieldMax":
                magneticFieldMax = Std.parseFloat(value);
                keyCount++;
            case "DataRateMin":
                dataRateMin = Std.parseInt(value);
                keyCount++;
            case "DataRateMax":
                dataRateMin = Std.parseInt(value);
                keyCount++;
            case "DataRate":
                if (dataRate == com.phidgets.Constants.PUNI_INT) 
                    keyCount++;
                dataRate = Std.parseInt(value);
            case "InterruptRate":
                interruptRate = Std.parseInt(value);
                keyCount++;
            case "SpatialData":
                if (spatialDataNetwork == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                spatialDataNetwork = 1;
                
                var data : Array<Dynamic> = value.split(",");
                var i : Int;
                
                for (i in 0...3){
                    acceleration[i] = data[i];
                }
                for (i in 0...3){
                    angularRate[i] = data[i + 3];
                }
                for (i in 0...3){
                    magneticField[i] = data[i + 6];
                }
                
                if (isAttached) 
                {
                    var accel : Array<Dynamic> = new Array<Dynamic>(numAccelAxes);
                    for (i in 0...numAccelAxes){
                        accel[i] = acceleration[i];
                    }
                    var gyro : Array<Dynamic> = new Array<Dynamic>(numGyroAxes);
                    for (i in 0...numGyroAxes){
                        gyro[i] = angularRate[i];
                    }
                    var comp : Array<Dynamic>;
                    if (numCompassAxes > 0 && magneticField[0] <= magneticFieldMax && magneticField[0] >= magneticFieldMin) 
                    {
                        comp = new Array<Dynamic>(numCompassAxes);
                        for (i in 0...numCompassAxes){
                            comp[i] = magneticField[i];
                        }
                    }
                    else 
                    comp = new Array<Dynamic>(0);
                    var sData : PhidgetSpatialEventData = new PhidgetSpatialEventData(accel, gyro, comp, data[9], data[10]);
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.SPATIAL_DATA, this, sData));
                }
        }
    }
    
    //don't need to worry about eventsAfterOpen, because the interrupts come at a set rate
    
    //Getters
    /*
			Property: AccelerationAxisCount
			Gets the number of acceleration axes.
		*/
    private function get_AccelerationAxisCount() : Int{
        if (numAccelAxes == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numAccelAxes;
    }
    /*
			Dynamic: getAcceleration
			Gets the acceleration of a axis.
			
			Parameters:
				index - acceleration axis
		*/
    public function getAcceleration(index : Int) : Float{
        return Std.parseFloat(indexArray(acceleration, index, numAccelAxes, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getAccelerationMin
			Gets the minimum acceleration that an axis will return.
			
			Parameters:
				index - acceleration axis
		*/
    public function getAccelerationMin(index : Int) : Float{
        if (accelerationMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return accelerationMin;
    }
    /*
			Dynamic: getAccelerationMax
			Gets the maximum acceleration that an axis will return.
			
			Parameters:
				index - acceleration index
		*/
    public function getAccelerationMax(index : Int) : Float{
        if (accelerationMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return accelerationMax;
    }
    /*
			Property: GyroAxisCount
			Gets the number of gyroscope axes.
		*/
    private function get_GyroAxisCount() : Int{
        if (numGyroAxes == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numGyroAxes;
    }
    /*
			Dynamic: getAngularRate
			Gets the angularRate of a axis.
			
			Parameters:
				index - angularRate axis
		*/
    public function getAngularRate(index : Int) : Float{
        return Std.parseFloat(indexArray(angularRate, index, numGyroAxes, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getAngularRateMin
			Gets the minimum angularRate that an axis will return.
			
			Parameters:
				index - angularRate axis
		*/
    public function getAngularRateMin(index : Int) : Float{
        if (angularRateMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return angularRateMin;
    }
    /*
			Dynamic: getAngularRateMax
			Gets the maximum angularRate that an axis will return.
			
			Parameters:
				index - angularRate index
		*/
    public function getAngularRateMax(index : Int) : Float{
        if (angularRateMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return angularRateMax;
    }
    /*
			Property: CompassAxisCount
			Gets the number of compass axes.
		*/
    private function get_CompassAxisCount() : Int{
        if (numCompassAxes == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numCompassAxes;
    }
    /*
			Dynamic: getMagneticField
			Gets the magneticField of a axis.
			
			Parameters:
				index - magneticField axis
		*/
    public function getMagneticField(index : Int) : Float{
        return Std.parseFloat(indexArray(magneticField, index, numCompassAxes, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getMagneticFieldMin
			Gets the minimum magneticField that an axis will return.
			
			Parameters:
				index - magneticField axis
		*/
    public function getMagneticFieldMin(index : Int) : Float{
        if (magneticFieldMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return magneticFieldMin;
    }
    /*
			Dynamic: getMagneticFieldMax
			Gets the maximum magneticField that an axis will return.
			
			Parameters:
				index - magneticField index
		*/
    public function getMagneticFieldMax(index : Int) : Float{
        if (magneticFieldMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return magneticFieldMax;
    }
    /*
			Property: DataRate
			Gets the data rate, in milliseconds.
		*/
    private function get_DataRate() : Int{
        if (dataRate == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRate;
    }
    /*
			Property: DataRateMin
			Gets the minimum data rate, in milliseconds.
		*/
    private function get_DataRateMin() : Int{
        if (dataRateMin == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRateMin;
    }
    /*
			Property: DataRateMax
			Gets the maximum data rate, in milliseconds.
		*/
    private function get_DataRateMax() : Int{
        if (dataRateMax == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return dataRateMax;
    }
    
    //Setters
    /*
			Property: setDataRate
			Sets the data rate for a sensor, in milliseconds.
			
			Parameters:
				val - data rate
		*/
    private function set_DataRate(val : Int) : Int{
        _phidgetSocket.setKey(makeKey("DataRate"), Std.string(val), true);
        return val;
    }
    /*
			Dynamic: zeroGyro
			Re-Zeroes the gyro. This should only be called when stationary.
		*/
    public function zeroGyro(val : Int) : Void{
        flip ^= 1;
        _phidgetSocket.setKey(makeKey("ZeroGyro"), Std.string(flip), true);
    }
    /*
			Dynamic: setCompassCorrectionParameters
			Sets the compass correction factors. This can be used to correcting any sensor errors, including hard and soft iron offsets and sensor error factors.
			
			Parameters:
				magField - Local magnetic field strength.
				offset0 - Axis 0 offset correction.
				offset1 - Axis 1 offset correction.
				offset2 - Axis 2 offset correction.
				gain0 - Axis 0 gain correction.
				gain1 - Axis 1 gain correction.
				gain2 - Axis 2 gain correction.
				T0 - Non-orthogonality correction factor 0.
				T1 - Non-orthogonality correction factor 1.
				T2 - Non-orthogonality correction factor 2.
				T3 - Non-orthogonality correction factor 3.
				T4 - Non-orthogonality correction factor 4.
				T5 - Non-orthogonality correction factor 5.
		*/
    public function setCompassCorrectionParameters(magField : Float, offset0 : Float, offset1 : Float, offset2 : Float, gain0 : Float, gain1 : Float, gain2 : Float, T0 : Float, T1 : Float, T2 : Float, T3 : Float, T4 : Float, T5 : Float) : Void{
        var val : String = magField + "," + offset0 + "," + offset1 + "," + offset2 + "," + gain0 + "," + gain1 + "," + gain2 + "," + T0 + "," + T1 + "," + T2 + "," + T3 + "," + T4 + "," + T5;
        _phidgetSocket.setKey(makeKey("CompassCorrectionParams"), Std.string(val), true);
    }
    /*
			Dynamic: setCompassCorrectionParameters
			Sets the compass correction factors. This can be used to correcting any sensor errors, including hard and soft iron offsets and sensor error factors.
			
			Parameters:
				magField - Local magnetic field strength.
				offset0 - Axis 0 offset correction.
				offset1 - Axis 1 offset correction.
				offset2 - Axis 2 offset correction.
				gain0 - Axis 0 gain correction.
				gain1 - Axis 1 gain correction.
				gain2 - Axis 2 gain correction.
				T0 - Non-orthogonality correction factor 0.
				T1 - Non-orthogonality correction factor 1.
				T2 - Non-orthogonality correction factor 2.
				T3 - Non-orthogonality correction factor 3.
				T4 - Non-orthogonality correction factor 4.
				T5 - Non-orthogonality correction factor 5.
		*/
    public function resetCompassCorrectionParameters() : Void{
        var val : String = "1,0,0,0,1,1,1,0,0,0,0,0,0";
        _phidgetSocket.setKey(makeKey("CompassCorrectionParams"), Std.string(val), true);
    }
}

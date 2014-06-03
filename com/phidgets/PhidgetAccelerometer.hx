package com.phidgets;

import com.phidgets.PhidgetError;

import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetAccelerometer
		A class for controlling a PhidgetAccelerometer.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetAccelerometer. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.ACCELERATION_CHANGE	- acceleration change
	*/
class PhidgetAccelerometer extends Phidget
{
    public var AxisCount(get, never) : Int;

    private var numAxes : Int;
    private var accelerationMin : Float;
    private var accelerationMax : Float;
    
    private var axes : Array<Dynamic>;
    private var axisTriggers : Array<Dynamic>;
    
    public function new()
    {
        super("PhidgetAccelerometer");
    }
    
    override private function initVars() : Void{
        numAxes = com.phidgets.Constants.PUNK_INT;
        accelerationMin = com.phidgets.Constants.PUNK_NUM;
        accelerationMax = com.phidgets.Constants.PUNK_NUM;
        axes = new Array<Dynamic>(3);
        axisTriggers = new Array<Dynamic>(3);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfAxes":
                numAxes = Std.parseInt(value);
                keyCount++;
            case "Acceleration":
                if (axes[index] == null) 
                    keyCount++;
                axes[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.ACCELERATION_CHANGE, this, Std.parseFloat(axes[index]), index));
            case "AccelerationMin":
                accelerationMin = Std.parseFloat(value);
                keyCount++;
            case "AccelerationMax":
                accelerationMax = Std.parseFloat(value);
                keyCount++;
            case "Trigger":
                if (axisTriggers[index] == null) 
                    keyCount++;
                axisTriggers[index] = value;
        }
    }
    override private function eventsAfterOpen() : Void
    {
        for (i in 0...numAxes){
            if (isKnown(axes, i, com.phidgets.Constants.PUNK_NUM)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.ACCELERATION_CHANGE, this, Std.parseFloat(axes[i]), i));
        }
    }
    
    //Getters
    /*
			Property: AxisCount
			Gets the number of axes on this accelerometer.
		*/
    private function get_AxisCount() : Int{
        if (numAxes == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numAxes;
    }
    /*
			Dynamic: getAcceleration
			Gets the acceleration of a axis.
			
			Parameters:
				index - acceleration axis
		*/
    public function getAcceleration(index : Int) : Float{
        return Std.parseFloat(indexArray(axes, index, numAxes, com.phidgets.Constants.PUNK_NUM));
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
			Dynamic: getAccelerationChangeTrigger
			Gets the change trigger for an axis.
			
			Parameters:
				index - acceleration axis
		*/
    public function getAccelerationChangeTrigger(index : Int) : Float{
        return Std.parseFloat(indexArray(axisTriggers, index, numAxes, com.phidgets.Constants.PUNK_NUM));
    }
    
    //Setters
    /*
			Dynamic: setAccelerationChangeTrigger
			Sets the change trigger for an axis.
			
			Parameters:
				index - acceleration axis
				val - change trigger
		*/
    public function setAccelerationChangeTrigger(index : Int, val : Float) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Trigger", index, numAxes), Std.string(val), true);
    }
}

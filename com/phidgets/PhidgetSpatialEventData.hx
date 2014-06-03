package com.phidgets;



/*
		Class: PhidgetSpatialEventData
		Represents a set of spatial data, as recieved via the Spatial Data event
	*/
class PhidgetSpatialEventData
{
    public var Acceleration(get, never) : Array<Dynamic>;
    public var AngularRate(get, never) : Array<Dynamic>;
    public var MagneticField(get, never) : Array<Dynamic>;
    public var TimeSeconds(get, never) : Int;
    public var TimeMicroSeconds(get, never) : Int;
    public var Time(get, never) : Float;

    private var acceleration : Array<Dynamic>;
    private var angularRate : Array<Dynamic>;
    private var magneticField : Array<Dynamic>;
    private var timeSeconds : Int;
    private var timeMicroSeconds : Int;
    
    public function new(acceleration : Array<Dynamic>, angularRate : Array<Dynamic>, magneticField : Array<Dynamic>, timeSeconds : Int, timeMicroSeconds : Int)
    {
        var i : Int;
        this.acceleration = new Array<Dynamic>(acceleration.length);
        for (i in 0...acceleration.length){this.acceleration[i] = acceleration[i];
        }
        this.angularRate = new Array<Dynamic>(angularRate.length);
        for (i in 0...angularRate.length){this.angularRate[i] = angularRate[i];
        }
        this.magneticField = new Array<Dynamic>(magneticField.length);
        for (i in 0...magneticField.length){this.magneticField[i] = magneticField[i];
        }
        this.timeSeconds = timeSeconds;
        this.timeMicroSeconds = timeMicroSeconds;
    }
    
    /*
			Property: Acceleration
			Gets the acceleration array
		*/
    private function get_Acceleration() : Array<Dynamic>{
        return acceleration;
    }
    /*
			Property: AngularRate
			Gets the angular rate array (gyro data)
		*/
    private function get_AngularRate() : Array<Dynamic>{
        return angularRate;
    }
    /*
			Property: MagneticField
			Gets the magnetic field array (compass data)
		*/
    private function get_MagneticField() : Array<Dynamic>{
        return magneticField;
    }
    /*
			Property: TimeSeconds
			Gets the number of whole seconds since attach.
		*/
    private function get_TimeSeconds() : Int{
        return timeSeconds;
    }
    /*
			Property: TimeMicroSeconds
			Gets the number of microseconds since the last second (0-999999).
		*/
    private function get_TimeMicroSeconds() : Int{
        return timeMicroSeconds;
    }
    /*
			Property: Time
			Gets the number of seconds since attach.
		*/
    private function get_Time() : Float{
        return (timeMicroSeconds / 1000000.0 + timeSeconds);
    }
    
    public function toString() : String{
        var out : String = "";
        var i : Int;
        var time : Float = timeSeconds + timeMicroSeconds / 1000000.0;
        out = out + "Timestamp: " + time;
        if (acceleration.length > 0) 
        {
            out = out + "\n Acceleration: ";
            for (i in 0...acceleration.length){out = out + acceleration[i] + (((i == acceleration.length - 1)) ? "" : ",");
            }
        }
        if (angularRate.length > 0) 
        {
            out = out + "\n Angular Rate: ";
            for (i in 0...angularRate.length){out = out + angularRate[i] + (((i == angularRate.length - 1)) ? "" : ",");
            }
        }
        if (magneticField.length > 0) 
        {
            out = out + "\n Magnetic Field: ";
            for (i in 0...magneticField.length){out = out + magneticField[i] + (((i == magneticField.length - 1)) ? "" : ",");
            }
        }
        return out;
    }
}

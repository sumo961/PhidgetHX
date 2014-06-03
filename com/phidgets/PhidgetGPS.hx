package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetGPS
		A class for interfacing with a PhidgetGPS.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetGPS. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.FIX_CHANGE	- position fix status change
		PhidgetDataEvent.POSITION_CHANGE	- position change (Array:[latitude,longitude,altitude])
	*/
class PhidgetGPS extends Phidget
{
    public var PositionFixStatus(get, never) : Bool;
    public var Latitude(get, never) : Float;
    public var Longitude(get, never) : Float;
    public var Altitude(get, never) : Float;
    public var Heading(get, never) : Float;
    public var Velocity(get, never) : Float;
    public var DateTime(get, never) : Date;

    private var date : Date;
    private var altitude : Float;
    private var heading : Float;
    private var velocity : Float;
    private var latitude : Float;
    private var longitude : Float;
    private var fix : Int;
    private var havedate : Bool;
    
    public function new()
    {
        super("PhidgetGPS");
    }
    
    override private function initVars() : Void{
        havedate = false;
        altitude = com.phidgets.Constants.PUNK_NUM;
        heading = com.phidgets.Constants.PUNK_NUM;
        velocity = com.phidgets.Constants.PUNK_NUM;
        latitude = com.phidgets.Constants.PUNK_NUM;
        longitude = com.phidgets.Constants.PUNK_NUM;
        fix = com.phidgets.Constants.PUNI_INT;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "PositionFix":
                if (fix == com.phidgets.Constants.PUNI_INT) 
                    keyCount++;
                fix = Std.parseInt(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.FIX_CHANGE, this, intToBool(fix)));
            case "Velocity":
                velocity = Std.parseFloat(value);
            case "Heading":
                heading = Std.parseFloat(value);
            case "DateTime":
                var data : Array<Dynamic> = value.split("/");
                date = Date.now();
                date.setUTCFullYear(Std.parseInt(data[0]), Std.parseInt(data[1]), Std.parseInt(data[2]));
                date.setUTCHours(Std.parseInt(data[3]), Std.parseInt(data[4]), Std.parseInt(data[5]), Std.parseInt(data[6]));
                havedate = true;
            case "Position":
                var data2 : Array<Dynamic> = value.split("/");
                latitude = Std.parseFloat(data2[0]);
                longitude = Std.parseFloat(data2[1]);
                altitude = Std.parseFloat(data2[2]);
                var eventData : Array<Dynamic> = [latitude, longitude, altitude];
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, eventData));
        }
    }
    override private function eventsAfterOpen() : Void
    {
        if (fix != com.phidgets.Constants.PUNK_INT) 
            dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.FIX_CHANGE, this, intToBool(fix)));
        if (intToBool(fix) == true && latitude != com.phidgets.Constants.PUNK_NUM) 
        {
            var eventData : Array<Dynamic> = [latitude, longitude, altitude];
            dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, eventData));
        }
    }
    
    //Getters
    /*
			Property: PositionFixStatus
			Gets the position fix status of this gps.
		*/
    private function get_PositionFixStatus() : Bool{
        if (fix == com.phidgets.Constants.PUNK_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return intToBool(fix);
    }
    /*
			Property: Latitude
			Gets the last recieved latitude.
		*/
    private function get_Latitude() : Float{
        if (latitude == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return latitude;
    }
    /*
			Property: Longitude
			Gets the last recieved longitude.
		*/
    private function get_Longitude() : Float{
        if (longitude == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return longitude;
    }
    /*
			Property: Altitude
			Gets the last recieved altitude.
		*/
    private function get_Altitude() : Float{
        if (altitude == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return altitude;
    }
    /*
			Property: Heading
			Gets the last recieved heading.
		*/
    private function get_Heading() : Float{
        if (heading == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return heading;
    }
    /*
			Property: Velocity
			Gets the last recieved velocity.
		*/
    private function get_Velocity() : Float{
        if (velocity == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return velocity;
    }
    /*
			Property: DateTime
			Gets the last recieved date and time in UTC.
		*/
    private function get_DateTime() : Date{
        if (!havedate) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return date;
    }
}

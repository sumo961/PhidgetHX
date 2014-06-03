package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetPHSensor
		A class for controlling a PhidgetPHSensor.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetPHSensor. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.PH_CHANGE	- PH change
	*/
class PhidgetPHSensor extends Phidget
{
    public var PH(get, never) : Float;
    public var PHMin(get, never) : Float;
    public var PHMax(get, never) : Float;
    public var Potential(get, never) : Float;
    public var PotentialMin(get, never) : Float;
    public var PotentialMax(get, never) : Float;
    public var PHChangeTrigger(get, set) : Float;
    public var Temperature(never, set) : Float;

    private var phMin : Float;
    private var phMax : Float;
    private var potentialMin : Float;
    private var potentialMax : Float;
    
    private var ph : Float;
    private var potential : Float;
    private var phTrigger : Float;
    
    public function new()
    {
        super("PhidgetPHSensor");
    }
    
    override private function initVars() : Void{
        phMin = com.phidgets.Constants.PUNI_NUM;
        phMax = com.phidgets.Constants.PUNI_NUM;
        potentialMin = com.phidgets.Constants.PUNK_NUM;
        potentialMax = com.phidgets.Constants.PUNK_NUM;
        
        ph = com.phidgets.Constants.PUNI_NUM;
        potential = com.phidgets.Constants.PUNI_NUM;
        phTrigger = com.phidgets.Constants.PUNI_NUM;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "PHMin":
                if (phMin == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                phMin = Std.parseFloat(value);
            case "PHMax":
                if (phMax == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                phMax = Std.parseFloat(value);
            case "PotentialMin":
                potentialMin = Std.parseFloat(value);
                keyCount++;
            case "PotentialMax":
                potentialMax = Std.parseFloat(value);
                keyCount++;
            case "PH":
                if (ph == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                ph = Std.parseFloat(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.PH_CHANGE, this, ph));
            case "Trigger":
                if (phTrigger == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                phTrigger = Std.parseFloat(value);
            case "Potential":
                if (potential == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                potential = Std.parseFloat(value);
        }
    }
    override private function eventsAfterOpen() : Void
    {
        if (ph != com.phidgets.Constants.PUNK_NUM) 
            dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.PH_CHANGE, this, ph));
    }
    
    //Getters
    /*
			Property: PH
			Gets the current PH sensed by the PH sensor.
		*/
    private function get_PH() : Float{
        if (ph == com.phidgets.Constants.PUNK_NUM || ph == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return ph;
    }
    /*
			Property: PHMin
			Gets the minumum PH that the sensor might return.
		*/
    private function get_PHMin() : Float{
        if (phMin == com.phidgets.Constants.PUNK_NUM || phMin == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return phMin;
    }
    /*
			Property: PHMax
			Gets the maximum PH that the sensor might return
		*/
    private function get_PHMax() : Float{
        if (phMax == com.phidgets.Constants.PUNK_NUM || phMax == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return phMax;
    }
    /*
			Property: Potential
			Gets the potential (mV) being measured by the board.
		*/
    private function get_Potential() : Float{
        if (potential == com.phidgets.Constants.PUNK_NUM || potential == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return potential;
    }
    /*
			Property: PotentialMin
			Gets the minimum potential that might be returned.
		*/
    private function get_PotentialMin() : Float{
        if (potentialMin == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return potentialMin;
    }
    /*
			Property: PotentialMax
			Gets the maximum potential that might be returned.
		*/
    private function get_PotentialMax() : Float{
        if (potentialMax == com.phidgets.Constants.PUNK_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return potentialMax;
    }
    /*
			Property: PHChangeTrigger
			Gets the change trigger for PH.
		*/
    private function get_PHChangeTrigger() : Float{
        if (phTrigger == com.phidgets.Constants.PUNK_NUM || phTrigger == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return phTrigger;
    }
    
    //Setters
    /*
			Property: PHChangeTrigger
			Sets the change trigger for PH.
			
			Parameters:
				val - change trigger
		*/
    private function set_PHChangeTrigger(val : Float) : Float{
        _phidgetSocket.setKey(makeKey("Trigger"), Std.string(val), true);
        return val;
    }
    /*
			Property: Temperature
			Sets the temperature used for internal PH calculations.
			
			Parameters:
				val - temperature
		*/
    private function set_Temperature(val : Float) : Float{
        _phidgetSocket.setKey(makeKey("Temperature"), Std.string(val), true);
        return val;
    }
}

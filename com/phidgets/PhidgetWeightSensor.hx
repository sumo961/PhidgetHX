package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetWeightSensor
		A class for controlling a PhidgetWeightSensor.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetWeightSensor. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.WEIGHT_CHANGE	- weight change
	*/
class PhidgetWeightSensor extends Phidget
{
    public var Weight(get, never) : Float;
    public var WeightChangeTrigger(get, set) : Float;

    private var weight : Float;
    private var weightTrigger : Float;
    
    public function new()
    {
        super("PhidgetWeightSensor");
    }
    
    override private function initVars() : Void{
        weight = com.phidgets.Constants.PUNI_NUM;
        weightTrigger = com.phidgets.Constants.PUNI_NUM;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "Weight":
                if (weight == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                weight = Std.parseFloat(value);
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.WEIGHT_CHANGE, this, weight));
            case "Trigger":
                if (weightTrigger == com.phidgets.Constants.PUNI_NUM) 
                    keyCount++;
                weightTrigger = Std.parseFloat(value);
        }
    }
    override private function eventsAfterOpen() : Void
    {
        if (weight != com.phidgets.Constants.PUNK_NUM) 
            dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.WEIGHT_CHANGE, this, weight));
    }
    
    //Getters
    /*
			Property: Weight
			Gets the currently sensed weight.
		*/
    private function get_Weight() : Float{
        if (weight == com.phidgets.Constants.PUNK_NUM || weight == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return weight;
    }
    /*
			Property: WeightChangeTrigger
			Gets the weight change trigger.
		*/
    private function get_WeightChangeTrigger() : Float{
        if (weightTrigger == com.phidgets.Constants.PUNK_NUM || weightTrigger == com.phidgets.Constants.PUNI_NUM) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return weightTrigger;
    }
    
    //Setters
    /*
			Property: WeightChangeTrigger
			Sets the weight change trigger.
			
			Parameters:
				val - change trigger
		*/
    private function set_WeightChangeTrigger(val : Float) : Float{
        _phidgetSocket.setKey(makeKey("Trigger"), Std.string(val), true);
        return val;
    }
}

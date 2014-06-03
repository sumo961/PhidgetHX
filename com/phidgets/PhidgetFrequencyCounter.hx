package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetFrequencyCounter
		A class for controlling a PhidgetFrequencyCounter.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetFrequencyCounter. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.COUNT	- counts (Array:[timeChange, countChange]). Happens when input counts are recieved, or when the timeout occurs.
	*/
class PhidgetFrequencyCounter extends Phidget
{
    public var FrequencyInputCount(get, never) : Int;

    private var numInputs : Int;
    
    private var frequency : Array<Dynamic>;
    private var timeout : Array<Dynamic>;
    private var filter : Array<Dynamic>;
    private var enabled : Array<Dynamic>;
    private var totalCount : Array<Dynamic>;
    private var totalTime : Array<Dynamic>;
    private var countsGood : Array<Dynamic>;
    
    private var flip : Int;
    
    /*
			Constants: FrequencyCounter filter types
			These are the filter types supported by PhidgetFrequencyCounter. These constants are used with <getFilter> and <setFilter>.
			
			PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_ZERO_CROSSING - zero crossing filter.
			PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_LOGIC_LEVEL - logic level filter.
		*/
    public static inline var PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_ZERO_CROSSING : Int = 1;
    public static inline var PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_LOGIC_LEVEL : Int = 2;
    private static inline var PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_UNKNOWN : Int = 3;
    
    public function new()
    {
        super("PhidgetFrequencyCounter");
    }
    
    override private function initVars() : Void{
        numInputs = com.phidgets.Constants.PUNK_INT;
        frequency = new Array<Dynamic>(2);
        timeout = new Array<Dynamic>(2);
        filter = new Array<Dynamic>(2);
        enabled = new Array<Dynamic>(2);
        totalCount = new Array<Dynamic>(2);
        totalTime = new Array<Dynamic>(2);
        countsGood = new Array<Dynamic>(2);
        
        flip = 0;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfInputs":
                numInputs = Std.parseInt(value);
                keyCount++;
            case "Enabled":
                if (enabled[index] == null) 
                    keyCount++;
                enabled[index] = Std.parseInt(value);
            case "Timeout":
                if (timeout[index] == null) 
                    keyCount++;
                timeout[index] = Std.parseInt(value);
            case "Filter":
                if (filter[index] == null) 
                    keyCount++;
                filter[index] = Std.parseInt(value);
            case "Count", "CountReset":
                var data : Array<Dynamic> = value.split("/");
                var totTime : Float = data[0];
                var totCount : Float = data[1];
                var freq : Float = data[2];
                
                if (frequency[index] == null) 
                    keyCount++;
                
                frequency[index] = freq;
                
                //no event on first time or reset
                if (countsGood[index] == true && setThing == "Count") 
                {
                    var timeChange : Int = Std.parseInt(totTime - totalTime[index]);
                    var cntChange : Int = Std.parseInt(totCount - totalCount[index]);
                    
                    totalTime[index] = totTime;
                    totalCount[index] = totCount;
                    
                    var eventData : Array<Dynamic>;
                    eventData = [timeChange, cntChange];
                    
                    if (isAttached) 
                        dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.COUNT, this, eventData, index));
                }
                else 
                {
                    totalTime[index] = totTime;
                    totalCount[index] = totCount;
                }
                countsGood[index] = true;
        }
    }
    override private function eventsAfterOpen() : Void
    {
        
    }
    
    //Getters
    /*
			Property: FrequencyInputCount
			Gets the number of inputs on this frequencycounter.
		*/
    private function get_FrequencyInputCount() : Int{
        if (numInputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numInputs;
    }
    /*
			Dynamic: getEnabled
			Gets the enabled state of an input.
			
			Parameters:
				index - input index
		*/
    public function getEnabled(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(enabled, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getFrequency
			Gets the frequency, in Hz.
			
			Parameters:
				index - input index
		*/
    public function getFrequency(index : Int) : Float{
        return Std.parseFloat(indexArray(frequency, index, numInputs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getFilter
			Gets the filter type for an input.
			
			Parameters:
				index - input index.
		*/
    public function getFilter(index : Int) : Int{
        return Std.parseInt(indexArray(filter, index, numInputs, PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_UNKNOWN));
    }
    /*
			Dynamic: getTimeout
			Gets the timeout for an input, in microseconds
			
			Parameters:
				index - input index.
		*/
    public function getTimeout(index : Int) : Int{
        return Std.parseInt(indexArray(timeout, index, numInputs, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getTotalCount
			Gets the total count of input pulses.
			
			Parameters:
				index - input index.
		*/
    public function getTotalCount(index : Int) : Float{
        return Std.parseFloat(indexArray(totalCount, index, numInputs, com.phidgets.Constants.PUNK_NUM));
    }
    /*
			Dynamic: getTotalTime
			Gets the total time of input pulses.
			
			Parameters:
				index - input index.
		*/
    public function getTotalTime(index : Int) : Float{
        return Std.parseFloat(indexArray(totalTime, index, numInputs, com.phidgets.Constants.PUNK_NUM));
    }
    
    //Setters
    /*
			Dynamic: setEnabled
			Enables/Disables an input.
			
			Parameters:
				index - input index
				val - state
		*/
    public function setEnabled(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Enabled", index, numInputs), Std.string(boolToInt(val)), true);
    }
    /*
			Dynamic: setFilter
			Sets the filter type for an input. Set to one of the defined filter types -
			 <PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_ZERO_CROSSING> - <PHIDGET_FREQUENCYCOUNTER_FILTERTYPE_LOGIC_LEVEL>.
			
			Parameters:
				index - input index
				val - state
		*/
    public function setFilter(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Filter", index, numInputs), Std.string(val), true);
    }
    /*
			Dynamic: setTimeout
			Sets the timout for an input, in microseconds.
			
			Parameters:
				index - input index
				val - state
		*/
    public function setTimeout(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Timeout", index, numInputs), Std.string(val), true);
    }
    /*
			Dynamic: reset
			Resets the totalCount and totalTime for an input.
		*/
    public function reset(val : Int) : Void{
        flip ^= 1;
        _phidgetSocket.setKey(makeKey("Reset"), Std.string(flip), true);
    }
}

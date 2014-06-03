package com.phidgets;

import com.phidgets.PhidgetError;

import com.phidgets.events.PhidgetDataEvent;


/*
		Class: PhidgetEncoder
		A class for controlling a PhidgetEncoder.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetEncoder. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.INPUT_CHANGE		- digital input change
		PhidgetDataEvent.POSITION_CHANGE	- position change
			-Note that this is a relative position change, not an absolute position.
	*/
class PhidgetEncoder extends Phidget
{
    public var InputCount(get, never) : Int;
    public var EncoderCount(get, never) : Int;

    private var numEncoders : Int;
    private var numInputs : Int;
    private var inputs : Array<Dynamic>;
    private var encoders : Array<Dynamic>;
    private var encoderIndexes : Array<Dynamic>;
    private var enabled : Array<Dynamic>;
    private var timeChanges : Array<Dynamic>;
    
    public function new()
    {
        super("PhidgetEncoder");
    }
    
    override private function initVars() : Void{
        numEncoders = com.phidgets.Constants.PUNK_INT;
        numInputs = com.phidgets.Constants.PUNK_INT;
        inputs = new Array<Dynamic>(4);
        timeChanges = new Array<Dynamic>(4);
        encoders = [0, 0, 0, 0];
        encoderIndexes = new Array<Dynamic>(4);
        enabled = new Array<Dynamic>(4);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfEncoders":
                numEncoders = Std.parseInt(value);
                keyCount++;
            case "NumberOfInputs":
                numInputs = Std.parseInt(value);
                keyCount++;
            case "Input":
                inputs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[index]), index));
            case "Position":
                var posnArray : Array<Dynamic> = value.split("/");
                encoders[index] = posnArray[2];
                
                timeChanges[index] = posnArray[0];
                if (timeChanges[index] >= 30000) 
                    timeChanges[index] = com.phidgets.Constants.PUNK_INT;
                
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.POSITION_CHANGE, this, Std.parseInt(posnArray[1]), index));
            case "ResetPosition":
                encoders[index] = value;
            case "IndexPosition":
                encoderIndexes[index] = value;
            case "Enabled":
                if (enabled[index] == null) 
                    keyCount++;
                enabled[index] = value;
        }
    }
    override private function eventsAfterOpen() : Void
    {
        var i : Int = 0;
        for (i in 0...numInputs){
            if (isKnown(inputs, i, com.phidgets.Constants.PUNK_BOOL)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.INPUT_CHANGE, this, intToBool(inputs[i]), i));
        }
    }
    
    //Getters
    /*
			Property: InputCount
			Gets the number of digital inputs supported by this encoder.
			Note that not all encoders support digital inputs.
		*/
    private function get_InputCount() : Int{
        if (numInputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numInputs;
    }
    /*
			Property: EncoderCount
			Gets the number of encoder inputs supported by this encoder.
		*/
    private function get_EncoderCount() : Int{
        if (numEncoders == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numEncoders;
    }
    /*
			Dynamic: getPosition
			Gets the absolute position of the encoder.
			
			Parameters:
				inputs - encoder index
		*/
    public function getPosition(index : Int) : Int{
        return Std.parseInt(indexArray(encoders, index, numEncoders, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getIndexPosition
			Gets the absolute position of the last index pulse. This is undefined until the first index pulse.
			
			Parameters:
				inputs - encoder index
		*/
    public function getIndexPosition(index : Int) : Int{
        return Std.parseInt(indexArray(encoderIndexes, index, numEncoders, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getTimeChange
			Gets the ammount of time that passed between the last two position change events, in milliseconds.
			This should be called from within the position change handler.
			
			Parameters:
				inputs - encoder index
		*/
    public function getTimeChange(index : Int) : Int{
        return Std.parseInt(indexArray(timeChanges, index, numEncoders, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Dynamic: getInputState
			Gets the state of a digital input.
			
			Parameters:
				index - digital input index
		*/
    public function getInputState(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(inputs, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Dynamic: getEnabled
			Gets the enabled state of an encoder
			
			Parameters:
				index - encoder index
		*/
    public function getEnabled(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(enabled, index, numInputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    
    //Setters
    /*
			Dynamic: setPosition
			Sets/Resets the position of the encoder.
			
			Parameters:
				index - encoder index
				val - position
		*/
    public function setPosition(index : Int, val : Int) : Void{
        _phidgetSocket.setKey(makeIndexedKey("ResetPosition", index, numEncoders), Std.string(val), true);
    }
    /*
			Dynamic: setEnabled
			Sets the enabled state of an encoder
			
			Parameters:
				index - encoder index
				val - true/false
		*/
    public function setEnabled(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Enabled", index, numEncoders), Std.string(boolToInt(val)), true);
    }
}

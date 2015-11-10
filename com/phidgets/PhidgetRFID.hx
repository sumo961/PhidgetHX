package com.phidgets;

import com.phidgets.PhidgetRFIDTag;

import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetRFID
		A class for controlling a PhidgetRFID.
		See your product manual for more specific API details, supported functionality, units, etc.
		
		Topic: Events
		Events supported by PhidgetRFID. Pass these constants to the addEventListener() function when adding event listeners to a Phidget object.
		
		PhidgetDataEvent.OUTPUT_CHANGE	- digital output change
		PhidgetDataEvent.TAG			- rfid tag detected
		PhidgetDataEvent.TAG_LOST		- rfid tag removed
		
	*/
class PhidgetRFID extends Phidget
{
    public var OutputCount(get, never) : Int;
    public var Antenna(get, set) : Bool;
    public var LED(get, set) : Bool;
    public var TagPresent(get, never) : Bool;

    private var numOutputs : Int;
    
    private var lastTag : String;
    private var lastTagProtocol : Int;
    private var tagState : Int;
    private var lastTagValid : Int;
    private var antennaState : Int;
    private var ledState : Int;
    private var outputs : Array<Dynamic>;
    
    /*
			Constants: RFID Protocols
			These are the protocols supported by the PhidgetRFID. These constants are used with <write> and <getLastTagProtocol>.
			
			PHIDGET_RFID_PROTOCOL_EM4100 - EM4100 (EM4102) 40-bit.
			PHIDGET_RFID_PROTOCOL_ISO11785_FDX_B - ISO11785 FDX-B encoding (Animal ID).
			PHIDGET_RFID_PROTOCOL_PHIDGETS - PhidgetsTAG Protocol 24 character ASCII.
		*/
    public static inline var PHIDGET_RFID_PROTOCOL_EM4100 : Int = 1;
    public static inline var PHIDGET_RFID_PROTOCOL_ISO11785_FDX_B : Int = 2;
    public static inline var PHIDGET_RFID_PROTOCOL_PHIDGETS : Int = 3;
    
    public function new()
    {
        super("PhidgetRFID");
       // super();
        trace("new PhidgetRFID");
    }
    
    override private function initVars() : Void{
        numOutputs = com.phidgets.Constants.PUNK_INT;
        lastTag = null;
        lastTagProtocol = 0;
        outputs = new Array<Dynamic>();
        lastTagValid = com.phidgets.Constants.PUNI_BOOL;
        tagState = com.phidgets.Constants.PUNI_BOOL;
        antennaState = com.phidgets.Constants.PUNI_BOOL;
        ledState = com.phidgets.Constants.PUNI_BOOL;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        trace ("setThing"+setThing);
        switch (setThing)
        {
            case "NumberOfOutputs":
                numOutputs = Std.parseInt(value);
                keyCount++;
            case "LastTag":
                lastTagProtocol = Std.parseInt(value.split("/")[0]);
                lastTag = value.substring(value.indexOf("/") + 1);
                if (lastTagValid == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                lastTagValid = com.phidgets.Constants.PTRUE;
            case "Tag2":
                if (tagState == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                tagState = com.phidgets.Constants.PTRUE;
                var tagString : String = value.substring(value.indexOf("/") + 1);
                var tagProto : Int = Std.parseInt(value.split("/")[0]);
                if (isAttached) 
                    dispatchEvent(
                        new PhidgetDataEvent(
                            PhidgetDataEvent.TAG, this, 
                                new PhidgetRFIDTag(
                                    tagString, 
                                    tagProto 
                                ) 
                            )
                        );
                lastTag = tagString;
                lastTagProtocol = tagProto;
            case "TagLoss2":
                if (tagState == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                tagState = com.phidgets.Constants.PFALSE;
                if (isAttached) 
                    dispatchEvent(
                        new PhidgetDataEvent(
                        PhidgetDataEvent.TAG_LOST, this, 
                        new PhidgetRFIDTag(
                        value.substring(value.indexOf("/") + 1), 
                        Std.parseInt(value.split("/")[0]) 
                        ) 
                        ));
            case "TagState":
                if (tagState == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                tagState = Std.parseInt(value);
            case "AntennaOn":
                if (antennaState == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                antennaState = Std.parseInt(value);
            case "LEDOn":
                if (ledState == com.phidgets.Constants.PUNI_BOOL) 
                    keyCount++;
                ledState = Std.parseInt(value);
            case "Output":
                if (outputs[index] == null) 
                    keyCount++;
                outputs[index] = value;
                if (isAttached) 
                    dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE, this, intToBool(outputs[index]), index));
        }
    }
    
    override private function eventsAfterOpen() : Void
    {
        for (i in 0...numOutputs){
            if (isKnown(outputs, i, com.phidgets.Constants.PUNK_BOOL)) 
                dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.OUTPUT_CHANGE, this, intToBool(outputs[i]), i));
        }
        if (tagState == com.phidgets.Constants.PTRUE) 
            dispatchEvent(new PhidgetDataEvent(PhidgetDataEvent.TAG, this, new PhidgetRFIDTag(lastTag, lastTagProtocol)));
    }
    
    
    //Getters
    /*
			Property: OutputCount
			Gets the number of digital outputs supported by this board.
		*/
    private function get_OutputCount() : Int{
        if (numOutputs == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numOutputs;
    }
    /*
			Property: Antenna
			Gets the antenna state.
		*/
    private function get_Antenna() : Bool{
        if (antennaState == com.phidgets.Constants.PUNK_BOOL || antennaState == com.phidgets.Constants.PUNI_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return intToBool(antennaState);
    }
    /*
			Property: LED
			Gets the onboard LED state.
		*/
    private function get_LED() : Bool{
        if (ledState == com.phidgets.Constants.PUNK_BOOL || ledState == com.phidgets.Constants.PUNI_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return intToBool(ledState);
    }
    /*
			Property: TagPresent
			Gets whether a tag is currently being detected by the reader.
		*/
    private function get_TagPresent() : Bool{
        if (tagState == com.phidgets.Constants.PUNK_BOOL || tagState == com.phidgets.Constants.PUNI_BOOL) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return intToBool(tagState);
    }
    /*
			Property: Antenna
			Sets the antenna state.
			Note that the antenna is initially disabled and must be enabled before any tags will be read.
			
			Parameters:
				val - antenna state
		*/
    private function set_Antenna(val : Bool) : Bool{
        _phidgetSocket.setKey(makeKey("AntennaOn"), Std.string(boolToInt(val)), true);
        return val;
    }
    /*
			Property: LED
			Sets the onboard LED state.
			
			Parameters:
				val - led state
		*/
    private function set_LED(val : Bool) : Bool{
        _phidgetSocket.setKey(makeKey("LEDOn"), Std.string(boolToInt(val)), true);
        return val;
    }
    
    /*
			Dynamic: getLastTag
			Gets the last tag read. This tag may or may not still be on the reader.
		*/
    public function getLastTag() : PhidgetRFIDTag{
        if (lastTag == null) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return new PhidgetRFIDTag(lastTag, lastTagProtocol);
    }
    /*
			Dynamic: getOutputState
			Gets the state of a digital output.
			
			Parameters:
				index - digital output index
		*/
    public function getOutputState(index : Int) : Bool{
        return intToBool(Std.parseInt(indexArray(outputs, index, numOutputs, com.phidgets.Constants.PUNK_BOOL)));
    }
    
    //Setters
    /*
			Dynamic: setOutputState
			Sets the state of a digital output.
			
			Parameters:
				index - digital output index
				val - output state
		*/
    public function setOutputState(index : Int, val : Bool) : Void{
        _phidgetSocket.setKey(makeIndexedKey("Output", index, numOutputs), Std.string(boolToInt(val)), true);
    }
    
    /*
			Dynamic: write
			Write a tag.
			
			Parameters:
				tag - tag string and protocol.
				lock - lock the tag from being written again. Defaults to FALSE.
		*/
    public function write(tag : PhidgetRFIDTag, lock : Bool = false) : Void{
        _phidgetSocket.setKey(makeKey("WriteTag"), tag.Protocol + "/" + boolToInt(lock) + "/" + tag.Tag, true);
    }
}

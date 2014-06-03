package com.phidgets;


/*
		Class: PhidgetRFIDTag
		Represents an RFID Tag, as recieved via the RFID Tag events
	*/
class PhidgetRFIDTag
{
    public var Protocol(get, never) : Int;
    public var Tag(get, never) : String;

    private var protocol : Int;
    private var tagString : String;
    
    public function new(tag : String, protocol : Int)
    {
        this.tagString = tag;
        this.protocol = protocol;
    }
    
    /*
			Property: Protocol
			Gets the Tag Protocol
		*/
    private function get_Protocol() : Int{
        return protocol;
    }
    /*
			Property: Tag
			Gets the Tag string
		*/
    private function get_Tag() : String{
        return tagString;
    }
    
    public function toString() : String{
        return tagString;
    }
}

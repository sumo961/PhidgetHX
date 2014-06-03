package com.phidgets;



/*
		Class: PhidgetIRCode
		A class for storing an IR code.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetIRCode
{
    public var Code(get, never) : String;
    public var BitCount(get, never) : Int;
    public var Repeat(get, never) : Bool;

    private var hexlookup : Array<Dynamic> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];
    
    private var code : String;
    private var bitCount : Int;
    private var repeat : Bool;
    
    public function new(code : String, bitCount : Int, repeat : Bool = false)
    {
        this.code = code;
        this.bitCount = bitCount;
        this.repeat = repeat;
    }
    
    /*
			Property: Code
			Gets the IR code string.
		*/
    private function get_Code() : String{
        return code;
    }
    /*
			Property: BitCount
			Gets the bit count of the IR Code
		*/
    private function get_BitCount() : Int{
        return bitCount;
    }
    /*
			Property: Repeat
			Gets the repeat state for this code. This is used in the CODE event when an incoming code is being repeated.
		*/
    private function get_Repeat() : Bool{
        return repeat;
    }
    
    public function toString() : String{
        return code;
    }
}

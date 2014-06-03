package com.phidgets;


import com.phidgets.Constants;
import com.phidgets.events.PhidgetEvent;
import flash.events.EventDispatcher;
/*
		Class: PhidgetIRCodeInfo
		A class for storing Code parameters, used for transmitting codes.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetIRCodeInfo
{
    /*
			Constants: IR Encodings
			These are the supported encoding types for the PhidgetIR. These constants are used with <Encoding>.
			
			ENCODING_UNKNOWN - Unknown Encoding.
			ENCODING_SPACE - Space Encoding.
			ENCODING_PULSE - Pulse Encoding.
			ENCODING_BIPHASE - BiPhase Encoding.
			ENCODING_RC5 - RC5 Encoding.
			ENCODING_RC6 - RC6 Encoding.
		*/
    public static inline var ENCODING_UNKNOWN : Int = 1;
    public static inline var ENCODING_SPACE : Int = 2;
    public static inline var ENCODING_PULSE : Int = 3;
    public static inline var ENCODING_BIPHASE : Int = 4;
    public static inline var ENCODING_RC5 : Int = 5;
    public static inline var ENCODING_RC6 : Int = 6;
    
    /*
			Constants: IR Code length styles
			These are the supported code length styles for the PhidgetIR. These constants are used with <Length>.
			
			CODE_LENGTH_UNKNOWN - Unknown length.
			CODE_LENGTH_CONSTANT - Constant - the bitstream + gap length is constant.
			CODE_LENGTH_VARIABLE - Variable - the bitstream has a variable length with a constant gap.
		*/
    public static inline var CODE_LENGTH_UNKNOWN : Int = 1;
    public static inline var CODE_LENGTH_CONSTANT : Int = 2;
    public static inline var CODE_LENGTH_VARIABLE : Int = 3;
    
    /*
			Variable: Encoding
			IR Code encoding.
		*/
    public var Encoding : Int = ENCODING_UNKNOWN;
    /*
			Variable: Length
			IR Code length style.
		*/
    public var Length : Int = CODE_LENGTH_UNKNOWN;
    /*
			Variable: BitCount
			IR Code bit count.
		*/
    public var BitCount : Int = 32;
    /*
			Variable: Gap
			IR Code gap in microseconds.
		*/
    public var Gap : Int = 0;
    /*
			Variable: Trail
			IR Code trailing pulse in microseconds.
		*/
    public var Trail : Int = 0;
    /*
			Variable: Header
			IR Code header. Can be null, or a two-element array (pulse and space in microseconds).
		*/
    public var Header : Array<Dynamic> = [0, 0];
    /*
			Variable: One
			IR Code one - pulse and space in microseconds representing a '1'.
		*/
    public var One : Array<Dynamic> = [0, 0];
    /*
			Variable: Zero
			IR Code zero - pulse and space in microseconds representing a '0'.
		*/
    public var Zero : Array<Dynamic> = [0, 0];
    /*
			Variable: MinRepeat
			Number of times to repeat the code on transmit.
		*/
    public var MinRepeat : Int = 0;
    /*
			Variable: ToggleMask
			Mask of bits to toggle on each repeat.
		*/
    public var ToggleMask : String;
    /*
			Variable: Repeat
			Repeat code. Must begin and end with a pulse.
		*/
    public var Repeat : Array<Dynamic>;
    /*
			Variable: CarrierFrequency
			Carrier Frequency. Defaults to 38000kHz.
		*/
    public var CarrierFrequency : Int = 38000;
    /*
			Variable: DutyCycle
			IR LED duty cycle. Defaults to 33%.
		*/
    public var DutyCycle : Int = 33;
    
    /*
			Constructor: PhidgetIRCodeInfo
			Creates a new PhidgetIRCodeInfo object. All arguments are optional - defaults will be filled in for any arguments left out.
		*/
    public function new(
            bitCount : Int = 32,
            encoding : Int = ENCODING_UNKNOWN,
            header : Array<Dynamic> = null,
            zero : Array<Dynamic> = null,
            one : Array<Dynamic> = null,
            trail : Int = 0,
            gap : Int = 0,
            repeat : Array<Dynamic> = null,
            minRepeat : Int = 0,
            toggleMask : String = null,
            Length : Int = CODE_LENGTH_UNKNOWN,
            carrierFrequency : Int = 38000,
            dutyCycle : Int = 33)
    {
        BitCount = bitCount;
        Encoding = encoding;
        if (header != null) 
        {
            if (header.Length != 2) 
                throw new PhidgetError(com.phidgets.Constants.EPHIDGET_INVALIDARG);
            Header = new Array<Dynamic>(header[0], header[1]);
        }
        if (zero != null) 
        {
            if (zero.Length != 2) 
                throw new PhidgetError(com.phidgets.Constants.EPHIDGET_INVALIDARG);
            Zero = new Array<Dynamic>(zero[0], zero[1]);
        }
        if (one != null) 
        {
            if (one.Length != 2) 
                throw new PhidgetError(com.phidgets.Constants.EPHIDGET_INVALIDARG);
            One = new Array<Dynamic>(one[0], one[1]);
        }
        Trail = trail;
        Gap = gap;
        if (repeat != null) 
        {
            Repeat = new Array<Dynamic>(repeat.Length);
            for (i in 0...repeat.Length){Repeat[i] = repeat[i];
            }
        }
        MinRepeat = minRepeat;
        ToggleMask = toggleMask;
        Length = length;
        CarrierFrequency = carrierFrequency;
        DutyCycle = dutyCycle;
    }
    
    //flips from MSB to LSB after padding to 32-bit
    private function flipString(str : String) : String{
        var outStr : String = "";
        while (str.length < 8)
        str = "0" + str;
        var i : Int = str.length - 2;
        while (i >= 0){outStr = outStr + str.substring(i, i + 2);
            i -= 2;
        }
        return outStr;
    }
    
    private var IR_MAX_CODE_BIT_COUNT : Int = 128  /**< Maximum bit count for sent / received data */  ;
    private var IR_MAX_CODE_DATA_LENGTH : Int = (IR_MAX_CODE_BIT_COUNT / 8)  /**< Maximum array size needed to hold the longest code */  ;
    private var IR_MAX_REPEAT_LENGTH : Int = 26  /**< Maximum array size for a repeat code */  ;
    public function toString() : String{
        var codeString : String = "";
        codeString = codeString + flipString(Std.string(BitCount));
        codeString = codeString + flipString(Std.string(Encoding));
        codeString = codeString + flipString(Std.string(Length));
        codeString = codeString + flipString(Std.string(Gap));
        codeString = codeString + flipString(Std.string(Trail));
        codeString = codeString + flipString(Std.string(Header[0]));
        codeString = codeString + flipString(Std.string(Header[1]));
        codeString = codeString + flipString(Std.string(One[0]));
        codeString = codeString + flipString(Std.string(One[1]));
        codeString = codeString + flipString(Std.string(Zero[0]));
        codeString = codeString + flipString(Std.string(Zero[1]));
        for (i in 0...IR_MAX_REPEAT_LENGTH){
            if (Repeat.length > i) 
                codeString = codeString + flipString(Std.string(Repeat[i]))
            else 
            codeString = codeString + "00000000";
        }
        codeString = codeString + flipString(Std.string(MinRepeat));
        i = IR_MAX_CODE_DATA_LENGTH * 2;
        while (ToggleMask.length < i--)
        {
            codeString = codeString + "0";
        }
        codeString = codeString + ToggleMask;
        codeString = codeString + flipString(Std.string(CarrierFrequency));
        codeString = codeString + flipString(Std.string(DutyCycle));
        return codeString;
    }
}

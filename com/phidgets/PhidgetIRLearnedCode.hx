package com.phidgets;



/*
		Class: PhidgetIRLearnedCode
		A class for storing a learned IR code.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetIRLearnedCode
{
    public var Code(get, never) : String;
    public var CodeInfo(get, never) : PhidgetIRCodeInfo;

    private var code : String;
    private var codeInfo : PhidgetIRCodeInfo;
    
    public function new(code : String, codeInfo : PhidgetIRCodeInfo)
    {
        this.code = code;
        this.codeInfo = codeInfo;
    }
    
    /*
			Property: Code
			Gets the IR code.
		*/
    private function get_Code() : String{
        return code;
    }
    /*
			Property: CodeInfo
			Gets the IR code properties.
		*/
    private function get_CodeInfo() : PhidgetIRCodeInfo{
        return codeInfo;
    }
    
    public function toString() : String{
        return code;
    }
    
    //This all depends on the CPhidgetIR_CodeInfo structure in the C code not changing!
    private static var IR_MAX_CODE_BIT_COUNT : Int = 128  /**< Maximum bit count for sent / received data */  ;
    private static var IR_MAX_CODE_DATA_LENGTH : Int = (IR_MAX_CODE_BIT_COUNT / 8)  /**< Maximum array size needed to hold the longest code */  ;
    private static var IR_MAX_REPEAT_LENGTH : Int = 26  /**< Maximum array size for a repeat code */  ;
    
    private static function bitCountToByteCount(bits : Int) : Int{
        var bytes : Int = bits / 8;
        if (bits % 8) 
            bytes++;
        return bytes;
    }
    
    //flips from MSB to LSB
    private static function flipString(str : String) : String{
        var outStr : String = "";
        var i : Int = str.length - 2;
        while (i >= 0){outStr = outStr + str.substring(i, i + 2);
            i -= 2;
        }
        return outStr;
    }
    
    @:allow(com.phidgets)
    private static function stringToPhidgetIRLearnedCode(str : String) : PhidgetIRLearnedCode
    {
        var codeInfo : PhidgetIRCodeInfo = new PhidgetIRCodeInfo();
        var ptr : Int = 0;
        var i : Int = 0;
        var byteCount : Int;
        
        codeInfo.Repeat = new Array<Dynamic>(IR_MAX_REPEAT_LENGTH);
        
        codeInfo.BitCount = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        byteCount = bitCountToByteCount(codeInfo.BitCount);
        codeInfo.Encoding = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Length = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Gap = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Trail = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Header[0] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Header[1] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.One[0] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.One[1] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Zero[0] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.Zero[1] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        for (i in 0...IR_MAX_REPEAT_LENGTH){
            codeInfo.Repeat[i] = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        }
        codeInfo.MinRepeat = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.ToggleMask = "";
        i = (IR_MAX_CODE_DATA_LENGTH * 2) - 2;
        while (i >= 0){
            if (((IR_MAX_CODE_DATA_LENGTH * 2) - i) <= (byteCount * 2)) 
                codeInfo.ToggleMask = codeInfo.ToggleMask + str.substring(ptr, ptr + 2);
            ptr += 2;
            i -= 2;
        }
        codeInfo.CarrierFrequency = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        codeInfo.DutyCycle = Std.parseInt("0x" + flipString(str.substring(ptr, ptr + 8)));ptr += 8;
        
        var code : String = str.substring(ptr, ptr + byteCount * 2);
        var learnedCode : PhidgetIRLearnedCode = new PhidgetIRLearnedCode(code, codeInfo);
        
        return learnedCode;
    }
}

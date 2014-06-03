package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetTextLED
		A class for controlling a PhidgetTextLED.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetTextLED extends Phidget
{
    public var RowCount(get, never) : Int;
    public var ColumnCount(get, never) : Int;
    public var Brightness(get, set) : Int;

    private var numRows : Int = com.phidgets.Constants.PUNK_INT;
    private var numColumns : Int = com.phidgets.Constants.PUNK_INT;
    private var brightness : Int = com.phidgets.Constants.PUNK_INT;
    
    public function new()
    {
        super("PhidgetTextLED");
    }
    
    override private function initVars() : Void{
        numRows = com.phidgets.Constants.PUNK_INT;
        numColumns = com.phidgets.Constants.PUNK_INT;
        brightness = com.phidgets.Constants.PUNK_INT;
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfRows":
                numRows = Std.parseInt(value);
                keyCount++;
            case "NumberOfColumns":
                numColumns = Std.parseInt(value);
                keyCount++;
            case "Brightness":
                brightness = Std.parseInt(value);
        }
    }
    
    //Getters
    /*
			Property: RowCount
			Gets the number of rows supported by the TextLED.
		*/
    private function get_RowCount() : Int{
        if (numRows == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numRows;
    }
    /*
			Property: ColumnCount
			Gets the number of columns per row supported by this TexlLED
		*/
    private function get_ColumnCount() : Int{
        if (numColumns == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numColumns;
    }
    /*
			Property: Brightness
			Gets the brightness of the display.
		*/
    private function get_Brightness() : Int{
        if (brightness == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return brightness;
    }
    
    //Setters
    /*
			Property: Brightness
			Sets the brightness of the display (0-100).
			
			Parameters:
				val - brightness
		*/
    private function set_Brightness(val : Int) : Int{
        _phidgetSocket.setKey(makeKey("brightness"), Std.string(val), true);
        return val;
    }
    /*
			Dynamic: setDisplayString
			Sets the display string for a row.
			
			Parameters:
				index - row
				val - display string
		*/
    public function setDisplayString(index : Int, val : String) : Void{
        _phidgetSocket.setKey(makeIndexedKey("DisplayString", index, numRows), val, true);
    }
}

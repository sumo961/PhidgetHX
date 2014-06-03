package com.phidgets;


import com.phidgets.events.PhidgetDataEvent;

/*
		Class: PhidgetTextLCD
		A class for controlling a PhidgetTextLCD.
		See your product manual for more specific API details, supported functionality, units, etc.
	*/
class PhidgetTextLCD extends Phidget
{
    public var ScreenCount(get, never) : Int;
    public var RowCount(get, never) : Int;
    public var ColumnCount(get, never) : Int;
    public var Backlight(get, set) : Bool;
    public var Cursor(get, set) : Bool;
    public var CursorBlink(get, set) : Bool;
    public var Contrast(get, set) : Int;
    public var Brightness(get, set) : Int;
    public var ScreenSize(get, set) : Int;
    public var Screen(get, set) : Int;

    private var numScreens : Int;
    private var numRows : Array<Dynamic>;
    private var numColumns : Array<Dynamic>;
    private var backlight : Array<Dynamic>;
    private var cursorOn : Array<Dynamic>;
    private var cursorBlink : Array<Dynamic>;
    private var contrast : Array<Dynamic>;
    private var brightness : Array<Dynamic>;
    private var init : Array<Dynamic>;
    private var screenSize : Array<Dynamic>;
    
    private var currentScreen : Int;
    
    /*
			Constants: Screen Sizes
			These are the Screen sizes supported by the various PhidgetTextLCDs. These constants are used with <getScreenSize> and <setScreenSize>.
			
			PHIDGET_TEXTLCD_SCREEN_NONE - no screen attached
			PHIDGET_TEXTLCD_SCREEN_1x8 - 1 row, 8 column screen
			PHIDGET_TEXTLCD_SCREEN_2x8 - 2 row, 8 column screen
			PHIDGET_TEXTLCD_SCREEN_1x16 - 1 row, 16 column screen
			PHIDGET_TEXTLCD_SCREEN_2x16 - 2 row, 16 column screen
			PHIDGET_TEXTLCD_SCREEN_4x16 - 4 row, 16 column screen
			PHIDGET_TEXTLCD_SCREEN_2x20 - 2 row, 20 column screen
			PHIDGET_TEXTLCD_SCREEN_4x20 - 4 row, 20 column screen
			PHIDGET_TEXTLCD_SCREEN_2x24 - 2 row, 24 column screen
			PHIDGET_TEXTLCD_SCREEN_1x40 - 1 row, 40 column screen
			PHIDGET_TEXTLCD_SCREEN_2x40 - 2 row, 40 column screen
			PHIDGET_TEXTLCD_SCREEN_4x40 - 4 row, 40 column screen (special case, requires both screen connections)
			PHIDGET_TEXTLCD_SCREEN_UNKNOWN - Screen size is unknown
		*/
    public static inline var PHIDGET_TEXTLCD_SCREEN_NONE : Int = 1;
    public static inline var PHIDGET_TEXTLCD_SCREEN_1x8 : Int = 2;
    public static inline var PHIDGET_TEXTLCD_SCREEN_2x8 : Int = 3;
    public static inline var PHIDGET_TEXTLCD_SCREEN_1x16 : Int = 4;
    public static inline var PHIDGET_TEXTLCD_SCREEN_2x16 : Int = 5;
    public static inline var PHIDGET_TEXTLCD_SCREEN_4x16 : Int = 6;
    public static inline var PHIDGET_TEXTLCD_SCREEN_2x20 : Int = 7;
    public static inline var PHIDGET_TEXTLCD_SCREEN_4x20 : Int = 8;
    public static inline var PHIDGET_TEXTLCD_SCREEN_2x24 : Int = 9;
    public static inline var PHIDGET_TEXTLCD_SCREEN_1x40 : Int = 10;
    public static inline var PHIDGET_TEXTLCD_SCREEN_2x40 : Int = 11;
    public static inline var PHIDGET_TEXTLCD_SCREEN_4x40 : Int = 12;
    public static inline var PHIDGET_TEXTLCD_SCREEN_UNKNOWN : Int = 13;
    
    public function new()
    {
        super("PhidgetTextLCD");
    }
    
    override private function initVars() : Void{
        currentScreen = 0;
        
        numScreens = com.phidgets.Constants.PUNK_INT;
        numColumns = new Array<Dynamic>(2);
        numRows = new Array<Dynamic>(2);
        backlight = new Array<Dynamic>(2);
        cursorOn = new Array<Dynamic>(2);
        cursorBlink = new Array<Dynamic>(2);
        contrast = new Array<Dynamic>(2);
        brightness = new Array<Dynamic>(2);
        init = new Array<Dynamic>(2);
        init[0] = 0;init[1] = 0;
        screenSize = new Array<Dynamic>(2);
    }
    
    override private function onSpecificPhidgetData(setThing : String, index : Int, value : String) : Void{
        switch (setThing)
        {
            case "NumberOfScreens":
                numScreens = Std.parseInt(value);
                keyCount++;
            case "NumberOfRows":
                if (numRows[index] == null) 
                    keyCount++;
                numRows[index] = Std.parseInt(value);
            case "NumberOfColumns":
                if (numColumns[index] == null) 
                    keyCount++;
                numColumns[index] = Std.parseInt(value);
            case "Backlight":
                if (backlight[index] == null) 
                    keyCount++;
                backlight[index] = Std.parseInt(value);
            case "CursorOn":
                cursorOn[index] = Std.parseInt(value);
            case "CursorBlink":
                cursorBlink[index] = Std.parseInt(value);
            case "Contrast":
                if (contrast[index] == null) 
                    keyCount++;
                contrast[index] = Std.parseInt(value);
            case "Brightness":
                if (brightness[index] == null) 
                    keyCount++;
                brightness[index] = Std.parseInt(value);
            case "ScreenSize":
                if (screenSize[index] == null) 
                    keyCount++;
                screenSize[index] = Std.parseInt(value);
        }
    }
    
    //Getters
    /*
			Property: ScreenCount
			Gets the number of screens available on the LCD.
		*/
    private function get_ScreenCount() : Int{
        if (numScreens == com.phidgets.Constants.PUNK_INT) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_UNKNOWNVAL);
        return numScreens;
    }
    /*
			Property: RowCount
			Gets the number of rows available on the LCD.
		*/
    private function get_RowCount() : Int{
        return Std.parseInt(indexArray(numRows, currentScreen, numScreens, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Property: ColumnCount
			Gets the number of columns available per row on the LCD.
		*/
    private function get_ColumnCount() : Int{
        return Std.parseInt(indexArray(numColumns, currentScreen, numScreens, com.phidgets.Constants.PUNK_INT));
    }
    /*
			Property: Backlight
			Gets tha state of the backlight.
		*/
    private function get_Backlight() : Bool{
        return intToBool(Std.parseInt(indexArray(backlight, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Property: Cursor
			Gets the visible state of the cursor.
		*/
    private function get_Cursor() : Bool{
        return intToBool(Std.parseInt(indexArray(cursorOn, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Property: CursorBlink
			Gets the blinking state of the cursor.
		*/
    private function get_CursorBlink() : Bool{
        return intToBool(Std.parseInt(indexArray(cursorBlink, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL)));
    }
    /*
			Property: Contrast
			Gets the last set contrast value.
		*/
    private function get_Contrast() : Int{
        return Std.parseInt(indexArray(contrast, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL));
    }
    /*
			Property: Brightness
			Gets the last set brightness value.
		*/
    private function get_Brightness() : Int{
        return Std.parseInt(indexArray(brightness, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL));
    }
    /*
			Property: ScreenSize
			Gets the screen size.
		*/
    private function get_ScreenSize() : Int{
        return Std.parseInt(indexArray(screenSize, currentScreen, numScreens, com.phidgets.Constants.PUNK_BOOL));
    }
    /*
			Property: Screen
			Gets the active screen. This is the screen that will respond to all commands.
		*/
    private function get_Screen() : Int{
        return currentScreen;
    }
    
    //Setters
    /*
			Property: Backlight
			Sets the backlight state.
			
			Parameters:
				val - backlight state
		*/
    private function set_Backlight(val : Bool) : Bool{
        _phidgetSocket.setKey(makeIndexedKey("Backlight", currentScreen, numScreens), Std.string(boolToInt(val)), true);
        return val;
    }
    /*
			Property: Cursor
			Sets the cursor (visible) state.
			
			Parameters:
				val - cursor state
		*/
    private function set_Cursor(val : Bool) : Bool{
        _phidgetSocket.setKey(makeIndexedKey("CursorOn", currentScreen, numScreens), Std.string(boolToInt(val)), true);
        return val;
    }
    /*
			Property: CursorBlink
			Sets the cursor blink state.
			
			Parameters:
				val - cursor blink state
		*/
    private function set_CursorBlink(val : Bool) : Bool{
        _phidgetSocket.setKey(makeIndexedKey("CursorBlink", currentScreen, numScreens), Std.string(boolToInt(val)), true);
        return val;
    }
    /*
			Property: Contrast
			Sets the contrast (0-255).
			
			Parameters:
				val - contrast
		*/
    private function set_Contrast(val : Int) : Int{
        _phidgetSocket.setKey(makeIndexedKey("Contrast", currentScreen, numScreens), Std.string(val), true);
        return val;
    }
    /*
			Property: Brightness
			Sets the brightness of the backlight (0-255).
			
			Parameters:
				val - brightness
		*/
    private function set_Brightness(val : Int) : Int{
        _phidgetSocket.setKey(makeIndexedKey("Brightness", currentScreen, numScreens), Std.string(val), true);
        return val;
    }
    /*
			Property: ScreenSize
			Sets the screen size. Choose from one of the defined screen size constants.
			Note that not all PhidgetTextLCDs support setting screen size.
			
			Parameters:
				val - screen size
		*/
    private function set_ScreenSize(val : Int) : Int{
        _phidgetSocket.setKey(makeIndexedKey("ScreenSize", currentScreen, numScreens), Std.string(val), true);
        return val;
    }
    /*
			Property: Screen
			Sets the active screen. This is the screen that subsequent commands will target.
			
			Parameters:
				val - screen
		*/
    private function set_Screen(val : Int) : Int{
        if (val >= numScreens || val < 0) 
            throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
        currentScreen = val;
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
        var ind : Int = (index << 8) + currentScreen;
        _phidgetSocket.setKey(makeIndexedKey("DisplayString", ind, 0xffff), val, true);
    }
    /*
			Dynamic: setDisplayCharacter
			Sets the character at a row and column. Send a one character string.
			
			Parameters:
				row - row
				column - column
				val - character
		*/
    public function setDisplayCharacter(row : Int, column : Int, val : String) : Void{
        var index : Int = (column << 16) + (row << 8) + currentScreen;
        _phidgetSocket.setKey(makeIndexedKey("DisplayCharacter", index, 0xffffff), val, true);
    }
    /*
			Dynamic: setCustomCharacter
			Creates a custom character. See the product manual for more information.
			
			Parameters:
				index - character index (8-15)
				val1 - character data 1
				val2 - character data 2
		*/
    public function setCustomCharacter(index : Int, val1 : Int, val2 : Int) : Void{
        var ind : Int = (index << 8) + currentScreen;
        var key : String = makeIndexedKey("CustomCharacter", ind, 0xffff);
        if (index < 8)             throw new PhidgetError(com.phidgets.Constants.EPHIDGET_OUTOFBOUNDS);
        var val : String = val1 + "," + val2;
        _phidgetSocket.setKey(key, val, true);
    }
    /*
			Dynamic: initialize
			Initializes a screen. This should be called after setting the screen size.
		*/
    public function initialize() : Void{
        init[currentScreen] ^= 1;
        _phidgetSocket.setKey(makeIndexedKey("Init", currentScreen, numScreens), Std.string(init[currentScreen]), true);
    }
}

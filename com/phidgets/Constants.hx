package com.phidgets;



/*
	   Class: Constants
	 */
class Constants
{
    public static var Phid_DeviceSpecificName(get, never) : Array<String>;

    /*
		   Constants: Error Codes
		   Error codes that can show up in <PhidgetError> exceptions.
		
		   EPHIDGET_UNEXPECTED	- unknown error occured
		   EPHIDGET_INVALIDARG	- invalid argument passed to function
		   EPHIDGET_UNKNOWNVAL	- state not yet recieved from device
		   EPHIDGET_UNSUPPORTED	- function not supported for this device, or not yet implemented
		   EPHIDGET_OUTOFBOUNDS	- tried to index past the end of an array
		 */
    public static inline var EPHIDGET_UNEXPECTED : Int = 3;
    public static inline var EPHIDGET_INVALIDARG : Int = 4;
    public static inline var EPHIDGET_UNKNOWNVAL : Int = 9;
    public static inline var EPHIDGET_UNSUPPORTED : Int = 11;
    public static inline var EPHIDGET_OUTOFBOUNDS : Int = 14;
    
    /*
		   Constants: Error Event Codes
		   Error event codes that can show up in <PhidgetErrorEvent.ERROR> events.
		
		   Networks related errors:
		
		   EPHIDGET_NETWORK	- network error
		   EPHIDGET_BADPASSWORD	- wrong password specified
		   EPHIDGET_NETWORK_NOTCONNECTED	- not connected error
		   EPHIDGET_BADVERSION	- webservice and client version mismatch
		
		   Phidget related errors:
		
		   EEPHIDGET_OK	- An error state has ended - see description for details.
		   EEPHIDGET_OVERRUN	- A sampling overrun happend in firmware.
		   EEPHIDGET_PACKETLOST	- One or more packets were lost.
		   EEPHIDGET_WRAP	- A variable has wrapped around.
		   EEPHIDGET_OVERTEMP	- Overtemperature condition detected.
		   EEPHIDGET_OVERCURRENT	- Overcurrent condition detected.
		   EEPHIDGET_OUTOFRANGE	- Out of range condition detected.
		   EEPHIDGET_BADPOWER	- Power supply problem detected.
		 */
    public static inline var EPHIDGET_NETWORK : Int = 8;
    public static inline var EPHIDGET_BADPASSWORD : Int = 10;
    public static inline var EPHIDGET_NETWORK_NOTCONNECTED : Int = 16;
    public static inline var EPHIDGET_BADVERSION : Int = 19;
    
    public static inline var EEPHIDGET_OK : Int = 0x9000;
    public static inline var EEPHIDGET_OVERRUN : Int = 0x9002;
    public static inline var EEPHIDGET_PACKETLOST : Int = 0x9003;
    public static inline var EEPHIDGET_WRAP : Int = 0x9004;
    public static inline var EEPHIDGET_OVERTEMP : Int = 0x9005;
    public static inline var EEPHIDGET_OVERCURRENT : Int = 0x9006;
    public static inline var EEPHIDGET_OUTOFRANGE : Int = 0x9007;
    public static inline var EEPHIDGET_BADPOWER : Int = 0x9008;
    
    public static inline var PFALSE : Int = 0x00;
    public static inline var PTRUE : Int = 0x01;
    
    public static inline var PUNK_BOOL : Int = 0x02;
    public static inline var PUNK_INT : Int = 0x7FFFFFFF;
    public static var PUNK_NUM : Float = 1e+300;
    
    public static inline var PUNI_BOOL : Int = 0x03;
    public static inline var PUNI_INT : Int = 0x7FFFFFFE;
    public static var PUNI_NUM : Float = 1e+250;
    
    public static var Phid_ErrorDescriptions : Array<String> = ["", "", "", "Unexpected Error.  Contact Phidgets Inc. for support.", "Invalid argument passed to function.", "", "", "", "Network Error.", "Value is Unknown (State not yet received from device).", "Authorization Failed.", "Not Supported", "", "", "Index out of Bounds", "", "A connection to the server does not exist.", "", "", "Webservice and Client protocol versions don't match. Update both to newest release."];
    /* This needs to match the CPhidget_DeviceID enum in phidget21 C library */  /* These are all current devices */  
    private static var phidDeviceNames : Array<String> = null;
    
    private static function get_Phid_DeviceSpecificName() : Array<String>
    {
        if (phidDeviceNames == null) 
        {
            phidDeviceNames = [];
            phidDeviceNames[126] = "Phidget Accelerometer 3-axis";
            phidDeviceNames[130] = "Phidget Advanced Servo Controller 1-motor";
            phidDeviceNames[58] = "Phidget Advanced Servo Controller 8-motor";
            phidDeviceNames[55] = "Phidget Analog 4-output";
            phidDeviceNames[123] = "Phidget Bipolar Stepper Controller 1-motor";
            phidDeviceNames[59] = "Phidget Bridge 4-input";
            phidDeviceNames[75] = "Phidget Encoder 1-encoder 1-input";
            phidDeviceNames[128] = "Phidget High Speed Encoder 1-encoder";
            phidDeviceNames[79] = "Phidget High Speed Encoder 4-input";
            phidDeviceNames[53] = "Phidget Frequency Counter 2-input";
            phidDeviceNames[121] = "Phidget GPS";
            phidDeviceNames[64] = "Phidget InterfaceKit 0/0/4";
            phidDeviceNames[129] = "Phidget InterfaceKit 0/0/8";
            phidDeviceNames[68] = "Phidget InterfaceKit 0/16/16";
            phidDeviceNames[54] = "Phidget InterfaceKit 2/2/2";
            phidDeviceNames[69] = "Phidget InterfaceKit 8/8/8";
            phidDeviceNames[125] = "Phidget InterfaceKit 8/8/8";
            phidDeviceNames[77] = "Phidget IR Receiver Transmitter";
            phidDeviceNames[76] = "Phidget LED 64 Advanced";
            phidDeviceNames[118] = "Phidget Touch Slider";
            phidDeviceNames[62] = "Phidget Motor Controller 1-motor";
            phidDeviceNames[89] = "Phidget High Current Motor Controller 2-motor";
            phidDeviceNames[49] = "Phidget RFID 2-output";
            phidDeviceNames[52] = "Phidget RFID Read-Write";
            phidDeviceNames[119] = "Phidget Touch Rotation";
            phidDeviceNames[127] = "Phidget Spatial 0/0/3";
            phidDeviceNames[51] = "Phidget Spatial 3/3/3";
            phidDeviceNames[112] = "Phidget Temperature Sensor";
            phidDeviceNames[50] = "Phidget Temperature Sensor 4-input";
            phidDeviceNames[60] = "Phidget Temperature Sensor IR";
            phidDeviceNames[381] = "Phidget TextLCD";
            phidDeviceNames[61] = "Phidget TextLCD Adapter";
            phidDeviceNames[122] = "Phidget Unipolar Stepper Controller 4-motor";
            
            /* These are all past devices (no longer sold) */
            phidDeviceNames[113] = "Phidget Accelerometer 2-axis";
            phidDeviceNames[83] = "Phidget InterfaceKit 0/8/8";
            phidDeviceNames[4] = "Phidget InterfaceKit 4/8/8";
            phidDeviceNames[74] = "Phidget LED 64";
            phidDeviceNames[88] = "Phidget Low Voltage Motor Controller 2-motor 4-input";
            phidDeviceNames[116] = "Phidget PH Sensor";
            phidDeviceNames[48] = "Phidget RFID";
            phidDeviceNames[2] = "Phidget Servo Controller 1-motor";
            phidDeviceNames[56] = "Phidget Servo Controller 4-motor";
            phidDeviceNames[57] = "Phidget Servo Controller 1-motor";
            phidDeviceNames[3] = "Phidget Servo Controller 4-motor";
            phidDeviceNames[82] = "Phidget TextLCD";
            phidDeviceNames[339] = "Phidget TextLCD";
            phidDeviceNames[72] = "Phidget TextLED 4x8";
            phidDeviceNames[73] = "Phidget TextLED 1x8";
            phidDeviceNames[114] = "Phidget Weight Sensor";
            
            /* Nothing device */
            phidDeviceNames[1] = "Uninitialized Phidget Handle";
            
            /* never released to general public */
            phidDeviceNames[81] = "Phidget InterfaceKit 0/5/7";
            phidDeviceNames[337] = "Phidget TextLCD Custom";
            phidDeviceNames[5] = "Phidget InterfaceKit 2/8/8";
            
            /* These are unreleased or prototype devices */
            
            /* This is for internal prototyping */
            phidDeviceNames[153] = "Phidget Generic Device";
        }
        return phidDeviceNames;
    }
    
    //Socket Server Constants
    //Commands
    public static inline var NULL_CMD : String = "need nulls";
    public static inline var LISTEN_CMD : String = "listen";
    public static inline var IGNORE_CMD : String = "ignore";
    public static inline var REPORT_CMD : String = "report";
    public static inline var WAIT_CMD : String = "wait";
    public static inline var FLUSH_CMD : String = "flush";
    public static inline var WALK_CMD : String = "walk";
    public static inline var QUIT_CMD : String = "quit";
    public static inline var GET_CMD : String = "get";
    public static inline var SET_CMD : String = "set";
    //responses
    public static inline var SUCCESS_200_RESP : String = "2";
    public static inline var FAILURE_300_RESP : String = "3";
    public static inline var FAILURE_400_RESP : String = "4";
    public static inline var FAILURE_500_RESP : String = "5";
    public static inline var AUTHENTICATE_900_RESP : String = "9";
    
    public static inline var OK_PENDING_RESP : String = "200-";
    public static inline var OK_RESP : String = "200 ";
    
    //Listen key change reasons
    public static inline var VALUE_CHANGED : Int = 1;
    public static inline var ENTRY_ADDED : Int = 2;
    public static inline var ENTRY_REMOVING : Int = 3;
    public static inline var CURRENT_VALUE : Int = 4;
    
    //open types
    public static inline var PHIDGETOPEN_ANY : Int = 0;
    public static inline var PHIDGETOPEN_SERIAL : Int = 1;
    public static inline var PHIDGETOPEN_ANY_ATTACHED : Int = 2;
    public static inline var PHIDGETOPEN_LABEL : Int = 4;
}

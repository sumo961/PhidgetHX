package;


/**
* @author Patrick Tresp
* @see patricktresp.de | blog.patricktresp.de
*
*/
 
 
import flash.text.TextFormat;
import flash.text.TextField;
import flash.display.Shape;


 
import com.phidgets.PhidgetRFID;

import com.phidgets.events.PhidgetDataEvent;
import com.phidgets.events.PhidgetErrorEvent;
import com.phidgets.events.PhidgetEvent;
 
import flash.display.Sprite;
 
/**
* @author ptresp
*/
//class PhidgetRFIDReader extends Sprite
class Main extends Sprite
{
	var HOST : String = "127.0.0.1";
	var PORT : UInt;

	var PASSWORD : String;
	var _phidgetRFID : PhidgetRFID;
 
	public function new()
	{
		super();
		construct();
	}
 
	private function construct()
	{
		trace("construct");

		var phidgedRFID : PhidgetRFID = _phidgetRFID = new PhidgetRFID();

		//phidgedRFID = new PhidgetRFID();
		 
		phidgedRFID.addEventListener( PhidgetEvent.DETACH, attachDetachHandler );
		phidgedRFID.addEventListener( PhidgetEvent.CONNECT, attachDetachHandler );
		phidgedRFID.addEventListener( PhidgetEvent.ATTACH, attachDetachHandler );
		phidgedRFID.addEventListener( PhidgetErrorEvent.ERROR, errorHandler );
		phidgedRFID.addEventListener( PhidgetDataEvent.TAG, tagHandler );
		phidgedRFID.addEventListener( PhidgetDataEvent.TAG_LOST, tagHandler );

		PORT=5001;
		PASSWORD="";

		 
		phidgedRFID.open( HOST, PORT, PASSWORD );


	}
 
	private function attachDetachHandler( event : PhidgetEvent )
	{
		trace("PhidgetEvent received:"+PhidgetEvent);
		switch( event.type )
		{
			case PhidgetEvent.ATTACH:
			trace( "Main.attachDetachHandler(event) PhidgetEvent.ATTACH" );
			
			_phidgetRFID.Antenna = true;
			_phidgetRFID.LED = true;
			case PhidgetEvent.CONNECT:
			trace( "Main.attachDetachHandler(event) PhidgetEvent.CONNECT" );
			//trace("_phidgetRFID.Antenna "+_phidgetRFID.LED);
			// _phidgetRFID.Antenna = true;
			
			//_phidgetRFID.LED = true;
			//break;
			case PhidgetEvent.DETACH:
			default:
			_phidgetRFID.Antenna = false;
			_phidgetRFID.LED = false;
			trace( "Main.attachDetachHandler(event) PhidgetEvent.DETACH" );
			//break;
		}
	}
	 
	private function errorHandler( event : PhidgetErrorEvent )
	{
		trace( "Main.errorHandler(event)", event.type, event.Error );
	}
	 
	private function tagHandler( event : PhidgetDataEvent )
	{
		trace("PhidgetDataEvent received:"+PhidgetDataEvent);
		switch( event.type )
		{
			case PhidgetDataEvent.TAG:
			trace( "Main.tagHandler(event) PhidgetDataEvent.TAG", event.Data );
			displayStatus( true, event.Data.toString() );
			
			case PhidgetDataEvent.TAG_LOST:
			trace( "Main.tagHandler(event) PhidgetDataEvent.LOST", event.Data );
			displayStatus( false, event.Data.toString() );
			
		}
	}
	 
	private function displayStatus( connected : Bool, RFIDTag : String )
	{
		while ( numChildren > 0 ) removeChildAt( 0 );
	 
		if ( RFIDTag != "0/" )
		{
			var color : UInt; 
			var s : Shape; 
			var tf : TextField ; 
			var format : TextFormat; 
			var text : String;
		 
			color = connected ? 0x1B3A00 : 0x660000;
			 
			s = new Shape();
			s.graphics.beginFill( color );
			s.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			s.graphics.endFill();
			 
			addChild( s );
			 
			text = RFIDTag + " ";
			text += connected ? "found" : "lost";
			 
			format = new TextFormat();
			format.font = "Arial";
			format.size = 24;
			format.color = 0xFFFFFF;
			 
			tf = new TextField();
			tf.width = stage.stageWidth - 40;
			tf.x = tf.y = 20;
			 
			tf.defaultTextFormat = format;
			tf.text = text ;
			 
			addChild( tf );
		}
	}
}

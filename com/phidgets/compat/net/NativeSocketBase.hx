package com.phidgets.compat.net;
import com.phidgets.compat.NativeEventDispatcher;
import sys.net.Socket;
import sys.net.Host;
private typedef Event = com.phidgets.compat.NativeEvent;
private typedef DataEvent = com.phidgets.compat.net.NativeDataEvent;

/**
 * ...
 * @author Andreas Rønning
 */
class NativeSocketBase extends NativeEventDispatcher
{
	public var connected:Bool;
	private var _socket:Socket;
	public function new() 
	{
		super();
		init();

	}
	private function init(){

		_socket=new Socket();
		//_socket.setBlocking(false);
		//_socket.setTimeout(20);
		//_socket.

	}
	public function send(str:String):Void {
		_socket.output.writeString(str+ "\n");
		trace("writing to socket");//+_socket.input.readInt8());
		//var msgBytes:haxe.io.BytesInput=new haxe.io.BytesInput(null);
		//msgBytes=_socket.input;
		//trace("reading:"+_socket.read());
		/*var msgLength = _socket.input.readInt8();
		trace("onData " + msgLength);

        var msgBytes = _socket.input.readString(41);
        trace("onData " + msgBytes);

        var msgLength = _socket.input.readInt8();
		trace("onData " + msgLength);*/
		//_socket.input.bigEndian=false;
		while(true){
			try {

				//var incomingBuffer:haxe.io.Bytes=null;//=new haxe.io.BytesBuffer();

				//var bytesRead:Int = _socket.input.readBytes(incomingBuffer, 0, 10);

				//trace("bytesRead"+bytesRead);

				var l:String=_socket.input.readLine()+"\n";
				trace("l "+l);
				//trace("rmaining length "+_socket.input.readInt8());
				dispatchEvent(new DataEvent(DataEvent.DATA,l));

			}catch (z:Dynamic){
				trace("disconnected");
			}
		}
		
		//}
		
	}
	public function connect(host:String, port:Int):Void {

		 try{
            _socket.connect(new Host(host),port);
            connected=true;
            dispatchEvent(new Event(Event.CONNECT));
            //while( true ) {
                //trace("s.host "+s.host);
               // _socket.output.writeString("995 authenticate, version=1.0.10"+"\n");
              //  var l = _socket.input.readLine();
             //   trace(l);
                /*if( l == "exit" ) {
                    s.close();
                    //break;
                }*/
            //}
        } catch (z:Dynamic) {
            trace('Could not connect');// to ' + ip + ':' + port + '\n');
            return;
        }
		
		
	}
	
}
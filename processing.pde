import http.requests.*;
import processing.serial.*;
import java.net.URL;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port

void setup() {
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
}

void draw() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      //println(myString);
      
      String api = "http://0.0.0.0:8000/attendance/checkin/";
      String URL = sanitizeUrl(api += myString);
      println(URL);
      
      GetRequest get = new GetRequest(URL);
      get.send();
      println("Reponse Content: " + get.getContent());
    }
  }
}

private static String sanitizeUrl(String url) {
    return url.substring(0, url.length() - 2);
}
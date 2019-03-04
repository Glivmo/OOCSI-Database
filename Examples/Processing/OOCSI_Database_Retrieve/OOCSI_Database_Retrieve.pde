import nl.tue.id.oocsi.*;

// **************************************************
// This example requires a running OOCSI server!
//
// More information how to run an OOCSI server
// can be found here: https://iddi.github.io/oocsi/)
// **************************************************

OOCSI oocsi;

void setup() {
  size(200, 200);
  background(120);
  frameRate(10);

  // connect to OOCSI server running on the same machine (localhost)
  // with "senderName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  oocsi = new OOCSI(this, "Tyria_T01", "OOCSI_SERVER");

  println("");
}

void draw() {

  // retrieve data from ten timestamps
  if (mousePressed) {
    for (int i=1; i < 11; i++) {
      oocsi.channel("Tyria_World_Data_Get")
        .data("stone", 5)                    //Group to request data from
        .data("timeStamp", 2200700 + (i-1))  //Requested timeStamp
        .data("requestHandle", i)            //Requesthandle value is used to check if correct request is received
        .send();

      delay(1000);
    }
  }
}

void handleOOCSIEvent(OOCSIEvent event) {
  String sender = event.getSender();
  //println("Sender:", sender);
  if (sender.equals("Tyria_World_Database")) {
    if (event.getInt("requestHandle", -1) != -1) println("requestHandle:", event.getInt("requestHandle", -1));  //Only print if requesthandle != null
    if (event.getInt("timeStamp", -1) != -1) println("timeStamp:", event.getInt("timeStamp", -1));              //Only print if timeStamp != null

    if (event.getInt("dataAv", -1) != -1) println("dataAv:", event.getInt("dataAv", -1));                       //This could be any type. Please document
    if (event.getInt("dataMin", -1) != -1) println("dataMin", event.getInt("dataMin", -1));                     //used types in your own API, so other groups
    if (event.getInt("dataMax", -1) != -1) println("dataMax", event.getInt("dataMax", -1));                     //know what to request

    if (event.getString("debug") != null)println(event.getString("debug", ""));                         //if timeStamp is not available in database, 
  }                                                                                                             //the closest timeStamp will be used
}                                                                                                               //this sends the timeStamp that is used

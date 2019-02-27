/******************************************************************************
   Example of the OOCSI-ESP library connecting to WiFi and sending messages
   over OOCSI. Designed to work with the Processing OOCSI receiver example
   that is provided in the same directory
 ******************************************************************************/

#include "OOCSI.h"

// use this if you want the OOCSI-ESP library to manage the connection to the Wifi
// SSID of your Wifi network, the library currently does not support WPA2 Enterprise networks
const char* ssid = "Tyria_Hotspot";
// Password of your Wifi network.
const char* password = "You're welcome";

// name for connecting with OOCSI (unique handle)
const char* OOCSIName = "Tyria_T05";
// put the adress of your OOCSI server here, can be URL or IP address string
const char* hostserver = "oocsi.id.tue.nl";

// OOCSI reference for the entire sketch
OOCSI oocsi = OOCSI();

// put your setup code here, to run once:
void setup() {
  Serial.begin(115200);

  // output OOCSI activity on the built-in LED
  pinMode(LED_BUILTIN, OUTPUT);
  oocsi.setActivityLEDPin(LED_BUILTIN);

  oocsi.connect(OOCSIName, hostserver, ssid, password, processOOCSI);
   
  // create a new message
  for (int i = 1; i < 11; i++) {
    oocsi.newMessage("Tyria_World_Data");
    oocsi.addInt("timeStamp", 2200700 + (i - 1));
    oocsi.addString("dataNames", "dataAv,dataMin,dataMax");
    oocsi.addInt("dataAv", i + 4);
    oocsi.addInt("dataMin", i - 1);
    oocsi.addInt("dataMax", i + 9);

    // this command will send the message; don't forget to call this after creating a message
    oocsi.sendMessage();

    // needs to be checked in order for OOCSI to process incoming data.
    oocsi.check();
    delay(1000);
  }
}

// put your main code here, to run repeatedly:
void loop() {
  
}

void processOOCSI() {
  // don't do anything; we are sending only
}

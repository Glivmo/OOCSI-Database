//
// ATTENTION! Apparently OOCSI already has the NTPClient built-in. Therefor 
// The NTPClient library will not work. A working OOCSI NTPClient request will
// be added to this repository later
//

/******************************************************************************
   Example of retrieving the current time in a MDDHHMMSS format 
   on a internet enabled Arduino. Based on https://github.com/taranais/NTPClient.
   Please install this library before use.
 ******************************************************************************/

#include <NTPClient.h>
// change next line to use with another board/shield
#include <ESP8266WiFi.h>
//#include <WiFi.h> // for WiFi shield
//#include <WiFi101.h> // for WiFi 101 shield or MKR1000
#include <WiFiUdp.h>

const char *ssid     = "<SSID>";
const char *password = "<PASSWORD>";

WiFiUDP ntpUDP;

NTPClient timeClient(ntpUDP, "europe.pool.ntp.org", 3600, 60000);

String inTimeStamp;
String prevTimeStamp;

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while ( WiFi.status() != WL_CONNECTED ) {
    delay ( 500 );
    Serial.print ( "." );
  }

  timeClient.begin();
}

void loop() {
  timeClient.update();

  String inTimeStamp = timeClient.getFormattedDate();
  if (!prevTimeStamp.equals(inTimeStamp)) {
    String formattedTimeStamp = inTimeStamp.substring(6, inTimeStamp.length());

    char c;
    for (int i = 0; i < formattedTimeStamp.length(); ++i) {
      c = formattedTimeStamp.charAt(i);
      if (c == '-' || c == ':' || c == 'T' || c == 'Z') {
        formattedTimeStamp.remove(i, 1);
      }
    }
    int timeStamp = formattedTimeStamp.toInt();
    Serial.println(timeStamp);
    prevTimeStamp = inTimeStamp;
  }
}

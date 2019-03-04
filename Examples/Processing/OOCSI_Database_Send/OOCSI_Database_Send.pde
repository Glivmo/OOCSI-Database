import nl.tue.id.oocsi.*;

// **************************************************
// This example requires a running OOCSI server!
//
// More information how to run an OOCSI server
// can be found here: https://iddi.github.io/oocsi/)
//
// This example sends ten timestamps accompanied with data to the database
// **************************************************

OOCSI oocsi;

void setup() {
  size(200, 200);
  background(120);
  frameRate(10);

  // connect to OOCSI server running on the same machine (localhost)
  // with "senderName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  oocsi = new OOCSI(this, "Tyria_T01", "oocsi.id.tue.nl");  //IMPORTANT! OOCSI name must be World_GroupName (i.e. Tyria_T01)
  for (int i=1; i < 11; i++) {
    oocsi.channel("Tyria_World_Data")
      .data("timeStamp", 2270700 + (i-1))
      .data("dataNames", "dataAv,dataMin,dataMax")          //You must send data names for the database to work
      .data("dataAv", i + 4)
      .data("dataMin", i - 1)
      .data("dataMax", i + 9)
      .send();

    delay(1000);
  }
}

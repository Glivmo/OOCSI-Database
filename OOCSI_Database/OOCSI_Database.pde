/******************************************************************************
 A central OOCSI database that collects, saves and sends data for the Tyria 
 World. The database is built around the OOCSI framework by Mathias Funk. More
 information on using the database can be found on: 
 https://github.com/Glivmo/OOCSI-Database
 
 TU/e course of faculty of Industrial Design by Mathias Funk
 DBSU10 - Tyria Team 05
 
 For more information on OOCSI refer to: https://iddi.github.io/oocsi/
 ******************************************************************************/


import nl.tue.id.oocsi.*;
import java.util.*;
import java.io.*;

OOCSI oocsi;

// Creating the Navigable maps for the five groups
NavigableMap<Integer, Object[]> T01 = new TreeMap<Integer, Object[]>();
NavigableMap<Integer, Object[]> T02 = new TreeMap<Integer, Object[]>();
NavigableMap<Integer, Object[]> T03 = new TreeMap<Integer, Object[]>();
NavigableMap<Integer, Object[]> T04 = new TreeMap<Integer, Object[]>();
NavigableMap<Integer, Object[]> T05 = new TreeMap<Integer, Object[]>();

void setup() {
  
  size(200, 200);

  // Connect to OOCSI server
  oocsi = new OOCSI(this, "Tyria_World_Database", "OOCIS_SERVER");

  // Subscribe to the in- and outchannels
  println("");
  println("subscribing to Tyria_World_Data");
  oocsi.subscribe("Tyria_World_Data");

  println("");
  println("subscribing to Tyria_World_Data_Get");
  oocsi.subscribe("Tyria_World_Data_Get");

  // Load the saved data on start of sketch
  T01 = loadHM(T01, "T01");
  T02 = loadHM(T02, "T02");
  T03 = loadHM(T03, "T03");
  T04 = loadHM(T04, "T04");
  T05 = loadHM(T05, "T05");
}

void stop() {
  
  // Save data on stop of sketch
  saveHM(T01, "T01");
  saveHM(T02, "T02");
  saveHM(T03, "T03");
  saveHM(T04, "T04");
  saveHM(T05, "T05");
}

/*************** Data In ****************/

void Tyria_World_Data(OOCSIEvent event) {
  
  // Check if sender is group 1 through 5
  String sender = event.getSender();
  if (sender.equals("Tyria_T01") || sender.equals("Tyria_T02") || sender.equals("Tyria_T03") || sender.equals("Tyria_T04") || sender.equals("Tyria_T05")) {
    
    // Check if timestamp was received
    int timeStamp = event.getInt("timeStamp", -1);
    if (timeStamp == -1) {
      return;
    } else {

      // Create an Object array with the length of the amount of datanames received +1 and save datanames as first object
      String dataNames = event.getString("dataNames");
      String[] dN = splitTokens(dataNames, ",");    
      Object[] data = new Object[dN.length + 1];
      data[0] = dataNames;
      for (int i = 0; i < dN.length; i++) {
        data[i+1] = event.getObject(dN[i]);
      }

      // Assign data to correct group
      if (sender.equals("Tyria_T01")) {
        saveData(timeStamp, data, T01, "T01");
      }
      if (sender.equals("Tyria_T02")) {
        saveData(timeStamp, data, T02, "T02");
      }
      if (sender.equals("Tyria_T03")) {
        saveData(timeStamp, data, T03, "T03");
      }
      if (sender.equals("Tyria_T04")) {
        saveData(timeStamp, data, T04, "T04");
      }
      if (sender.equals("Tyria_T05")) {
        saveData(timeStamp, data, T05, "T05");
      }
    }
  }
}

void saveData(int timeStamp, Object[] data, NavigableMap<Integer, Object[]> T, String Tname) {
  
  // Map data to timeStamp 
  T.put(timeStamp, data);
  println("adding " + data  + " to HashMap");
  
  // Save mapping as groupname
  saveHM(T, Tname);
  println(T);
}

// Method of saving
void saveHM(NavigableMap<Integer, Object[]> hm, String name) {
  
  try {
    FileOutputStream file = new FileOutputStream("/home/pi/sketchbook/Sketches/OOCSI_Database/data/" + name);
    ObjectOutputStream out = new ObjectOutputStream(file);
    out.writeObject(hm);
    out.flush();
    out.close();
    file.close();
    System.out.println("Serialized data is saved in /home/pi/sketchbook/Sketches/OOCSI_Database/data/" + name);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}


/*************** Data Out ***************/

void Tyria_World_Data_Get(OOCSIEvent event) {
  
  String requester = event.getSender();
  int timeStamp = event.getInt("timeStamp", -1);
  int group = event.getInt("stone", -1);
  int requestHandle = event.getInt("requestHandle", -1);
  if (timeStamp != -1 && requestHandle != -1) {
    
    // Retrieve data from correct group
    if (group == 1) {
      sendData(requester, timeStamp, requestHandle, T01);
    } else if (group == 2) {
      sendData(requester, timeStamp, requestHandle, T02);
    } else if (group == 3) {
      sendData(requester, timeStamp, requestHandle, T03);
    } else if (group == 4) {
      sendData(requester, timeStamp, requestHandle, T04);
    } else if (group == 5) {
      sendData(requester, timeStamp, requestHandle, T05);
    } else {
      return;
    }
  }
}

void sendData(String requester, int timeStamp, int requestHandle, NavigableMap<Integer, Object[]> T) {

  // Check if timestamp is known
  if (T.get(timeStamp)!= null) {
    
    // Get Object array with the length of the amount of datanames +1  and split datanames
    Object[] o = T.get(timeStamp);
    String dataNames = o[0].toString();
    String[] dN = splitTokens(dataNames, ",");
    
    // Send useful information back to requester
    oocsi.channel(requester)
      .data("requestHandle", requestHandle)
      .data("timeStamp", timeStamp)
      .data("dataNames", dataNames)
      .send();
    
    // Send data back to requester
    for (int i= 0; i < dN.length; i++) {
      oocsi.channel(requester)
        .data(dN[i], o[i+1])
        .send();
      delay(10);
    }
  } else { 
    
    // If timestamp is not known, take timestamp closest by
    int above = 100000000;
    int below = 0;

    if (T.ceilingKey(timeStamp) != null) {
      above = T.ceilingKey(timeStamp);
    }
    if (T.floorKey(timeStamp) != null) {
      below = T.floorKey(timeStamp);
    }
    int val = timeStamp - below > above - timeStamp ? above : below;

    // Create informational string
    String debug = str(timeStamp) + " not found, defaulted to value from " + str(val) + ":";

    // Get Object array with the length of the amount of datanames +1  and split datanames
    Object[] o = T.get(val);
    String dataNames = o[0].toString();
    String[] dN = splitTokens(dataNames, ",");
    
    // Send useful information back to requester
    oocsi.channel(requester)
      .data("requestHandle", requestHandle)
      .data("timeStamp", val)
      .data("dataNames", dataNames)
      .data("debug", debug)
      .send();
      
    // Send data back to requester
    for (int i= 0; i < dN.length; i++) {
      oocsi.channel(requester)
        .data(dN[i], o[i+1])
        .send();
      delay(10);
    }
  }
}

// Method of loading
NavigableMap<Integer, Object[]> loadHM(NavigableMap<Integer, Object[]> hm, String name) {
  
  try {
    FileInputStream file = new FileInputStream("/home/pi/sketchbook/Sketches/OOCSI_Database/data/" + name);
    ObjectInputStream in = new ObjectInputStream(file);

    hm = (NavigableMap<Integer, Object[]>)in.readObject();

    in.close();
    file.close();
    System.out.println("Serialized data is read from /home/pi/sketchbook/Sketches/OOCSI_Database/data/" + name);
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  return hm;
}

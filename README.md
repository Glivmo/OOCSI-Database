# OOCSI Database

A processing for Pi based database for OOCSI. This particular database was designed for use by the Tyria World of the course DBSU10 (2018-3) Technologies for Connectivity. The Database is divided in two distinct functions; saving data sent to the database through OOCSI and retrieving data from the database.

## Getting Started
Using this database is very easy. You only need to install the [necessary oocsi library](https://github.com/iddi) and you are off to a great start! Please try to get familiar with the possibilities of OOCSI before using this database.

## How to use
OOCSI-Database is divided in two part; database saving and database requesting. First we will learn how to save data to the database.

**Database saving**

To start sending data to the database, you need to use the correct client- channel- and datanames. Every group has one clientname that will work on the database, which is "Tyria_*groupname*. An example for T05 would be:
```Processing
oocsi = new OOCSI(this, "Tyria_T05" , "oocsi server");
```
Next up is the database channel. For this database you should use the Channel "Tyria_World_Data". A few important things about communicating with the channel are as follows:
1. Always send a timestamp integer named *"timeStamp"* in a *MDDHHMMSS* format.
2. Don't send data more than once a second. Since we work with a system based on seconds, sending data more than once a second will not benefit you and only overcrowd the server.
An example of sending data in Processing is the following:
```Processing
timeStamp = int(nf(month(), 1) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2)); // timestamp in mddhhmmss format
String data = "Example"

  if (prevTimeStamp != timeStamp) {
    oocsi.channel("Tyria_World_Data")
      .data("timeStamp", timeStamp)
      .data("data", data)
      .send();
```
In this example *"timeStamp"* has to be an integer, but *"data"* could be any type OOCSI can send.

**Database requesting**

To perform a database request you need to have an OOCSIEvent handler set up:
```Processing
void handleOOCSIEvent(OOCSIEvent event) {
  String sender = event.getSender();
  if (sender.equals("Tyria_World_Database")) {
    int messageHandle = event.getInt("messageNum", -1));
    float responseVal = event.getObject("response"));
    String debug = event.getString("debug", ""));
  }
}
```
Again, in the example *"response"* could have been any type possible for OOCSI.

To request a value from the database the following message has to be sent:
```Processing
oocsi.channel("Tyria_World_Data_Get")
      .data("stone", 5)
      .data("timeStamp", requestTimeStamp)
      .data("messageHandle", messageHandle)
      .send();
```
Here *"stone"* is the group from which you want to receive the data (in this example T05), *"timeStamp"* is the specific timeStamp you want to receive and *"messageHandle"* is a message handle by you will be able to check if you have received the correct response. This last variable should be different for every request.

As you might have noticed, a string called *"debug"* is also included in the payload. When you request a certain timestamp which happens to not be present in the database, the closest timestamp will be picked. The *"debug"* string will tell you which timestamp was picked:
```
226085512 not found, defaulted to value from 226090000
```

/**
 * Please note: the real database is not fully functioning yet, 
 therefor the used data in this activity map is not real data!
 (Test data is only available for the 4th and the 5th of March) 
 
 Tyria World
    
    T01 - Mind Stone:
    T02 - Space Stone:
    T03 - Time Stone:
    T04 - Power Stone:
    T05 - Reality Stone:
    
    This code is still under construction
    To do: Retrieve data from database (For each requested timestamp and for all 5 groups)
         : Make the visualisation match the actual crowds
 */

PImage bg; //Background image
Scrollbar TimeBar; //The scrollbar for the time
Button PreviousDateButton, NextDateButton;
DataBar barT01, barT02, barT03, barT04, barT05;
ActivityCircle circleT01, circleT02, circleT03, circleT04, circleT05;

int day, month, year; //Variables for the date

int sensitivityClick = 100; //HAmount of ms delay after click
int rDate; //requested date by DateButtons
int rTimestamp; //requested timestamp rDate plus Scrollbar 

void setup() {
  size(900, 600); //Map equals 600 x 400
  // The background image must be the same size as the parameters
  bg = loadImage("Background900x600.png");
  //Create scrollbar to select time
  TimeBar= new Scrollbar(50, height-100, width-100, 20, 1);
  PreviousDateButton = new Button(280,550,40);
  NextDateButton = new Button(580,550,40);
  
  //Create bars for data visualisation
  barT01 = new DataBar(650,100,200,color(204,213,255),color(35,78,255));
  barT02 = new DataBar(650,130,200,color(195,242,232),color(1,204,157));
  barT03 = new DataBar(650,160,200,color(223,250,195),color(255,231,9));
  barT04 = new DataBar(650,190,200,color(229,207,253),color(146,51,255));
  barT05 = new DataBar(650,220,200,color(254,198,197),color(225,13,12));
  
  //Create activty circle for data visualisation (show covered area)
  circleT01 = new ActivityCircle(410,55,color(35,78,255,80));
  circleT02 = new ActivityCircle(565,100,color(1,204,157,80));
  circleT03 = new ActivityCircle(550,220,color(255,231,9,80));
  circleT04 = new ActivityCircle(300,55,color(146,51,255,80));
  circleT05 = new ActivityCircle(465,55,color(225,13,12,80));
  
  //Get current Date
  day = day();
  month = month();
  year = year(); //program works only correctly for the year 2019, due to date conversion (Feb 29th is missing)
}

void draw() {
  background(bg);
  
  DateButtonCheck();
  TimeBarCheck();
  DrawDataBars();
  DrawActivityCircles();
  
  DrawGUI();
}

void DrawGUI(){
  fill(50);
  textSize(12);
  text("T01 - Mind Stone",650,115);
  text("T02 - Space Stone",650,145);
  text("T03 - Time Stone",650,175);
  text("T04 - Power Stone",650,205);
  text("T05 - Reality Stone",650,235);
  text("Timestamp:"+rTimestamp,650,265);//only for test
  
  //Button description
  text("Previous",275,545);
  text("Next",585,545);
}

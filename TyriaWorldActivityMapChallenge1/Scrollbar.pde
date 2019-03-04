void TimeBarCheck(){
  // Get the position of the scrollbar (Currently a point between 0-800) 
  float TimePos = TimeBar.getPos()-51;
  int TimeNum = int(TimePos);
  //Conversion from TimeNum to actual timestamp
  int pph = 50;//Points per hour, every 50 point is 1 hour
  int rHour= TimeNum/pph + 7; //Requested hour
  float Minutes= ((TimePos%pph)/50)*60;//Requested minutes
  int rMinute= int(Minutes);//Requested minutes
  
  String rTimeString = str(rHour)+str(rMinute);
  String rTimestampString = str(rDate)+rTimeString;
  //split string stringname.substringname(0.7) // Dit stukje moet dan naar het ontvang stukje van de timestamp van oosci 
  rTimestamp = int(rTimestampString); //Create the requested (int)timestamp (Be aware, now there are no zeros in front of the days/months
  
  fill(0);
  textSize(12);
  if (rHour>=10){
    if(rMinute>=10){
      text("Time: "+rHour+":"+rMinute,700,40);
      text(rHour+":"+rMinute,TimePos+35,height-120);
    }
    else{
      text("Time: "+rHour+":0"+rMinute,700,40);
      text(rHour+":0"+rMinute,TimePos+35,height-120);
    }      
  }
  else{
    if(rMinute>=10){
      text("Time: 0"+rHour+":"+rMinute,700,40);
      text("0"+rHour+":"+rMinute,TimePos+35,height-120);
    }
    else{
      text("Time: 0"+rHour+":0"+rMinute,700,40);
      text("0"+rHour+":0"+rMinute,TimePos+35,height-120);
    } 
  }
  
  
  text("07:00",37,height-70);
  text("15:00",435,height-70);
  text("23:00",837,height-70);
  TimeBar.update();
  TimeBar.display();
}

class Scrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  Scrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

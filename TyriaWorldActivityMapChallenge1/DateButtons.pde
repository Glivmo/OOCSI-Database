//note: int cannot start with 0 -> thus zero in front of month goes lost

void DateButtonCheck(){
  //Check if button is pressed
  boolean PreviousDateButtonClicked = PreviousDateButton.getState();
  boolean NextDateButtonClicked = NextDateButton.getState();
  
  //Process click
  if (PreviousDateButtonClicked){
    if (day>1){day--;}
    else if ((month==2||month==4||month==6||month==8||month==9||month==11)&&day==1){day=31; month--;}
    else if((month==5||month==7||month==10||month==12)&&day==1){day=30; month--;}
    else if (month==3 && day==1){day=28; month--;}
    else{month=12; day=31;}
  }
  else if (NextDateButtonClicked){
    if ((month==1||month==3||month==5||month==7||month==8||month==10||month==12)&&day<31){day++;}
    else if((month==4||month==6||month==9||month==11)&&day<30){day++;}
    else if (month==2 && day<28){day++;}
    else if (month<12){month++; day=1;}
    else{month=1; day=1;}
  }
  else{
    //skip
  }
  
  //Display Date
  textSize(30);
  text(day+"-"+month+"-"+year,360,580);
  if (month>9){
    if(day>9){
      String rDateString = str(month)+str(day);
      rDate = int(rDateString);
    }
    else{//if(day<10)
      String rDateString = str(month)+"0"+str(day);
      rDate = int(rDateString);
    }
  }
  else{ //if(month<10)
    if(day>9){
      String rDateString = "0"+str(month)+str(day);
      rDate = int(rDateString);
    }
    else{//if(day<10)
      String rDateString = "0"+str(month)+"0"+str(day);
      rDate = int(rDateString);
    }
  }
  
  PreviousDateButton.update();
  PreviousDateButton.display();
  
  NextDateButton.update();
  NextDateButton.display();
  
}

class Button { 
  
  int buttonX, buttonY;      // Position of button for changing date
  
  int buttonSize;     // Diameter of button
  
  color buttonColor, buttonHighlight; 
  boolean buttonOver = false;
  boolean buttonClicked = false;
  
  Button(int X, int Y, int Size){
  
    buttonX = X;
    buttonY = Y;
    buttonSize = Size;
    buttonColor = color(102);
    buttonHighlight = color(0);
  }
  
  void update(){
    if ( overButton(buttonX, buttonY, buttonSize, buttonSize) ) {
      buttonOver = true;
    } else {
      buttonOver = false;
    }
    if ( clickedButton(buttonX, buttonY, buttonSize, buttonSize) ) {
      buttonClicked = true;
    } else {
      buttonClicked = false;
    }
  }

  void display(){ 
  
    if (buttonOver) {
      fill(buttonHighlight);
    } else {
      fill(buttonColor);
    }
    stroke(255);
    rect(buttonX, buttonY, buttonSize, buttonSize);
  }
  
  boolean overButton(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean clickedButton(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height && mousePressed) {
      delay(sensitivityClick);
      return true;
    } else {
      return false;
    }
  } 
  
  boolean getState(){
    
    return buttonClicked;
  }
  

}

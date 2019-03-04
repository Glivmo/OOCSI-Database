void DrawActivityCircles(){
  
  circleT01.update();
  circleT01.display();
  
  circleT02.update();
  circleT02.display();
  
  circleT03.update();
  circleT03.display();
  
  circleT04.update();
  circleT04.display();
  
  circleT05.update();
  circleT05.display();
  
}

class ActivityCircle {
  
  int CircleX, CircleY, CircleSize ;
  color CircleColor;
    
  ActivityCircle(int X, int Y, color Color){
  
    CircleX = X;
    CircleY = Y;
    CircleColor = Color;
  }
  
  void update(){
    //Check data !Fake Data!
    if ((rTimestamp > 3041119)&&(rTimestamp < 3041219)){ 
      CircleSize = 100; //for test
    }
    else if((rTimestamp > 3050619)&&(rTimestamp < 3051919)){
      CircleSize = 160; //for test
    }
    else{
      CircleSize = 40; //for test
    }
  }
  
  void display(){
  //draw circle
    fill(CircleColor);
    ellipse(CircleX,CircleY,CircleSize,CircleSize);
    
  }
  
    
}

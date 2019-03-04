void DrawDataBars(){
  
  barT01.update();
  barT01.display();
  
  barT02.update();
  barT02.display();
  
  barT03.update();
  barT03.display();
  
  barT04.update();
  barT04.display();
  
  barT05.update();
  barT05.display();
  
}

class DataBar {
  
  int BarX, BarY, BarSize ;
  color BarBaseColor, BarActiveColor;
  int FilledSize; // number between 0 and 200
  
  DataBar(int X, int Y, int Size, color Base, color Active){
  
    BarX = X;
    BarY = Y;
    BarSize = Size;
    BarBaseColor = Base;
    BarActiveColor = Active;
  
  }
  
  void update(){
    //Check data  !Fake Data!
    if ((rTimestamp > 3041119)&&(rTimestamp < 3041219)){ 
      FilledSize = 50; //for test
    }
    else if((rTimestamp > 3050619)&&(rTimestamp < 3051919)){
      FilledSize = 60; //for test
    }
    else{
      FilledSize = 10; //for test
    }
  }
  
  void display(){
  //draw base (Empty) bar
    fill(BarBaseColor);
    rect(BarX,BarY,BarSize,(BarSize/10));
    
  //draw active bar
    fill(BarActiveColor);
    rect(BarX,BarY,FilledSize,(BarSize/10));
  }
  
    
}

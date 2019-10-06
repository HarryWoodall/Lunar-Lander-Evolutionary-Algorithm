class Terrain {
  
  private float[] current;
  private Ship ship;
  private Ship ships[];
  
  public Terrain(Ship ship) {
    this.ship = ship;
    current = new float[] {0, 300};
  }
  
  public Terrain(Ship[] ships) {
    this.ships = ships;
    current = new float[] {0, 300};
  }
  
  public void drawTerrain() {
    stroke(255);
    
    drawLine(20, 575);
    drawLine(60, 620);
    
    drawPlatform(100, 620);
    
    drawLine(140, 520);
    drawLine(180, 480);
    drawLine(220, 545);
    drawLine(260, 530);
    drawLine(300, 470);
    drawLine(340, 390);
    drawLine(380, 270);
    
    drawPlatform(420, 270);
    drawPlatform(460, 270);
    
    drawLine(500, 320);
    drawLine(540, 300);
    drawLine(580, 420);
    drawLine(620, 530);
    drawLine(660, 590);
    drawLine(700, 670);
    
    drawPlatform(740, 670);
    
    drawLine(780, 570);
    drawLine(820, 520);
    
    drawPlatform(860, 520);  
    drawPlatform(900, 520);
    
    drawLine(940, 370);
    drawLine(980, 320);
    
    drawPlatform(1020, 320);
    
    drawLine(1060, 370);
    drawLine(1100, 395);
    drawLine(1140, 420);
    drawLine(1180, 370);
    drawLine(1200, 420);
    
    // reset origin
    current[0] = 0;
    current[1] = 600;
  }
  
  public void drawLine(float x, float y) {
    line(current[0], current[1], x, y);
    if (ships == null) {
      if(collisionDetection(current[0], current[1], x, y, ship)) {
        ship.destroy();
      }
    } else {
      for (int i = 0; i < ships.length; i++) {
        if(collisionDetection(current[0], current[1], x, y, ships[i])) {
          ships[i].destroy();
        }
      }
    }
    
    current[0] = x;
    current[1] = y;
  }
  
  public void drawPlatform(float x, float y) {
    stroke(0, 255, 0);
    line(current[0], current[1], x, y);
    
    if (ships == null) {
      if(collisionDetection(current[0], current[1], x, y, ship)) {
        ship.land();
      }
    } else {
      for (int i = 0; i < ships.length; i++) {
        if(collisionDetection(current[0], current[1], x, y, ships[i])) {
          ships[i].land();
        }
      }
    }
    
    current[0] = x;
    current[1] = y;
    stroke(255);
  }
  
  public boolean collisionDetection(float x1, float y1, float x2, float y2, Ship ship) {
    if (checkIfNeedCollision(x1, y1, x2, y2, ship)) {
      float rx = ship.getXPos() - (ship.getWidth() / 2);
      float ry = ship.getYPos() - (ship.getWidth() / 2);
      float rw = ship.getWidth();
      float rh = ship.getHeight();
      
      boolean left = lineCollisionDetection(x1, y1, x2, y2, rx,ry, rx, ry+rh);
      boolean right = lineCollisionDetection(x1, y1, x2, y2, rx+rw, ry, rx + rw, ry + rh);
      boolean top = lineCollisionDetection(x1, y1, x2, y2, rx, ry, rx+rw, ry);
      boolean bottom = lineCollisionDetection(x1, y1, x2, y2, rx,ry+rh, rx+rw,ry+rh);
      
      if (left || right || top || bottom) {
        return true;
      }
      return false;
      
      //http://www.jeffreythompson.org/collision-detection/line-rect.php
    }
    return false;
  }
  
  public boolean lineCollisionDetection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      return true;
    }
    return false;
    
    //http://www.jeffreythompson.org/collision-detection/line-line.php
    //https://www.topcoder.com/community/data-science/data-science-tutorials/geometry-concepts-line-intersection-and-its-applications/
  }
  
  public boolean checkIfNeedCollision(float x1, float y1, float x2, float y2, Ship ship) {
    if (ship.getXPos() > min(x1, x2) - 20 && ship.getXPos() < max(x1, x2) + 20) {
      if ((ship.getYPos() < max(y1, y2) && ship.getYPos() > min(y1, y2) - 20) || (ship.getYPos() > min(y1, y2) && ship.getYPos() < max(y1, y2) + 20)) {
        return true; 
      }
    }
    else if (ship.getYPos() > min(y1, y2) && ship.getYPos() < max(y1, y2)) {
      if ((ship.getXPos() < max(x1, x2) && ship.getXPos() > min(x1, x2) - 20) || (ship.getXPos() > min(x1, x2) && ship.getXPos() < max(x1, x2) + 20)) {
        return true;
      }
    }
    return false;
  }
  
  public void setShips(Ship[] ships) {
    this.ships = ships;
  }
}

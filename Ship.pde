class Ship {

  private float xPos;
  private float yPos;
  private float hSpeed;
  private float vSpeed;
  private float currentRotation;
  private float fuel;
  private boolean isDestroyed;
  private boolean isLanded;
  
  private int index;
  private int width;
  private int height;
  
  public Ship(int index) {
    this.xPos = 350.0f;
    this.yPos = 20.0f;
    this.hSpeed = 0f;
    this.vSpeed = 0.0f;
    this.currentRotation = 0;
    this.fuel = 900.0f;
    this.isDestroyed = false;
    this.isLanded = false;
    this.index = index;
    this.width = 10;
    this.height = 10;
    rectMode(CENTER);
  }
  
  public void drawShip() {
      pushMatrix();
      rotateShip();
      rect(0, 0, width, height);
      popMatrix();
      if (!(isDestroyed || isLanded)) {
        gravityEffect();
        playerControls();
        xPos = xPos + hSpeed;
        yPos = yPos + vSpeed;
      }
  }
  
  public void gravityEffect() {
    vSpeed += 0.001f;
  }
  
  public void playerControls() {
    if (keyPressed && keyCode == UP) {
      thrust();
    }
    
    if (keyPressed && keyCode == LEFT) {
      turnLeft();
    } 
    
    if (keyPressed && keyCode == RIGHT) {
      turnRight();
    }
  }
  
  public void rotateShip() {
    translate(xPos, yPos);
    rotate(currentRotation);
  }
  
  public float getXPos() {
    return xPos;
  }
  
  public float getYPos() {
    return yPos;
  }
  
  public float getVSpeed() {
    return vSpeed;
  }
  
  public float getHSpeed() {
    return hSpeed;
  }
  
  public float getRotation() {
    return currentRotation;
  }
  
  public int getWidth() {
    return width;
  }
  
  public int getHeight() {
    return height;
  }
  
  public void destroy() {
    //println("Ship Destroyed");
    isDestroyed = true;
    if (index == -1) {
      noLoop();
    } else {
    }
  }
  
  public void land() {
    if (abs(currentRotation) <= 0.1 && vSpeed <= 0.15 && hSpeed < 0.15) {
      if (index == -1) {
        noLoop();
      }
      println("Landed");
      isLanded = true;
    }
    else {
      destroy();
    }
  }
  
  public void turnLeft() {
    if (currentRotation > (- PI/2)) {
        currentRotation -= 0.03f;
      } else {
        currentRotation = -PI/2;
      }
  }
  
  public void turnRight() {
    if (currentRotation < (PI/2)) {
        currentRotation += 0.03f;
      } else {
        currentRotation = PI/2;
      }
  }
  
  public void thrust() {
    vSpeed -= 0.0032f * cos(currentRotation);
      hSpeed += 0.0032f * sin(currentRotation);
      fuel--;
      
      if (fuel < 0) {
        destroy();
      }
  }
  
  public boolean isDestroyed() {
    return isDestroyed;
  }
  
  public boolean isLanded() {
    return isLanded;
  }
  

}

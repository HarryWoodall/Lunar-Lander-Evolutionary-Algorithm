class DNA {
  
  private ArrayList<action> genes;
  private Ship ship;
  private boolean isActive;
  private boolean isThrusting;
  private int thrustRemaining = 0;
  private float[][] targets;
  private boolean outOfBounds = false;
  
  private int targetIndex = -1;
  private float proximity = -1;
  private float finalVSpeed = -1;
  private float finalHSpeed = -1;
  private float finalRotation = -1;
  
  private float fitness;
  
  public DNA(int index) {
    genes = new ArrayList<action>();
    this.isActive = true;
    ship = new Ship(index);
    
    targets = new float[][] {
      {100, 620},
      {420, 270},
      {740, 670},
      {860, 520},
      {1020, 320}     
    };
  }
  
  public void performAction(int currentFrame) {
    if (currentFrame < genes.size()) {
      if (!isThrusting) {
        switch (genes.get(currentFrame)) {
          case thrust: 
            isThrusting = true;
            thrustRemaining = 0;
            ship.thrust();
            break;
          case left:
            ship.turnLeft();
            break;
          case right:
            ship.turnRight();
            break;
          case none:
            break;
        }
      } else {
        if (thrustRemaining > 0) {
          ship.thrust();
          thrustRemaining--;
        } else {
          ship.thrust();
          isThrusting = false;
        }
      }
    } else {
      int random = (int)random(4);
      if (!isThrusting) {
        switch (random) {
          case 0: 
            isThrusting = true;
            thrustRemaining = 0;
            genes.add(action.thrust);
            ship.thrust();
            break;
          case 1:
            genes.add(action.left);
            ship.turnLeft();
            break;
          case 2:
            genes.add(action.right);
            ship.turnRight();
            break;
          case 3:
            genes.add(action.none);
            break;
        }
      } else {
        if (thrustRemaining > 0) {
          ship.thrust();
          thrustRemaining--;
          genes.add(action.none);
        } else {
          ship.thrust();
          isThrusting = false;
          genes.add(action.none);
        }
      }
      
      if (genes.size() > 10000) {
        ship.destroy();
      }
    }
    
    if (ship.isDestroyed() || ship.isLanded()) {
      targetIndex = findNearestTarget();
      proximity = findProximity(targetIndex);
      finalVSpeed = abs(ship.getVSpeed());
      finalHSpeed = abs(ship.getHSpeed());
      finalRotation = abs(ship.getRotation());
      setPrefitness();
      isActive = false;
    }
    
    //ship.drawShip();
    boundDetection();
  }
  
  private void setPrefitness(){ 
    int difficulty = 0;
    
    switch(targetIndex) {
      case 0:
        difficulty = 1;
        break;
      case 1:
        difficulty = 1;
        break;
      case 2:
        difficulty = 5;
        break;
      case 3:
        difficulty = 1;
        break;
      case 4:
        difficulty = 1;
        break;
    }
    
    float target = pow(0.15 * 100, 3) + (sq(10 / difficulty)) + sq(finalHSpeed * 100) + sq(finalRotation * 100);
    fitness = pow(finalVSpeed * 100, 3) + (sq(proximity / difficulty)) + sq(finalHSpeed * 100) + sq(finalRotation * 100);
    fitness = target / fitness; //<>//
    
    if (ship.isLanded) {
      fitness *= 2;
    } 
    else if (outOfBounds) {
      fitness /= 2;
    }
  }
  
  public float getFitness() {
    return fitness;
  }
  
  public void setFitness(float fitness) {
    this.fitness = fitness;
  }
  
  public DNA crossover(DNA partner, int index) {
    DNA child = new DNA(index);
    
    int midpoint = (int)random(genes.size());
    
    for (int i = 0; i < genes.size(); i++) {
      if (i < midpoint) {
        child.genes.add(genes.get(i));
      } else {
        if (partner.getGenes().size() > i) {
          child.genes.add(partner.getGenes().get(i));
        }
      }
    }
    
    return child;
  }
  
  public void mutate(float mutationRate) {
    for (int i = 0; i < genes.size(); i++) {
      if (random(1) < mutationRate) {
        int rand = (int)random(4);
        switch (rand) {
          case 0:
            genes.set(i, action.thrust);
          case 1:
            genes.set(i, action.left);
          case 2:
            genes.set(i, action.right);
          case 3:
            genes.set(i, action.none);
        }
      }
    }
  }
  
  private int findNearestTarget() {
    float currentNearest = 100000;
    int index = -1;
    for (int i = 0; i < targets.length; i++) {
      float proximity = findProximity(i);
      if (proximity < currentNearest) {
        currentNearest = proximity;
        index = i;
      }
    }
    return index;
  }
  
  private float findProximity(int index) {
    float a = abs(ship.getXPos() - targets[index][0]);
    float b = abs(ship.getYPos() - targets[index][1]);
    return sqrt(sq(a) + sq(b));
  }
  
  private void boundDetection() {
    if (ship.getXPos() < 0 || ship.getXPos() > width || ship.getYPos() < 0 || ship.getYPos() > height) {
      outOfBounds = true;
      ship.destroy();
    }
  }
  
  public boolean isActive() {
    return isActive;
  }
  
  public ArrayList<action> getGenes() {
    return genes;
  }
  
  public Ship getShip() {
    return ship;
  }
  
  public void printAtributes() {
    println("target: " + targetIndex);
    println("Proximity: " + proximity);
    println("VSpeed: " + finalVSpeed);
    println("HSpeed: " + finalHSpeed);
    println("Rotation: " + finalRotation);
  }
}

public enum action {
  thrust,
  left,
  right,
  none
}

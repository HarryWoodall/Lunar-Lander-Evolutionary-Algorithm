class Controller {
  
  private DNA population[] = new DNA[300];
  private int currentIndex = 0;
  private int currentGeneration = 1;
  private float currentMaxFitness = 0;
  private float generationMaxFitness = 0;
  private float totalAverageFitness = 0;
  private float averageFitness = 0;
  private float mutationRate = 0.01;
  
  private int currentFrame = 0;
  private boolean ended = false;
  private int landings = 0;
  
  public Controller() {
    for (int i = 0; i < population.length; i++) {
      population[i] = new DNA(i);
    }
  }
  
  public void simulate() {
    boolean totalCompletion = true;
    for (int i = 0; i < population.length; i++) {
      if (population[i].isActive()) {        
        population[i].performAction(currentFrame);
        totalCompletion = false;
      }
      population[i].getShip().drawShip();
    }
    
    generateText();
    
    if (totalCompletion) {
      //evaluateFitness();
      for (int i = 0; i < population.length; i++) {
        currentIndex++;
      }
      ended = true;
      println("End Phase");
      calculateLandings();
      selection();
      currentGeneration++;
      currentFrame = 0;
    }
    
    currentFrame++;
  }
  
  private void selection() {
    ArrayList<DNA> matingPool = new ArrayList();    
    generationMaxFitness = 0;
    int index = 0;
    float totalFitness = 0;
    
    for (int i = 0; i < population.length; i++) {
      int n = (int)(population[i].getFitness() * 100);
      
      totalFitness += population[i].getFitness();
      
      if (population[i].getFitness() > generationMaxFitness) {
        generationMaxFitness = population[i].getFitness();
        index = i;        
      }
      
      if (population[i].getFitness() > currentMaxFitness) {
        currentMaxFitness = population[i].getFitness();
        println("CurrentMaxFitness: " + currentMaxFitness);
        population[i].printAtributes();
      }
      
      for (int j = 0; j < n; j++) {
        matingPool.add(population[i]);
      }
    }
    
    totalAverageFitness += (totalFitness / 100);
    averageFitness = totalAverageFitness / currentGeneration;
    
    println("Generation Champ: ");
    population[index].printAtributes();
    
    for (int i = 0; i < population.length; i++) {
      DNA parentA = matingPool.get((int)random(matingPool.size()));
      DNA parentB = matingPool.get((int)random(matingPool.size()));
      DNA child = parentA.crossover(parentB, i);
      child.mutate(mutationRate);
      
      population[i] = child;
    }
  }
  
  private void evaluateFitness() {
    float maxValue = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].getFitness() > maxValue) {
        maxValue = population[i].getFitness();
      }
    }
    
    for (int i = 0; i < population.length; i++) {
      population[i].setFitness(1 - (population[i].getFitness() / maxValue));
    }
  }
  
  public Ship[] getShips() {
    Ship ships[] = new Ship[population.length];
    for (int i = 0; i < population.length; i++) {
      ships[i] = population[i].getShip();
    }
    
    return ships;
  }
  
  public void calculateLandings() {
    landings = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].getShip().isLanded) {
        landings++;
      }
    }
  }
  
  public void generateText() {
    text("Max Fitness last Generation: " + generationMaxFitness, width - 250, 20);
    text("Current Max Fitness: " + currentMaxFitness, width - 250, 40);
    text("Landings last Generation: " + landings, width - 250, 60);
    text("Average Fitness: " + averageFitness, width - 250, 80);
    text("Current Generation: " + currentGeneration, width - 250, 100);
  }
  
  public boolean isEnded() {
    return ended;
  }
  
  public void reset() {
    ended = false;
  }
}

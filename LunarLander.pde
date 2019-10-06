float x = 0;
Ship ship;
Ship ships[];
Terrain terrain;
Controller controller;

void setup() {
  frameRate(200);
  size(1200, 700);
  ship = new Ship(-1);
  controller = new Controller();
  ships = controller.getShips();
  terrain = new Terrain(ships);
  rotate(PI/3.0);
}

void draw() {
  background(0);
  terrain.drawTerrain();
  controller.simulate();
  
  if (controller.isEnded()) {
    terrain.setShips(controller.getShips());
    controller.reset();
  }
  //ship.drawShip();
}

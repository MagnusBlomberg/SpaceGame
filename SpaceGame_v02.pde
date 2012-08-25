import ddf.minim.*; //Sound library
boolean[] keys = new boolean[526];
boolean mouseDown;
Ship ship;
ArrayList shots;
ArrayList explosions;
ArrayList enemyShips;
AudioPlayer player;
Minim minim;
void setup(){
  minim = new Minim(this);  
  size(800, 600);
  rectMode(CENTER);
  ship = new Ship(new PVector(100, 100), .2, .11, 0.1, "spaceship.png", 600);
  ship.addWeapon("laser", 1, 1, false, true);
  ship.addWeapon("laser", 1, 2, false, true);
  ship.maxSpeed = 8;
  shots = new ArrayList();
  explosions = new ArrayList();
  enemyShips = new ArrayList();
  enemyShips.add(new Ship(new PVector(300, 100), .02, .02, 0.05, "spaceship2.png", 100));
/*  enemyShips.add(new Ship(500, 200, .05, .02, 2000, "spaceship2.png", 100));
  enemyShips.add(new Ship(200, 2000, .05, .02, 1200, "spaceship2.png", 100));
  enemyShips.add(new Ship(700, 2000, .05, .02, 200, "spaceship2.png", 100));
  enemyShips.add(new Ship(5000, 200, .05, .02, 5000, "spaceship2.png", 100));
  enemyShips.add(new Ship(6000, 200, .05, .02, 100, "spaceship2.png", 100));*/
  enemyShips.add(new Ship(new PVector(500, 100), .01, .01, 0.01, "mothership.png", 1000));
  for (int i = enemyShips.size() - 1; i >= 0; i--) {
    Ship enemyShip = (Ship) enemyShips.get(i);
    enemyShip.addWeapon("laser", 1, 0, true, false);
  }
  Ship enemyShip = (Ship) enemyShips.get(1);
  enemyShip.addWeapon("laser", 1, 1, true, false);
  enemyShip.addWeapon("laser", 1, 2, true, false);
  smooth();
}
void draw (){
  background(150);
  if (!ship.disabled){
    ship.targetMouse();
    ship.wantedPosition.set(mouseX, mouseY, 0);
    ship.update();
  }
  displayExplosions();
  updateEnemyShips();
  if (mouseDown){
    ship.fireAll();
  }
  if (ship.health < 0){
    gameOver();
  }
}

void displayExplosions(){
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion explosion = (Explosion) explosions.get(i);
    if (millis()-explosion.created > explosion.duration){
      explosions.remove(i);
    } else {
      explosion.display();
    }
  }
}

void updateEnemyShips(){
  for (int i = enemyShips.size() - 1; i >= 0; i--) {
    Ship enemyShip = (Ship) enemyShips.get(i);
    if (enemyShip.health < 0){
      explosions.add(new Explosion(enemyShip.position, 200, "explosion1.png"));
      player = minim.loadFile("boom1.wav", 2048);
      player.play();
      enemyShips.remove(i);
    } else {
      if (!ship.disabled){
        enemyShip.wantedPosition = ship.position;        
        PVector tmpVect = new PVector(enemyShip.acc,0);
        tmpVect.rotate(enemyShip.direction);
        enemyShip.acceleration.add(tmpVect);
//        enemyShip.acceleration = PVector.fromAngle(PVector.angleBetween(enemyShip.position, enemyShip.wantedPosition), null).mult(enemyShip.acc);
        enemyShip.velocity.add(enemyShip.acceleration);
        enemyShip.targetShip();
      }      
      enemyShip.update();
      if (enemyShip.position.dist(ship.position) < 700 && !ship.disabled){
        enemyShip.fireAll();
      } else {
        enemyShip.holdAllFire();
      }
    }
  }
}

void mouseMoved() {
//  ship.updateDirection();
}
void mousePressed() {
  mouseDown = true;
  ship.fireAll();
}
void mouseReleased() {
  mouseDown = false;
  ship.holdAllFire();
}

boolean checkKey(int k){
  if (keys.length >= k) {
    return keys[k];  
  }
  return false;
}

void keyPressed(){
  keys[keyCode] = true;
  if (checkKey(KeyEvent.VK_W)){
    PVector tmpVect = new PVector(ship.acc,0);
    tmpVect.rotate(ship.direction);
    ship.acceleration.add(tmpVect);
    
    

//    ship.xspeed += ship.acc * cos(ship.direction);
//    ship.yspeed += ship.acc * sin(ship.direction);
  }
  if (checkKey(KeyEvent.VK_D)){
//    ship.xspeed += ship.strafeAcc * cos(ship.direction + PI / 2);
 //   ship.yspeed += ship.strafeAcc * sin(ship.direction + PI / 2);
  } 
  if (checkKey(KeyEvent.VK_A)){
//    ship.xspeed += ship.strafeAcc * cos(ship.direction - PI / 2);
//    ship.yspeed += ship.strafeAcc * sin(ship.direction - PI / 2);
  } 
  if (key=='c'){
    ship.distancedShots = !ship.distancedShots;
    for (int i = ship.weapons.size()-1; i >= 0; i--) {
      Weapon weapon = (Weapon) ship.weapons.get(i);
      weapon.proximityShots = ship.distancedShots;
    }    
  }
}
void keyReleased(){
  keys[keyCode] = false; 
}

void gameOver(){
  ship.disabled = true;
  ship.health = 0;
  println("Game Over");
}

class Ship{
  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  PVector wantedPosition = new PVector();
  float direction;
  float health;
  float maxHealth;
  float maxSpeed;
  PImage shipImage;
  float acc;
  float strafeAcc;
  float turnSpeed;
  float turnAcc;
  boolean disabled;
  boolean distancedShots;
  ArrayList weapons;
  
  Ship(PVector newPosition, float newAcc, float newStrafeAcc, float newTurnSpeed, String newShipImage, float newHealth){
    shipImage = loadImage(newShipImage);
    position = newPosition;
    acc = newAcc;
    strafeAcc = newStrafeAcc;
    maxHealth = newHealth;
    health = maxHealth;
    turnSpeed = newTurnSpeed;
    maxSpeed = 3;
    weapons = new ArrayList();
  }
  
  void fireAll(){
    for (int i = weapons.size()-1; i >= 0; i--) {
      Weapon weapon = (Weapon) weapons.get(i);
      weapon.tryToFire = true;
    }
  }
  void holdAllFire(){
    for (int i = weapons.size()-1; i >= 0; i--) {
      Weapon weapon = (Weapon) weapons.get(i);
      weapon.tryToFire = false;
    }
  }
  void addWeapon (String type, int level, int slot, boolean newDamageShip, boolean newDamageEnemy){
    weapons.add(new Weapon(type, level, slot, newDamageShip, newDamageEnemy));
  }
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(direction);
    imageMode(CENTER);
    image(shipImage, 0, 0);
    
    for (int i = weapons.size() - 1; i >= 0; i--){
      Weapon weapon = (Weapon) weapons.get(i);
      pushMatrix();
      translate(weapon.offset.y, weapon.offset.x);
      ellipse(0,0,3,3);
      rotate(weapon.direction - direction);
      imageMode(CENTER);
      image(weapon.weaponImage, 0, 0);
      popMatrix();
    }
    
    popMatrix();
    rectMode(CORNER);
    fill(170, 0, 0);
    rect(position.x - 8, position.y - 12, 16, 4);
    fill(0, 255, 0);
    rect(position.x - 8, position.y - 12, map(health, 0, maxHealth, 0, 16), 4);
  }
  void update(){
    velocity.add(acceleration);
    acceleration.set(0,0,0);
    velocity.mult(0.99);
    velocity.limit(maxSpeed);
    position.add(velocity);
    updateDirection();
    display();
    updateWeapons();
  }
  void targetMouse(){
    for (int i = weapons.size() - 1; i >= 0; i--) { 
      Weapon weapon = (Weapon) weapons.get(i);
      weapon.targetPosition.set((float)mouseX, (float)mouseY, 0);
    }
  }
  void targetShip(){
    for (int i = weapons.size() - 1; i >= 0; i--) {
      Weapon weapon = (Weapon) weapons.get(i);
      weapon.targetPosition = ship.position;
    }
  }
  void updateWeapons(){
    for (int i = weapons.size()-1; i >= 0; i--) {
      Weapon weapon = (Weapon) weapons.get(i);
      weapon.update(direction, position, velocity.mag());
    }
  }
  void updateDirection(){
    direction = atan2(-1*(position.x - wantedPosition.x), position.y - wantedPosition.y) - HALF_PI;
  }
}
  


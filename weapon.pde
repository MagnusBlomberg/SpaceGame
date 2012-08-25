class Weapon{
  float reloadTime;
  float rpm;
  int magazineSize;
  int magazine;
  float damage;
  float lastFired;
  float startedReloading;
  float direction;
  PVector shipVelocity = new PVector();
  PVector targetPosition = new PVector();
  float speed;
  float shipSpeed;
  boolean proximityShots;
  boolean damageEnemy;
  boolean damageShip;
  boolean autoFire;
  boolean tryToFire;
  boolean reloading;
  boolean disabled;
  boolean canRotate;
  String type;
  int level;
  int slot;
  float sensorRadius;
  PVector offset = new PVector();
  PVector shipPosition = new PVector();
  PVector position = new PVector();
  float offsetDistance;
  float range;
  PImage weaponImage;
  ArrayList shots;
  Weapon(String newType, int newLevel, int newSlot, boolean newDamageShip, boolean newDamageEnemy){
    type = newType;
    level = newLevel;
    shots = new ArrayList();
    damageShip = newDamageShip;
    damageEnemy = newDamageEnemy;
    if (type == "laser"){
      rpm = 300;
      magazineSize = 50;
      reloadTime = 1000;
      damage = 20;
      offsetDistance = 10;
      speed = 7;
      range = 300;
      canRotate = true;
      weaponImage = loadImage("turret1.png");
      updateLevel();
    }
    slot = newSlot;
    switch (slot){
      case 1:
        offset.set(-20, 5, 0);
        break;
      case 2:
        offset.set(20, 5, 0);
        break;
    } 
    reload();
  }
  void updateLevel(){
    //Vet inte hur jag ska göra detta än.
  }
  void update(float newShipDirection, PVector newShipPosition, float newShipSpeed){
    shipPosition = newShipPosition;
    shipSpeed = newShipSpeed;
    direction = newShipDirection;
    position.set(shipPosition);
    PVector tmpDir = offset.get();
    tmpDir.rotate(direction + HALF_PI);
    position.add(tmpDir);
    
    if (canRotate){
      direction = atan2(-1*(position.x - targetPosition.x), position.y - targetPosition.y) - HALF_PI;
    }
    if (tryToFire && !disabled){
      if (millis() - lastFired > 60000/rpm && magazine > 0){
        fire();
      } else if (magazine <= 0 && !reloading){
        reload();
      } else if (reloading && millis() - startedReloading > reloadTime){
        magazine = magazineSize;
        reloading = false;
      }
    }
    updateShots();
  }
  
  
  void updateShots(){
    for (int i = shots.size()-1; i >= 0; i--) {
      Shot shot = (Shot) shots.get(i);
      shot.update();
      if (shot.shouldBeDestroyed){
        shot.explode();
        shots.remove(i);
      }
    }
  }
  void reload(){
    startedReloading = millis();
    reloading = true;
  }
  
  void fire(){
      PVector tmpVect = new PVector(speed, 0);
      tmpVect.rotate(direction);
    if (proximityShots){
      float tmpDist = PVector.dist(targetPosition, position) - offsetDistance;
      if (tmpDist > range){
        tmpDist = range;
      }
      shots.add( new Shot(position.get(), tmpVect, tmpDist, damageShip, damageEnemy));
    } else {
      shots.add( new Shot(position.get(), tmpVect, range, damageShip, damageEnemy));
    }
    magazine -= 1;
    lastFired = millis();
    player = minim.loadFile("pew.wav", 2048);
    player.play();
  }
}

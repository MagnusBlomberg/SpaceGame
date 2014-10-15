class Shot{
  PVector position;
  PVector velocity;
  float range;
  float travelledRange;
  float damage;
  float health;
  PImage shotImage; //hejfas
  boolean shouldBeDestroyed;
  boolean damageShip;
  boolean damageEnemy;
  
  Shot(PVector newPosition, PVector newVelocity, float newRange, boolean newDamageShip, boolean newDamageEnemy){
    position = newPosition;
    velocity = newVelocity;
    range = newRange;
    shotImage = loadImage("laser.png");
    damage = 10;
    damageShip = newDamageShip;
    damageEnemy = newDamageEnemy;
  }
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading2D());
    imageMode(CENTER);
    image(shotImage, 0, 0);
    popMatrix();
  }
    
  void update(){
    position.add(velocity);
    travelledRange += velocity.mag();
    if (travelledRange > range){
      shouldBeDestroyed = true;
    } else {
      checkCollission();
    }
    display();
  }
  
  void checkCollission(){
    if (damageEnemy){
      for (int i = enemyShips.size() - 1; i >= 0; i--) {
        Ship enemyShip = (Ship) enemyShips.get(i);
        if (enemyShip.position.dist(position) < 30){
          shouldBeDestroyed = true;
        }
      }
    }
    if (damageShip && ship.position.dist(position) < 30){
      shouldBeDestroyed = true;
    }
  }
  void explode(){
    explosions.add(new Explosion(position, 200, "explosion1.png"));
    for (int i = enemyShips.size() - 1; i >= 0; i--) {
      Ship enemyShip = (Ship) enemyShips.get(i);
      if (enemyShip.position.dist(position) < 50){
        enemyShip.health -= damage;
      }
    }
    if (ship.position.dist(position) < 50){
      ship.health -= damage;
    }
  }
}

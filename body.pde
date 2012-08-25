class body{
  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  PVector angularDisplacement = new PVector();
  PVector angularVelocity = new PVector();
  PVector angularAcceleration = new PVector();
  
  float mass;
  body(PVector newPosition, float newMass){
    position = newPosition;
    mass = newMass;
  }
  void affectShip(Ship newShip){
    
  }
}

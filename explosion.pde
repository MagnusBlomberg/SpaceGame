class Explosion{
  PVector position;
  float duration;
  float created;
  PImage explosionImage;
  Explosion(PVector newPosition, float newDuration, String newExplosionImage){
    position = newPosition;
    duration = newDuration;
    explosionImage = loadImage(newExplosionImage);
    created = millis();
    player = minim.loadFile("boom1.wav", 2048);
    player.play();
  }
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    imageMode(CENTER);
    image(explosionImage, 0, 0);
    popMatrix();
  }
}

class Bird
{
  float y; //height
  float x = 75; //set, since the bird only moves up and down
  float radius; //radius for hitbox
  float yAcc; //y acceleration
  float jumpSpeed; //speed of jumping

  void show() //draws bird
  {
    sprite.resize(40,40);
    image(sprite, this.x - 20, this.y - 20); 
  }
}

class Bird
{
  float y;
  float x = 75;
  float radius;
  float yAcc;
  float jumpSpeed;

  void show()
  {
    sprite.resize(40,40);
    image(sprite, this.x - 20, this.y - 20); 
  }
}
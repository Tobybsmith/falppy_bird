class Bird
{
  //The centre of the brid circle
  float x;
  float y;

  //The radius of the bird circle
  float radius;
  
  float yAcc;
  
  float jumpSpeed;

  void show()
  {
    ellipse(this.x, this.y, this.radius, this.radius);
  }
}

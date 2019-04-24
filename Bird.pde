class Bird
{
  //The centre of the bird circle
  float y;

  //The radius of the bird circle
  float radius;

  float yAcc;

  float jumpSpeed;

  void show()
  {
    ellipse(75, this.y, this.radius, this.radius);
  }
}

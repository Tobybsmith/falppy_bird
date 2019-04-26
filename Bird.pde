class Bird
{
  float y;
  float x = 75;
  float radius;
  float yAcc;
  float jumpSpeed;
  color c;

  void show()
  {
    fill(c);
    ellipse(75, this.y, this.radius, this.radius);
  }
}

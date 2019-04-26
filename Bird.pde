class Bird
{
  float y;
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

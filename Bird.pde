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
    if(this.yAcc > 0)
    {
      c = #0000FF;
    }
    else if(this.yAcc < 0)
    {
      c = #FF0000;
    }
    else
    {
      c = #000000;
    }
    ellipse(75, this.y, this.radius, this.radius);
  }
}

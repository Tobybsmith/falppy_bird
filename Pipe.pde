class Pipe
{
  float x = width;
  float y = random(height/2);
  float yBottom = this.y + 200;
  float yLenBottom = yBottom + height;
  float xLen = 20;
  float yLen = y - height;
  color c = #75FF33;
  int score = 0;
  boolean passed = false;

  void show()
  {
    if (ProMode)
    {
      this.c = #FF0000;
    }
    fill(c);
    //Top rectangle
    rect(this.x, this.y, this.xLen, this.yLen);
    //Bottom rectangle
    rect(this.x, this.yBottom, this.xLen, this.yLenBottom);
  }
  void update()
  {
    this.x = this.x - pipeSpeed;
    if (x <= 75 && this.score == 0)
    {
      this.score = 1;
    }
  }
  boolean hits(Bird b)
  {
    if (b.y + b.radius/2 > this.yBottom || b.y - b.radius/2 < this.y)
    {
      if (b.x + b.radius/2 > this.x && b.x - b.radius/2 < this.x + this.xLen)
      {
        return true;
      }
    }
    return false;
  }
  void colorTo(color col)
  {
    c = col;
  }
}
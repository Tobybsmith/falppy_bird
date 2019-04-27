class Pipe
{
  float x = width;
  float y = random(height/2 - b.radius);
  float yBottom = this.y + 150;
  float yLenBottom = yBottom + height;
  float xLen = 20;
  float yLen = y - height;
  color c = #1b5e20;
  void show()
  {
    fill(c);
    rect(this.x, this.y, this.xLen, this.yLen);
    rect(this.x, this.yBottom, this.xLen, this.yLenBottom);
  }
  void update()
  {
    this.x = this.x - pipeSpeed;
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
}

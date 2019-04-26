class Pipe
{
  float x;
  float y;
  float xLen;
  float yLen;
  color c;
  void show()
  {
    fill(c);
    rect(this.x, this.y, this.xLen, this.yLen);
  }
  void update()
  {
    //detect collisions here
    this.x = this.x - pipeSpeed;
  }
}

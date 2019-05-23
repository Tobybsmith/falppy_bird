class Pipe
{
  float x = width; //where pipe is drawn, originally width, the far right of the screen
  float y = random(height/2); //height of pipe
  float yBottom; //bottom of pipe
  float yLenBottom = height; //where the bottom of the pipe is drawn
  float xLen = 20; //width of pipe
  float yLen = y - height; //where the top of the pipe is drawn
  color c = #75FF33; //color of the pipe
  int score = 0; //used for scoring
  boolean passed = false;

  void show() //draw the pipe
  {
    if (ProMode) //draw pipe in high contrast color if in promode
    {
      this.c = #FF0000;
    }
    fill(c); //fill with the color of the pipe
    //Top rectangle
    rect(this.x, this.y, this.xLen, this.yLen); //draw top pipe
    //Bottom rectangle
    rect(this.x, this.yBottom, this.xLen, this.yLenBottom); //draw bottom pipe
  }
  void update() //change where the pipe is
  {
    this.x = this.x - pipeSpeed; //if the pipe is past the bird, set score to 1
    if (x <= 75 && this.score == 0)
    {
      this.score = 1;
    }
  }
  boolean hits(Bird b) //check if it hits the bird, return if it does
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
  void colorTo(color col) //receives color to use
  {
    c = col;
  }
}

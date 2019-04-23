import processing.sound.*;  

Bird b = new Bird();
float gravity = 0.5;

boolean hasJumped = false;

SoundFile file;

void setup()
{ 
  size(1000, 500);
  b.y = 100;
  b.radius = 40;
  b.yAcc = 1;
  b.jumpSpeed = 5;
  background(200);
  noStroke();
  file = new SoundFile(this, "music.wav");
}

void draw()
{
  background(200);
  fill(0);
 
  b.y = b.y + b.yAcc;
  b.yAcc = b.yAcc + gravity;
  if(hasJumped)
  {
    b.yAcc = b.yAcc - b.jumpSpeed;
    hasJumped = false;
  }

  if(mousePressed && !hasJumped)
  {
    hasJumped = true;
  }
   b.show();
}

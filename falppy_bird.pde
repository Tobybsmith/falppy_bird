Bird b = new Bird();
float gravity = 0.5;

boolean hasJumped = false;

void setup()
{
  rectMode(CENTER);
  size(1000, 500);
  b.x = 50;
  b.y = 100;
  b.radius = 40;
  b.yAcc = 1;
  b.jumpSpeed = 10;
  background(200);
  noStroke();
}

void draw()
{
  background(200);
  fill(0);
  b.show();
  
  b.y = b.y + b.yAcc;
  b.yAcc = b.yAcc + gravity;
  if(hasJumped)
  {
    b.yAcc = b.yAcc - b.jumpSpeed;
    hasJumped = false;
    
  }
  
  if(mousePressed)
  {
    hasJumped = true;
  }
}

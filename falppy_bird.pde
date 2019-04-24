import processing.sound.*;

Bird b = new Bird();
float gravity = 0.3;

int mode = 0;
int cooldown = 0;

boolean hasJumped = false;

boolean space = false;

boolean isAlive = true;

SoundFile file;

void setup()
{
  size(1000, 500);
  b.y = 100;
  b.radius = 40;
  b.yAcc = 1;
  b.jumpSpeed = 6;
  background(200);
  noStroke();
  file = new SoundFile(this, "music.mp3");
}

void draw()
{
  
  if (mode == 0)
  {
    int boxX = width/2 - 100;
    int boxY = 200;
    //Menu Time Boys!
    background(#4fc3f7);
    fill(#ffc107);
    rect(width/2 - 200, 100, 400, 75);
    textSize(30);
    fill(#fb8c00);
    text("Welcome to Falppy Bird!", width/2 - 180, 150);
    fill(#ffc107);
    rect(boxX, boxY, 200, 50);
    fill(#fb8c00);
    text("Click to play!", boxX + 7, boxY + 35);
    fill(#1b5e20);
    rect(0, height - 20, width, 30);
    if(mousePressed)
    {
      //If the user clicks on the box
      if((mouseX > boxX && mouseX < boxX + 200) && (mouseY > boxY && mouseY < boxY + 50))
      {
        mode = 1;
      }
    }
  } else if (mode == 1)
  {
    background(200);
    fill(0);

    b.y = b.y + b.yAcc;
    if (b.y > height)
    {
      b.y = height; //change to kill player
      isAlive = false;
    }
    if (b.y < 0)
    {
      b.y = 0; //change to kill player
      isAlive = false;
    }
    b.yAcc = b.yAcc + gravity;
    if (hasJumped)
    {
      b.yAcc = -b.jumpSpeed;
      hasJumped = false;
    }

    if (space && !hasJumped && cooldown == 0)
    {
      hasJumped = true;
      cooldown = 10;
      space = false;
    } else if (cooldown != 0)
    {
      cooldown -= 1;
      if (cooldown < 0)
      {
        cooldown = 0;
      }
    }
    b.show();
    if(!isAlive)
    {
      mode = 2;
    }
  }
  else if(mode == 2)
  {
    //Death Menu!
  }
}

void keyReleased()
{
  if(key == ' ')
  {
    space = true;
  }
}

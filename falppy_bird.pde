import processing.sound.*;

BufferedReader reader;
PrintWriter output;
String highscore;

Bird b = new Bird();

ArrayList<Pipe> pipeList = new ArrayList<Pipe>();
Pipe p1 = new Pipe();

float gravity = 0.35;
int score = 0;
int mode = 0;
int cooldown = 0;
int pipeSpeed = 3;

boolean hasJumped = false;
boolean space = false;
boolean isAlive = true;

SoundFile file;

void setup()
{
  
  size(1000, 500);
  //This messes with 
  reader = createReader("highscore.txt");
  
  try
  {
    highscore = reader.readLine();
    try
    {
      Integer.parseInt(highscore);
    }
      catch (Exception e)
    {
      highscore = "0";
      output = createWriter("highscore.txt");
      output.println("0");
      output.flush();
      output.close();
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  b.y = 100;
  b.radius = 40;
  b.yAcc = 1;
  b.jumpSpeed = 6;
  b.c = #ffc107;

  p1.x = width;
  p1.y = random(height/2 - b.radius*2);
  p1.xLen = 20;
  p1.yLen = p1.y - height;

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
    if (mousePressed)
    {
      //If the user clicks on the box
      if ((mouseX > boxX && mouseX < boxX + 200) && (mouseY > boxY && mouseY < boxY + 50))
      {
        mode = 1;
      }
    }
  } else if (mode == 1)
  {
    background(#4fc3f7);
    fill(0);

    b.y = b.y + b.yAcc;
    if (b.y > height - b.radius/2)
    {
      b.y = height - b.radius/2; //change to kill player
      isAlive = false;
    }
    if (b.y < 0 + b.radius/2)
    {
      b.y = 0 + b.radius/2; //change to kill player
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
    p1.show();
    p1.update();

    if (!isAlive)
    {
      mode = 2;
    }
  } else if (mode == 2)
  {

    //Death Menu!
    fill(#ffc107);
    rect(width/2 - 220, 200, 525, 75);
    textSize(30);
    fill(#fb8c00);
    text("You Died! Score: " + score + " Highscore: " + highscore, width/2 - 205, 250);
    fill(#ffc107);
    rect(width/2 - 110, 310, 180, 55);
    textSize(30);
    fill(#fb8c00);
    text("Play Again?", width/2 - 100, 350);
    if (mousePressed)
    {
      if ((mouseX > width/2 - 110 && mouseX < width/2 - 110 + 180) && (mouseY > 310 && mouseY < 310 + 55))
      {
        b.y = 100;
        isAlive = true;
        b.yAcc = 0;
        //Pipes reset
        mode = 1;
      }
    }
    //Store score if larger then current global highscore!
    //Maybe insult the player or something


    output = createWriter("highscore.txt");
    
    if (score > Integer.parseInt(highscore))
    {
    output.println(score);
    }
    else
    {
    output.println(highscore);
    }
    output.flush();
    output.close();
  }
}

void keyReleased()
{
  if (key == ' ')
  {
    space = true;
  }
}

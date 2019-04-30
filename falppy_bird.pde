//import processing.sound.*;

BufferedReader reader;
PrintWriter output;
String highscore;

PImage sprite;

Bird b = new Bird();

ArrayList<Pipe> pipeList = new ArrayList<Pipe>();

float gravity = 0.35;
int score = 0;
int justScored;
int mode = 0;
int cooldown = 0;
int pipeSpeed = 3;
int pipeSpace = 100;

boolean hasJumped = false;
boolean space = false;
boolean isAlive = true;
boolean safe = false;

//SoundFile music;
//SoundFile flap;
//SoundFile death;

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
  
  sprite = loadImage("rossJamieson.jpg");

  b.y = 100;
  b.radius = 40;
  b.yAcc = 1;
  b.jumpSpeed = 7;
  b.c = #ffc107;
  noStroke();
  
  //music = new SoundFile(this, "music.wav");
  //music.amp(0.5);
  
  
  //flap = new SoundFile(this, "sfxFlap.wav");
  //flap.amp(0.3);
  
  //death = new SoundFile(this, "sfxDeath.wav");
  //death.amp(0.1);
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
        //music.loop();
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
      //death.play();
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

    if (frameCount%100 == 0)
    {
      pipeList.add(new Pipe());
      
    }
    
    b.show();
    
    /*
    Some properties of the bird to score points we should take advantage of:
    - If the bird does not collide with a pipe (in the space) then the player has
    passed that pipe and should be awarded one point
    - If the player's X coordinate is inside the pipe space and they are alive, award one point
    - If the player hits a new rectangle in the pipe (would be made) award a point and remove collision
    (to avoid hundreds of points per pipe with the increment function)
    */
    
    for(int i = pipeList.size() - 1; i >= 0; i--)
    {
      Pipe p = pipeList.get(i);
      p.update();
      if (p.score == 1 && !p.passed)
      {
        score += p.score;
        p.passed = true;
      }
      if(p.x + p.xLen < 0)
      {
        pipeList.remove(p); 
      }
      if(p.hits(b))
      {
        isAlive = false;
        //death.play();
        p.show();
      }
      else
      {
        p.show();
      }
    }

    if (!isAlive)
    {
      mode = 2;
      if (score > Integer.parseInt(highscore))
      {
        highscore = str(score);
      }
      justScored = score;
    }
  } else if (mode == 2)
  {
    
    //Death Menu!
    fill(#ffc107);
    rect(width/2 - 220, 200, 525, 75);
    textSize(30);
    fill(#fb8c00);
    text("You Died! Score: " + justScored + " Highscore: " + highscore, width/2 - 205, 250);
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
        pipeList.clear();
        //restart(music);
        mode = 1;
      }
    }
    //Store score if larger then current global highscore!
    //Maybe insult the player or something


    output = createWriter("highscore.txt");
    if (score > Integer.parseInt(highscore))
    {
      output.println(score);
    } else
    {
      output.println(highscore);
    }
    output.flush();
    output.close();
    score = 0;
  }
}

void keyReleased()
{
  if (key == ' ')
  {
    space = true;
    //flap.play();
  }
}

//void restart(SoundFile file)
//{
  //file.stop();
  //delay(100);
  //file.play();
//}
//If this gives an error, please go to the Sketch
import processing.sound.*;

BufferedReader reader;
PrintWriter output;
String highscore;

PImage sprite;
PImage spriteAlt0;
PImage spriteAlt1;
PImage spriteAlt2;
PImage spriteAlt3;
PImage background1;
PImage background2;
PImage sky1;
PImage sky2;
PImage sky3;
PImage sky4;
PImage sansBkg1;
PImage sansBkg2;
PImage sansPlayer;
PImage bone;

Bird b = new Bird();

ArrayList<Pipe> pipeList = new ArrayList<Pipe>();

float gravity = 0.35;
float var = 200;

int score = 0;
int justScored;
int mode = 0;
int cooldown = 0;
int pipeSpeed = 3;
int pipeSpace = 100;
int bkgX = 0;
int bkg2X = 1000;
int skyX = 0;
int sky2X = 1000;
int sky3X = 0;
int sky4X = -2*1000;
int sansX = 0;
int sans2X = 1000;
int colourPalette = 1;
int pipenutte = 0;

boolean hasJumped = false;
boolean space = false;
boolean isAlive = true;
boolean safe = false;
boolean ProMode = false;
boolean justClicked = false;
boolean sans = false;

color text = #ff5722;
color background = #4fc3f7;
color box = #ffc107;
color ProBox = #ffc107;
color ProText = #ff5722;
color ground = #75ff33;
color dot = #f0fff0;

//The sound effects for the game
SoundFile music;
SoundFile flap;
SoundFile death;

void setup()
{

  size(1000, 500);
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

  sprite = loadImage("rossJamieson.png");
  spriteAlt0 = loadImage("rossJamieson.png");
  spriteAlt1 = loadImage("twitter.png");
  spriteAlt2 = loadImage("bird.png");
  spriteAlt3 = loadImage("obama.png");
  background1 = loadImage("bkg.png");
  background2 = loadImage("bkg.png");
  sky1 = loadImage("clouds.png");
  sky2 = loadImage("clouds.png");
  sky3 = loadImage("ships2.png");
  sky4 = loadImage("ships2.png");
  bone = loadImage("hummus.png");
  

  b.y = 100;
  b.radius = 40;
  b.yAcc = 1;
  b.jumpSpeed = 7;
  // noStroke();

  music = new SoundFile(this, "music.wav");
  music.amp(0.3);

  flap = new SoundFile(this, "sfxFlap.wav");
  flap.amp(0.1);

  death = new SoundFile(this, "sfxDeath.wav");
  death.amp(1);
}

void draw()
{
  strokeWeight(0);
  if (mode == 0)
  {

    int boxX = width/2 - 100;
    int boxY = 190;
    //Menu Time Boys!

    textSize(30);
    background(background);
    if (colourPalette % 3 != 0)
    {
      sky1.resize(width, 0);
      sky2.resize(width, 0);
      skyX--;
      sky2X--;
      if (skyX + width < 0)
      {
        skyX = width;
      }
      if (sky2X + width < 0)
      {
        sky2X = width;
      }
      image(sky1, skyX, 0);
      image(sky2, sky2X, 0);
    }
    //This is the menu box for the title
    fill(box);
    rect(width/2 - 200, 100, 400, 75);
    fill(text);
    text("Welcome to Falppy Bird!", width/2 - 180, 150);
    //This is the box for the play button
    fill(box);
    rect(boxX, boxY, 200, 50);
    fill(text);
    text("Click to play!", boxX + 7, boxY + 35);
    //This is the green grass bkg
    fill(ground);
    rect(0, height - 20, width, 30);
    fill(box);
    //For instructions
    rect(boxX, 260, 200, 50);
    fill(text);
    text("Instuctions", boxX + 21, 260 + 35);
    //This is for the credits button
    fill(box);
    rect(boxX, 330, 200, 50);
    fill(text);
    text("Credits", boxX + 48, 330 + 35);
    //This is for the customization box
    fill(box);
    rect(boxX, 400, 200, 50);
    fill(text);
    text("Customize", boxX + 27, 400 + 35);
    
    if (keyPressed && key == 's')
    {
      sans = true;
      sprite = loadImage("heart.png");
      background1 = loadImage("sansBkg.png");
      background2 = loadImage("sansBkg.png");
      sky1 = loadImage("sans.png");
      pipeSpeed = 15;
      pipeSpace = 40;
      mode = 1;
      ground = #ffffff;
    }
    
    if (mousePressed)
    {
      if (mouseX > boxX && mouseX < boxX + 200)
      {
        //1st Box (Play Button)
        if (mouseY > boxY && mouseY < boxY + 50)
        {
          mode = 1;
        }
        //2nd Box (Instructions)
        if (mouseY > 260 && mouseY < 260 + 50)
        {
          mode = 3;
        }
        //3rd Box (Credits)
        if (mouseY > 330 && mouseY < 330 + 50)
        {
          //mode = 4;
        }
        if (mouseY > 400 && mouseY < 400 + 50)
        {
          mode = 5;
        }
      }
    }
  } else if (mode == 1)
  {
    background1.resize(width, height);
    background2.resize(width + 5, height);
    sky1.resize(width, height/3);
    sky2.resize(width, height/3);
    
    if (!sans)
    {
      bkg2X = bkg2X - 2;
      bkgX = bkgX - 2;
    }
    if (sans)
    {
      skyX = skyX - 25;
      sky2X = sky2X - 25;
    }
    
    if (colourPalette % 3 == 1 && !sans)
    {
      skyX = skyX - 1;
      sky2X = sky2X - 1;
    }
    if (colourPalette % 3 == 2 && !sans)
    {
      skyX = skyX - 20;
      sky2X = sky2X - 20;
      sky3X = sky3X + 10;
      sky4X = sky4X + 10;
    }

    if (colourPalette % 3 != 0)
    {
      image(background1, bkgX, 0);
      image(background2, bkg2X, 0);
      image(sky1, skyX, 0);
      if (!sans)
      {
        image(sky2, sky2X, 0);
      }
    }

    if (colourPalette % 3 == 2)
    {
      image(sky3, sky3X, 0);
      image(sky4, sky4X, 0);
    }

    if (colourPalette % 3 == 0)
    {
      fill(255);
      rect(0, 0, width, height);
    }

    if (bkgX + width < 0)
    {
      bkgX = width;
    }
    if (bkg2X + width < 0)
    {
      bkg2X = width;
    }
    if (skyX + width < 0)
    {
      if (sans)
      {
        skyX = width * 5;
      }
      else
      {
        skyX = width;
      }
    }
    if (sky2X + width < 0)
    {
      sky2X = width;
    }
    if (sky3X > width)
    {
      sky3X = -width;
    }
    if (sky4X > width)
    {
      sky4X = -width;
    }
    b.y = b.y + b.yAcc;
    if (b.y > height - b.radius/2)
    {
      b.y = height - b.radius/2; //change to kill player
      isAlive = false;
      death.play();
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

    if (frameCount % pipeSpace == 0)
    {
      pipeList.add(new Pipe());
      pipenutte++;
    }

    var -= 0.03;
    if (var < 150)
    {
      var = 150;
    }

    b.show();

    for (int i = pipeList.size() - 1; i >= 0; i--)
    {
      Pipe p = pipeList.get(i);
      p.colorTo(ground);
      p.update();
      if (p.score == 1 && !p.passed)
      {
        score += p.score;
        p.passed = true;
      }
      if (p.x + p.xLen < 0)
      {
        pipeList.remove(p);
      }
      if (p.hits(b))
      {
        isAlive = false;
        death.play();
        p.show();
      } else
      {
        p.show();
      }

      if (pipenutte <= 5 && !sans)
      {
        fill(dot);
        ellipse(p.x - 28, p.y/2 + p.yBottom/2 + 30, 15, 15);
      }

      p.yBottom = p.y + var;
    }

    if (colourPalette % 3 == 1)
    {
      fill(0);
    }
    if (colourPalette % 3 == 2)
    {
      fill(255);
    }
    if (colourPalette % 3 == 0)
    {
      fill(#ff0000);
    }
    if (sans)
    {
      fill(255);
    }
    text(score, 50, 50);

    if (!isAlive)
    {
      if (sans)
      {
        exit();
      }
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
    fill(box);
    rect(width/2 - 260, 180, 520, 75);
    textSize(30);
    fill(text);
    text("You Died! Score: " + justScored + " Highscore: " + highscore, width/2 - 245, 230);
    fill(box);
    rect(width/2 - 260, 310, 180, 55);
    textSize(30);
    fill(text);
    text("Play Again?", width/2 - 250, 350);
    fill(box);
    rect(width/2 + 80, 310, 180, 55);
    fill(text);
    text("Main Menu", width/2 + 90, 350);

    if (mousePressed || keyPressed)
    {
      if (((mouseX > width/2 - 260 && mouseX < width/2 - 260 + 180) && (mouseY > 310 && mouseY < 310 + 55)) || (key == ' '))
      {
        reset();
        mode = 1;
      }
      if ((mouseX > width/2 + 80 && mouseX < width/2 + 80 + 180) && (mouseY > 310 && mouseY < 310 + 55))
      {
        reset();
        mode = 0;
      }
    }


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
  } else if (mode == 3)
  {
    background(background);
    fill(box);
    rect(width/2 - 200, height/2 - 200, 400, 400);
    textSize(50);
    fill(text);
    text("How to Play", width/2 - 145, height/2 - 130);
    textSize(30);
    text("Press space to jump!", width/2 - 180, height/2 - 60);
    text("Avoid the pipes!", width/2 - 180, height/2 - 20);
    text("Jump on lil nodes (yellow)", width/2 - 180, height/2 + 20);
    text("If your name happens to \nbe Mr. Jamieson, please\ngive this project 100%", width/2 - 180, height/2 + 60);

    stroke(text);
    strokeWeight(4);
    line(width/2 + 170, height/2 - 197, width/2 + 197, height/2 - 170);
    line(width/2 + 170, height/2 - 170, width/2 + 197, height/2 - 197);
    if (mousePressed)
    {
      if (mouseX < width/2 + 197 && mouseX > width/2 + 170)
      {
        if (mouseY > height/2 - 197 && mouseY < width/2 - 170)
        {
          mode = 0;
        }
      }
    }
  } else if (mode == 4)
  {
    mode = 1;
  } else if (mode == 5)
  {

    background(background);
    fill(box);
    int boxxY = height/2-100;
    sprite.resize(100, 100);
    spriteAlt0.resize(100, 100);
    spriteAlt1.resize(100, 100);
    spriteAlt2.resize(100, 100);
    spriteAlt3.resize(100, 100);
    image(spriteAlt0, width/2 - 400, boxxY);
    image(spriteAlt1, width/2 - 200, boxxY);
    image(spriteAlt2, width/2, boxxY);
    image(spriteAlt3, width/2 + 200, boxxY);
    image(sprite, width/2 - 100, boxxY + 225);
    fill(ProBox);
    rect(width/2 - 415, boxxY + 130, 170, 45);
    fill(ProText);
    text("Pro Mode", width/2 - 410, boxxY + 165);
    fill(box);
    rect(width/2 - 120, boxxY + 175, 135, 45);
    rect(width/2 + 200, boxxY + 130, 210, 45);
    fill(text);
    text("You are:", width/2 - 115, boxxY + 205);
    text("Palette Switch", width/2 + 205, boxxY + 165);
    fill(box);
    rect(width/2 - 140, 50, 205, 45);
    fill(text);
    text("Back to Menu", width/2 - 135, 85);
    if(sans)
    {
      
    }
    if (mousePressed)
    {
      if (mouseY > 50 && mouseY < 50 + 45)
      {
        if (mouseX > width/2 - 140 && mouseX < width/2 - 140 + 205)
        {
          mode = 0;
        }
      }
      if (mouseY > boxxY && mouseY < boxxY + 100)
      {
        if (mouseX > width/2 - 400 && mouseX < width/2 - 400 + 150)
        {
          sprite = loadImage("rossJamieson.png");
          //mode = 0;
        }
        if (mouseX > width/2 - 200 && mouseX < width/2 - 200 + 100)
        {
          sprite = loadImage("twitter.png");
          //mode = 0;
        }
        if (mouseX > width/2 && mouseX < width/2 + 100)
        {
          sprite = loadImage("bird.png");
          //This is the weed number!
          //mode = 0;
        }
        if (mouseX > width/2 + 200 && mouseX < width/2 + 200 + 100)
        {
          sprite = loadImage("obama.png");
          //mode = 0;
        }
      }
      if (mouseY > boxxY + 125 && mouseY < boxxY + 125 + 50)
      {
        if (mouseX > width/2 - 415 && mouseX < width/2 - 415 + 170 && !justClicked)
        {
          justClicked = true;
          ProMode = !ProMode;
          if (ProMode)
          {
            ProBox = text;
            ProText = box;
          } else
          {
            ProBox = box;
            ProText = text;
          }
        }
      }
      if (mouseY > boxxY + 130 && mouseY < boxxY + 175)
      {
        if (mouseX > width/2 + 200 && mouseX < width/2 + 410 && !justClicked)
        {
          justClicked = true;
          colourPalette += 1;
          if (colourPalette % 3 == 1)
          {
            background1 = loadImage("bkg.png");
            background2 = loadImage("bkg.png");
            sky1 = loadImage("clouds.png");
            sky2 = loadImage("clouds.png");
            if (ProBox == box)
            {
              ProBox = #ffc107;
              ProText = #fb8c00;
            } else
            {
              ProBox = #fb8c00;
              ProText = #ffc107;
            }
            text = #FF5722;
            background = #4fc3f7;
            box = #ffc107;
            ground = #1b5e20;
          }
          if (colourPalette % 3 == 2)
          {
            background1 = loadImage("bkg2.png");
            background2 = loadImage("bkg2.png");
            sky1 = loadImage("ships1.png");
            sky2 = loadImage("ships1.png");
            if (ProBox == box)
            {
              ProBox = #3a21c9;
              ProText = #8d0104;
            } else
            {
              ProBox = #8d0104;
              ProText = #3a21c9;
            }
            text = #8d0104;
            background = #28009f;
            box = #3a21c9;
            ground = #ff0000;
            dot = #F0FFF0;
          }
          if (colourPalette % 3 == 0)
          {
            if (ProBox == box)
            {
              ProBox = #808080;
              ProText = #ffffff;
            } else
            {
              ProBox = #ffffff;
              ProText = #808080;
            }
            text = #ffffff;
            background = #ffffff;
            box = #808080;
            ground = #000000;
            dot = #4fc3f7;
          }
        }
      }
    } else
    {
      justClicked = false;
    }
  }
}

void keyReleased()
{
  if (key == ' ')
  {
    space = true;
    flap.play();
  }
}
void mouseReleased()
{
  space = true;
  flap.play();
}

void restart(SoundFile file)
{
  file.stop();
  delay(100);
  file.play();
}

void reset()
{
  b.y = 100;
  pipenutte = 0; 
  var = 200;
  isAlive = true;
  b.yAcc = 0;
  pipeList.clear();
  restart(music);
  bkgX = 0;
  bkg2X = width;
}
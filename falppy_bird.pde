import processing.sound.*; 
//in the event that the skeych won't run, please go to the Sketch tab on the upper bar, 
//click on Import Library, and then import the Sound Library

BufferedReader reader; //reader for high score text file
PrintWriter output; //writer for high score text file
String highscore; //high score value

//images
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

//makes bird, from bird.pde
Bird b = new Bird();

//makes array of pipes, from pipe.pde
ArrayList<Pipe> pipeList = new ArrayList<Pipe>();

//floats
float gravity = 0.35; //gravity so it can be easily tweaked
float pipeWide = 200; //space between pipes, so it can change while the game is played
float soundPercent = 1; //sound percent for slider in customize

//ints
int score = 0; //score
int justScored; //held score for use across modes
int mode = 0; //mode, for which screen the player is in, including all of the offshoots of the menu and the actual gameplay
int cooldown = 0; //cooldown for flapping
int pipeSpeed = 3; //speed the pipes move towards the player at
int pipeSpace = 100; //number of frames in between each pipe spawn
int bkgX = 0; //x value of the first background image
int bkg2X = 1000; //x value of the copy of the first background image, so it can scroll and repeat
int skyX = 0; //x value of the secondary background image
int sky2X = 1000; //x value of the copy of the secondary background image, so it can scroll and repeat
int sky3X = 0; //x value of the tertiary background image
int sky4X = -4000; //x value of the copy of the tertiary background image, so it can scroll and repeat
int sansX = 0; //x value of the background image for sans mode
int sans2X = 1000; //x value of the copy of the background image for sans mode, so it can scroll and repeat
int colourPalette = 1; //which color mode the player is in
int beginnerPipe = 0; //counter so after the first few pipes the beginner dots stop appearing
int instructionNum = 0; //counts which instruction menu the player is on

boolean space = false; //boolean to prevent the space key from repeating without being released
boolean isAlive = true; //boolean for if the palyer is alive or not
boolean ProMode = false; //checks if player is in pro mode with high contrast pipes
boolean justClicked = false; //boolean to prevent clicking from repeating without being released
boolean sans = false; //checks if the player is in sans mode

color text = #ff5722; //starting text color
color background = #4fc3f7; //starting background color
color box = #ffc107; //starting box (for menus) color
color ProBox = #ffc107; //starting color for the promode box so it can flip when clicked
color ProText = #ff5722; //starting color for the promode text so it can flip when clicked
color pipeColor = #75ff33; //starting color for the pipes
color dot = #f0fff0; //starting color for the training dots

//The sound effects for the game
SoundFile music; //music
SoundFile flap; //flap sound
SoundFile death; //death sound

void setup()
{

  size(1000, 500); //makes screen
  reader = createReader("highscore.txt"); //reads highscore

  try //checks for input output exception
  {
    highscore = reader.readLine(); //sets highscore to the text
    try
    {
      Integer.parseInt(highscore); //sees if the text can be read as an integer
    }
    catch (Exception e) //if it can't, it remakes the text file with the highscore as 0
    {
      highscore = "0";
      output = createWriter("highscore.txt");
      output.println("0");
      output.flush();
      output.close();
    }
  } 
  catch (IOException e) { //throws exception if input/output exception
    e.printStackTrace();
  }

  //loads images
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

  //sets bird stuff
  b.y = 100; //bird y value
  b.radius = 40; //bird hitbox size
  b.yAcc = 1; //bird y acceleration
  b.jumpSpeed = 7; //bird jumpspeed

  //defines sounds and volumes
  music = new SoundFile(this, "music.wav");
  music.amp(0.3);

  flap = new SoundFile(this, "sfxFlap.wav");
  flap.amp(0.1);

  death = new SoundFile(this, "sfxDeath.wav");
  death.amp(1);

  restart(music); //starts playing the music at the start of the file
}

void draw()
{
  strokeWeight(0);
  if (mode == 0) //in the menus
  {

    int boxX = width/2 - 100;
    int boxY = 190;
    //Menu Time!

    textSize(30);
    background(background); 
    if (colourPalette % 3 != 0) //as long as it is the color palettes with background images, display them moving
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
    //This is the green grass for the background
    fill(pipeColor);
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

    if (keyPressed && key == 's') //if the player presses s, meant to be secret
    {
      sans = true;
      sprite = loadImage("heart.png"); //changes icon to the heart
      background1 = loadImage("sansBkg.png"); //sets the background images to the sans images
      background2 = loadImage("sansBkg.png");
      sky1 = loadImage("sans.png");
      //changes the pipe speed and distance apart
      pipeSpeed = 10;
      pipeSpace = 40;
      //switches immediately to gameplay, to disorient the player
      mode = 1;
      //changes the pipe color, the rest are for menus which will no longer be seen
      pipeColor = #ffffff;
      //resets background
      bkgX = 0;
      bkg2X = 1000;
    }

    if (mousePressed) //checks if the player clicks on the boxes
    {
      if (!justClicked)
      {
        if (mouseX > boxX && mouseX < boxX + 200)
        {
          //1st Box (Play Button)
          if (mouseY > boxY && mouseY < boxY + 50)
          {
            mode = 1;
            justClicked = true;
          }
          //2nd Box (Instructions)
          if (mouseY > 260 && mouseY < 260 + 50)
          {
            mode = 3;
            justClicked = true;
          }
          //3rd Box (Credits)
          if (mouseY > 330 && mouseY < 330 + 50)
          {
            mode = 4;
            justClicked = true;
          }
          //4th Box (Customize)
          if (mouseY > 400 && mouseY < 400 + 50)
          {
            mode = 5;
            justClicked = true;
          }
        }
      } else
      {
        justClicked = false;
      }
    }
  } else if (mode == 1)
  {
    background1.resize(width, height); //fits images
    background2.resize(width + 5, height);
    sky1.resize(width, height/3);
    sky2.resize(width, height/3);

    if (!sans) //moves first background image if not sans mode
    {
      bkg2X = bkg2X - 2;
      bkgX = bkgX - 2;
    }
    if (sans) //moves the secondary background image extremely quickly if sans mode
    {
      skyX = skyX - 25;
    }

    if (colourPalette % 3 == 1 && !sans) //moves the secondary background image slowly if in palette 1
    {
      skyX = skyX - 1;
      sky2X = sky2X - 1;
    }
    if (colourPalette % 3 == 2 && !sans) //moves the secondary background image as well as tertiary images very quickly if in palette 2
    {
      skyX = skyX - 20;
      sky2X = sky2X - 20;
      sky3X = sky3X + 10;
      sky4X = sky4X + 10;
    }

    if (colourPalette % 3 != 0 || sans) //draws the background if not palette 3, unless it's sans mode
    {
      image(background1, bkgX, 0);
      image(background2, bkg2X, 0);
      image(sky1, skyX, 0);
      if (!sans)
      {
        image(sky2, sky2X, 0); //if not sans draws the copy of the secondary background image
      }
    }

    if (colourPalette % 3 == 2 && !sans) //if palette is 3, also draw tertiary background images
    {
      image(sky3, sky3X, 0);
      image(sky4, sky4X, 0);
    }

    if (colourPalette % 3 == 0 && !sans) //fills background with white if in palette 3, unless on sans mode
    {
      fill(255);
      rect(0, 0, width, height);
    }

    if (bkgX + width < 0) //resets background images if they've gone off screen
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
        skyX = width * 5; //has skyX way further if in sans mode so it is off screen for longer
      } else
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
    b.y = b.y + b.yAcc; //changes bird y value by y acceleration
    if (b.y > height - b.radius/2) //kills player if they touch the ground
    {
      b.y = height - b.radius/2;
      isAlive = false;
      death.play(); //play death sound
    }
    b.yAcc = b.yAcc + gravity; //change bird y acceleration by gravity


    if (space && cooldown == 0) //if the player pressed space and isn't on cooldown, change their acceleration by the jumping speed
    {
      b.yAcc = -b.jumpSpeed;
      cooldown = 10;
      space = false;
    } else if (cooldown != 0) //if on cooldown, make the cooldown smaller
    {
      cooldown -= 1;
      if (cooldown < 0)
      {
        cooldown = 0;
      }
    }

    if (frameCount%pipeSpace == 0) //if it has been enough frames, make a new pipe
    {
      pipeList.add(new Pipe());
      beginnerPipe++;
    }

    pipeWide -= 0.03; //make the pipes slightly less wide

    if (pipeWide < 150) //keeps pipe width at the minimum of 150 pixels
    {
      pipeWide = 150;
    }

    b.show(); //draw the bird

    for (int i = pipeList.size() - 1; i >= 0; i--) //checks, for every pipe
    {
      Pipe p = pipeList.get(i);
      p.colorTo(pipeColor);
      p.update();
      if (p.score == 1 && !p.passed) //if the player passed it, if so, score
      {
        score += p.score;
        p.passed = true;
      }
      if (p.x + p.xLen < 0) //if the pipe is off screen, if so, delete it
      {
        pipeList.remove(p);
      }
      if (p.hits(b)) //if the player hit the pipe, if so, kill the player
      {
        isAlive = false;
        death.play();
      }

      p.show(); //draw the pipe

      if (beginnerPipe <= 5 && !sans) //if at most 5 pipes have been shown, draw the beginner dot
      {
        fill(dot);
        ellipse(p.x - 28, p.y/2 + p.yBottom/2 + 30, 15, 15);
      }

      p.yBottom = p.y + pipeWide; //draw the bottom pipe
    }

    //fill score the color pertaining to the palette they're on
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
      if (sans) //reset stuff if the player was on sans mode
      {
        sans = false;
        sprite = loadImage("rossJamieson.png");
        background1 = loadImage("bkg.png");
        background2 = loadImage("bkg.png");
        sky1 = loadImage("clouds.png");
        sky2 = loadImage("clouds.png");
        if (ProBox == box)
        {
          ProBox = #ffc107;
          ProText = #fb8c00;
        } 
        else
        {
          ProBox = #fb8c00;
          ProText = #ffc107;
        }
        text = #FF5722;
        background = #4fc3f7;
        box = #ffc107;
        pipeColor = #75ff33;
        colourPalette = 1;
        pipeSpeed = 3;
        pipeSpace = 100;
        justScored = -1; //sets score to -1 from sans mode
      } else //stores score if not in sans mode, sans mode scores are not counted
      {
        if (score > Integer.parseInt(highscore))
        {
          highscore = str(score); //check if the score was better than the highscore, if so, set the highscore to it
        }
        justScored = score; //prepares justScored for storing score across modes
      }
      mode = 2; //otherwise go to the death screen
    }
  } else if (mode == 2)
  {

    //Death Menu!
    fill(box); //box with scores and "You Died" message
    rect(width/2 - 260, 180, 520, 75);
    textSize(30);
    fill(text);
    text("You Died! Score: " + justScored + " Highscore: " + highscore, width/2 - 245, 230); //scores and "You Died" message
    fill(box);
    rect(width/2 - 260, 310, 180, 55); //play again box
    textSize(30);
    fill(text);
    text("Play Again?", width/2 - 250, 350);
    fill(box);
    rect(width/2 + 80, 310, 180, 55);
    fill(text);
    text("Main Menu", width/2 + 90, 350); //main menu box

    if (mousePressed || keyPressed) //checks if the player clicked on any if the boxes (or pressed space for playing again)
    {
      if (((mouseX > width/2 - 260 && mouseX < width/2 - 260 + 180) && (mouseY > 310 && mouseY < 310 + 55)) || (key == ' '))
      {
        reset(); //reset so the player can play again
        mode = 1;
      }
      if ((mouseX > width/2 + 80 && mouseX < width/2 + 80 + 180) && (mouseY > 310 && mouseY < 310 + 55))
      {
        reset(); //resets and returns to menu
        mode = 0;
      }
    }

    //stores highscore
    output = createWriter("highscore.txt");
    output.println(highscore);
    output.flush();
    output.close();
    score = 0; //resets score for playing again
  } else if (mode == 3)
  {
    background(background);
    fill(box); //how to play box
    rect(width/2 - 200, height/2 - 160, 400, 400);
    textSize(50);
    fill(text);
    text("How to Play", width/2 - 145, height/2 - 90);
    textSize(30);
    if (instructionNum == 0)
    {
      text("Press space or click to\njump!\nAvoid the pipes!\nIf your name happens to \nbe Mr. Jamieson, please\ngive this project 100%!", width/2 - 180, height/2 - 20); //instructions 1
    }
    if (instructionNum == 1)
    {
      text("The first few pipes\nshow a training dot,\nuse it if you need\nhelp knowing where to\njump.", width/2 - 180, height/2); //instructions 2
    }
    if (instructionNum == 2)
    {
      text("Pro mode turns on\nhigh contrast\npipes for increased\nvisibility. Turn it\non in customize.", width/2 - 180, height/2 - 20); //instructions 3
    }
    if (instructionNum == 3)
    {
      text("You can change your\ncharacter in customize,\njust click on the image\nyou want to be.", width/2 - 180, height/2 - 20); //instructions 4
    }
    if (instructionNum == 4)
    {
      text("Want to get right back\ninto the action?\nPress space on the death\nscreen to restart right\naway", width/2 - 180, height/2 - 20); //instructions 5
    }
    stroke(text);
    strokeWeight(4); //draws x in corner
    line(width/2 + 170, height/2 - 157, width/2 + 197, height/2 - 130);
    line(width/2 + 170, height/2 - 130, width/2 + 197, height/2 - 157);

    strokeWeight(0);
    fill(box); //previous instructions box
    rect(width/2 - 200, height/2 - 215, 175, 50);
    fill(text);
    text("Previous", width/2 - 175, height/2 - 180);
    fill(box); //next instructions box
    rect(width/2 + 25, height/2 - 215, 175, 50);
    fill(text);
    text("Next", width/2 + 75, height/2 - 180);


    if (mousePressed) //checks if player clicks x or one of the buttons
    {
      if (!justClicked) //makes sure the player hasn't just clicked
      {
        if (mouseX < width/2 + 197 && mouseX > width/2 + 170)
        {
          if (mouseY < height/2 - 130 && mouseY > height/2 - 157)
          {
            mode = 0;
          }
        }
        if (mouseY < height/2 - 160 && mouseY > height/2 - 210)
        {
          if (mouseX > width/2 + 25 && mouseX < width/2 + 200)
          {
            justClicked = true; //so it only counts once per click
            instructionNum ++; //go to the next instructions
          }
          if (mouseX > width/2 - 200 && mouseX < width/2 - 25)
          {
            justClicked = true; //so it only counts once per click
            instructionNum --; //go to the previous instructions
          }
        }
      }
    } else //if you didn't click, reset justClicked
    {
      justClicked = false;
    }
    if (instructionNum < 0)
    {
      instructionNum = 4; //reset to last instruction if before the first one
    }
    if (instructionNum > 4)
    {
      instructionNum = 0; //reset to first instruction if through the other two
    }
  } else if (mode == 4) //credits
  {
    background(background);
    fill(box); //credits box
    rect(width/2 - 200, height/2 - 25, 400, 125);
    fill(text); //credits text
    text("By: Toby and Malachi", width/2 - 150, height/2 + 25);
    text("We hope you enjoyed!", width/2 - 160, height/2 + 75);
    //back button
    fill(box);
    rect(width/2 - 75, height/2 - 100, 150, 50);
    fill(text);
    text("Back", width/2 - 35, height/2 - 65);
    if (mousePressed)
    {
      if (!justClicked)
      {
        if (mouseY > height/2 - 100 && mouseY < height/2 - 50)
        {
          if (mouseX > width/2 - 75 && mouseX < width/2 + 75)
          {
            mode = 0; //if clicked the back button, go back to the menu
            justClicked = true;
          }
        }
      } else
      {
        justClicked = false;
      }
    }
  } else if (mode == 5) //customize screen
  {

    background(background);
    fill(box);
    int boxxY = height/2-100;
    sprite.resize(100, 100); //draws sprites for player and possible choices
    spriteAlt0.resize(100, 100);
    spriteAlt1.resize(100, 100);
    spriteAlt2.resize(100, 100);
    spriteAlt3.resize(100, 100);
    image(spriteAlt0, width/2 - 400, boxxY);
    image(spriteAlt1, width/2 - 200, boxxY);
    image(spriteAlt2, width/2, boxxY);
    image(spriteAlt3, width/2 + 200, boxxY);
    image(sprite, width/2 - 100, boxxY + 225);
    fill(ProBox); //probox box
    rect(width/2 - 415, boxxY + 130, 170, 45);
    fill(ProText);
    text("Pro Mode", width/2 - 410, boxxY + 165);
    fill(box); //palette switch and "You are" boxes
    rect(width/2 - 120, boxxY + 175, 135, 45);
    rect(width/2 + 200, boxxY + 130, 210, 45);
    fill(text);
    text("You are:", width/2 - 115, boxxY + 205);
    text("Palette Switch", width/2 + 205, boxxY + 165);
    fill(box); //back to menu box
    rect(width/2 - 140, 50, 205, 45);
    fill(text);
    text("Back to Menu", width/2 - 135, 85);
    fill(box); //sound slider and box
    rect (width/2 - 405, 35, 110, 70);
    fill (text);
    text("Sound", width/2 - 395, 65);
    rect (width/2 - 400, 85, 100 * soundPercent, 15);

    if (mousePressed) //checks if the player clicks a sprite to change to, back to menu, or slider
    {
      if (mouseY > 85 && mouseY < 110)
      {
        if (mouseX > width/2 - 400 && mouseX < width/2 - 300)
        {
          //figures out where the player clicked in the bar and sets soundPercent to how far through it was,
          soundPercent = (mouseX - (width/2 - 400))/100.0;
          //then sets sound volumes accordingly
          music.amp(0.3 * soundPercent);
          flap.amp(0.1 * soundPercent);
          death.amp(1 * soundPercent);
        }
      }
      //if player clicked back to menu,
      if (mouseY > 50 && mouseY < 50 + 45)
      {
        if (mouseX > width/2 - 140 && mouseX < width/2 - 140 + 205)
        {
          mode = 0; //return to menu
        }
      }
      //if player clicked on one of the sprites, set them to that sprite
      if (mouseY > boxxY && mouseY < boxxY + 100)
      {
        if (mouseX > width/2 - 400 && mouseX < width/2 - 400 + 150)
        {
          sprite = loadImage("rossJamieson.png");
        }
        if (mouseX > width/2 - 200 && mouseX < width/2 - 200 + 100)
        {
          sprite = loadImage("twitter.png");
        }
        if (mouseX > width/2 && mouseX < width/2 + 100)
        {
          sprite = loadImage("bird.png");
        }
        if (mouseX > width/2 + 200 && mouseX < width/2 + 200 + 100)
        {
          sprite = loadImage("obama.png");
        }
      }
      //if promode was clicked on and the player hasn't just clicked, swap promode box and text and change promode
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
      //if color palette was clicked and the player hasn't just clicked, swap to the next color palette
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
            pipeColor = #75ff33;
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
            pipeColor = #ff0000;
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
            pipeColor = #000000;
            dot = #4fc3f7;
          }
        }
      }
    } else //if the player hasn't been clicking last time, set justClicked to false
    {
      justClicked = false;
    }
  }
}

void keyReleased() //method so whenever space is pressed it sets space to true and plays the flap noise
{
  if (key == ' ')
  {
    space = true;
    flap.play();
  }
}
void mouseReleased()
{
  space = true; //method so whenever the mouse is clicked it sets space to true and plays the flap noise
  flap.play();
}

void restart(SoundFile file) //method to reset the sound file
{
  file.stop();
  delay(100);
  file.play();
}

void reset() //resets stuff
{
  b.y = 100; //bird height
  beginnerPipe = 0; //how many pipes have been seen for training dots
  pipeWide = 200; //pipe width
  isAlive = true; //if the player is alive
  b.yAcc = 0; //bird acceleration
  pipeList.clear(); //clears the list of pipes
  restart(music); //plays music again
}
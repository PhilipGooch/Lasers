import processing.sound.*;
SoundFile powerUpAudio;
SoundFile beamAudio;
SoundFile laserAudio;
SoundFile levelStartAudio;
SoundFile levelCompleteAudio;
SoundFile endModuleAudio;

enum TYPE
{
  _START,
  _MIX, 
  _END
}

color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color YELLOW = color(255, 255, 0);
color CYAN = color(0, 255, 255);
color MAJENTA = color(255, 0, 255);
color WHITE = color(255, 255, 255);
color BLACK = color(0, 0, 0);

boolean frameMoved = false;
World world;
ArrayList<PImage> images;
int w = 7;
int h = 7;
int imageSize = 75;
float spacingX;
float spacingY;
int laserWidth = 8;

void setup()
{
  size(700, 700);
  powerUpAudio = new SoundFile(this, "Audio/powerUp.wav");
  powerUpAudio.amp(0.6);
  beamAudio = new SoundFile(this, "Audio/beam.wav");
  beamAudio.amp(0.6);
  laserAudio = new SoundFile(this, "Audio/laser.wav");
  levelStartAudio = new SoundFile(this, "Audio/levelStart.wav");
  levelCompleteAudio = new SoundFile(this, "Audio/levelComplete.wav");
  endModuleAudio = new SoundFile(this, "Audio/endModule.wav");
  spacingX = width / (w - 1) + 0.5;
  spacingY = height / (h - 1) + 0.5;
  images = new ArrayList<PImage>();
  images.add(loadImage("Images/start.png"));
  images.add(loadImage("Images/mix.png"));
  images.add(loadImage("Images/end.png"));
  for(PImage image : images)
  {
    image.resize(imageSize, 0);
  }
  world = new World();
}

void mousePressed()
{
  if(mouseButton == LEFT)
  {
    world.handleInput(0);
  }
  else if(mouseButton == RIGHT)
  {
    world.handleInput(1);
  }
}

void draw()
{
  if(!frameMoved){
    surface.setLocation(100, 100);
    frameMoved = true;
  }
  background(BLACK);
  world.render();
  world.render();
}

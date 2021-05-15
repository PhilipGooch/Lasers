class Laser
{
  int x, y;
  int direction;
  color colour;
  int Y_AXIS = 1;
  int X_AXIS = 2;
  
  Laser(int x, int y, int direction, color colour)
  {
    this.x = x;
    this.y = y;
    this.direction = direction;
    this.colour = colour;
  }
  
  void render()
  {
    noStroke();
    fill(colour);
    if(direction == 0)
    {
      rect(x * spacingX - laserWidth / 2, y * spacingY - spacingY / 2, laserWidth, spacingY / 2);
    }
    else if(direction == 1)
    {
      rect(x * spacingX, y * spacingY - laserWidth / 2, spacingX / 2, laserWidth);
    }
    else if(direction == 2)
    {
      rect(x * spacingX - laserWidth / 2, y * spacingY, laserWidth, spacingY / 2);
    }
    else if(direction == 3)
    {
      rect(x * spacingX - spacingX / 2, y * spacingY - laserWidth / 2, spacingX / 2, laserWidth);
    }
  }
}

class Node
{
  
  int x, y;
  Laser lasers[] = new Laser[4];
  Module module;
  
  Node(int x, int y)
  { 
    this.x = x;
    this.y = y;
    for(int i = 0; i < 4; i++)
    {
      lasers[i] = null;
    }
    module = null;
  }
  
  //void mixLaserColours()
  //{
  //  mixedLaserColour = co
  //  for(Laser laser : lasers)
  //  {
  //    if(laser != null)
  //    {
  //      mix
  //    }
  //  }
  //}
  
  void addStartModule(color colour)
  {
    module = new Module(x, y, TYPE._START, colour);
  }
  
  void addEndModule(color colour)
  {
    module = new Module(x, y, TYPE._END, colour);
  }
  
  void addMixModule(int top, int right, int bottom, int left, int rotation)
  {
    module = new Module(x, y, TYPE._MIX, BLACK);
    module.setPorts(top, right, bottom, left);
    module.rotation = rotation;
  }
  
  Laser getLaser(int direction)
  {
    if(lasers[direction] != null)
      return lasers[direction];
    return null;
  }
  
  void addLaser(int direction, color colour)
  {
    float r = red(colour);
    float g = green(colour);
    float b = blue(colour);
    if(lasers[direction] != null)
    {
      r += red(lasers[direction].colour);
      g += green(lasers[direction].colour);
      b += blue(lasers[direction].colour);
    }
    lasers[direction] = new Laser(this.x, this.y, direction, color(r, g, b));
  }
  
  void deleteLaser(int direction)
  {
    lasers[direction] = null;
  }
  
  void render()
  {
    renderLasers();
    if(module != null)
      module.render();
  }
  
  void renderLasers()
  {
    
    float r = 0;
    float g = 0;
    float b = 0;
    int laserCount = 0;
    for(Laser laser : lasers)
      if(laser != null)
      {
        laserCount++;
        laser.render();
        r += red(laser.colour);
        g += green(laser.colour);
        b += blue(laser.colour);
      }
    if(laserCount > 2)
    {
      fill(r, g, b);
      noStroke();
      rect(x * spacingX - laserWidth / 2, y * spacingY - laserWidth / 2, laserWidth, laserWidth);
    }
  }
}

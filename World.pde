class World 
{
  boolean levelComplete = false;
  int level = 1;
  boolean fading = false;
  boolean emerging = true;
  float alpha = 400;
  float fadeSpeed = 1.9;
  float fadeTime = 320;
  boolean titleScreen = true;
  PImage title;
  int lastEndNodesLit = 0;
  int endNodesLit = 0;
  int numberOfEndNodes = 0;
  
  Node [][] nodes = new Node[h][w];
  
  World()
  {       
    level--;
    title = loadImage("Images/title.png");
    powerUpAudio.play();
  }
  
  boolean complete() //<>//
  {
    endNodesLit = 0;
    for(int i = 0; i < h; i++)
    {
      for(int j = 0; j < w; j++)
      {
        if(nodes[i][j].module != null)
        {
          if(nodes[i][j].module.type == TYPE._END)
          {
            boolean connected = false;
            for(int k = 0; k < 4; k++)
            {
              if(nodes[i][j].lasers[k] != null)
              {
                if(nodes[i][j].lasers[k].colour == nodes[i][j].module.colour) //<>//
                {
                  connected = true;
                  endNodesLit++;
                  break;
                }
              }
            }
            //if(!connected)
            //{
            //  return false;
            //}
          }
        }
      }
    }
    return(endNodesLit == numberOfEndNodes);
    //return true;
  }
  
  void loadLevel(String[] file)
  {
    numberOfEndNodes = 0;
    levelComplete = false;
    
    for(int i = 0; i < h; i++)
    {
      for(int j = 0; j < w; j++)
      {
        nodes[i][j] = new Node(j, i);
      }
    }
    for (int i = 0 ; i < file.length; i++) {
      loadModule(file[i]);
    }
  }
  
  void loadModule(String string)
  {
    char type = string.charAt(0);
    int x = Integer.parseInt(String.valueOf(string.charAt(1)));
    int y = Integer.parseInt(String.valueOf(string.charAt(2)));
    color colour;
    int rotation;
    switch(type)
    {
      case 's':
        colour = translateColour(string.charAt(3));
        addStartModule(x, y, colour);
        break;
      case 'm':
        rotation = Integer.parseInt(String.valueOf(string.charAt(3)));
        addMixModule(x, y, rotation);
        break;
      case 'e':
        colour = translateColour(string.charAt(3));
        addEndModule(x, y, colour);
        numberOfEndNodes++;
        break;
      default:
        println("Error reading file.");
    }
  }
  
  color translateColour(char colour)
  {
    switch(colour)
    {
      case 'r':
        return color(255, 0, 0);
      case 'g':
        return color(0, 255, 0);
      case 'b':
        return color(0, 0, 255);
      case 'y':
        return color(255, 255, 0);
      case 'c':
        return color(0, 255, 255);
      case 'm':
        return color(255, 0, 255);
      case 'w':
        return color(255, 255, 255);
      default:
        println("Error translating colour.");
    }
    return color(0, 0, 0);
  }
  
  void handleInput(int button)
  {
    if(titleScreen)
    {
      if(button == 0)
      {
        fading = true;
      }
    }
    else
    {
      if(!fading)
      {
        if(button == 0)
        {
          boolean flag = false;
          for(int i = 0; i < h; i++)
          {
            for(int j = 0; j < w; j++)
            {
              if(pow(nodes[i][j].x * spacingX - mouseX, 2) + pow(nodes[i][j].y * spacingX - mouseY, 2) < pow(imageSize / 2, 2))
              {
                if(nodes[i][j].module != null)
                {
                  if(nodes[i][j].module.type == TYPE._MIX)
                  {
                    nodes[i][j].module.rotateRight();
                    reset();
                    shootLasers();
                    if(nodes[i][j].module.colour != BLACK)
                    {
                      laserAudio.play();
                    }
                    if(complete())
                    {
                      fading = true;
                      flag = true;
                      break;
                    }
                  }
                }
              }
            }
            if(flag)
            {
              break;
            }
          }
          if(endNodesLit > lastEndNodesLit)
          {
            endModuleAudio.play();
          }
          lastEndNodesLit = endNodesLit;
        }
        else if (button == 1)
        {
          
        }
      }
    }
  }
  
  void reset()
  {
    for(int i = 0; i < h; i++)
    {
      for(int j = 0; j < w; j++)
      {
        for(int k = 0; k < 4; k++)
        {
          nodes[j][i].deleteLaser(k);
        }
        if(nodes[j][i].module != null)
        {
          if(nodes[j][i].module.type == TYPE._MIX)
          {
            nodes[j][i].module.colour = BLACK;
          }
        }
      }
    }
  }
  
  void addStartModule(int x, int y, color colour)
  {
    nodes[y][x].addStartModule(colour);
  }
  
  void addMixModule(int x, int y, int rotation)
  {
    switch(rotation)
    {
      case 0:
        nodes[y][x].addMixModule(2, 1, 1, 1, 0);
        break;
      case 1:
        nodes[y][x].addMixModule(1, 2, 1, 1, 1);
        break;
      case 2:
        nodes[y][x].addMixModule(1, 1, 2, 1, 2);
        break;
      case 3:
        nodes[y][x].addMixModule(1, 1, 1, 2, 3);
        break;
    }
  }
  
  void addEndModule(int x, int y, color colour)
  {
    nodes[y][x].addEndModule(colour);
  }
  
  void deleteModule(int x, int y)
  {
    nodes[y][x] = null;
  }
  
  void shootLasers()
  {
    for(int i = 0; i < h; i++)
      for(int j = 0; j < w; j++)
        if(nodes[i][j].module != null)
          if(nodes[i][j].module.type == TYPE._START)
            shoot(nodes[i][j], nodes[i][j].module.rotation, nodes[i][j].module.colour);
  }
  
  void shoot(Node node, int direction, color colour)
  {
    node.addLaser(direction, colour);
    Node nextNode = getNextNodeInDirection(node, direction);
    if(nextNode == null)
      return;
    if(nextNode.lasers[oppositeDirection(direction)] != null)
      if(nextNode.lasers[oppositeDirection(direction)].colour == colour)
        return;
    nextNode.addLaser(oppositeDirection(direction), colour);
    if(nextNode.module != null)
    {
      //if(nextNode.module.type == TYPE._END)
      //{
      //  endModuleAudio.play();
      //}
      if(nextNode.module.type == TYPE._MIX)
      {
        if(nextNode.module.ports[oppositeDirection(direction)].type == 1)
        { //<>//
          colour = nextNode.module.mixColours(colour);
          int portDirection = 0;
          for(Port port : nextNode.module.ports)
          {
            if(port.type == 2)
            {
              shoot(nextNode, portDirection, colour);
            } //<>//
            portDirection++;
          }
        }
      }
    }
    else //<>//
    {
      nextNode.addLaser(direction, colour);
      shoot(nextNode, direction, colour);
    }
  }
  
  boolean inputPort(Module module, int side)
  {
    return module.ports[side].type == 1;
  }
  
  int oppositeDirection(int direction)
  {
    int opposite;
    opposite = direction + 2;
    if(opposite > 3)
      opposite -= 4;
    return opposite;
  }
  
  Node getNextNodeInDirection(Node node, int direction)
  {
    if(direction == 0 && (int)node.y > 0)
    {
      return nodes[(int)node.y - 1][(int)node.x];
    }
    else if(direction == 1 && (int)node.x < w - 1)
    {
      return nodes[(int)node.y][(int)node.x + 1];
    }
    else if(direction == 2 && (int)node.y < h - 1)
    {
      return nodes[(int)node.y + 1][(int)node.x];
    }
    else if(direction == 3 && (int)node.x > 0)
    {
      return nodes[(int)node.y][(int)node.x - 1];
    } //<>//
    return null;
  }
  
  void render()
  {
    if(!powerUpAudio.isPlaying() && !beamAudio.isPlaying())
    {
      beamAudio.loop();
    }
    
    if(titleScreen)
    {
      image(title, 50, 150);
    }
    else
    {
      if(alpha < 255)
      {
        for(int i = 0; i < h; i++)
        {
          for(int j = 0; j < w; j++)
          {
            if(nodes[i][j] != null)
            {
              nodes[i][j].render();
            }
          }
        }
      }
    }
    
    stroke(0, 0, 1, 0);
    fill(0, 0, 1, 0);
    if(fading)
    {
      
      alpha += fadeSpeed;
      if(!titleScreen && alpha > -350 && !levelCompleteAudio.isPlaying())
      {
        levelCompleteAudio.play();
      }
      stroke(0, 0, 1, (int)alpha);
      fill(0, 0, 1, (int)alpha);
      if(alpha > fadeTime)
      {
        //
        fading = false;
        emerging = true;
        level++;
        if(!titleScreen)
        {
          reset();
        }
        loadLevel(loadStrings("Levels/" + level + ""));
        shootLasers();
        titleScreen = false;
      }
    }
    else if(emerging)
    {
      
      alpha -= fadeSpeed;
      if(!titleScreen && !levelStartAudio.isPlaying() && alpha < fadeTime - 80)
      {
        levelStartAudio.play();
      }
      stroke(0, 0, 1, (int)alpha);
      fill(0, 0, 1, (int)alpha);
      if(alpha < 0)
      {
        alpha = titleScreen ? 0 : -400;
        emerging = false;
      }
    }
      
      rect(0, 0, width, height);
    
  }
  
}

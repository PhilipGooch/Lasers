class Module 
{
  TYPE type;
  PVector position;
  int rotation;
  Port ports[] = new Port[4];
  PImage image;
  color colour;
  
  Module(int x, int y, TYPE type, color colour)
  {
    this.type = type;
    position = new PVector(x, y);
    this.colour = colour;
    switch (type)
    {
      case _START:
        image = images.get(0);
        rotation = edgeRotation(x, y);
        setPorts(2, 0, 0, 0);
        break;
      case _MIX:
        image = images.get(1);
        break;
      case _END:
        image = images.get(2);
        rotation = edgeRotation(x, y);
        setPorts(1, 0, 0, 0);
        break;
      default:
        println("!");
    }
  }
  
  void rotateRight()
  {
    rotation += 1;
    if(rotation > 3) 
      rotation -= 4;
    Port save = ports[3];
    ports[3] = ports[2];
    ports[2] = ports[1];
    ports[1] = ports[0];
    ports[0] = save;
  }
  
  int edgeRotation(int x, int y)
  {
    if(x == 0)
      return 1;
    else if(x == w - 1)
      return 3;
    else if(y == 0)
      return 2;
    else if(y == h - 1)
      return 0;
    else
    {
      println("!");
      return -1;
    }
  }
  
  void setColour(color colour)
  {
    this.colour = colour;
  }
  
  color mixColours(color c)
  {
    colour = color(red(colour) + red(c), green(colour) + green(c), blue(colour) + blue(c));
    return colour;
  }void setPorts(int top, int right, int bottom, int left)
  {
    ports[0] = new Port(top);
    ports[1] = new Port(right);
    ports[2] = new Port(bottom);
    ports[3] = new Port(left);
  }
  
  void render()
  {
    noStroke();
    fill(colour);
    pushMatrix();
      translate(position.x * spacingX, position.y * spacingY);
      rect(-imageSize * 0.22, -imageSize * 0.22, imageSize * 0.44, imageSize * 0.44);
      pushMatrix();
        translate(-image.width / 2, -image.height / 2);
        pushMatrix();
          translate(image.width / 2, image.height / 2);
          rotate(radians(rotation * 90));
          translate(-image.width / 2, -image.height / 2);
          image(image, 0, 0);
        popMatrix();
      popMatrix();
    popMatrix();
  }
}

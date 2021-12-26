PImage nova;
Splitter source;
Particles [] tiles;
boolean dissolve;

void setup() {
  size (1024, 768, P3D);
  nova=loadImage("nova.jpg"); //load your image here
 
  //Split original image into tiles
  source=new Splitter(nova, 40, 40); //image to split, 40x40 tiles (change as how many x,y images you want) 


//Create particles of splitted images
  tiles=new Particles[source.smallImages.length]; 

  for (int i=0; i<tiles.length-1; i++) {
    println(i, tiles.length, source.smallImages.length);

    tiles[i]=new Particles(source.smallImages[i], new PVector(source.tilepositions[i].x, source.tilepositions[i].y));
  }
}

void draw() {
  println(frameRate);
  background(0);
  
  // if left mouse mouse pressed dissolve particles and drop them if right mouse button pressed reset
  if (dissolve) {
    for (int i=0; i<tiles.length-1; i++) {
      tiles[i].update();
      tiles[i].display();
    }
  } else {
    image(nova, 0, 0);
  }
}


// splitter class
class Splitter {

  int xtiles, ytiles, smallXwidth, smallYheight;
  PImage source;
  PImage tempimg;
  int inc=3;
  int spacing=25;
  PVector [] tilepositions;
  PImage [] smallImages;

  Splitter(PImage temp, int _xtiles, int _ytiles) {
    source=temp.get();
    int sourceWidth=source.width;
    int sourceHeight=source.height;
    xtiles=_xtiles;
    ytiles=_ytiles;
    smallImages=new PImage[xtiles*ytiles+1];
    tilepositions=new PVector[xtiles*ytiles+1];
    println(xtiles*ytiles);
    smallXwidth=sourceWidth/xtiles;
    smallYheight=sourceHeight/ytiles;
    int index=0;

    for (int x=0; x<xtiles; x++) {
      for (int y=0; y<ytiles; y++) {

        smallImages[index]=source.get(x*smallXwidth, y*smallYheight, smallXwidth, smallYheight);
        tilepositions[index]=new PVector(x*smallXwidth, y*smallYheight);
        index++;
      }
    }
  }

//for debug
  void display() {
    for (int i=0; i<smallImages.length-1; i++) {
      image(smallImages[i], tilepositions[i].x+random(-3, 3), tilepositions[i].y+random(-3, 3));
    }
  }
}


class Particles {
  PVector location, velocity, acceleration;
  PImage particleimage;
  int counter=0;

  Particles(PImage temp, PVector _temploc) {
    location=_temploc.get();
    particleimage=createImage(temp.width, temp.height, RGB);
    particleimage=temp.get();
    velocity=new PVector(0, 0);
    acceleration=new PVector(random(0, 0.01), random(0.3, 0.6));
  }

  void update() {

    velocity.add(acceleration);
    location.add(velocity);
    if (location.y>height-100) {
       velocity.mult(0);
    }
  }


  void display() {

    if (location.y>height-100) {
      location.y=height-100;
    }
    if (location.x>width-100) {
      velocity.x*=-1;
    }
    image(particleimage, location.x, location.y);
  }
}

void mouseClicked() {
  if (mouseButton==LEFT) {
    dissolve=true;
  }
  if (mouseButton==RIGHT) {
    dissolve=false;
    for (int i=0; i<tiles.length-1; i++) {
      tiles[i].location.x=source.tilepositions[i].x;
      tiles[i].location.y=source.tilepositions[i].y;
     
    }
}
}

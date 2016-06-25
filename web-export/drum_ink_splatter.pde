//import java.util.*;//import java.util.LinkedList;
/*  Processing Java specific 
import oscP5.*;
import netP5.*;
OscP5 oscP5; 
NetAddress myRemoteLocation;*/

ArrayList<Blob> blobs_pool;
BlobFactory blobFactory;

//LinkedList<Splatter> splatters;//SplatterPool splatters;
ArrayList<Splatter> splatters;

int frameCounter = 0;

boolean createSplatterSnare = false;
boolean createSplatterCrash = false;
boolean createSplatterTon   = false;

SplatterSourceFactory splatterSourceFactory;
SplatterSource splatterSnareSource;
SplatterSource splatterCrashSource;
SplatterSource splatterTonSource;

float trajectories_scale;

float lastMillis;

void setup()
{  
  size(640,480);
  trajectories_scale = width/690.;
  
  //  BEGIN Processing Java specific 
  // start oscP5, listening for incoming messages at port 12000 
  /*oscP5 = new OscP5(this,12000);
  
  // myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
  // an ip address and a port number. myRemoteLocation is used as parameter in 
  // oscP5.send() when sending osc packets to another computer, device, 
  // application. usage see below. for testing purposes the listening port 
  // and the port of the remote location address are the same, hence you will 
  // send messages back to this sketch.
  myRemoteLocation = new NetAddress("localhost", 12000);//"192.168.0.101" 
   
  // osc plug service * osc messages with a specific address pattern can be automatically 
  // forwarded to a specific method of an object. in this example 
  // a message with address pattern /test will be forwarded to a method 
  // test(). below the method test takes 2 arguments - 2 ints. therefore each 
  // message with address pattern /test and typetag ii will be forwarded to 
  // the method test(int theA, int theB)
  oscP5.plug(this,
    "snare",  //  name of the function to be called here in Processing
    "/snare"  //  the name sent on the udp in Pure Data
  );
  
  //  Idem para o prato
  oscP5.plug(this, "crash", "/crash");
  //  E idem para um ton (ou seja lá o que for)
  oscP5.plug(this, "ton", "/ton");*/
  //  END Processing Java specific
  
  //splatters = new LinkedList<Splatter>();//splatters = new SplatterPool(200);
  splatters = new ArrayList<Splatter>();
  
  /*  testing different blobs styles
  blobs_pool = new ArrayList();
  
  blobFactory = new BlobFactory();
  
  blobs_pool.add(blobFactory.createBlob1(60,60));
  blobs_pool.add(blobFactory.createBlob2(width-60,60));
  blobs_pool.add(blobFactory.createBlob3(60,height-60));
  blobs_pool.add(blobFactory.createBlob4(width-60,height-60));*/
  
  splatterSourceFactory = new SplatterSourceFactory(); 
  splatterSnareSource   = splatterSourceFactory.createSplatterSource_snareDefault(trajectories_scale);
  splatterCrashSource   = splatterSourceFactory.createSplatterSource_crashDefault(trajectories_scale);
  splatterTonSource     = splatterSourceFactory.createSplatterSource_tonDefault();
  
  //frameRate(60);
}

//
//  These are the functions that will be called by Processing when received osc message accordingly
//  NOTE - we are not really using a_param
//---------
void crash(int a_param) {
  if(a_param == 1)
    createSplatterCrash = true;
}
void snare(int a_param) {
  if(a_param == 1)
    createSplatterSnare = true;
}

void ton(int a_param) {
  if(a_param == 1)
    createSplatterTon = true;
}
//---------

void draw() {
  
  //println(frameRate);
  //println(splatters.size() + " .");
  
  smooth();
  //background(255);
   
  /*blobs_pool.get(0).displayPerlin();
  blobs_pool.get(1).display();
  blobs_pool.get(2).displayContour();
  blobs_pool.get(3).displayComic();*/
  
  splatterSnareSource.updateAndDraw();
  splatterCrashSource.updateAndDraw();
  splatterTonSource.updateAndDraw();
  
  if(createSplatterSnare)
  {
    splatters./*push*/add(new Splatter(splatterSnareSource.blob.center.x, splatterSnareSource.blob.center.y,  PI/5.,
        50, 0.8, splatterSnareSource.blob.colour,//0xFFFF0000,
        0.15,   // aProbArm
        PI/50., // aAverageArmsAngSpread
        2.)     // aAverageArmsSize
    );
    createSplatterSnare = false;
  }
  
  if(createSplatterCrash)
  {
    splatters./*push*/add(new Splatter(splatterCrashSource.blob.center.x, splatterCrashSource.blob.center.y,  PI/5.,
        50, 0.8, splatterCrashSource.blob.colour,
        0.15,   // aProbArm
        PI/50., // aAverageArmsAngSpread
        2.)     // aAverageArmsSize
    );
    createSplatterCrash = false;
  }
  
  if(createSplatterTon)
  {
    splatters./*push*/add(new Splatter(splatterTonSource.blob.center.x, splatterTonSource.blob.center.y,  PI/5.,
        50, 0.8, splatterTonSource.blob.colour,
        0.15,   // aProbArm
        PI/50., // aAverageArmsAngSpread
        2.)     // aAverageArmsSize
    );
    createSplatterTon = false;
  }
  
  //  If blob gets ejected, reset its trajectory
  if(  (splatterCrashSource.blob.center.x > width  || splatterCrashSource.blob.center.x < 0)
    || (splatterCrashSource.blob.center.y > height || splatterCrashSource.blob.center.y < 0))
  {
    splatterCrashSource.trajectory.reset();
  }
  
  for(Splatter s: splatters) {  
    s.display(); 
  }
  /*if(splatters.getActualFirst_index() >= 0)
    for(int i=splatters.getActualFirst_index(); i < splatters.getMaxSize(); i++)
      if(splatters.at(i) != null)
        splatters.at(i).display();*/
  
  //  White rectangle with transparency, to fade everything out
  fill(255, 255, 255, 10);
  noStroke();
  rect(0, 0, width, height);
  
  /*
  if(frameCounter > 30)
    blobs_pool.get(0).display();
  if(frameCounter > 31)
    blobs_pool.get(1).display();
  if(frameCounter > 32)
    blobs_pool.get(2).display();
  if(frameCounter > 33)
    blobs_pool.get(3).display();
  
  
  print((frameCounter % 300));
  print((frameCounter % 600));
  print((frameCounter % 900));
  println((frameCounter % 1200));
  
  frameCounter++;*/
  
  //  Discarding the splatters that finished to fade out
  /*Iterator s_it = splatters.descendingIterator();
  // print list with descending order
  while (s_it.hasNext())
    if( ((Splatter)s_it.next()).getAlpha() <= 0)
      s_it.remove();*/
  for (int i = splatters.size()-1; i >= 0; i--)
    if( ((Splatter)splatters.get(i)).getAlpha() <= 0)
      splatters.remove(i);
  /*if(splatters.getActualSize() > 0) {
    for(int i=splatters.getActualFirst_index(); i < splatters.getMaxSize(); i++) {
      if(splatters.getActualFirst_member().alpha <= 0) {
        splatters.removeActualFirst();
        println("removed actualFirst. actualSize = " + splatters.getActualSize());
      }
      else {
        break;
      }
    } 
  }*/
  
  //  calculating and showing the FPS
  fill(0);
  rect(0, 0, 150, 20);
  fill(255);
  text("FPS = " + (1000./(millis() - lastMillis)), 20, 15);
  lastMillis = millis();
}

void keyPressed()
{ 
  //  In addition to create splatters when receiving OSC messages,
  //we can create by pressing a, s or d...
  
  if (key == 'a')
  {
    //frameCounter = 0;
    
    /*blobs_pool.set(0, blobFactory.createBlob1(60,60));
    blobs_pool.set(1, blobFactory.createBlob2(width-60,60));
    blobs_pool.set(2, blobFactory.createBlob3(60,height-60));
    blobs_pool.set(3, blobFactory.createBlob4(width-60,height-60));*/
    
    splatters./*push*/add(new Splatter(splatterCrashSource.blob.center.x, splatterCrashSource.blob.center.y,
        PI/5.,
        50, 0.8, 0xFFFF0000,
        0.15,   // aProbArm
        PI/50., // aAverageArmsAngSpread
        2.)     // aAverageArmsSize
    );
  }
  else if (key == 's')
  {
    //frameCounter = 0;
    splatters./*push*/add(new Splatter(splatterSnareSource.blob.center.x, splatterSnareSource.blob.center.y,
        PI/5.,
        50, 0.8, 0xFF00FF00,
        0.15,   // aProbArm
        PI/50., // aAverageArmsAngSpread
        2.)     // aAverageArmsSize
    );
  }
  else if (key == 'd')
  {
    //frameCounter = 0;
    splatters./*push*/add(new Splatter(splatterTonSource.blob.center.x, splatterTonSource.blob.center.y,
        PI/5.,
        50, 0.8, 0xFF0000FF,
        0.15,   // aProbArm
        PI/50., // aAverageArmsAngSpread
        2.)    // aAverageArmsSize
    );
  }
}


//  BlobFactory, Blob, Splatter classes

class BlobFactory
{  
  Blob createBlob1(PVector aCenter, float a_radius, color a_color) {
    return new Blob(400, a_radius, aCenter, 1.2, 1.25, 0.8, a_color);
  }
  
  Blob createBlob2(PVector aCenter, float a_radius, color a_color) {
    return new Blob(400, a_radius, aCenter, 0.25, 1., 0.8, a_color);
  }
  
  Blob createBlob3(PVector aCenter, float a_radius, color a_color) {
    return new Blob(400, 30, aCenter, 0.1, 1., 0., a_color);
  }
  
  Blob createBlob4(PVector aCenter, float a_radius, color a_color) {
    return new Blob(400, 30, aCenter, 0.35, 1.25, 0.8*PI, a_color);
  }
  
}

public class Blob
{
  /*ArrayList<float> x;*/float [] x;
  /*ArrayList<float> y;*/float [] y;
  
  float   radius;
  float   eccentricity;
  PVector center;
  float   rotation; 
  color   colour;
 
  int count;  //  auxiliar
  int numVertex;
  float maxRadiusDeviation;
 
  Blob(int a_numVertex, float rad, PVector aCenter, float a_maxRadiusDeviation, float a_eccentricity,
    float a_rotation, color a_color)
  {
    radius = rad;
    center = aCenter;
   
    eccentricity = a_eccentricity;
    rotation     = a_rotation;
    
    maxRadiusDeviation = a_maxRadiusDeviation;
    
    numVertex    = a_numVertex;
    
    colour       = a_color;
   
    /*x = new ArrayList;*/x = new float[a_numVertex];
    /*y = new ArrayList;*/y = new float[a_numVertex];
   
    generate();
   
   //println(count);
   
  }
  
  void generate()
  {
    float [] perlinNoiseCenter = {random(5, 10), random(0, 4)};
    
    float angle = 0;
    float deltaAngle = TWO_PI / numVertex;
   
    //  Perlin noise: para fechar a elipse mais suavemente, vamos usar 
    //o fato do Perlin Noise nao apresentar grandes saltos entre 
    //elementos adjacentes. Assim, vamos percorrer um circuito 
    //fechado, circular, no espaco 2D do ruido, em passos de 0.02
    float r_in_noiseSpace = 0.02/deltaAngle;
   
    float maxRadiusDev = maxRadiusDeviation; // max radius deviation in percent
    float radFactor;
    float zRad;
    float r;

    float i;
    count = 0;
    for (i=0; i<TWO_PI; i+=deltaAngle)
    {    
      r = sqrt(1./
        (cos(angle)*cos(angle)/(radius*radius) + sin(angle)*sin(angle)/(radius*eccentricity*radius*eccentricity)));
      //println(radius);
   
      radFactor = 1 + maxRadiusDev *
        (1 - 2 * noise( perlinNoiseCenter[0] + r_in_noiseSpace*cos(angle), perlinNoiseCenter[1] + r_in_noiseSpace*sin(angle) ));
     
      //  center sera usado somente na hora de plotar
      x[count] = radFactor * r * cos(angle);
      y[count] = radFactor * r * sin(angle);
      angle += deltaAngle;
      
      count++;
    }
  }

  //  NOTE - rotacao na mao porque "Transformations such as translate(), rotate(), and 
  //scale() do not work within beginShape()" - http://processing.org/reference/beginShape_.html
  void display()
  {
    fill(colour);
    beginShape(); 
      
      //for (int i=1; i<count-1; i++) {
      //  point(center.x + x[i]*cos(rotation) - y[i]*sin(rotation),
      //  center.y + x[i]*sin(rotation) + y[i]*cos(rotation));
      //}
      
      vertex(center.x + x[0]*cos(rotation) - y[0]*sin(rotation),
        center.y + x[0]*sin(rotation) + y[0]*cos(rotation));
       
      for (int i=1; i<count-1; i+=3) {
        float rfactor = random(1.5, 2.);
        if(random(0., 1.) < 0.04 && i > 0)
        {          
          bezierVertex(
            center.x + x[i+1]*rfactor*cos(rotation) - y[i+1]*rfactor*sin(rotation),
            center.y + x[i+1]*rfactor*sin(rotation) + y[i+1]*rfactor*cos(rotation),
            center.x + x[i]*rfactor*cos(rotation) - y[i]*rfactor*sin(rotation),
            center.y + x[i]*rfactor*sin(rotation) + y[i]*rfactor*cos(rotation),
            center.x + x[i+1]*cos(rotation) - y[i+1]*sin(rotation),
            center.y + x[i+1]*sin(rotation) + y[i+1]*cos(rotation)
          );
        } else {
          vertex(center.x + x[i-1]*cos(rotation) - y[i-1]*sin(rotation),
            center.y + x[i-1]*sin(rotation) + y[i-1]*cos(rotation));
        }
        //  agora faltam os dois ultimos pontos
      }
  
    endShape();
    
    //noLoop();
  
  }
  
  //  "Borroes de tinta"
  void displayPerlin() {
    fill(colour);
    noStroke();
    beginShape();
    for (int i=0; i<count; i++) {
      vertex(center.x + x[i]*cos(rotation) - y[i]*sin(rotation),
        center.y + x[i]*sin(rotation) + y[i]*cos(rotation));
    }
    endShape();
  }
  
  //  Uma experiencia interessante...
  void displayComic()
  {
    fill(colour); 
    beginShape(); 
      
      for (int i=1; i<count-1; i++) {
        if(random(0., 1.) < 0.75 && i > 0)
        {
          vertex(center.x + x[i-1]*cos(rotation) - y[i-1]*sin(rotation),
            center.y + x[i-1]*sin(rotation) + y[i-1]*cos(rotation));
          
          bezierVertex(
            center.x + x[i+1]*2.*cos(rotation) - y[i+1]*2.*sin(rotation),
            center.y + x[i+1]*2.*sin(rotation) + y[i+1]*2.*cos(rotation),
            center.x + x[i]*2.*cos(rotation) - y[i]*2.*sin(rotation),
            center.y + x[i]*2.*sin(rotation) + y[i]*2.*cos(rotation),
            center.x + x[i+1]*cos(rotation) - y[i+1]*sin(rotation),
            center.y + x[i+1]*sin(rotation) + y[i+1]*cos(rotation)
          );
        } else {
          point(center.x + x[i-1]*cos(rotation) - y[i-1]*sin(rotation),
            center.y + x[i-1]*sin(rotation) + y[i-1]*cos(rotation));
        }
        //  agora faltam os dois ultimos pontos
      }
      
    endShape();   
  }
  
  //  Mostra apenas os vertices
  void displayContour()
  {
    fill(colour);
    
    pushMatrix();
      translate(center.x, center.y);
      
      for (int i=0; i<count; i++) {
        pushMatrix();
          rotate(0.1);
          translate(x[i], y[i]);
          rect(-0.2, -0.2, .4, .4);
        popMatrix();
      }
    
    popMatrix();  
  }
 
}

//----------------------------------------------------------------
/*public class Point2d {
  public float x;
  public float y;
  Point2d(float aX, float aY) {
    x = aX;
    y = aY;  
  }
  void set(float aX, float aY) {
    x = aX;
    y = aY;  
  }
   
}*/
/*class Splatter_factory {
  Splatter createSplatter
}*/

public class Splatter {
  
  //  The form is based on an ellipsis
  float rad;  //  radius in x
  float eccentricity;  //  radius in y is eccentricity * radius
  
  //  Points. They are relative to the center and haven't the rotation applied 
  ArrayList<Float> x, y;//FloatList x, y;  FloatList not supported on Processing.js by now...
  //  Type of the point or points to draw. p stands for (poly)line, b for Bezier  
  //ArrayList<char>  t;
  
  //  These are applied just at draw
  float positionX, positionY;  //  center
  float rotation;
  
  //  Probability per degree of existance of an arm
  float angularArmAppearenceProbability;
  
  //  Average angular spread of the arms
  float averageArmsAngularSpread;
 
  //  Average arms size relative to the radius
  float averageArmsRelativeSize;
  
  float angularStep = 5*PI/180.;
  
  color colorRGBA = 0xFFFF0000;
  int alpha = 255;
  
  float [] perlinNoiseCenter = {random(5, 10), random(0, 4)};
  
  Splatter(float aX, float aY, float aRotation,
    float aR, float aEcc, color aColor,
    float aProbArm, float aAverageArmsAngSpread, float aAverageArmsSize)
  {
    positionX    = aX;
    positionY    = aY;
    rotation     = aRotation;
    rad          = aR;
    eccentricity = aEcc;
    colorRGBA    = aColor;
    angularArmAppearenceProbability = aProbArm;
    averageArmsAngularSpread        = aAverageArmsAngSpread;
    averageArmsRelativeSize         = aAverageArmsSize;
    
    buildPoints();    
  }
  
  int getAlpha() {
    return alpha; 
  }
  
  //  
  void buildPoints() {
    float angSpreadDeviation;
    float armAngSpread;
    float armSize;
    float angCenter;  //  for Bezier
    
    float initAngle = 0;
    float angle     = initAngle;
    
    float radius;
    
    float r_in_noiseSpace = 0.02/angularStep;
    
    println("[]");
    
    x = new ArrayList<Float>();//FloatList not supported on Processing.js by now...
    println("[][]");
    y = new ArrayList<Float>();//
    
    println("-");
    
    float radFactor = 1 + /**/1.2/**/ *
        (1 - 2 * noise( perlinNoiseCenter[0] + r_in_noiseSpace*cos(angle), perlinNoiseCenter[1] + r_in_noiseSpace*sin(angle) ));
        
    println("--");
    
    radius = radFactor * sqrt(1./
      (cos(angle)*cos(angle)/(rad*rad) + sin(angle)*sin(angle)/(rad*eccentricity*rad*eccentricity)));
      
    x.add(radius * cos(angle));
    println("---");
    y.add(radius * sin(angle));
    println("----");
    for(angle = angularStep; angle < 2*PI; angle += angularStep)
    {
      radFactor = 1 + /**/1.2/**/ *
        (1 - 2 * noise( perlinNoiseCenter[0] + r_in_noiseSpace*cos(angle), perlinNoiseCenter[1] + r_in_noiseSpace*sin(angle) ));
       
      if( random(0., 1.) < angularArmAppearenceProbability)  //  Bezier
      {
        //t.add('b');
        angSpreadDeviation = random(
          0.75*averageArmsAngularSpread, 1.25*averageArmsAngularSpread);
        armAngSpread = averageArmsAngularSpread + angSpreadDeviation;
        angCenter = angle + armAngSpread/2.;
        radius = radFactor * sqrt(1./
          (cos(angCenter)*cos(angCenter)/(rad*rad) + sin(angCenter)*sin(angCenter)/(rad*eccentricity*rad*eccentricity)));
        armSize = radius*random(averageArmsRelativeSize*0.8, averageArmsRelativeSize*1.2);
        //  control point
        x.add(armSize * cos(angle+0.8*armAngSpread));
        y.add(armSize * sin(angle+0.8*armAngSpread));
        //  control point
        x.add(armSize * cos(angle+0.2*armAngSpread));
        y.add(armSize * sin(angle+0.2*armAngSpread));
        //  anchor point
        x.add(radius * cos(angle+armAngSpread));
        y.add(radius * sin(angle+armAngSpread));
        
        angle += (armAngSpread - angularStep);
      }
      else  //  let's make a straight line using bezier...
      {
        //t.add('p');
        radius = radFactor * sqrt(1./
          (cos(angle)*cos(angle)/(rad*rad) + sin(angle)*sin(angle)/(rad*eccentricity*rad*eccentricity)));
        //  control point
        x.add(radius * cos(angle));
        y.add(radius * sin(angle));
        //  control point
        //xy.add( new Point2d(x.get(x.size()-1),
        //  y.get(y.size()-1)) );
        x.add(radius * cos(angle));
        y.add(radius * sin(angle));
        //  anchor point
        x.add(radius * cos(angle));
        y.add(radius * sin(angle));
      }
    }
  }
  
  void display()
  {
    alpha-=1.5;
    fill(colorRGBA >> 16 & 0xFF,
      colorRGBA >> 8 & 0xFF,
      colorRGBA & 0xFF,
      alpha);
    noStroke();
    beginShape();
    /*for(int i =0; i<t.size(); i++)
    {
      switch(t[i]) {
        case 'p':
          vertex(center.x + x[i]*cos(rotation) - y[i]*sin(rotation),
            center.y + x[i]*sin(rotation) + y[i]*cos(rotation));
        break;
        case 'b':
          vertex
          bezierVertex(
        break;
      } 
    }*/ 
    vertex(positionX + x.get(0)*cos(rotation) - y.get(0)*sin(rotation),
           positionY + x.get(0)*sin(rotation) + y.get(0)*cos(rotation));
    for(int i =0; i<x.size()-1; i+=3) {
      bezierVertex(
        positionX + x.get(i)*cos(rotation) - y.get(i)*sin(rotation),
          positionY + x.get(i)*sin(rotation) + y.get(i)*cos(rotation),
        positionX + x.get(i+1)*cos(rotation) - y.get(i+1)*sin(rotation),
          positionY + x.get(i+1)*sin(rotation) + y.get(i+1)*cos(rotation),
        positionX + x.get(i+2)*cos(rotation) - y.get(i+2)*sin(rotation),
          positionY + x.get(i+2)*sin(rotation) + y.get(i+2)*cos(rotation)
      );
    }
    endShape();
  }
 
} /**/
//  A specific fixed-size array of Splatters.
//  NOTE - not being used
public class SplatterPool
{
  Splatter [] members;
  int max_size;
  int actual_n_members = 0;
  int firstFreePosition = 0;
  int actualFirst = -1;
  
  SplatterPool(int a_size)
  {
    max_size = a_size;
    members = new Splatter[a_size];
    for(int i=0; i<max_size; i++) {
      members[i] = null;
    }
  }
  
  boolean push(Splatter aSplatter) {
    if(actual_n_members < max_size)
    {
      members[/*actual_n_members*/firstFreePosition] = aSplatter;
      actual_n_members++;
      if(actual_n_members == max_size) {  //  list is full
        firstFreePosition = -1;
        actualFirst       = 0;
      }
      else if(firstFreePosition+1 == max_size) // not full, but last is filled
      {
        for(int i=0; i<max_size; i++) {
          if(members[i] != null) {
            actualFirst       = i;
            break;
          }
        }
        for(int i=0; i<max_size; i++) {
          if(members[i] == null)
          {
            firstFreePosition = i;
            break; 
          }
        }
      }
      else {  //  last is not filled
        for(int i=0; i<max_size; i++) {
          if(members[i] != null)
          {
            actualFirst = i;
            break; 
          }
        }
        for(int i=0; i<max_size; i++) {
          if(members[i] == null)
          {
            firstFreePosition = i;
            break; 
          }
        }
      }
      println("pushed. " + actual_n_members + " members");
      println("actualFirst = " + actualFirst + " | firstFreePosition = " + firstFreePosition);
      return true;
    }
    return false;
  }
  
  /*boolean pop() {
    if(actual_n_members > 0) {
      members[actual_n_members-1] = null;
      actual_n_members--;
      return true;
    }
    return false;
  }*/
  
  boolean removeActualFirst() {
    
    /*if(actual_n_members == max_size) {
      members[0] = null;
      actualFirst       = 1;
      firstFreePosition = 0;
      println("actualFirst = " + actualFirst + " | firstFreePosition = " + firstFreePosition);
      return true;
    }*/
    
    if(actual_n_members > 0) {
      members[actualFirst] = null;
      actual_n_members--;
      if(actualFirst+1 == max_size) {
        for(int i=0; i<max_size; i++) {
          if(members[i] != null) {
            actualFirst = i;
            break;
          }
        }
      }
      else {
        actualFirst++;
      }
      
      for(int i=0; i<max_size; i++) {
        if(members[i] == null) {
          firstFreePosition = i;
          break;
        }
      }
      println("actualFirst = " + actualFirst + " | firstFreePosition = " + firstFreePosition);
      return true;
    }
    println("Error in removeActualFirst() or called in empty list"); 
    return false;
  }
  
  Splatter at(int i) {
    return members[i]; 
  }
  
  int getActualSize() {
    return  actual_n_members;
  }
  
  int getMaxSize() {
    return max_size; 
  }
  
  Splatter getActualFirst_member() {
    return members[actualFirst];
  }
  
  int getActualFirst_index() {
    return actualFirst;
  }
  
  /*Splatter last() {
    if(actual_n_members > 0)
      return members[actual_n_members-1];
    else
      return null;
  }*/
  
}
//  Trajectory class
//  SplatterSource class - a Blob that obbeys a Trajectory
//  SplatterSourceFactory class


public class Trajectory
{
  PVector position;
  
  float   scale;
  PVector offset;
  
  Trajectory() {
    
  }
  
  Trajectory(PVector aInitialPosition)
  {
    position = aInitialPosition;
  }
  
  PVector update() {
    return null;
  }
  
  void reset()
  {  
  }
}

public class TrajectoryOcho extends Trajectory
{
  TrajectoryOcho(PVector aInitialPosition)
  {
    position = aInitialPosition;
  }
  
  PVector update() {
    return null;  //  TODO
  }
}

public class TrajectoryErratic extends Trajectory
{
  TrajectoryErratic(PVector aInitialPosition, float aPertur)
  {
    position = aInitialPosition;
  }
  
  PVector update() {
    return null;  //  TODO
  }
}

public class TrajectoryFastWrap extends Trajectory
{
  PVector speed;
  
  TrajectoryFastWrap(PVector aInitialPosition, PVector aSpeed)
  {
    speed    = aSpeed;
    position = aInitialPosition;
    
    scale = 1.;
    offset = new PVector(0., 0.);
  }
  
  PVector update() {
    position.x += speed.x;
    position.y += speed.y;
    if(position.x >= width)   position.x -= width;
    else if(position.x < 0)   position.x = width - position.x;
    if(position.y >= height)  position.y -= height;
    else if(position.y < 0)   position.y = height - position.y;
    
    return position;
  }
}

public class TrajectoryCircle extends Trajectory
{
  TrajectoryCircle(PVector aCenter, float aRadius, float aInitialAngularPosition, 
    float aAngularSpeed, float aRadiusPerturbationPeriod, float aRadiusPerturbationAmplitude)
  {
    position = aCenter;
  }
  
  PVector update() {
    return null;  //  TODO
  }
}

public class TrajectoryLorenz extends Trajectory
{
  PVector center;
  float x, y, z;
  
  //  why not double?
  float x0,y0,z0,x1,y1,z1;
  float h = 0.01;
  float a = 10.0;
  float b = 28.0;
  float c = 8.0 / 3.0;
  
  TrajectoryLorenz(float aStartX, float aStartY, float aStartZ, PVector aCenter, float a_scale)
  {
    position = new PVector(aStartX + width/2., aStartY + height/2.);
    x = aStartX;
    y = aStartY;
    z = aStartZ;
    center = aCenter;
    
    scale = 10.*a_scale;
    offset = new PVector( aCenter.x, aCenter.y );
  }
 
 PVector update()
  {
    /*x0 = 0.1;
    y0 = 0;
    z0 = 0;*/
    x0 = x;  y0 = y;  z0 = z;
    //for (i=0;i<N;i++) {
      x = x0 + h * a * (y0 - x0);
      y = y0 + h * (x0 * (b - z0) - y0);
      z = z0 + h * (x0 * y0 - c * z0);

      position.x = x;
      position.y = y;
      //position.x = x*scale + center.x + offset.x;
      //position.y = y*scale + center.y + offset.y;
      //if (i > 100)
      //   printf("%d %g %g %g\n",i,x0,y0,z0);
    //}
    return position; 
  }
}

public class Trajectory3BodyGravityChaos extends Trajectory
{
  PVector pos_planet1, pos_planet2;
  PVector velocity;
  float G, m, m1, m2;
  
  int currentTime, prevTime;
  float timeElapsed;
  
  //  auxiliars
  PVector aux1, aux2;
  PVector initPosition, initVelocity;
  
  Trajectory3BodyGravityChaos(PVector aCenter, PVector aPosition, PVector aVelocity, PVector aPosPlanet1, PVector aPosPlanet2, float a_scale)
  {
    m  = 0.1; 
    m1 = 1080000;
    m2 = 1080000;
    
    G = 1;
    
    position = aPosition;
    
    aux1 = new PVector(0., 0.);
    aux2 = new PVector(0., 0.);
    velocity    = aVelocity;
    pos_planet1 = aPosPlanet1;
    pos_planet2 = aPosPlanet2;
    
    initPosition = new PVector(position.x, position.y);
    initVelocity = new PVector(velocity.x, velocity.y);
    
    println(position);
    println(velocity);
    println(aPosPlanet1);
    println(aPosPlanet2);
    
    scale = 2.5*a_scale;
    
    offset = new PVector( aCenter.x, aCenter.y );
    //offset = new PVector(-350., -200);
    
    prevTime = millis();
  }
  
  void reset() {
    position.x = initPosition.x;
    position.y = initPosition.y;
    velocity.x = initVelocity.x;
    velocity.y = initVelocity.y;
    prevTime = millis();
  }
  
  PVector update()
  {
    for (int i = 0; i < 1; i++)
    {    
      //  getting the time elapsed since last frame
      currentTime = millis();
      timeElapsed = currentTime - prevTime;
      timeElapsed /= 1000.;  //  converting from miliseconds to seconds
      prevTime   = currentTime;  //  updating
      
      //  calculating force due to gravity of planets 1 and 2 upon the body
      float G_m_Dt = G * /*m **/ timeElapsed;
      
      //  planet 1
      aux1 = PVector.sub(pos_planet1, position);
      /*println("pos_planet1 = " + pos_planet1);
      println("position = " + position);
      println("aux1 = " + aux1);*/
 
      float d1_squared = aux1.x*aux1.x + aux1.y*aux1.y;//aux1.magSq(); nao funcionou no modo JS
      //println("d1_squared = " + d1_squared);
      
      //  If too close to a planet, just keep the last calculated velocity
      if (d1_squared < 50)//  NOTE - hard-coded
      {
        d1_squared = 50;
        //println("d_squared < 50");
      }
      aux1.normalize();
      aux1.mult(m1 / d1_squared);
      
      //  planet 2
      aux2 = PVector.sub(pos_planet2, position);
 
      /*println("pos_planet2 = " + pos_planet2);
      println("position = " + position);
      println("aux2 = " + aux2);*/
 
      float d2_squared = aux2.x*aux2.x + aux2.y*aux2.y;//aux2.magSq(); nao funcionou no modo JS
      //println("d2_squared = " + d2_squared);
      
      //  If too close to a planet, just keep the last calculated velocity
      if (d2_squared < 50)//  NOTE - hard-coded
      {
        d2_squared = 50;
        //println("d_squared < 50");
      }
      aux2.normalize();
      aux2.mult(m2 / d2_squared);
      
      //  moving
      
      PVector velocity_increment = PVector.mult( PVector.add(aux1, aux2), G_m_Dt );
      /*println("PVector.add(aux1, aux2) = " + PVector.add(aux1, aux2));
      println("G_m_Dt = " + G_m_Dt);
      println("velocity_increment = " + velocity_increment);*/
      
      //  Euler-Cromer iteration (Leapfrog?)
      velocity.add(velocity_increment);
      //aux_ = ship.velocity.clone();
      //aux_.scaleBy(timeElapsed);
      aux2.x = velocity.x;    aux2.y = velocity.y;
      aux2.mult(timeElapsed);
      //println("novo aux2 = " + aux2);
      
      position.add(aux2);
      
      //if(d_squared < 25)
      //  keepEnergy();
    } 

    return position;
  }
}

//----------------------------------------
class SplatterSourceFactory
{
  SplatterSource createSplatterSource_snareDefault(float a_scale)
  {
    return new SplatterSource_Snare(new PVector(width/2.f, height/2.f), new PVector(width/2.f + width/6.f, height/2.f), color(0, 255, 0), a_scale);
  }
  
  SplatterSource createSplatterSource_crashDefault(float a_scale)
  {
    return new SplatterSource_Crash(new PVector(width/2.f, height/2.f), color(255, 0, 0), a_scale);
  }
  
  SplatterSource createSplatterSource_tonDefault()
  {
    return new SplatterSource_Ton(new PVector(0.75*width,height/2.), new PVector(width/4./60.,height/5./60.), color(0, 0, 255)); 
  }
}

//
//  A SplatterSource is composed of a Blob that obbeys a Trajectory
//
public class SplatterSource
{
  BlobFactory blobFactory = new BlobFactory();
  Blob        blob;
  Trajectory  trajectory;
  //PVector    position;
  
  SplatterSource() {
  }
  
  SplatterSource(PVector a_position, color a_color) {
    //blob = blobFactory.createBlob2(a_position, /*radius*/12., a_color);
    //position = a_position;
    //trajectory = new TrajectoryCircle(position, /*radius*/100., /*initial ang position*/0., 
    ///*angular speed (rad/s)*/PI/2., /*radius perturbation period (ms)*/300., /*radius perturbation amplitude*/0.2);
    
    //trajectory = new TrajectoryFastWrap(a_position, new PVector(width/3./60., height/2./60.));
    
    //trajectory = new TrajectoryLorenz(0.1, 0., 0., new PVector(a_position.x, a_position.y));
  }
  
  void updateAndDraw()
  {
    blob.generate();
    trajectory.update();
    blob.center.x = trajectory.position.x*trajectory.scale + trajectory.offset.x;
    blob.center.y = trajectory.position.y*trajectory.scale + trajectory.offset.y;
    blob.displayPerlin();
  }  
}

public class SplatterSource_Snare extends SplatterSource
{
  SplatterSource_Snare() {
  }
  
  SplatterSource_Snare(PVector a_position, PVector a_trajectoryCenter, color a_color, float a_scale)
  {
    blob = blobFactory.createBlob2(a_position, /*radius*/12., a_color); 
    trajectory = new TrajectoryLorenz(0.1, 0., 0., a_trajectoryCenter, a_scale);
  }
}

//  A ideia para escalar um sistema gravitacional eh a seguinte... deixe com os numeros 
//que funcionam.
//  Escale apenas a posicao a cada frame, nao mexa em velocidade nem massa nem posicao dos
//dois corpos massivos
public class SplatterSource_Crash extends SplatterSource
{
  SplatterSource_Crash(PVector a_center, color a_color, float a_scale)
  {
    //  fiz offset de -300, -200. Meio caminho entre os dois corpos massivos esta em (0.,0.)
    
    //  note: this position of the blob is overwritten by the trajectory, that updates it every frame...
    blob = blobFactory.createBlob2(new PVector(0., 180.), /*radius*/12., a_color); 
        
    trajectory = new Trajectory3BodyGravityChaos(
      a_center,
      new PVector(0., 80.),
      new PVector(8., 10.),
      new PVector(-100., 0.),
      new PVector(100., 0.), a_scale);
  }
}

public class SplatterSource_Ton extends SplatterSource
{
  SplatterSource_Ton(PVector a_position, PVector a_speed, color a_color)
  {
    blob = blobFactory.createBlob2(a_position, /*radius*/12., a_color); 
    trajectory = new TrajectoryFastWrap(a_position, a_speed);
  }
}



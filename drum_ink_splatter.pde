//import java.util.*;//import java.util.LinkedList;
import oscP5.*;
import netP5.*;
OscP5 oscP5; 
NetAddress myRemoteLocation;

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

float lastMillis;

void setup()
{  
  size(960, 720);
  
  /**** JAVA 
  // start oscP5, listening for incoming messages at port 12000 
  oscP5 = new OscP5(this,12000);
  
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
  oscP5.plug(this, "ton", "/ton");
  END JAVA*/
  
  //splatters = new LinkedList<Splatter>();//splatters = new SplatterPool(200);
  splatters = new ArrayList<Splatter>();
  
  /*blobs_pool = new ArrayList();
  
  blobFactory = new BlobFactory();
  
  blobs_pool.add(blobFactory.createBlob1(60,60));
  blobs_pool.add(blobFactory.createBlob2(width-60,60));
  blobs_pool.add(blobFactory.createBlob3(60,height-60));
  blobs_pool.add(blobFactory.createBlob4(width-60,height-60));*/
  
  splatterSourceFactory = new SplatterSourceFactory(); 
  splatterSnareSource   = splatterSourceFactory.createSplatterSource_snareDefault(new PVector(width/2.,height/2.));
  splatterCrashSource   = splatterSourceFactory.createSplatterSource_crashDefault();
  splatterTonSource     = splatterSourceFactory.createSplatterSource_tonDefault(new PVector(0.75*width,height/2.), new PVector(width/4./60.,height/5./60.));
  
  //frameRate(60);
}

//
//  These are the functions that will be called by Processing when received osc message accordingly
//  NOTE - we are not using a_param
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
  
  //  If blob gets ejected, rest its trajectory
  if(       splatterCrashSource.trajectory.position.x > width  || splatterCrashSource.trajectory.position.x < 0)
  {
    splatterCrashSource.trajectory.reset();
  } else if(splatterCrashSource.trajectory.position.y > height || splatterCrashSource.trajectory.position.y < 0)
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
  if (key == 'a')
  {
    println(key);
    
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



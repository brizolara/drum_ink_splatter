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

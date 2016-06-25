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


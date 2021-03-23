class Vehicle {
 PVector location;
 PVector velocity;
 PVector acceleration;
 PVector steer2;
 
 float r;
 float maxspeed;
 float maxforce;
 
 PImage fotos[] = new PImage[2];
 PImage foto;
 
 Vehicle(float x, float y) {
   acceleration = new PVector(0,0);
   velocity = new PVector(0,0);
   location = new PVector(x,y);
   steer2 = new PVector(0,0);
   r=3.0;
   maxspeed = 4;
   maxforce = .1;
   
   fotos[0] = loadImage("peixe.png");
   fotos[0].resize(100,0);
   fotos[1] = loadImage("pipa2.png");
   fotos[1].resize(0,100);
   foto = fotos[int(random(fotos.length))];

 }
 
 void update() {
   velocity.add(acceleration);
   velocity.limit(maxspeed);
   location.add(velocity);
   acceleration.mult(0);
 }
 
 void applyForce(PVector force) {
   acceleration.add(force);
 }
 
 void seek(PVector target) {
   PVector desired = PVector.sub(target,location);
   desired.normalize();
   desired.mult(maxspeed);
   PVector steer = PVector.sub(desired,velocity);
   steer.limit(maxforce);
   line(location.x,location.y, (location.x + steer.x)*1.5, (location.y+steer.y)*1.5);
   applyForce(steer);
 }
 
 void display() {
   float theta = velocity.heading() + PI/2;
   fill(175);
   stroke(0);
   pushMatrix();
   translate(location.x,location.y);
   rotate(theta);
   imageMode(CENTER);
   image(foto,0,0);
   //beginShape();
   //vertex(0,-r*2);
   //vertex(-r, r*2);
   //vertex(r, r*2);
   //endShape(CLOSE);
   popMatrix();
 }
 
 void follow(FlowField flow) {
   PVector desired = new PVector(0,0);
   
   if (location.y < height/2) {
     desired = flow.lookup(location);
     desired.mult(maxspeed);
   }
   else {
     desired.set(velocity.x,maxspeed*-1);
   }
   
   PVector steer = PVector.sub(desired,velocity);
   steer.limit(maxforce);
   applyForce(steer);
 }
 
 boolean saiuDeTela() {
   if(location.x <= width && location.x >= 0 && location.y >= 0 && location.y <= height) {
     return false;
   }
   else {
     return true;
   }
 }
}

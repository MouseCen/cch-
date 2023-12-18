import processing.dxf.*;

import peasy.*;
import controlP5.*;
import processing.core.PImage;



boolean record;
PImage p1;
PVector[][] vp;
int layer ;
int section ;
float original_radiu = 100;
float cyHigth = 5;
int si = 1;
int sj = 1;
int detail =10;
int h1 = 100, h2 = 0, s1 = 100, s2 = 0, b1 = 100, b2 = 0;
float k = 1;

PeasyCam cam;
ControlP5 cp;

void setup(){
p1 = loadImage("Union.jpg");
p1.loadPixels();
  size(1200,1200, P3D);
  section = p1.width;
  layer = p1.height;
  background(0);
  cam = new PeasyCam(this, 600);
  UI();
  colorMode(HSB, 360, 100, 100);
  buildCylinder();
}

void draw(){
  background(0, 0, 10);
  si = sj = detail; 
  

  if (record) {
    beginRaw (DXF, "output.dxf");
  }
  
  
  buildCylinder();
  displayCylinder();


  if (record) {
    endRaw ();
    record = false;
  }


  cam.beginHUD();
  cp.draw();
  cam.endHUD();


  if (mouseX<300 && mouseY<500) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}

void buildCylinder(){
  vp = new PVector[layer][section];
  float angle = TWO_PI/section;

  for(int j = 0; j < layer; j=j+1){
    for(int i = 0; i < section; i=i +1){
        color ccc =p1.pixels[i +  j* p1.width];
        float Add_radiu =  k * brightness(ccc);
        float radiu = original_radiu+Add_radiu;
      vp[j][i] = new PVector(radiu*cos(angle*i), radiu*sin(angle*i), cyHigth*j);
    }
  } 
  }



void displayCylinder(){

  strokeWeight(0.5);
  stroke(255);
  for(int j = 0; j < layer-sj; j=j+sj){
    for(int i = 0; i < section-si; i=i +si){
      float h = map(j,0,layer,h1,h2);
      float s = map(j,0,layer,s1,s2);
      float b = map(j,0,layer,b1,b2);
      fill(h,s,b);
        beginShape(TRIANGLE);
        vertex(vp[j][i].x, 
               vp[j][i].y, 
               vp[j][i].z);
        vertex(vp[j+sj][i].x, 
               vp[j+sj][i].y, 
               vp[j+sj][i].z);
        vertex(vp[j][(i+sj)%vp[j].length].x, 
               vp[j][(i+sj)%vp[j].length].y, 
               vp[j][(i+sj)%vp[j].length].z);

               
               
        vertex(vp[j][0].x, 
               vp[j][0].y, 
               vp[j][0].z);
        vertex(vp[j][section-si].x, 
               vp[j][section-si].y, 
               vp[j][section-si].z);
        vertex(vp[j+sj][0].x, 
               vp[j+sj][0].y, 
               vp[j+sj][0].z);
               
        vertex(vp[j+sj][section-si].x, 
               vp[j+sj][section-si].y, 
               vp[j+sj][section-si].z);
        vertex(vp[j][section-si].x, 
               vp[j][section-si].y, 
               vp[j][section-si].z);
        vertex(vp[j+sj][0].x, 
               vp[j+sj][0].y, 
               vp[j+sj][0].z);
        
        vertex(vp[j][(i+si)%vp[j].length].x, 
               vp[j][(i+si)%vp[j].length].y, 
               vp[j][(i+si)%vp[j].length].z);
        vertex(vp[j+sj][i].x, 
               vp[j+sj][i].y, 
               vp[j+sj][i].z);
        vertex(vp[j+sj][(i+si)%vp[j].length].x,
               vp[j+sj][(i+si)%vp[j].length].y, 
               vp[j+sj][(i+si)%vp[j].length].z);
        endShape();
      
    }
  }
  
  for(int j = 0; j < layer; j=j+sj){
    for(int i = 0; i < section; i=i +si){
      strokeWeight(5);
      //stroke(255,0,255);
      noStroke();
      point(vp[j][i].x, vp[j][i].y, vp[j][i].z);
    }
  }
}

void keyPressed () {
  // 使用按键触发，以避免每次通过draw()都写入一个文件
  if (key == 'r') {
    record = true;
  }
}

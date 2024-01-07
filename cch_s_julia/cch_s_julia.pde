import controlP5.*;
ControlP5 cp;

float zoom = 1;
float panX = 0;
float panY = 0;

  float cRe = -0.7; // 实部
  float cIm = 0.27015; // 虚部
  int maxIterations = 100;


void setup() {
  size(800, 800);
  pixelDensity(1);
  colorMode(HSB, 1);
  UI();
}

void draw() {
  loadPixels();
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float a = map(x, 0, width, -2.5*zoom + panX, 2.5*zoom + panX);
      float b = map(y, 0, height, -2.5*zoom + panY, 2.5*zoom + panY);
      
      int n = 0;

      
      while (n < maxIterations) {
        float aa = a * a - b * b;
        float bb = 2 * a * b;
        
        a = aa + cRe;
        b = bb + cIm;
        
        if (abs(a + b) > 16) {
          break;
        }
        n++;
      }
      float brightness = map(n, 0, maxIterations, 0, 1);
      brightness = map(sqrt(brightness), 0, 1, 0, 1);
      
      int pix = x + y * width;
      pixels[pix] = color((brightness*frameCount/200)%1, 1, 1.2*brightness);
    }
  }
  
  updatePixels();
  //saveFrame();
}

void mouseWheel(MouseEvent event) {
    if (mouseX>200 || mouseY>200) {  
  float e = event.getCount();
  zoom -= e*0.01;
    }
}

void mouseDragged() {
  
  if(mouseX>200 || mouseY>200){
  panX += (pmouseX - mouseX) / (width * zoom);
  panY += (pmouseY - mouseY) / (height * zoom);
}
}

void keyPressed() {
  if (key == 'j' || key == 'J') {
    saveFrame("screenshot-####.png"); // 保存屏幕图像
  }
}

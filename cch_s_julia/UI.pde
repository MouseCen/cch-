 void UI(){
  cp = new ControlP5(this, createFont("得意黑", 24));
  cp.addSlider("cRe", -2, 2, -0.7, 50, 40, 100, 30).setLabel("实部");
  cp.addSlider("cIm", -2, 2, 0.27015, 50, 90, 100, 30).setLabel("虚部");
  cp.addSlider("maxIterations", 10, 300, 100, 50, 130, 100, 30).setLabel("最大迭代次数");
 }

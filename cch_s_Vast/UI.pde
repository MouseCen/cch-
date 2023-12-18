 void UI(){
  cp = new ControlP5(this, createFont("得意黑", 24));
  cp.addSlider("cyHigth", 1, 20, 5, 50, 50, 100, 30).setLabel("高度");
  cp.addSlider("detail", 1, 20, 10, 50, 90, 100, 30).setLabel("粗糙度");
  cp.addSlider("s1", 0, 360, 100, 50, 170, 100, 30).setLabel("上边色相");
  cp.addSlider("h1", 0, 100, 100, 50, 210, 100, 30).setLabel("上边彩度");
  cp.addSlider("b1", 0, 100, 100, 50, 250, 100, 30).setLabel("上边明度");
  cp.addSlider("s2", 0, 360, 0, 50, 290, 100, 30).setLabel("下边色相");
  cp.addSlider("h2", 0, 100, 0, 50, 330, 100, 30).setLabel("下边彩度");
  cp.addSlider("b2", 0, 100, 0, 50, 370, 100, 30).setLabel("下边明度");
  cp.addSlider("original_radiu", 0, 300, 100, 50, 370+50, 100, 30).setLabel("筒半径");
  cp.addSlider("k", 0,2 , 1, 50, 370+100, 100, 30).setLabel("肌理强度");
  cp.setAutoDraw(false);
 }

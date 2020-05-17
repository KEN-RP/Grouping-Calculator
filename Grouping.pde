ArrayList<Point> pointList = new ArrayList<Point>();
Point averagePoint = new Point(-100,-100);
boolean renderBullet = true;
float grouping = -1;
int numOfBullets = 0;
int calculatedNum = 10;
ArrayList<Integer> removedPoint = new ArrayList<Integer>();
boolean removeOutlier = false;
boolean drawAv = true;

void setup() {
  //surface.setResizable(true);
  surface.setSize(504, 574);
  smooth();
  background(20);
}

void draw() {
  background(20);
  drawTarget();
  drawImpactPoints();
  drawMousePoint();
  drawData();
}

void drawImpactPoints() {
  averagePoint.x=0;
  averagePoint.y=0;
  for (int i = 0; i<pointList.size(); i++) {
    Point tmpPoint = pointList.get(i);
    if (i<pointList.size()-calculatedNum) {
      drawBullet(tmpPoint.x, tmpPoint.y, 100, 100, 100);
    } else {
      drawBullet(tmpPoint.x, tmpPoint.y, 230, 230, 230);
      averagePoint.x+=tmpPoint.x;
      averagePoint.y+=tmpPoint.y;
    }
  }
  if (drawAv) {
    if (pointList.size()>calculatedNum) {
      averagePoint.x/=calculatedNum;
      averagePoint.y/=calculatedNum;
    } else {
      averagePoint.x/=pointList.size();
      averagePoint.y/=pointList.size();
    }
    strokeWeight(2);
    stroke(0, 255, 0);
    line(averagePoint.x-5, averagePoint.y-5, averagePoint.x+5, averagePoint.y+5);
    line(averagePoint.x-5, averagePoint.y+5, averagePoint.x+5, averagePoint.y-5);
  }
}

void drawMousePoint() {
  if (mouseY < 504) {
    noCursor();
    drawBullet(mouseX, mouseY, 255, 200, 200);
  } else {
    cursor();
  }
}

void refleshData() {
  numOfBullets = pointList.size();
}

void calculateGrouping() {
  refleshData();
  if (numOfBullets<calculatedNum) {
    grouping = -1;
    return;
  }
  if (removeOutlier) {
    int removeNum = calculatedNum/10;
    float[] distance = new float[numOfBullets];
    for(int i = 0;i<distance.length;i++){
      distance[i] = dist(pointList.get(i),averagePoint);
    }
    float[][] removeRank = new float[removeNum][2];
    for(int i = 0;i<removeRank[0].length;i++){
      for(int j = 0;j<2;j++){
        removeRank[i][j] = 0;
      }
    }
    for(int i = 0;i<distance.length;i++){
      
    }
  } else {
    float max = 0;
    for (int i = numOfBullets-calculatedNum; i<numOfBullets; i++) {
      for (int j = i; j<numOfBullets; j++) {
        float tmp = dist(pointList.get(i), pointList.get(j));
        if (tmp>max)max=tmp;
      }
    }
    grouping = round(max*25)/100.0;
  }
}

void drawData() {
  refleshData();
  fill(255);
  textSize(15);
  textAlign(LEFT, TOP);
  text(numOfBullets+" Bullet(s)", 10, 514);
  textAlign(CENTER, TOP);
  text("Grouping : "+(grouping==-1 ? "null" : grouping)+"[mm]", 252, 514);
  textAlign(RIGHT, TOP);
  text("Outlier : "+(removeOutlier ? "removed" : "unremoved"), 494, 514);
  textAlign(LEFT, BOTTOM);
  text("Bullet(s) : "+(renderBullet ? "rendered" : "unrendered"), 10, 564);
  textAlign(CENTER, BOTTOM);
  text("Measuring : "+calculatedNum, 252, 564);
  strokeWeight(1);
  fill(50);
  stroke(255);
  rect(355, 540, 130, 30, 20);
  fill(255);
  textAlign(CENTER, BOTTOM);
  text("Reset", 420, 564);
}

void drawTarget() {
  textSize(20);
  textAlign(CENTER, CENTER);
  ellipseMode(CORNERS);
  strokeWeight(1);
  stroke(255);
  noFill();
  for (int i = 0; i < 6; i++) {
    ellipse(i*36, i*36, 504-i*36, 504-i*36);
    fill(255);
    text(4+i, i*36+18, 252);
    noFill();
  }
  fill(220, 0, 0);
  ellipse(216, 216, 288, 288);
  line(0, 504, 504, 504);
}

void drawBullet(float x, float y, float r, float g, float b) {
  if (renderBullet) {
    stroke(0);
    strokeWeight(1.5);
    fill(r, g, b);
    ellipseMode(CENTER);
    ellipse(x, y, 24, 24);
  }
  strokeWeight(0.8);
  stroke(0, 255, 255);
  line(x-4, y-4, x+4, y+4);
  line(x-4, y+4, x+4, y-4);
}

float dist(Point a,Point b){
  return dist(a.x,a.y,b.x,b.y);
}

void mousePressed() {
  if (mouseY < 504) {
    pointList.add(new Point(mouseX, mouseY));
    calculateGrouping();
  }
  if (mouseX>355 && mouseY>540 && mouseX<485 && mouseY<570) {
    pointList.clear();
    grouping = 0;
  }
}

void keyPressed() {
  if (key == 'r') {
    renderBullet = !renderBullet;
  }
  if (key == 'a') {
    drawAv = !drawAv;
  }
  if (keyCode == UP) {
    calculatedNum++;
    calculateGrouping();
  }
  if (keyCode == DOWN) {
    calculatedNum--;
    calculateGrouping();
  }
}

class Point {
  float x, y;
  Point(float in1, float in2) {
    x = in1;
    y = in2;
  }
}

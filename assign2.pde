PImage bgImg,cabbageImg,titleImg,gameoverImg,startNormalImg,startHoveredImg,restartNormalImg,restartHoveredImg;
PImage groundhogDownImg,groundhogIdleImg,groundhogLeftImg,groundhogRightImg,lifeImg,soilImg,soldierImg;

int grid=80;
int gressH=15;
int lifeX=10,lifeY=10,lifeW=51,lifeSpace=20,lifeNomber;
int groundhogW=80,soldierW=80,cabbageW=80;
int soldierX,soldierY,robotX,robotY;
//int move=0;
int x,y,cx,cy;
int speed=80/15;
int downX,downY,leftX,leftY,rightX,rightY;
int groundhogLestX, groundhogLestY;
int n;

int groundhogMoveTime = 250;//move to next grid need 0.25s
int actionFrame; //groundhog's moving frame 
float lastTime; //time when the groundhog finished moving

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;
int gameState = 0; 


void setup() {
	size(640, 480, P2D);
  //loadImage
  bgImg=loadImage("img/bg.jpg");
  cabbageImg=loadImage("img/cabbage.png");
  titleImg=loadImage("img/title.jpg");
  gameoverImg=loadImage("img/gameover.jpg");
  startNormalImg=loadImage("img/startNormal.png");
  startHoveredImg=loadImage("img/startHovered.png");
  restartNormalImg=loadImage("img/restartNormal.png");
  restartHoveredImg=loadImage("img/restartHovered.png");
  groundhogDownImg=loadImage("img/groundhogDown.png");
  groundhogIdleImg=loadImage("img/groundhogIdle.png");
  groundhogLeftImg=loadImage("img/groundhogLeft.png");
  groundhogRightImg=loadImage("img/groundhogRight.png");
  lifeImg=loadImage("img/life.png");
  soilImg=loadImage("img/soil.png");
  soldierImg=loadImage("img/soldier.png");
  //soldier
  soldierX=-soldierW;
  soldierY=(floor(random(0,4))+2)*grid;
  //groundhog
  x=grid*4;
  y=grid;
  //cabbage
  cx=floor(random(0,8))*grid;
  cy=floor((random(0,4))+2)*grid;
  
  frameRate(60);
  lastTime = millis(); // save lastest time call the millis();
  lifeNomber=2;
  
  
}

void draw() {
  switch(gameState) {
    case GAME_START:
      image(titleImg,0,0,640,480);
      image(startNormalImg,248,360,144,60);
      if (mouseX>248&& mouseX<248+144&& mouseY>360&& mouseY<360+60){
        image(startHoveredImg,248,360,144,60);
        if (mousePressed){
          gameState=1;
        }
      }
      break; 
    case GAME_RUN:
      image(bgImg,0,0);
      image(soilImg,0,grid*2);
      //gress
      fill(124,204,25);
      noStroke();
      rect(0,grid*2-gressH,width,gressH);
      //life
      for(int i=0;i<lifeNomber;i++){
        imageMode(CORNER);
        image(lifeImg,lifeX+(lifeW+lifeSpace)*i,lifeY);
      }
      //sun
      fill(253,184,19);
      stroke(255,255,0);
      strokeWeight(5);
      ellipse(width-50,50,120,120);
      //groundHog
      //image(groundhogIdleImg,x,y);
      //random
      image(soldierImg,soldierX,soldierY);
      //soldierWalk
      if (soldierX<640+soldierW){
        soldierX++;
      }else{
        soldierX=-soldierW;
      }
      //cabbage
      image(cabbageImg,cx,cy);
      
      //draw the groundhogDown image between 1-14 frames
      if (downPressed) {
        actionFrame++; //in 1s actionFrame=60
        if (actionFrame > 0 && actionFrame <15) {
          y += grid / 15.0;
          image(groundhogDownImg,x,y);
        } else {
          y = groundhogLestY + grid;
          downPressed = false;
        }
      }
      //draw the groundhogLeft image between 1-14 frames
      if (leftPressed) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame <15) {
          x -= grid / 15.0;
         image(groundhogLeftImg,x,y);
        } else {
          x= groundhogLestX - grid;
          leftPressed = false;
        }
      }
      //draw the groundhogRight image between 1-14 frames
      if (rightPressed) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame < 15) {
          x += grid / 15.0;
          image(groundhogRightImg,x,y);
        } else {
          x = groundhogLestX + grid;
          rightPressed = false;
        }
      }
      if(!downPressed&&!leftPressed&&!rightPressed){
        image(groundhogIdleImg,x,y);
      }
      ////boundary detection
      if (x>=width-groundhogW){
        x=width-groundhogW;
      }
      if (x<=0){
        x=0;
      }
      if (y>height-groundhogW){
        y=height-groundhogW;
      }
      if (y<grid){
        y=grid;
      }
      //touch the soldier
      if(soldierX<x+groundhogW&& soldierX+soldierW>x&& soldierY<y+groundhogW&& soldierY+soldierW>y){
        x=grid*4;
        y=grid;
        lifeNomber-=1;
      }
      //eat the cabbage
      if(cx<x+groundhogW&& cx+cabbageW>x&& cy<y+groundhogW&& cy+cabbageW>y){
        cx=640;
        cy=480;
        lifeNomber+=1;
      }
      if(lifeNomber==0){
        gameState=2;
      }
      break;
    case GAME_LOSE:
      image(gameoverImg,0,0,640,480);
      image(restartNormalImg,248,360,144,60);
      if (mouseX>248&& mouseX<248+144&& mouseY>360&& mouseY<360+60){
        image(restartHoveredImg,248,360,144,60);
        if (mousePressed){
          lifeNomber=2;
          //soldier
          soldierX=-soldierW;
          soldierY=(floor(random(0,4))+2)*grid;
          //groundhog
          x=grid*4;
          y=grid;
          //cabbage
          cx=floor(random(0,8))*grid;
          cy=floor((random(0,4))+2)*grid;
          gameState=1;
        }
      }
      break;
  }
}

void keyPressed() {
  float newTime = millis(); //time when the groundhog started moving
  if (key == CODED) {
    switch (keyCode) {
    case DOWN:
      if (newTime - lastTime > groundhogMoveTime) {
        downPressed = true;
        actionFrame = 0;
        groundhogLestY = y;
        lastTime = newTime;
      }
      break;
    case LEFT:
      if (newTime - lastTime > groundhogMoveTime) {
        leftPressed = true;
        actionFrame = 0;
        groundhogLestX = x;
        lastTime = newTime;
      }
      break;
    case RIGHT:
      if (newTime - lastTime > groundhogMoveTime) {
        rightPressed = true;
        actionFrame = 0;
        groundhogLestX = x;
        lastTime = newTime;
      }
      break;
    }
  }
}

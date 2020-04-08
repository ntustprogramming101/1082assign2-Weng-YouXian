PImage bgImg,cabbageImg,titleImg,gameoverImg,startNormalImg,startHoveredImg,restartNormalImg,restartHoveredImg;
PImage groundhogDownImg,groundhogIdleImg,groundhogLeftImg,groundhogRightImg,lifeImg,soilImg,soldierImg;

int grid=80;
int gressH=15;
int lifeX=10,lifeY=10,lifeW=51,lifeSpace=20,lifeNomber;
int groundhogW=80,soldierW=80,cabbageW=80;
int soldierX,soldierY,robotX,robotY;
int x,y,cx,cy;
int speed=80;

boolean upPressed = false;
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
  
  frameRate(15);
  
  lifeNomber=2;
}

void draw() {
  switch(gameState) {
    case GAME_START:
      image(titleImg,0,0,640,480);
      image(startNormalImg,248,360,144,60);
      if (mouseX>248&& mouseX<248+144&& mouseY>360&& mouseY<360+60){ //boundary
        image(startHoveredImg,248,360,144,60);
        if (mousePressed){
          gameState=1;
        }
      }
      break; 
    case GAME_RUN:
      imageMode(CORNER);
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
      image(groundhogIdleImg,x,y);
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
      //move
      if (upPressed) {
        y -= speed;   
      }
      if (downPressed) {
        y += speed;
      }
      if (leftPressed) {
        x -= speed;
      }
      if (rightPressed) {
        x += speed;
      }
      //boundary detection
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
      imageMode(CORNER);
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

void keyPressed(){
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}

void keyReleased(){
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}

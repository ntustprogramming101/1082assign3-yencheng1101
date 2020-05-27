final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24,life;
PImage soil0,soil1,soil2,soil3,soil4,soil5;
PImage stone1,stone2;
PImage groundhogIdle,groundhogDown,groundhogLeft,groundhogRight;

float soilWidth=80,soilHeight=80;

final int COUNT=8;
float stone1X,stone1Y;
float spacing = 80;
float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * spacing;
final float PLAYER_INIT_Y = - spacing;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;
boolean demoMode = false;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;

void setup() {
	size(640, 480, P2D);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	soil8x24 = loadImage("img/soil8x24.png");
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  life = loadImage("img/life.png");
  
    // Initialize player
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / spacing);
  playerRow = (int) (playerY /spacing);
  playerMoveTimer = 0;
  playerHealth = 2;
}

void draw() {

  /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

		// Grass
  		fill(124, 204, 25);
  		noStroke();
  		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
      for(int y =160; y<27*soilHeight; y+=soilHeight){ 
        for(int x=0; x<width; x+=soilWidth){
          if(y <=5*soilHeight ) {
          image(soil0,x,y );   
          }else if(y<=9*soilHeight){
          image(soil1,x,y );  
          }else if(y<=13*soilHeight){
          image(soil2,x,y );
          }else if(y<=17*soilHeight){
          image(soil3,x,y );
          }else if(y<=21*soilHeight){
          image(soil4,x,y );
          }else{
          image(soil5,x,y );
          }
        }
      }
    
    //stone
    //later 1-8
    for (int i=0;i<8;i++){
      image(stone1,i*spacing,i*spacing+2*spacing);
    }
    //layer 9-16
    for(int i=0;i<8;i++){
      if (i%4==1||i%4==2){
        for(int j=0;j<8;j++){
          if (j%4==0||j%4==3){
            image(stone1,j*spacing,(i+8)*spacing);
          }
        }
      }
      if (i%4==3||i%4==0){
        for(int j=0;j<8;j++){
          if (j%4==1||j%4==2){
            image(stone1,j*spacing,(i+8)*spacing);
          }
        }
      }
    }
    //layer 17-24
    for (int i=0;i<8;i++){
      if(i%3==0){
        for(int j=0;j<8;j++){
          if(j%3!=0){
            image(stone1,j*spacing,(i+16)*spacing);
            if(j%3==2){
              image(stone2,j*spacing,(i+16)*spacing);
            }
          }
        }
      }
      if(i%3==1){
        for(int j=0;j<8;j++){
          if(j%3!=2){
            image(stone1,j*spacing,(i+16)*spacing);
            if(j%3==1){
              image(stone2,j*spacing,(i+16)*spacing);
            }
          }
        }
      }
      if(i%3==2){
        for(int j=0;j<8;j++){
          if(j%3!=1){
            image(stone1,j*spacing,(i+16)*spacing,spacing,spacing);
            if(j%3==0){
              image(stone2,j*spacing,(i+16)*spacing,spacing,spacing);
            }
          }
        }
      }
    }
      
    //life
    for(int l=0; l < playerHealth ;l++){
     image(life,10+70*l,10,50,50);
     }
     
     
		// Player

    PImage groundhogDisplay = groundhogIdle;

    // If player is not moving, we have to decide what player has to do next
    if(playerMoveTimer == 0){

      // HINT:
      // You can use playerCol and playerRow to get which soil player is currently on

      // Check if "player is NOT at the bottom AND the soil under the player is empty"
      // > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
      // > Else then determine player's action based on input state

      if(leftState){

        groundhogDisplay = groundhogLeft;

        // Check left boundary
        if(playerCol > 0){

          // HINT:
          // Check if "player is NOT above the ground AND there's soil on the left"
          // > If so, dig it and decrease its health
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)

          playerMoveDirection = LEFT;
          playerMoveTimer = playerMoveDuration;

        }

      }else if(rightState){

        groundhogDisplay = groundhogRight;

        // Check right boundary
        if(playerCol < SOIL_COL_COUNT - 1){

          // HINT:
          // Check if "player is NOT above the ground AND there's soil on the right"
          // > If so, dig it and decrease its health
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)

          playerMoveDirection = RIGHT;
          playerMoveTimer = playerMoveDuration;

        }

      }else if(downState){

        groundhogDisplay = groundhogDown;

        // Check bottom boundary

        // HINT:
        // We have already checked "player is NOT at the bottom AND the soil under the player is empty",
        // and since we can only get here when the above statement is false,
        // we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
        if(playerRow < SOIL_ROW_COUNT - 1){

          // > If so, dig it and decrease its health

          // For requirement #3:
          // Note that player never needs to move down as it will always fall automatically,
          // so the following 2 lines can be removed once you finish requirement #3

          playerMoveDirection = DOWN;
          playerMoveTimer = playerMoveDuration;


        }
      }

    }

    // If player is now moving?
    // (Separated if-else so player can actually move as soon as an action starts)
    // (I don't think you have to change any of these)

    if(playerMoveTimer > 0){

      playerMoveTimer --;
      switch(playerMoveDirection){

        case LEFT:
        groundhogDisplay = groundhogLeft;
        if(playerMoveTimer == 0){
          playerCol--;
          playerX = spacing * playerCol;
        }else{
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * spacing;
        }
        break;

        case RIGHT:
        groundhogDisplay = groundhogRight;
        if(playerMoveTimer == 0){
          playerCol++;
          playerX = spacing* playerCol;
        }else{
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * spacing;
        }
        break;

        case DOWN:
        groundhogDisplay = groundhogDown;
        if(playerMoveTimer == 0){
          playerRow++;
          playerY = spacing * playerRow;
        }else{
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * spacing;
        }
        break;
      }

    }

    image(groundhogDisplay, playerX, playerY);
    
		// Health UI

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
	// Add your moving input code here
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = true;
      break;
      case RIGHT:
      rightState = true;
      break;
      case DOWN:
      downState = true;
      break;
    }
  }else{
    if(key=='b'){
      // Press B to toggle demo mode
      demoMode = !demoMode;
    }
  }

  
	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}


void keyReleased(){
    if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = false;
      break;
      case RIGHT:
      rightState = false;
      break;
      case DOWN:
      downState = false;
      break;
    }
  }
}

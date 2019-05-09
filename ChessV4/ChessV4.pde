Player p1;
Player p2;
MovAlgo ref;
boolean setupTime;
int delay;
int gameOverTextX;
int gameOverTextY;
int playerScreen;

void setup() {
  size(800,900);
  setupTime = true;
  delay = 0;
  gameOverTextX = 200;
  gameOverTextY = 860;
  ref = new MovAlgo();
  makePlayers(false, false);
  playerScreen = 3;
}

void makePlayers(boolean p1AI, boolean p2AI) {
  if(p1AI && p2AI) {
    p1 = new AI();
    p2 = new AI();
  } else if(p1AI && !p2AI) {
    p1 = new AI();
    p2 = new Human();
  } else if(!p1AI && p2AI) {
    p1 = new Human();
    p2 = new AI();
  } else {
    p1 = new Human();
    p2 = new Human();
  }
}

void draw() {
  if(ref.current.gameOver) noLoop();
  else if(!setupTime) {
    if(notHumanDeciding()) makePlay();
    if(playerScreen == 0) ref.draw();
    else if(playerScreen == 1) p1.refSim.draw();
    else if(playerScreen == 2) p2.refSim.draw();
    else if(playerScreen == 3) {
      if(ref.catalog.size()%2 == 0) {
        p1.refSim.draw();
      } else {
        p2.refSim.draw();
      }
    }
  }
}

boolean notHumanDeciding() {
  boolean deciding = true;
  if(!p1.ai && ref.catalog.size()%2 == 0) {
    deciding = p1.desiredMove != null;
  } else if(!p2.ai && ref.catalog.size()%2 == 1) {
    deciding = p2.desiredMove != null;
  }
  return deciding;
}

void makePlay() {
  int turn = ref.catalog.size();
  if(ref.isStaleMate()) {
    staleMate();
  } else if(ref.isMate()) {
    if(turn%2 == 0) blackWins(false);
    else blackWins(true);
  } else if(turn%2 == 0) {
    if(p1.ai) delay(delay);
    ref.playMove(p1.getMove());
    if(ref.catalog.size() == turn+1) {
      updatePlayerBoards(p1.desiredMove);
    }
    p1.desiredMove = null;
  } else {
    if(p2.ai) delay(delay);
    ref.playMove(p2.getMove());
    if(ref.catalog.size() == turn+1) {
      updatePlayerBoards(p2.desiredMove);
    }
    p2.desiredMove = null;
  }
}

void updatePlayerBoards(Move move) {
  p1.updateMove(move);
  p2.updateMove(move);
}

void blackWins(boolean black) {
  ref.draw();
  println("Exiting at " + millis()/1000.0 + " seconds");
  textSize(32);
  fill(40, 125, 20);
  text("Game over, " + ((black)? "black": "white") + " wins", gameOverTextX, gameOverTextY);
  ref.current.gameOver = true;
}

void staleMate() {
  ref.draw();
  println("Exiting at " + millis()/1000.0 + " seconds");
  textSize(32);
  fill(40, 125, 20);
  text("Game over, stalemate", gameOverTextX, gameOverTextY);
  ref.current.gameOver = true;
}

//for a player vs player game

void mousePressed() {
  //check if !gameOver and is proper turn then
  //update human to hold piece in hand
  //human.putPieceClickedInHand
  if(!ref.current.gameOver) {
    if(!p1.ai && ref.catalog.size()%2 == 0) {
      p1.putClickedInHand();
    }
    if(!p2.ai && ref.catalog.size()%2 == 1) {
      p2.putClickedInHand();
    }
  }
}

void mouseDragged() {
  //check if !gameOver and is proper turn then
  //update the position of the piece in human's hand
  //move piece around
  if(!ref.current.gameOver) {
    if(!p1.ai && ref.catalog.size()%2 == 0) {
      p1.moveInHandToMouse();
    }
    if(!p2.ai && ref.catalog.size()%2 == 1) {
      p2.moveInHandToMouse();
    }
  }
}

void mouseReleased() {
  //place piece in human hand on the board
  if(!ref.current.gameOver) {
    if(!p1.ai && ref.catalog.size()%2 == 0) {
      p1.placeInHandOnBoard();
    }
    if(!p2.ai && ref.catalog.size()%2 == 1) {
      p2.placeInHandOnBoard();
    }
  }
}

//some extra stuff like puasing the game or reverting a turn

void keyPressed() {
  println(keyCode);
  
  switch(keyCode) {
    case 32: setupTime = !setupTime; break;
    case 80:
      //switch to view what different players see, along with the main board
      if(playerScreen == 0) {
        playerScreen = 1;
      } else if(playerScreen == 1) {
        playerScreen = 2;
      } else if(playerScreen == 2) {
        playerScreen = 3;
      } else {
        playerScreen = 0;
      }
      println("Screen " + playerScreen);
      break;
    case 82: goBackOneTurn(); break;
  }
  
}

void goBackOneTurn() {
  ref.revertTurn(); 
  p1.refSim.revertTurn();
  p2.refSim.revertTurn();
}

Player p1;
Player p2;
MovAlgo ref;
boolean gameOver;
boolean setupTime;
int delay;
int gameOverTextX;
int gameOverTextY;
Move p1Move;
Move p2Move;

void setup() {
  size(800,900);
  gameOver = false;
  setupTime = true;
  delay = 0;
  gameOverTextX = 200;
  gameOverTextY = 860;
  ref = new MovAlgo();
  makePlayers(true, true);
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
  if(gameOver) noLoop();
  else if(!setupTime) {
    makePlay();
    updateGameState();
    ref.draw();
  }
}

void makePlay() {
  if(ref.catalog.size()%2 == 0) {
    if(p1.ai) {
      delay(300);
      makeAIPlay();
    } else {
      
    }
  } else {
    if(p2.ai) {
      delay(300);
      makeAIPlay();
    } else {
      
    }
  }
}

void updateGameState() {
  updateAIBoard();
  updateHumanBoard();
}

void updateHumanBoard() {
  
}

void updateAIBoard() {
  if(p1.ai && p1Move != null) {
    p1.updateMove(p1Move);
    p1Move = null;
  } else if(p2.ai && p2Move != null) {
    p2.updateMove(p2Move);
    p2Move = null;
  }
}

void makeHumanPlay() {
  if(!gameOver && ((ref.catalog.size()%2 == 0 && !p1.ai) || (ref.catalog.size()%2 == 1 && !p2.ai))) {
    if(ref.isStaleMate()){
      staleMate();
    } else if(ref.catalog.size()%2 == 0 && ref.isMate()) {
      blackWins(true);
    } else if(ref.catalog.size()%2 == 1 && ref.isMate()) {
      blackWins(false);
    } else {
      updateGameState();
    }
  }
}

void makeAIPlay() {
  if(!gameOver && p1.ai && ref.catalog.size()%2 == 0) {
    if(ref.isStaleMate()) staleMate();
    else if(ref.isMate()) blackWins(true);
    else {
      Move move = p1.getMove();
      ref.playMove(move);
      p1Move = move;
      println(ref.catalog.size() + " p1 " + move);
    }
  } 
  else if(!gameOver && p2.ai && ref.catalog.size()%2 == 1) {
    if(ref.isStaleMate()) staleMate();
    else if(ref.isMate()) blackWins(false);
    else {
      Move move = p2.getMove();
      ref.playMove(move);
      p2Move = move;
      println(ref.catalog.size() + " p2 " + move);
    }
  }
}

void blackWins(boolean black) {
  println("Exiting at " + millis()/1000.0 + " seconds");
  textSize(32);
  fill(40, 125, 20);
  text("Game over, " + ((black)? "black": "white") + " wins", gameOverTextX, gameOverTextY);
  ref.draw();
  gameOver = true;
}

void staleMate() {
  println("Exiting at " + millis()/1000.0 + " seconds");
  textSize(32);
  fill(40, 125, 20);
  text("Game over, stalemate", gameOverTextX, gameOverTextY);
  ref.draw();
  gameOver = true;
}

//for a player vs player game

void mousePressed() {
  //check if !gameOver and is proper turn then
  //update human to hold piece in hand
  //human.putPieceClickedInHand(
}

void mouseDragged() {
  //check if !gameOver and is proper turn then
  //update the position of the piece in human's hand
  //human.movePieceInHandToMouse
}

void mouseReleased() {
  //human.placePieceInHand
  makeHumanPlay();
}

//some extra stuff like puasing the game or reverting a turn

void keyPressed() {
  println(keyCode);
  
  switch(keyCode) {
    case 32: setupTime = !setupTime; break;
    case 82: goBackATurn(); break;
  }
  
}

void goBackATurn() {
  ref.revertTurn(); 
  if(p1.ai && p1.refSim != null) p1.refSim.revertTurn();
  if(p2.ai && p2.refSim != null) p2.refSim.revertTurn();
}

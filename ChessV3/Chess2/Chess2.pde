Player p1;
Player p2;
MovAlgo ref;
boolean gameOver;

void setup() {
  size(800,900);
  ref = new MovAlgo();
  p1 = new AI(ref);
  p2 = new AI(ref);
  //p1 = new Player();
  //p2 = new Player();
  gameOver = false;
  ref.draw();
}

int delay = 0;
int regDelay = delay;
int pauseTime = 100000;
int gameOverTextX = 200;
int gameOverTextY = 860;

void draw() {
  if(!gameOver ) {
    if(p1.ai && ref.turn%2 == 0) {
      while(!gameOver && ref.turn%2 == 0) {
        ref.draw();
        if(ref.isCheck(false) && ref.isMate(false)) blackWins(true);
        else ref.playMove(p1.getMove());
      }
    } 
    else if(p2.ai && ref.turn%2 == 1) {
      while(!gameOver && ref.turn%2 == 1) {
        ref.draw();
        if(ref.isCheck(true) && ref.isMate(true)) blackWins(false);
        else ref.playMove(p2.getMove());
      }
    }
    if(ref.turn > 15) blackWins(false);
    ref.draw();
    delay(delay);
  }
}

//for a player vs player game

void mousePressed() {
  if(!gameOver && (ref.turn%2 == 0 && !p1.ai) || (ref.turn%2 == 1 && !p2.ai)) {
    ref.setOPos();
  }
}

void mouseDragged() {
  if(!gameOver && (ref.turn%2 == 0 && !p1.ai) || (ref.turn%2 == 1 && !p2.ai)) {
    ref.setHand();
  }
}

void mouseReleased() {
  if(!gameOver && ((ref.turn%2 == 0 && !p1.ai) || (ref.turn%2 == 1 && !p2.ai))) {
    ref.release(); //<>//
    if(ref.turn%2 == 0 && ref.isCheck(false) && ref.isMate(false)) {
      blackWins(true);
    } else if(ref.turn%2 == 1 && ref.isCheck(true) && ref.isMate(true)) {
      blackWins(false);
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

void mouseClicked() {
  if(mouseButton == RIGHT) ref.revertTurn();
}

void keyPressed() {
  if(keyCode == 75) delay = pauseTime;
  if(keyCode == 80) delay = regDelay;
}

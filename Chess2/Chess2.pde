Player p1;
Player p2;
MovAlgo ref;
boolean gameOver;
boolean playMade = false;
boolean makeTurn = false;
boolean gameStart = true;

void setup() {
  size(800,900);
  ref = new MovAlgo();
  //p1 = new AI(ref);
  p2 = new AI(ref);
  p1 = new Player();
  //p2 = new Player();
  gameOver = false;
}

void draw() {
  ref.draw();
  if((ref.turn%2 == 0 && p1.ai)) {
    ref.playMove(p1.getMove());
  }
  if((ref.turn%2 == 1 && p2.ai)) {
    ref.playMove(p2.getMove());
  }
}

//for a player vs player game

void mousePressed() {
  if(!gameOver) {
    if((ref.turn%2 == 0 && !p1.ai) || (ref.turn%2 == 1 && !p2.ai))
      ref.setOPos();
  }
}

void mouseDragged() {
  if(!gameOver) {
    if((ref.turn%2 == 0 && !p1.ai) || (ref.turn%2 == 1 && !p2.ai))
      ref.setHand();
  }
}

void mouseReleased() {
  if(!gameOver) {
    if((ref.turn%2 == 0 && !p1.ai) || (ref.turn%2 == 1 && !p2.ai)) {
      ref.release();
      playMade = true;
    }
  }
}

void mouseClicked() {
  if(mouseButton == LEFT)
    makeTurn = !makeTurn;
  if(mouseButton == RIGHT)
    ref.revertTurn();
}

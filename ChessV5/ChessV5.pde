Game game;

void setup() {
  size(1600,800);
  game = new Game();
}

void draw() {
  background(151);
  game.playGame();
}

void keyPressed() {
  //println(keyCode);
  if(keyCode == 80) {
    game.switchPlayerScreen();
  }
  if(keyCode == 32) {
    game.changePauseState();
  }
  if(keyCode == 82) {
    game.goBackATurn();
  }
}

void mousePressed() {
  game.updateHumanHand();
}

void mouseDragged() {
  game.updateHumanMove();
}

void mouseReleased() {
  game.dropHumanHand();
}

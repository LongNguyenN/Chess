class Player {
  
  boolean ai;
  
  Player() {
    ai = false;
  }
  
  Player(boolean n_ai) {
    ai = n_ai;
  }
  
  Move getMove() {
    return new Move(0,0,0,0);
  }
  
}

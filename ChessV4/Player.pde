class Player {
  
  boolean ai;
  MovAlgo refSim;
  
  Player() {
    ai = false;
  }
  
  Player(boolean n_ai) {
    ai = n_ai;
  }
  
  void updateMove(Move m) {
    
  }
  
  Move getMove() {
    return new Move(0,0,0,0);
  }
  
}

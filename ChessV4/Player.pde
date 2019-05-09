class Player {
  
  boolean ai;
  MovAlgo refSim;
  Move desiredMove;
  
  Player() {
    refSim = new MovAlgo();
    ai = false;
  }
  
  Player(boolean n_ai) {
    ai = n_ai;
  }
  
  void updateMove(Move m) {
    refSim.playMove(m);
  }
  
  void updateBoardState() {
    
  }
  
  Move getMove() { 
    return desiredMove; 
  }
  
  void putClickedInHand() { }
  
  void moveInHandToMouse() {}
  
  void placeInHandOnBoard() {}
  
}

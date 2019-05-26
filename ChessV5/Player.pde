class Player {
  
  protected boolean ai;
  protected MovAlgo refSim;
  protected Move desiredMove;
  
  Player(boolean n_ai) {
    refSim = new MovAlgo();
    ai = n_ai;
  }
  
  void updateMove(Move m) {
    refSim.playMove(m);
  }
  
  Move getMove() { 
    return desiredMove; 
  }
  
}

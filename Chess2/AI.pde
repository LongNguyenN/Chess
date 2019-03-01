class AI extends Player{
  
  MovAlgo ref;
  MovAlgo refSim;
  
  AI(MovAlgo n_ref) {
    ai = true;
    ref = n_ref;
    refSim = new MovAlgo();
  }
  
  Move getMove() {
    return playMove();
  }
  
  Move minMax() {
    
    return null;
  }
  
  Move playMove() {
    Move[] movesList = refSim.getAllMoves();
    /*
    for(int i = 0; i < movesList.length; i++) {
      refSim.playMove(movesList[i]);
      refSim.revertTurn();
    }
    */
    Move m = movesList[(int)random(movesList.length)];
    refSim.playMove(m);
    return m;
  }
  
}

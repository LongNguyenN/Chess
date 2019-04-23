class AI extends Player{
  
  int infinity = 10000;
  
  AI() {
    ai = true;
    refSim = new MovAlgo();
  }
  
  Move getMove() {
    if(refSim.catalog.size()%2 == 0) return randomMove();
    else if(refSim.catalog.size()%2 == 1) return randomMove();
    return null;
  }
  
  void updateMove(Move m) {
    refSim.playMove(m);
  }
  
  Move randomMove() {
    Move[] movesList = refSim.getAllMoves();
    return movesList[(int)random(movesList.length)];
  }
  
  Move miniMax(int depth, boolean maximizingPlayer) {
    Move[] movesList = refSim.getAllMoves();
    int bestMoveIndex = 0;
    if(maximizingPlayer) {
      int currentValue = -infinity;
      int bestValue = currentValue;
      for(int i = 0; i < movesList.length; i++) {
        refSim.playMove(movesList[i]);
        currentValue = alphabeta(depth-1, -infinity, infinity, false);
        refSim.revertTurn();
        if(bestValue <= currentValue) {
          bestValue = currentValue;
          bestMoveIndex = i;
        }
      }
      return movesList[bestMoveIndex];
    } else {
      int currentValue = infinity;
      int bestValue = currentValue;
      for(int i = 0; i < movesList.length; i++) {
        refSim.playMove(movesList[i]);
        currentValue = alphabeta(depth-1, -infinity, infinity, true);
        refSim.revertTurn();
        if(bestValue >= currentValue) {
          bestValue = currentValue;
          bestMoveIndex = i;
        }
      }
      return movesList[bestMoveIndex];
    }
  }
  
  int alphabeta(int depth, int alpha, int beta, boolean maximizingPlayer) {
    if(depth == 0 || gameFinished()) {
      return getPointsFor(true) - getPointsFor(false);
    }
    Move[] movesList = refSim.getAllMoves();
    if(maximizingPlayer) {
      int value = -infinity;
      for(int i = 0; i < movesList.length; i++) {
        refSim.playMove(movesList[i]);
        value = Math.max(value, alphabeta(depth-1, alpha, beta, false));
        alpha = Math.max(alpha, value);
        refSim.revertTurn();
        if(alpha >= beta) break;
      } return value;
    } else {
      int value = infinity;
      for(int i = 0; i < movesList.length; i++) {
        refSim.playMove(movesList[i]);
        value = Math.min(value, alphabeta(depth-1, alpha, beta, true));
        beta = Math.min(beta, value);
        refSim.revertTurn();
        if(alpha >= beta) break;
      } return value;
    }
  }
  
  boolean gameFinished() {
    if(refSim.isStaleMate()) return true;
    else if(refSim.isMate()) return true;
    else return false;
  }
  
  //Gets the points of the current board and depends on the turn
  //Odd turns count black points, even turns count white points
  int getPointsFor(boolean black) {
    int points = 0;
    Piece p = null;
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) {
        p = refSim.current.b[i][j];
        if(p != null && black == p.black)
          points += pieceWorth(p.type);
      }
    return points;
  }
  
  int pieceWorth(Type type) {
    switch(type) {
      case ROOK: return 5;
      case KNIGHT: return 3;
      case BISHOP: return 3;
      case QUEEN: return 9;
      case KING: return infinity;
      case PAWN: return 1;
      default: return 0;
    }
  }
  
}

class AI extends Player{
  
  int infinity = 10000;
  
  AI() {
    ai = true;
  }
  
  Move getMove() {
    if(refSim.catalog.size()%2 == 0) {
      //desiredMove = randomMove();
      desiredMove = miniMax(1, false);
    } else {
      desiredMove = randomMove();
      //desiredMove = miniMax(1, true);
    }
    return desiredMove;
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
        currentValue = alphabeta(movesList[i], depth, -infinity, infinity, true);
        if(bestValue <= currentValue) {
          bestValue = currentValue;
          bestMoveIndex = i;
        }
      }
      println(movesList[bestMoveIndex] + " " + bestValue);
      return movesList[bestMoveIndex];
    } else {
      int currentValue = infinity;
      int bestValue = currentValue;
      for(int i = 0; i < movesList.length; i++) {
        currentValue = alphabeta(movesList[i], depth, -infinity, infinity, false);
        if(bestValue >= currentValue) {
          bestValue = currentValue;
          bestMoveIndex = i;
        }
      }
      println(movesList[bestMoveIndex] + " " + bestValue);
      return movesList[bestMoveIndex];
    }
  }
  
  int alphabeta(Move node, int depth, int alpha, int beta, boolean maximizingPlayer) {
    int turn = refSim.catalog.size();
    refSim.playMove(node);
    if(depth == 0 || gameFinished()) {
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return getPointsFor(true) - getPointsFor(false);
    }
    Move[] movesList = ref.getAllMoves();
    if(maximizingPlayer) {
      int value = -infinity;
      for(Move child : movesList) {
        value = Math.max(value, alphabeta(child, depth-1, alpha, beta, false));
        alpha = Math.max(alpha, value);
        if(alpha >= beta) break;
      }
      if(refSim.catalog.size() > turn)
        refSim.revertTurn();
      return value;
    } else {
      int value = infinity;
      for(Move child : movesList) {
        value = Math.min(value, alphabeta(child, depth-1, alpha, beta, true));
        beta = min(beta, value);
        if(alpha >= beta) break;
      }
      if(refSim.catalog.size() > turn)
        refSim.revertTurn();
      return value;
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
        p = refSim.board[i][j];
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

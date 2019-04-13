class AI extends Player{
  
  MovAlgo ref;
  
  int infinity = 10000;
  
  AI(MovAlgo n_ref) {
    ai = true;
    ref = n_ref;
  }
  
  Move getMove() {
    if(ref.turn%2 == 0) return min(false);
    else if(ref.turn%2 == 1) return miniMax(2, true);
    return null;
  }
  
  Move miniMax(int depth, boolean maximizingPlayer) {
    Move[] movesList = ref.getAllMoves() ;
    int bestMoveIndex = 0;
    if(maximizingPlayer) {
      int value = -infinity;
      int currentValue = value;
      for(int i = 0; i < movesList.length; i++) {
        ref.playMove(movesList[i]);
        currentValue = Math.max(value, alphabeta(depth-1,-infinity, infinity, false));
        //currentValue = Math.max(value, miniMaxHelper(depth-1, false));
        if(value < currentValue) {
          value = currentValue;
          bestMoveIndex = i;
        }
        ref.revertTurn();
      }
    } else {
      int value = infinity;
      int currentValue = value;
      for(int i = 0; i < movesList.length; i++) {
        ref.playMove(movesList[i]);
        currentValue = Math.min(value, alphabeta(depth-1, -infinity, infinity, true));
        //currentValue = Math.min(value, miniMaxHelper(depth-1, true));
        if(value > currentValue) {
          value = currentValue;
          bestMoveIndex = i;
        }
        ref.revertTurn();
      }
    }
    return movesList[bestMoveIndex];
  }
  
  int miniMaxHelper(int depth, boolean maximizingPlayer) {
    Move[] movesList = ref.getAllMoves();
    int value = 0;
    if(depth == 0) {
      return getPointsFor(true)-getPointsFor(false);
    }
    if(maximizingPlayer) {
      value = -infinity;
      for(Move m: movesList) {
        ref.playMove(m);
        value = Math.max(value, miniMaxHelper(depth-1, false));
        ref.revertTurn();
      }
      return value;
    } else {
      value = infinity;
      for(Move m: movesList) {
        ref.playMove(m);
        value = Math.min(value, miniMaxHelper(depth-1,true));
        ref.revertTurn();
      }
      return value;
    }
  }
  
  int alphabeta(int depth, int alpha, int beta, boolean maximizingPlayer) {
    int value;
    Move[] movesList = ref.getAllMoves();
    if(depth == 0) {
      return getPointsFor(true)-getPointsFor(false);
    }
    if(maximizingPlayer) {
      value = - infinity;
      for(Move m: movesList) {
        ref.playMove(m);
        value = Math.max(value, alphabeta(depth-1, alpha, beta, false));
        alpha = Math.max(alpha, value);
        ref.revertTurn();
        if(alpha > beta) break;
      }
      return value;
    } else {
      value = infinity;
      for(Move m: movesList) {
        ref.playMove(m);
        value = Math.min(value, alphabeta(depth-1, alpha, beta, true));
        beta = Math.min(beta, value);
        ref.revertTurn();
        if(alpha > beta) break;
      }
      return value;
    }
  }
  
  public Move min(boolean black) {
    Move[] movesList = ref.getAllMoves();
    int turn = ref.turn;
    int minPoints = getPointsFor(!black);
    int currentPoints = minPoints;
    int bestMoveIndex = 0;
    for(int i = 0; i < movesList.length; i++) {
      ref.playMove(movesList[i]);
      currentPoints = getPointsFor(!black);
      if(currentPoints < minPoints) {
        minPoints = currentPoints;
        bestMoveIndex = i;
      }
      else if(currentPoints == minPoints && random(1) > 0.86) {
        bestMoveIndex = i;
      }
      if(ref.turn > turn) ref.revertTurn();
    }
    return movesList[bestMoveIndex];
  }
  
  //Gets the points of the current board and depends on the turn
  //Odd turns count black points, even turns count white points
  int getPointsFor(boolean black) {
    int points = 0;
    Piece p = null;
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) {
        p = ref.current.b[i][j];
        if(p != null && black == p.black)
          points += pieceWorth(p.type);
      }
    if(ref.isCheck(black)) points-=100;
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

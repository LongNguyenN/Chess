class AI extends Player {
  
  private int infinity = 10000;
  
  AI(boolean ai) {
    super(ai);
  }
  
  void findDesiredMove() {
    if(refSim.catalog.size()%2 == 0) {
      desiredMove = miniMax(3, false);
      //desiredMove = randomMove();
    } else {
      desiredMove = miniMax(1, true);
      //desiredMove = randomMove();
    }
  }
  
  Move randomMove() {
    Move[] movesList = refSim.getAllMoves();
    return movesList[(int)(random(movesList.length))];
  }
  
  Move miniMax(int depth, boolean maximizingPlayer) {
    int turn = refSim.catalog.size();
    Move[] movesList = refSim.getAllMoves();
    int bestMoveIndex = 0;
    if(maximizingPlayer) {
      int bestValue = -infinity;
      int currentValue = bestValue;
      for(int i = 0; i < movesList.length; i++) {
        currentValue = alphabeta(movesList[i], depth, -infinity, infinity, false);
        //currentValue = minimaxHelper(movesList[i], depth, false);
        if(refSim.catalog.size() > turn) refSim.revertTurn();
        if(bestValue <= currentValue) {
          bestValue = currentValue;
          bestMoveIndex = i;
        }
      }
      println("black " + bestValue);
      return movesList[bestMoveIndex];
    } else {
      int bestValue = infinity;
      int currentValue = bestValue;
      for(int i = 0; i < movesList.length; i++) {
        currentValue = alphabeta(movesList[i], depth, -infinity, infinity, true);
        //currentValue = minimaxHelper(movesList[i], depth, true);
        if(refSim.catalog.size() > turn) refSim.revertTurn();
        if(bestValue >= currentValue) {
          bestValue = currentValue;
          bestMoveIndex = i;
        }
      }
      println("white " + bestValue);
      return movesList[bestMoveIndex];
    }
  }
  
  int minimaxHelper(Move node, int depth, boolean maximizingPlayer) {
    int turn = refSim.catalog.size();
    refSim.playMove(node);
    if(refSim.isMate()) {
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return (maximizingPlayer)? -2*infinity: 2*infinity;
    } else if(refSim.isStaleMate()) {
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return 0;
    } else if(depth == 0) {
      int points = getPointsFor(true) - getPointsFor(false);
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return points;
    }
    int turnprime = refSim.catalog.size();
    Move[] legalMoves = refSim.getAllMoves();
    if(maximizingPlayer) {
      int value = -infinity;
      for(Move move : legalMoves) { //<>//
        value = max(value, minimaxHelper(move, depth-1, false));
        if(refSim.catalog.size() > turnprime) refSim.revertTurn();
      }
      return value;
    } else {
      int value = infinity;
      for(Move move : legalMoves) { //<>//
        value = min(value, minimaxHelper(move, depth-1, true));
        if(refSim.catalog.size() > turnprime) refSim.revertTurn();
      }
      return value;
    }
  }
  
  int alphabeta(Move node, int depth, int alpha, int beta, boolean maximizingPlayer) {
    int turn = refSim.catalog.size();
    refSim.playMove(node);
    if(refSim.isMate()) {
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return (maximizingPlayer)? -2*infinity: 2*infinity;
    } else if(refSim.isStaleMate()) {
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return 0;
    } else if(depth == 0) {
      int points = getPointsFor(true) - getPointsFor(false);
      if(refSim.catalog.size() > turn) refSim.revertTurn();
      return points;
    }
    int turnprime = refSim.catalog.size();
    Move[] legalMoves = refSim.getAllMoves();
    if(maximizingPlayer) {
      int value = -infinity;
      for(Move move : legalMoves) {
        value = max(value, alphabeta(move, depth-1, alpha, beta, false));
        alpha = max(alpha, value);
        if(refSim.catalog.size() > turnprime) refSim.revertTurn();
        if(alpha >= beta) break;
      }
      return value;
    } else {
      int value = infinity;
      for(Move move : legalMoves) {
        value = min(value, alphabeta(move, depth-1, alpha, beta, true));
        beta = min(beta, value);
        if(refSim.catalog.size() > turnprime) refSim.revertTurn();
        if(alpha >= beta) break;
      }
      return value;
    }
  }
  
  int getPointsFor(boolean black) {
    int value = 0;
    if(black) {
      for(Piece blackPiece : refSim.current.blackPieces) {
        if(refSim.board[blackPiece.x/100][blackPiece.y/100] != null && refSim.board[blackPiece.x/100][blackPiece.y/100] == blackPiece)
          value += getPieceValue(blackPiece);
      }
    } else {
      for(Piece whitePiece : refSim.current.whitePieces) {
        if(refSim.board[whitePiece.x/100][whitePiece.y/100] != null && refSim.board[whitePiece.x/100][whitePiece.y/100] == whitePiece)
          value += getPieceValue(whitePiece);
      }
    }
    return value;
  }
  
  int getPieceValue(Piece piece) {
    switch(piece.type) {
      case ROOK: return 5;
      case KNIGHT: return 3;
      case BISHOP: return 3;
      case QUEEN: return 9;
      case KING: return 100;
      case PAWN: return 1;
      default: return 0;
    }
  }
  
}

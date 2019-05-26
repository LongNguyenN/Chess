import java.util.Stack;

class MovAlgo {
  
  private Stack<Move> catalog;
  private Board current;
  private Piece[][] board;
  
  MovAlgo() {
    catalog = new Stack<Move>();
    current = new Board();
    board = current.board;
  }
  
  boolean isAttacked(int x, int y, boolean black) {
    if(black) {
      for(Piece whitePiece : current.whitePieces) {
        if(board[whitePiece.x/100][whitePiece.y/100] == whitePiece) {
          Move[] attackList = whitePiece.getMoves(new Move(whitePiece.x/100, whitePiece.y/100, 0, 0));
          if(attackList != null) {
            for(Move m : attackList) {
              if(m.nx == x && m.ny == y) return true;
            }
          }
        }
      }
    } else {
      for(Piece blackPiece : current.blackPieces) {
        if(board[blackPiece.x/100][blackPiece.y/100] == blackPiece) {
          Move[] attackList = blackPiece.getMoves(new Move(blackPiece.x/100, blackPiece.y/100, 0, 0));
          if(attackList != null) {
            for(Move m : attackList) {
              if(m.nx == x && m.ny == y) return true;
            }
          }
        }
      }
    }
    return false;
  }
  
  boolean isCheck(boolean black) {
    if(black) return isAttacked(current.blackPieces[4].x/100, current.blackPieces[4].y/100, true);
    else return isAttacked(current.whitePieces[4].x/100, current.whitePieces[4].y/100, false);
  }
  
  boolean causeCheck(Move m) {
    Piece save = board[m.nx][m.ny];
    current.move(m.ox,m.oy,m.nx,m.ny);
    if(board[m.nx][m.ny].black) {
      if(isCheck(true)) {
        current.move(m.nx,m.ny,m.ox,m.oy);
        board[m.nx][m.ny] = save;
        return true;
      } else {
        current.move(m.nx,m.ny,m.ox,m.oy);
        board[m.nx][m.ny] = save;
        return false;
      }
    } else {
      if(isCheck(false)) {
        current.move(m.nx,m.ny,m.ox,m.oy);
        board[m.nx][m.ny] = save;
        return true;
      } else {
        current.move(m.nx,m.ny,m.ox,m.oy);
        board[m.nx][m.ny] = save;
        return false;
      }
    }
  }
  
  boolean isMate() {
    if(catalog.size()%2 == 0) {
      return isCheck(false) && getAllMoves() == null;
    } else {
      return isCheck(true) && getAllMoves() == null;
    }
  }
  
  boolean isStaleMate() {
    if(catalog.size()%2 == 0) {
      return !isCheck(false) && getAllMoves() == null;
    } else {
      return !isCheck(true) && getAllMoves() == null;
    }
  }
  
  void revertTurn() {
    if(catalog.size() > 0) {
      Move save = catalog.pop();
      if(save.p2 != null && save.special != null) {
        if(board[save.nx][save.ny].type == Type.QUEEN) {
          if(board[save.nx][save.ny].black) {
            for(int i = 8; i < 16; i++) {
              if(current.blackPieces[i].x/100 == save.nx && current.blackPieces[i].y/100 == save.ny) {
                current.blackPieces[i] = save.p2;
                break;
              }
            }
          } else {
            for(int i = 8; i < 16; i++) {
              if(current.whitePieces[i].x/100 == save.nx && current.whitePieces[i].y/100 == save.ny) {
                current.whitePieces[i] = save.p2;
                break;
              }
            }
          }
        }
        board[save.special.ox][save.special.oy] = save.p2;
        save.p2.x = save.special.ox*100;
        save.p2.y = save.special.oy*100;
        board[save.special.nx][save.special.ny] = save.special.p1;
      }
      current.move(save.nx, save.ny, save.ox, save.oy);
      board[save.nx][save.ny] = save.p1;
    }
  }
  
  void playMove(Move m) {
    if(isLegalMove(m)) {
      if(m.p2 == null) {
        m.p1 = board[m.nx][m.ny];
        catalog.push(m);
        current.move(m.ox, m.oy, m.nx, m.ny);
      } else {
        playSpecialMove(m);
      }
    }
  }
  
  Move[] getAllMoves() {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(catalog.size()%2 == 0) {
      for(int i = 0; i < 16; i++) {
        Piece p = current.whitePieces[i];
        if(board[floor(p.x/100)][floor(p.y/100)] == p) {
          Move[] tempList = p.getMoves(new Move(floor(p.x/100),floor(p.y/100),0,0));
          if(tempList != null) {
            for(Move m : tempList) {
              if(isLegalMove(m)) movesList.add(m);
            }
          }
        }
      }
    } else {
      for(int i = 0; i < 16; i++) {
        Piece p = current.blackPieces[i];
        if(board[floor(p.x/100)][floor(p.y/100)] == p) {
          Move[] tempList = p.getMoves(new Move(floor(p.x/100),floor(p.y/100),0,0));
          if(tempList != null) {
            for(Move m : tempList) {
              if(isLegalMove(m)) movesList.add(m);
            }
          }
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  boolean isLegalMove(Move m) {
    if(board[m.ox][m.oy] == null) return false;
    if(causeCheck(m)) return false;
    if(catalog.size()%2 == 0 && board[m.ox][m.oy].black) return false;
    if(catalog.size()%2 == 1 && !board[m.ox][m.oy].black) return false;
    if(m.p2 == null) {
      Move[] legalMoves = board[m.ox][m.oy].getMoves(m);
      if(legalMoves == null) return false;
      for(Move move : legalMoves) {
        if(m.equals(move)) {
          return true;
        }
      }
      return false;
    } else {
      if(isLegalCastle(m)) {
        return true;
      } else if(isLegalEnPassent(m)) {
        return true;
      } else if(isLegalPawnPromo(m)) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  boolean isLegalCastle(Move m) {
    if(board[m.ox][m.oy] != null && board[m.ox][m.oy].type == Type.KING) {
      if(m.ox == 4) {
        if(m.oy == 0) {
          if(m.nx == 2) {
            if(board[3][0] == null && board[2][0] == null && board[1][0] == null
            && !isAttacked(3, 0, true) && !isAttacked(2, 0, true) && isFirstMoveFor(0,0) && isFirstMoveFor(4,0))
              return true;
          } else if(m.nx == 6){
            if(board[5][0] == null && board[6][0] == null
            && !isAttacked(5, 0, true) && !isAttacked(6, 0, true) && isFirstMoveFor(7,0) && isFirstMoveFor(4,0))
              return true;
          }
        } else if(m.oy == 7) {
          if(m.nx == 2) {
            if(board[3][7] == null && board[2][7] == null && board[3][7] == null
            && !isAttacked(3, 7, false) && !isAttacked(2, 7, false) && isFirstMoveFor(0,7) && isFirstMoveFor(4,7))
              return true;
          } else if(m.nx == 6) {
            if(board[5][7] == null && board[6][7] == null
            && !isAttacked(5, 7, false) && !isAttacked(6, 7, false) && isFirstMoveFor(7,7) && isFirstMoveFor(4,7))
              return true;
          }
        }
      }
    }
    return false;
  }
  
  void executeCastle(Move m) {
    if(m.oy == 0) {
      if(m.nx == 2) {
        m.p2 = board[0][0];
        current.move(0, 0, 3, 0);
        current.move(4, 0, 2, 0);
        m.special = new Move(0, 0, 3, 0);
        catalog.push(m);
      } else if(m.nx == 6) {
        m.p2 = board[7][0];
        current.move(7, 0, 5, 0);
        current.move(4, 0, 6, 0);
        m.special = new Move(7, 0, 5, 0);
        catalog.push(m);
      }
    } else if(m.oy == 7) {
      if(m.nx == 2) {
        m.p2 = board[0][7];
        current.move(0, 7, 3, 7);
        current.move(4, 7, 2, 7);
        m.special = new Move(0, 7, 3, 7);
        catalog.push(m);
      } else if(m.nx == 6) {
        m.p2 = board[7][7];
        current.move(7, 7, 5, 7);
        current.move(4, 7, 6, 7);
        m.special = new Move(7, 7, 5, 7);
        catalog.push(m);
      }
    }
  }
  
  boolean isLegalEnPassent(Move m) {
    if(board[m.ox][m.oy] != null && board[m.ox][m.oy].type == Type.PAWN && m.nx != m.ox && board[m.nx][m.ny] == null && board[m.nx][m.oy] != null && board[m.nx][m.oy].type == Type.PAWN) {
      Move recent = catalog.peek();
      if(recent.nx == m.nx && recent.ny == m.oy && Math.abs(recent.ny-recent.oy) == 2) {
        return true;
      }
    }
    return false;
  }
  
  void executeEnPassent(Move m) {
    m.p2 = board[m.nx][m.oy];
    board[m.nx][m.oy] = null;
    current.move(m.ox, m.oy, m.nx, m.ny);
    m.special = new Move(m.p2.x/100, m.p2.y/100, m.p2.x/100, m.p2.y/100);
    m.special.p1 = m.p2;
    catalog.push(m);
  }
  
  boolean isLegalPawnPromo(Move m) {
    if(board[m.ox][m.oy] != null && board[m.ox][m.oy].type == Type.PAWN) {
      if(board[m.ox][m.oy].black) {
        return m.ny == 7;
      } else {
        return m.ny == 0;
      }
    } else {
      return false;
    }
  }
  
  void executePawnPromo(Move m) {
    m.p1 = board[m.nx][m.ny]; 
    m.p2 = board[m.ox][m.oy];
    current.move(m.ox, m.oy, m.nx, m.ny);
    board[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, m.p2.black, Type.QUEEN, board);
    m.special = new Move(m.nx, m.ny, m.nx, m.ny);
    m.special.p1 = m.p2;
    if(m.p2.black) {
      for(int i = 8; i < 16; i++) {
        if(current.blackPieces[i].x/100 == m.p2.x/100 && current.blackPieces[i].y/100 == m.p2.y/100) {
          current.blackPieces[i] = board[m.nx][m.ny];
          break;
        }
      }
    } else {
      for(int i = 8; i < 16; i++) {
        if(current.whitePieces[i].x/100 == m.p2.x/100 && current.whitePieces[i].y/100 == m.p2.y/100) {
          current.whitePieces[i] = board[m.nx][m.ny];
          break;
        }
      }
    }
    catalog.push(m);
  }
  
  void playSpecialMove(Move m) {
    if(isLegalCastle(m))
      executeCastle(m);
    else if(isLegalEnPassent(m))
      executeEnPassent(m); 
    else if(isLegalPawnPromo(m))
      executePawnPromo(m);
  }
  
  boolean isFirstMoveFor(int x, int y) {
    boolean firstMove = true;
    Stack<Move> savedCatalog = new Stack();
    savedCatalog.push(catalog.pop());
    while(catalog.size() > 0) {
      savedCatalog.push(catalog.pop());
      if(savedCatalog.peek().ox == x && savedCatalog.peek().oy == y) {
        firstMove = false;
        break;
      }
    }
    while(savedCatalog.size() > 0) {
      catalog.push(savedCatalog.pop());
    }
    return firstMove;
  }
  
  void draw() {
    current.draw();
  }
  
}

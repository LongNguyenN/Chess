import java.util.Stack;

class MovAlgo {
  
  Stack<Move> catalog;
  Board current;
  Piece[][] board;
  
  MovAlgo() {
    catalog = new Stack<Move>();
    current = new Board();
    board = current.board;
  }
  
  void revertTurn() {
    if(catalog.size() > 0) {
      Move deletedMove = catalog.pop();
      current.move(deletedMove.nx, deletedMove.ny, deletedMove.ox, deletedMove.oy);
      if(deletedMove.p1 != null) board[deletedMove.p1.x/100][deletedMove.p1.y/100] = deletedMove.p1;
      if(deletedMove.p2 != null) {
        if(deletedMove.nx == 6) {
          if(deletedMove.ny == 0) {
            current.move(5,0,7,0);
            board[deletedMove.p2.x/100][deletedMove.p2.y/100] = deletedMove.p2;
          } else if(deletedMove.ny == 7) {
            current.move(5,7,7,7);
            board[deletedMove.p2.x/100][deletedMove.p2.y/100] = deletedMove.p2;
          }
        } else if(deletedMove.nx == 2) {
          if(deletedMove.ny == 0) {
            current.move(3,0,0,0);
            board[deletedMove.p2.x/100][deletedMove.p2.y/100] = deletedMove.p2;
          } else if(deletedMove.ny == 7) {
            current.move(3,7,0,7);
            board[deletedMove.p2.x/100][deletedMove.p2.y/100] = deletedMove.p2;
          }
        } else {
          board[deletedMove.ox][deletedMove.oy] = deletedMove.p2;
        }
      }
    }
  }
  
  boolean isValidMove(Move m) {
    if(board[m.ox][m.oy] != null) {
      if((!board[m.ox][m.oy].black && catalog.size()%2 == 1) || (board[m.ox][m.oy].black && catalog.size()%2 == 0))
        return false;
      Move[] moves = board[m.ox][m.oy].getMoves(m);
      for(int i = 0; moves != null && i < moves.length; i++) {
        if(m.equals(moves[i])) {
          return !causeCheck(m);
        }
      }
    }
    return false;
  }
  
  
  boolean isAttacked(int x, int y, boolean black) {
    Piece savedPiece = board[x][y];
    board[x][y] = new Pawn(x*100,y*100,black,Type.PAWN, board);
    Move[] movesList = (black)? current.blackPieces[0].getMoves(new Move(x,y,0,0)) : current.whitePieces[0].getMoves(new Move(x,y,0,0));
    board[x][y] = savedPiece;
    if(movesList != null) {
      for(Move m : movesList) {
        if(board[m.nx][m.ny] != null && board[m.nx][m.ny].black != black) {
          switch(board[m.nx][m.ny].type) {
            case ROOK: 
              return true;
            case QUEEN:
              return true;
            case KING: 
              if(isAttackHelper(x,y,m.nx,m.ny)) {
                return true;
              }
            default:
          }
        }
      }
    }
    board[x][y] = new Pawn(x*100,y*100,black,Type.PAWN, board);
    movesList = (black)? current.blackPieces[2].getMoves(new Move(x,y,0,0)) : current.whitePieces[2].getMoves(new Move(x,y,0,0));
    board[x][y] = savedPiece;
    if(movesList != null) {
      for(Move m : movesList) {
        if(board[m.nx][m.ny] != null && board[m.nx][m.ny].black != black) {
          switch(board[m.nx][m.ny].type) {
            case BISHOP: 
              return true;
            case QUEEN: 
              return true;
            case KING:
              if(isAttackHelper(x,y,m.nx,m.ny)) {
                return true;
              }
            case PAWN: 
              if(isAttackHelper(x,y,m.nx,m.ny)) {
                return true;
              }
            default:
          }
        }
      }
    }
    board[x][y] = new Pawn(x*100,y*100,black,Type.PAWN, board);
    movesList = (black)? current.blackPieces[1].getMoves(new Move(x,y,0,0)) : current.whitePieces[1].getMoves(new Move(x,y,0,0));
    board[x][y] = savedPiece;
    if(movesList != null) {
      for(Move m : movesList) {
        if(board[m.nx][m.ny] != null && board[m.nx][m.ny].black != black && board[m.nx][m.ny].type == Type.KNIGHT) {
          return true;
        }
      }
    }
    return false;
  }
  
  boolean isAttackHelper(int attackedX, int attackedY, int attackerX, int attackerY) {
    Move[] movesList = board[attackerX][attackerY].getMoves(new Move(attackerX,attackerY,0,0));
    if(movesList != null) {
      for(Move move : movesList) {
        if(move.nx == attackedX && move.ny == attackedY) return true;
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
  
  boolean playMove(Move m) {
    if(m != null) {
      if(isValidMove(m)) {
        if(board[m.nx][m.ny] != null) 
          m.p1 = board[m.nx][m.ny];
        catalog.push(m);
        current.move(m.ox, m.oy, m.nx, m.ny);
        boolean moved = specialMoves(m);
        if(!moved) revertTurn();
        return moved;
      } 
      if(!specialMoves(m)) revertTurn();
    }
    return false;
  }
  
  Move[] getAllMoves() {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(catalog.size()%2 == 0) {
      for(int i = 0; i < 16; i++) {
        Piece p = current.whitePieces[i];
        if(board[floor(p.x/100)][floor(p.y/100)] != null && !board[floor(p.x/100)][floor(p.y/100)].black) {
          Move[] tempList = p.getMoves(new Move(floor(p.x/100),floor(p.y/100),0,0));
          if(tempList != null) {
            for(Move m : tempList) {
              if(!causeCheck(m) && !badSpecialMove(m)) movesList.add(m);
            }
          }
        }
      }
    } else {
      for(int i = 0; i < 16; i++) {
        Piece p = current.blackPieces[i];
        if(board[floor(p.x/100)][floor(p.y/100)] != null && board[floor(p.x/100)][floor(p.y/100)].black) {
          Move[] tempList = p.getMoves(new Move(floor(p.x/100),floor(p.y/100),0,0));
          if(tempList != null) {
            for(Move m : tempList) {
              if(!causeCheck(m) && !badSpecialMove(m)) movesList.add(m);
            }
          }
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  boolean specialMoves(Move m) {
    boolean takeBackTurn = false;
    if(board[m.nx][m.ny] != null && board[m.nx][m.ny].type == Type.PAWN) {
      //PawnPromo
      if(m.ny == 7) {
        m.p2 = board[m.nx][m.ny];
        board[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, true, Type.QUEEN, board);
      } else if(m.ny == 0) {
        m.p2 = board[m.nx][m.ny];
        board[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, false, Type.QUEEN, board);
      }
      //EnPassent
      if((m.oy == 3 && !board[m.nx][m.ny].black) || (m.oy == 4 && board[m.nx][m.ny].black)) {
        if(board[m.nx][m.oy] != null && board[m.nx][m.oy].type == Type.PAWN) {
          Move save = catalog.pop();
          Move past = catalog.peek();
          if(past.nx == m.nx && past.ny == m.oy && board[m.nx][m.oy].black != board[m.nx][m.ny].black) {
            m.p1 = board[m.nx][m.oy];
            board[m.nx][m.oy] = null;
            catalog.push(save);
          } else {
            catalog.push(save);
            takeBackTurn = true;
          }
        } else if(m.ox != m.nx) {
          if(m.p1 == null) takeBackTurn = true;
        }
      }
    }
    //Castling
    if(triedAndFailedToCastle(m)) takeBackTurn = true;
    return !takeBackTurn;
  }
  
  boolean triedAndFailedToCastle(Move m) {
    if(m.ox == 4 && board[m.nx][m.ny] != null && board[m.nx][m.ny].type == Type.KING) {
      if(board[m.nx][m.ny].black) {
        if(m.nx == 6 && m.oy == 0) {
          //This part is super clever :3 (The m.p1 == null means that the king did not take any pieces in attempt to get a check) Wait... King can't take its own pieces anyway :P
          if(board[5][0] == null && m.p1 == null && !isAttacked(4,0,true) && !isAttacked(5,0,true) && firstMoveFor(m.ox,m.oy) && firstMoveFor(7,0)) {
            m.p2 = board[7][0];
            current.move(7,0,5,0);
          } else return true;
        } else if(m.nx == 2 && m.oy == 0) {
          if(board[3][0] == null && m.p1 == null && !isAttacked(4,0,true) && !isAttacked(3,0,true) && firstMoveFor(m.ox,m.oy) && firstMoveFor(0,0)) {
            m.p2 = board[0][0];
            current.move(0,0,3,0);
          } else return true;
        }
      } else {
        if(m.nx == 6 && m.oy == 7) {
          if(board[5][7] == null && m.p1 == null && !isAttacked(4,7,false) && !isAttacked(5,7,false) && firstMoveFor(4,7) && firstMoveFor(7,7)) {
            m.p2 = board[7][7];
            current.move(7,7,5,7);
          } else return true;
        } else if(m.nx == 2 && m.oy == 7) {
          if(board[3][7] == null && m.p1 == null && !isAttacked(4,7,false) && !isAttacked(3,7,false) && firstMoveFor(4,7) && firstMoveFor(0,7)) {
            m.p2 = board[0][7];
            current.move(0,7,3,7);
          } else return true;
        }
      }
    }
    return false;
  }
  
  boolean enPassentFailed(Move m) {
    if(board[m.ox][m.oy] != null && board[m.ox][m.oy].type == Type.PAWN && board[m.nx][m.ny] == null && m.nx != m.ox) {
      if(board[m.nx][m.oy] == null) {
        return true;
      } else {
        if(board[m.nx][m.oy].type != Type.PAWN) {
          return true;
        } else {
          Move previous = catalog.peek();
          if(previous.nx == m.nx && previous.ny == m.oy) {
            return false;
          } else {
            return true;
          }
        }
      }
    } else {
      return false;
    }
  }
  
  boolean badCastle(Move m) {
    if(board[m.ox][m.oy] != null && board[m.ox][m.oy].type == Type.KING) {
      if(m.ny == 0) {
        if(m.ox == 4 && m.nx == 2) {
          if(board[0][0] != null && board[0][0].type == Type.ROOK && board[1][0] == null && board[2][0] == null && board[3][0] == null
          && !isAttacked(2,0,true) && !isAttacked(3,0,true) && !isAttacked(4,0,true) && firstMoveFor(4,0) && firstMoveFor(0,0)) {
            return false;
          } else {
            return true;
          }
        } else if(m.ox == 4 && m.nx == 6) {
          if(board[7][0] != null && board[7][0].type == Type.ROOK && board[5][0] == null && board[6][0] == null
          && !isAttacked(4,0,true) && !isAttacked(5,0,true) && !isAttacked(6,0,true) && firstMoveFor(4,0) && firstMoveFor(7,0)) {
            return false;
          } else {
            return true;
          }
        } else {
          return false;
        }
      } else if(m.ny == 7) {
        if(m.ox == 4 && m.nx == 2) {
          if(board[0][7] != null && board[0][7].type == Type.ROOK && board[1][7] == null && board[2][7] == null && board[3][7] == null
          && !isAttacked(2,7,false) && !isAttacked(3,7,false) && !isAttacked(4,7,false) && firstMoveFor(4,7) && firstMoveFor(0,7)) {
            return false;
          } else {
            return true;
          }
        } else if(m.ox == 4 && m.nx == 6) {
          if(board[7][7] != null && board[7][7].type == Type.ROOK && board[5][7] == null && board[6][7] == null
          && !isAttacked(4,7,false) && !isAttacked(5,7,false) && !isAttacked(6,7,false) && firstMoveFor(4,7) && firstMoveFor(7,7)) {
            return false;
          } else {
            return true;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  
  boolean badSpecialMove(Move m) {
    return (enPassentFailed(m) || badCastle(m));
  }
  
  boolean firstMoveFor(int x, int y) {
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

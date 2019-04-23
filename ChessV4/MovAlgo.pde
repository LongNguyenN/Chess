import java.util.Stack;

class MovAlgo {
  
  Stack<Move> catalog;
  Board current;
  
  MovAlgo() {
    catalog = new Stack<Move>();
    current = new Board();
  }
  
  void revertTurn() {
    if(catalog.size() > 0) {
      Move deletedMove = catalog.pop();
      current.move(deletedMove.nx, deletedMove.ny, deletedMove.ox, deletedMove.oy);
      if(deletedMove.p1 != null) current.b[deletedMove.p1.x/100][deletedMove.p1.y/100] = deletedMove.p1;
      if(deletedMove.p2 != null) {
        if(deletedMove.nx == 6) {
          if(deletedMove.ny == 0) {
            current.move(5,0,7,0);
          } else if(deletedMove.ny == 7) {
            current.move(5,7,7,7);
          }
        } else if(deletedMove.nx == 2) {
          if(deletedMove.ny == 0) {
            current.move(3,0,0,0);
          } else if(deletedMove.ny == 7) {
            current.move(3,7,0,7);
          }
        }
        current.b[deletedMove.p2.x/100][deletedMove.p2.y/100] = deletedMove.p2;
      }
    }
  }
  
  boolean isValidMove(Move m) {
    if(current.b[m.ox][m.oy] != null) {
      if((!current.b[m.ox][m.oy].black && catalog.size()%2 == 1) || (current.b[m.ox][m.oy].black && catalog.size()%2 == 0))
        return false;
      Move[] moves = getMoves(m);
      for(int i = 0; moves != null && i < moves.length; i++) {
        if(m.equals(moves[i])) {
          return !causeCheck(m);
        }
      }
    }
    return false;
  }
  
  
  boolean isAttacked(int x, int y, boolean black) {
    Piece savedPiece = current.b[x][y];
    current.b[x][y] = new Pawn(x*100,y*100,black,Type.PAWN);
    Move[] movesList = getRookMoves(new Move(x,y,0,0));
    current.b[x][y] = savedPiece;
    if(movesList != null)
    for(Move m : movesList) {
      if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].black != black) {
        switch(current.b[m.nx][m.ny].type) {
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
    current.b[x][y] = new Pawn(x*100,y*100,black,Type.PAWN);
    movesList = getBishopMoves(new Move(x,y,0,0));
    current.b[x][y] = savedPiece;
    if(movesList != null) {
      for(Move m : movesList) {
        if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].black != black) {
          switch(current.b[m.nx][m.ny].type) {
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
    current.b[x][y] = new Pawn(x*100,y*100,black,Type.PAWN);
    movesList = getKnightMoves(new Move(x,y,0,0));
    current.b[x][y] = savedPiece;
    if(movesList != null) {
      for(Move m : movesList) {
        if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].black != black
        && current.b[m.nx][m.ny].type == Type.KNIGHT) {
          return true;
        }
      }
    }
    return false;
  }
  
  boolean isAttackHelper(int attackedX, int attackedY, int attackerX, int attackerY) {
    Move[] movesList = getMoves(new Move(attackerX,attackerY,0,0));
    if(movesList != null) {
      for(Move move : movesList) {
        if(move.nx == attackedX && move.ny == attackedY) return true;
      }
    }
    return false;
  }
  
  boolean isCheck(boolean black) {
    if(black) return isAttacked(current.blackKing.x/100, current.blackKing.y/100, true);
    else return isAttacked(current.whiteKing.x/100, current.whiteKing.y/100, false);
  }
  
  boolean causeCheck(Move m) {
    Piece save = current.b[m.nx][m.ny];
    current.move(m.ox,m.oy,m.nx,m.ny);
    if(current.b[m.nx][m.ny].black) {
      if(isCheck(true)) {
        current.move(m.nx,m.ny,m.ox,m.oy);
        if(save != null) current.b[m.nx][m.ny] = save;
        return true;
      } else {
        current.move(m.nx,m.ny,m.ox,m.oy);
        if(save != null) current.b[m.nx][m.ny] = save;
        return false;
      }
    } else {
      if(isCheck(false)) {
        current.move(m.nx,m.ny,m.ox,m.oy);
        if(save != null) current.b[m.nx][m.ny] = save;
        return true;
      } else {
        current.move(m.nx,m.ny,m.ox,m.oy);
        if(save != null) current.b[m.nx][m.ny] = save;
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
    if(isValidMove(m)) {
      if(current.b[m.nx][m.ny] != null) 
        m.p1 = current.b[m.nx][m.ny];
      catalog.push(m);
      current.move(m.ox, m.oy, m.nx, m.ny);
      boolean moved = specialMoves(m);
      if(!moved) revertTurn();
      return moved;
    } 
    if(!specialMoves(m)) revertTurn();
    return false;
  }
  
  Move[] getMoves(Move m) {
    switch(current.b[m.ox][m.oy].type) {
      case ROOK: return getRookMoves(m);
      case KNIGHT: return getKnightMoves(m);
      case BISHOP: return getBishopMoves(m);
      case QUEEN: return getQueenMoves(m);
      case KING: return getKingMoves(m);
      case PAWN: return getPawnMoves(m);
      default: return null;
    }
  }
  
  Move[] getAllMoves() {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(catalog.size()%2 == 0) {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && !current.b[i][j].black) {
            Move[] tempList = getMoves(new Move(i, j, 0, 0));
            for(int k = 0; tempList != null && k < tempList.length; k++) {
              if(!causeCheck(tempList[k])) movesList.add(tempList[k]);
            }
          }
        }
      }
    } else {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && current.b[i][j].black) {
            Move[] tempList = getMoves(new Move(i, j, 0, 0));
            for(int k = 0; tempList != null && k < tempList.length; k++) {
              if(!causeCheck(tempList[k])) movesList.add(tempList[k]);
            }
          }
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getAllMoves(boolean black) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(!black) {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && !current.b[i][j].black) {
            Move[] tempList = getMoves(new Move(i, j, 0, 0));
            for(int k = 0; tempList != null && k < tempList.length; k++) {
                movesList.add(tempList[k]);
            }
          }
        }
      }
    } else {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && current.b[i][j].black) {
            Move[] tempList = getMoves(new Move(i, j, 0, 0));
            for(int k = 0; tempList != null && k < tempList.length; k++)
              movesList.add(tempList[k]);
          }
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getRookMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    for(int i = 1; m.oy + i < 8; i++) {
      if(current.b[m.ox][m.oy+i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy+i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy+i));
        break;
      } else break;
    }
    for(int i = 1; m.oy - i >= 0; i++) {
      if(current.b[m.ox][m.oy-i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy-i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy-i));
        break;
      } else break;
    }
    for(int i = 1; m.ox + i < 8; i++) {
      if(current.b[m.ox+i][m.oy] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox+i, m.oy));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox+i][m.oy].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox+i, m.oy));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0; i++) {
      if(current.b[m.ox-i][m.oy] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox-i, m.oy));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox-i][m.oy].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox-i, m.oy));
        break;
      } else break;
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getKnightMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(m.ox + 2 < 8 && m.oy - 1 >= 0) {
      if(current.b[m.ox+2][m.oy-1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+2][m.oy-1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy - 1));
    }
    if(m.ox + 2 < 8 && m.oy + 1 < 8) {
      if(current.b[m.ox+2][m.oy+1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+2][m.oy+1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy + 1));
    }
    if(m.ox + 1 < 8 && m.oy + 2 < 8) {
      if(current.b[m.ox+1][m.oy+2] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+1][m.oy+2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 1, m.oy + 2));
    }
    if(m.ox - 1 >= 0 && m.oy + 2 < 8) {
      if(current.b[m.ox-1][m.oy+2] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-1][m.oy+2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 1, m.oy + 2));
    }
    if(m.ox - 2 >= 0 && m.oy + 1 < 8) {
      if(current.b[m.ox-2][m.oy+1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-2][m.oy+1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy + 1));
    }
    if(m.ox - 2 >= 0 && m.oy - 1 >= 0) {
      if(current.b[m.ox-2][m.oy-1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-2][m.oy-1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy - 1));
    }
    if(m.ox - 1 >= 0 && m.oy - 2 >= 0) {
      if(current.b[m.ox-1][m.oy-2] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-1][m.oy-2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 1, m.oy - 2));
    }
    if(m.ox + 1 < 8 && m.oy - 2 >= 0) {
      if(current.b[m.ox+1][m.oy-2] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+1][m.oy-2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 1, m.oy - 2));
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getBishopMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    for(int i = 1; m.ox + i < 8 && m.oy + i < 8; i++) {
      if(current.b[m.ox+i][m.oy+i] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy + i));
      } else if(current.b[m.ox][m.oy].black != current.b[m.ox+i][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy + i));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0 && m.oy - i >= 0; i++) {
      if(current.b[m.ox-i][m.oy-i] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy - i));
      } else if(current.b[m.ox][m.oy].black != current.b[m.ox-i][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy - i));
        break;
      } else break;
    }
    for(int i = 1; m.ox + i < 8 && m.oy - i >= 0; i++) {
      if(current.b[m.ox+i][m.oy-i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy - i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox+i][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy - i));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0 && m.oy + i < 8; i++) {
      if(current.b[m.ox-i][m.oy+i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy + i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox-i][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy + i));
        break;
      } else break;
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getQueenMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    for(int i = 1; m.oy + i < 8; i++) {
      if(current.b[m.ox][m.oy+i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy+i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy+i));
        break;
      } else break;
    }
    for(int i = 1; m.oy - i >= 0; i++) {
      if(current.b[m.ox][m.oy-i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy-i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy-i));
        break;
      } else break;
    }
    for(int i = 1; m.ox + i < 8; i++) {
      if(current.b[m.ox+i][m.oy] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox+i, m.oy));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox+i][m.oy].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox+i, m.oy));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0; i++) {
      if(current.b[m.ox-i][m.oy] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox-i, m.oy));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox-i][m.oy].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox-i, m.oy));
        break;
      } else break;
    }
    for(int i = 1; m.ox + i < 8 && m.oy + i < 8; i++) {
      if(current.b[m.ox+i][m.oy+i] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy + i));
      } else if(current.b[m.ox][m.oy].black != current.b[m.ox+i][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy + i));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0 && m.oy - i >= 0; i++) {
      if(current.b[m.ox-i][m.oy-i] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy - i));
      } else if(current.b[m.ox][m.oy].black != current.b[m.ox-i][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy - i));
        break;
      } else break;
    }
    for(int i = 1; m.ox + i < 8 && m.oy - i >= 0; i++) {
      if(current.b[m.ox+i][m.oy-i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy - i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox+i][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy - i));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0 && m.oy + i < 8; i++) {
      if(current.b[m.ox-i][m.oy+i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy + i));
      else if(current.b[m.ox][m.oy].black != current.b[m.ox-i][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy + i));
        break;
      } else break;
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getKingMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(m.oy - 1 >= 0)
      if(current.b[m.ox][m.oy-1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox][m.oy-1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy-1));
    if(m.ox + 1 < 8 && m.oy - 1 >= 0)
      if(current.b[m.ox+1][m.oy-1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+1][m.oy-1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
    if(m.ox + 1 < 8)
      if(current.b[m.ox+1][m.oy] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+1][m.oy].black))
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy));
    if(m.ox + 1 < 8 && m.oy + 1 < 8)
      if(current.b[m.ox+1][m.oy+1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox+1][m.oy+1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
    if(m.oy + 1 < 8)
      if(current.b[m.ox][m.oy+1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox][m.oy+1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy+1));
    if(m.ox - 1 >= 0 && m.oy + 1 < 8)
      if(current.b[m.ox-1][m.oy+1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-1][m.oy+1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
    if(m.ox - 1 >= 0)
      if(current.b[m.ox-1][m.oy] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-1][m.oy].black))
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy));
    if(m.ox - 1 >= 0 && m.oy - 1 >= 0)
      if(current.b[m.ox-1][m.oy-1] == null || (current.b[m.ox][m.oy].black != current.b[m.ox-1][m.oy-1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
    if(current.b[m.ox][m.oy].black) {
      if(m.ox == 4 && m.oy == 0) {
        if(current.b[3][0] == null && current.b[2][0] == null && current.b[1][0] == null)
          movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy));
        if(current.b[5][0] == null && current.b[6][0] == null)
          movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy));
      }
    } else {
      if(m.ox == 4 && m.oy == 7) {
        if(current.b[3][7] == null && current.b[2][7] == null && current.b[1][7] == null)
          movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy));
        if(current.b[5][7] == null && current.b[6][7] == null)
          movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy));
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getPawnMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(current.b[m.ox][m.oy].black) {
      if(m.oy + 1 < 8 && current.b[m.ox][m.oy+1] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy + 1));
      if(m.ox - 1 >= 0 && m.oy + 1 < 8 && current.b[m.ox-1][m.oy+1] != null && !current.b[m.ox-1][m.oy+1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
      if(m.ox + 1 < 8 && m.oy + 1 < 8 && current.b[m.ox+1][m.oy+1] != null && !current.b[m.ox+1][m.oy+1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
      if(m.oy == 1 && current.b[m.ox][m.oy+1] == null && current.b[m.ox][m.oy+2] == null) 
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy + 2));
      if(m.ox - 1 >= 0 && m.oy == 4)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
      if(m.ox+1 < 8 && m.oy == 4)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
    } else {
      if(m.oy - 1 >= 0 && current.b[m.ox][m.oy-1] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy - 1));
      if(m.ox - 1 >= 0 && m.oy - 1 >= 0 && current.b[m.ox-1][m.oy-1] != null && current.b[m.ox-1][m.oy-1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
      if(m.ox + 1 < 8 && m.oy - 1 >= 0 && current.b[m.ox+1][m.oy-1] != null && current.b[m.ox+1][m.oy-1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
      if(m.oy == 6 && current.b[m.ox][m.oy-1] == null && current.b[m.ox][m.oy-2] == null) 
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy - 2));
      if(m.ox - 1 >= 0 && m.oy == 3)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
      if(m.ox+1 < 8 && m.oy == 3)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  boolean specialMoves(Move m) {
    boolean takeBackTurn = false;
    if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].type == Type.PAWN) {
      //PawnPromo
      if(m.ny == 7) {
        m.p2 = current.b[m.nx][m.ny];
        current.b[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, true, Type.QUEEN);
      } else if(m.ny == 0) {
        m.p2 = current.b[m.nx][m.ny];
        current.b[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, false, Type.QUEEN);
      }
      //EnPassent
      if((m.oy == 3 && !current.b[m.nx][m.ny].black) || (m.oy == 4 && current.b[m.nx][m.ny].black)) {
        if(current.b[m.nx][m.oy] != null && current.b[m.nx][m.oy].type == Type.PAWN) {
          Move save = catalog.pop();
          Move past = catalog.peek();
          if(past.nx == m.nx && past.ny == m.oy && current.b[m.nx][m.oy].black != current.b[m.nx][m.ny].black) {
            m.p1 = current.b[m.nx][m.oy];
            current.b[m.nx][m.oy] = null;
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
    if(m.ox == 4 && current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].type == Type.KING) {
      if(current.b[m.nx][m.ny].black) {
        if(m.nx == 6 && m.oy == 0) {
          //This part is super clever :3 (The m.p1 == null means that the king did not take any pieces in attempt to get a check) Wait... King can't take its own pieces anyway :P
          if(current.b[5][0] == null && m.p1 == null && !isAttacked(4,0,true) && !isAttacked(5,0,true) && firstMoveFor(m.ox,m.oy) && firstMoveFor(7,0)) {
            m.p2 = current.b[7][0];
            current.move(7,0,5,0);
          } else return true;
        } else if(m.nx == 2 && m.oy == 0) {
          if(current.b[3][0] == null && m.p1 == null && !isAttacked(4,0,true) && !isAttacked(3,0,true) && firstMoveFor(m.ox,m.oy) && firstMoveFor(0,0)) {
            m.p2 = current.b[0][0];
            current.move(0,0,3,0);
          } else return true;
        }
      } else {
        if(m.nx == 6 && m.oy == 7) {
          if(current.b[5][7] == null && m.p1 == null && !isAttacked(4,7,false) && !isAttacked(5,7,false) && firstMoveFor(4,7) && firstMoveFor(7,7)) {
            m.p2 = current.b[7][7];
            current.move(7,7,5,7);
          } else return true;
        } else if(m.nx == 2 && m.oy == 7) {
          if(current.b[3][7] == null && m.p1 == null && !isAttacked(4,7,false) && !isAttacked(3,7,false) && firstMoveFor(4,7) && firstMoveFor(0,7)) {
            m.p2 = current.b[0][7];
            current.move(0,7,3,7);
          } else return true;
        }
      }
    }
    return false;
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

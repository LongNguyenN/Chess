class MovAlgo {
  
  ArrayList<Board> catalog;
  
  int ox, oy, turn;
  Board current;
  Piece inHand;
  
  MovAlgo() {
    catalog = new ArrayList<Board>();
    current = new Board();
    catalog.add(current);
    turn = 0;
  }
  
  void revertTurn() {
    if(turn>0) {
      catalog.remove(catalog.size()-1);
      turn--;
      current = catalog.get(turn);
      inHand = null;
    }
  }
  
  boolean isValidMove(Move m) {
    if(current.b[m.ox][m.oy] != null) {
      if((!current.b[m.ox][m.oy].black && turn%2 == 1) || (current.b[m.ox][m.oy].black && turn%2 == 0)) 
        return false;
      if(current.b[m.ox][m.oy].isValid(m)) {
        Move[] moves = getMoves(m);
        for(int i = 0; moves != null && i < moves.length; i++)
          if(m.equals(moves[i])) return true;
      }
    }
    return false;
  } //<>//
  
  boolean isCheck(boolean black) {
    return (black)? isAttacked(current.blackKing.x/100, current.blackKing.y/100, true):
    isAttacked(current.whiteKing.x/100, current.whiteKing.y/100, false);
  }
  
  boolean isAttacked(int x, int y, boolean black) {
    Move[] moves = getAllMoves(!black);
    if(moves != null)
    for(int i = 0;i < moves.length; i++) {
      if(moves[i].nx == x && moves[i].ny == y) {
        //println("attack:" + moves[i]);
        return true;
      }
    } return false;
  }
  
  boolean isMate(boolean black) {
    return true;
  }
  
  void playMove(Move m) {
    if(isValidMove(m)) {
      catalog.add(catalog.get(turn).copy());
      current = catalog.get(turn+1);
      current.move(m.ox, m.oy, m.nx, m.ny);
      turn++;
    }
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
    if(turn%2 == 0) {
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
  
  //gotta revamp this entire caslting thing
  void castling(Move m) {
    if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].type == Type.KING) {
       if(m.nx == 2 && m.ny == 7 && m.ox == 4 && m.oy == 7) {
        for(int i = 0; i < catalog.size()-1; i++) {
          if(catalog.get(i).b[0][7] == null) {
            revertTurn();
            break;
          } else if(i == catalog.size()-2) {
            if(isAttacked(4,7,false) || isAttacked(3,7,false) || isAttacked(2,7,false)) revertTurn();
            //if(isAttacked({m1,m2,m3})) revertTurn();
            else current.move(0,7,3,7);
          }
        }
      }
      else if(m.nx == 6 && m.ny == 7 && m.ox == 4 && m.oy == 7) {
        for(int i = 0; i < catalog.size()-1; i++) {
          if(catalog.get(i).b[7][7] == null) {
            revertTurn();
            break;
          } else if(i == catalog.size()-2) {
            if(isAttacked(4,7,false) || isAttacked(5,7,false) || isAttacked(6,7,false)) revertTurn();
            //if(isAttacked({m1,m2,m3})) revertTurn();
            else current.move(7,7,5,7);
          }
        }
      }
      else if(m.nx == 2 && m.ny == 0 && m.ox == 4 && m.oy == 0) {
        for(int i = 0; i < catalog.size()-1; i++) {
          if(catalog.get(i).b[0][0] == null || catalog.get(i).b[4][0] == null) {
            revertTurn();
            break;
          } else if(i == catalog.size()-2) {
            if(isAttacked(4,0,true) || isAttacked(3,0,true) || isAttacked(2,0,true)) revertTurn();
            //if(isAttacked({m1,m2,m3})) revertTurn();
            else current.move(0,0,3,0);
          }
        }
      }
      else if(m.nx == 6 && m.ny == 0 && m.ox == 4 && m.oy == 0) {
        for(int i = 0; i < catalog.size()-1; i++) {
          if(catalog.get(i).b[7][0] == null || catalog.get(i).b[4][0] == null) {
            revertTurn();
            break;
          } else if(i == catalog.size()-2) {
            if(isAttacked(4,0,true) || isAttacked(5,0,true) || isAttacked(6,0,true)) revertTurn();
            //if(isAttacked({m1,m2,m3})) revertTurn();
            else current.move(7,0,5,0);
          }
        }
      }
    }
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
      if(catalog.size() > 1) {
        if(m.ox - 1 >= 0 && m.oy == 4) {
          //if(current.b[m.ox-1][m.oy+1] == null && catalog.get(turn-1).b[m.ox-1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox-1][m.oy+2].black)
          //  if(catalog.get(turn-1).b[m.ox-1][m.oy+2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
              //Try fixing enPassent so that there is no use of catalog until later
        }
        if(m.ox+1 < 8 && m.oy == 4) {
          //if(current.b[m.ox+1][m.oy+1] == null && catalog.get(turn-1).b[m.ox+1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox+1][m.oy+2].black)
          //  if(catalog.get(turn-1).b[m.ox+1][m.oy+2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
        }
      }
    } else {
      if(m.oy - 1 >= 0 && current.b[m.ox][m.oy-1] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy - 1));
      }
      if(m.ox - 1 >= 0 && m.oy - 1 >= 0 && current.b[m.ox-1][m.oy-1] != null && current.b[m.ox-1][m.oy-1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
      if(m.ox + 1 < 8 && m.oy - 1 >= 0 && current.b[m.ox+1][m.oy-1] != null && current.b[m.ox+1][m.oy-1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
      if(m.oy == 6 && current.b[m.ox][m.oy-1] == null && current.b[m.ox][m.oy-2] == null) 
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy - 2));
      if(catalog.size() > 0) {
        if(m.ox - 1 >= 0 && m.oy == 3) {
          //if(current.b[m.ox-1][m.oy-1] == null && catalog.get(turn-1).b[m.ox-1][m.oy-2] != null && catalog.get(turn-1).b[m.ox-1][m.oy-2].black)
          //  if(catalog.get(turn-1).b[m.ox-1][m.oy-2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
        }
        if(m.ox+1 < 8 && m.oy == 3) {
          //if(current.b[m.ox+1][m.oy-1] == null && catalog.get(turn-1).b[m.ox+1][m.oy-2] != null && catalog.get(turn-1).b[m.ox+1][m.oy-2].black)
          //  if(catalog.get(turn-1).b[m.ox+1][m.oy-2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  void enPassent(Move m) {
    //black pawn
    //if(current.b[m.ox-1][m.oy+1] == null && catalog.get(turn-1).b[m.ox-1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox-1][m.oy+2].black)
    //  if(catalog.get(turn-1).b[m.ox-1][m.oy+2].type == Type.PAWN)
    //if(current.b[m.ox+1][m.oy+1] == null && catalog.get(turn-1).b[m.ox+1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox+1][m.oy+2].black)
    //  if(catalog.get(turn-1).b[m.ox+1][m.oy+2].type == Type.PAWN)
    //white pawn
    //if(current.b[m.ox-1][m.oy-1] == null && catalog.get(turn-1).b[m.ox-1][m.oy-2] != null && catalog.get(turn-1).b[m.ox-1][m.oy-2].black)
    //  if(catalog.get(turn-1).b[m.ox-1][m.oy-2].type == Type.PAWN)
    //if(current.b[m.ox+1][m.oy-1] == null && catalog.get(turn-1).b[m.ox+1][m.oy-2] != null && catalog.get(turn-1).b[m.ox+1][m.oy-2].black)
    //  if(catalog.get(turn-1).b[m.ox+1][m.oy-2].type == Type.PAWN)
    if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].type == Type.PAWN) {
      if(catalog.get(turn-1).b[m.nx][m.ny] == null && m.ox != m.nx) {
        if(current.b[m.nx][m.oy] != null && current.b[m.nx][m.oy].type == Type.PAWN 
        && current.b[m.nx][m.oy].black != current.b[m.nx][m.ny].black) {
          current.b[m.nx][m.oy] = null;
        } else revertTurn();
      }
    }
  }
  
  void pawnPromo(Move m) {
    if(current.b[m.nx][m.ny] != null && current.b[m.nx][m.ny].type == Type.PAWN) {
      if(current.b[m.nx][m.ny].black) {
        if(m.ny == 7) catalog.get(turn).b[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, true, Type.QUEEN);
      } else {
        if(m.ny == 0) catalog.get(turn).b[m.nx][m.ny] = new Queen(m.nx*100, m.ny*100, false, Type.QUEEN);
      }
    }
  }
  
  void setOPos() {
    ox = floor(mouseX/100);
    oy = floor(mouseY/100);
    inHand = current.b[ox][oy];
  }
  
  void setHand() {
    if(inHand != null) {
      inHand.setX(mouseX-50);
      inHand.setY(mouseY-50);
    }
  }
  
  void release() {
    if(inHand != null) {
      inHand.setX(ox*100);
      inHand.setY(oy*100);
      playMove(new Move (ox, oy, floor(mouseX/100), floor(mouseY/100)));
    } inHand = null;
  }
  
  void draw() {
    current.draw();
  }
  
}

class MovAlgo {
  
  ArrayList<Board> catalog = new ArrayList<Board>();
  
  int ox, oy, turn;
  Board current;
  Piece inHand;
  
  MovAlgo() {
    current = new Board();
    catalog.add(current);
    turn = 0;
  }
  
  void revertTurn() {
    System.out.println(catalog.size());
    if(turn>0) {
      catalog.remove(catalog.size()-1);
      turn--;
      current = catalog.get(turn);
      inHand = null;
    }
  }
  
  boolean adjudicate(Move m) {
    Move[] moves = getMoves(m);
    if(moves != null) {
      for(int i = 0; i < moves.length; i++) {
        if(m.equals(moves[i])) return true;
      }
    }
    return false;
  }
  
  boolean isValidMove(Move m) {
    if(current.b[m.ox][m.oy] != null) {
      if(!current.b[m.ox][m.oy].black && turn%2 != 0) {
        return false;
      } else if(current.b[m.ox][m.oy].black && turn%2 == 0) {
        return false;
      }
      if(current.b[m.ox][m.oy].isValid(m)) {
        return adjudicate(m);
      }
    }
    return false;
  }
  
  boolean isAttacked(int x, int y) {
    if(current.b[x][y].black) {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && !current.b[i][j].black)
            if(adjudicate(new Move(i, j, x, y))) return true;
        }
      }
    } else {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && current.b[i][j].black)
            if(adjudicate(new Move(i, j, x, y))) return true;
        }
      }
    }
    return false;
  }
  
    boolean isAttacked(int x, int y, boolean black) {
    if(black) {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && !current.b[i][j].black)
            if(adjudicate(new Move(i, j, x, y))) return true;
        }
      }
    } else {
      for(int i = 0; i < 8; i++) {
        for(int j = 0; j < 8; j++) {
          if(current.b[i][j] != null && current.b[i][j].black)
            if(adjudicate(new Move(i, j, x, y))) return true;
        }
      }
    }
    return false;
  }
  
  boolean isCheckMate() {
    current.locateKings();
    Move[] movesList = getAllMoves();
    if(turn%2 == 0) {
      for(int i = 0; movesList != null && i < movesList.length; i++) {
        Move m = movesList[i];
        if(isValidMove(m)) {
          catalog.add(catalog.get(turn).copy());
          current = catalog.get(turn+1);
          enPassent(m);
          pawnPromo(m);
          castling(m);
          current.move(m.ox, m.oy, m.nx, m.ny);
          turn++;
          current.locateKings();
          if(!isAttacked(floor(current.whiteKing.x/100), floor(current.whiteKing.y/100))) {
            revertTurn();
            println(m);
            return false;
          }
        }
        revertTurn();
      }
    } else {
      for(int i = 0; movesList != null && i < movesList.length; i++) {
        Move m = movesList[i];
        if(isValidMove(m)) {
          catalog.add(catalog.get(turn).copy());
          current = catalog.get(turn+1);
          enPassent(m);
          pawnPromo(m);
          castling(m);
          current.move(m.ox, m.oy, m.nx, m.ny);
          turn++;
          current.locateKings();
          if(!isAttacked(floor(current.blackKing.x/100), floor(current.blackKing.y/100))) {
            revertTurn();
            println(m);
            return false;
          }
        }
        revertTurn();
      }
    }
    return true; //<>//
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
  
  Move[] getMoves(Move m) {
    switch(current.b[m.ox][m.oy].type) {
      case ROOK: return getRookMoves(m);
      case KNIGHT: return getKnightMoves(m);
      case BISHOP: return getBishopMoves(m);
      case QUEEN: return getQueenMoves(m);
      case KING: return getKingMoves(m);
      case PAWN: return getPawnMoves(m);
    }
    return null;
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
    Move[] lesserPiece = getRookMoves(m);
    for(int i = 0; lesserPiece != null && i < lesserPiece.length; i++) {
      movesList.add(lesserPiece[i]);
    }
    lesserPiece = getBishopMoves(m);
    for(int i = 0; lesserPiece != null && i < lesserPiece.length; i++) {
      movesList.add(lesserPiece[i]);
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
        boolean moved = false;
        for(int i = 0; i < catalog.size(); i++) {
          if(catalog.get(i).b[4][0] == null || catalog.get(i).b[4][0].type != Type.KING || !catalog.get(i).b[4][0].black) moved = true;
          if(catalog.get(i).b[0][0] == null || catalog.get(i).b[0][0].type != Type.ROOK || !catalog.get(i).b[0][0].black) moved = true;
          if(catalog.get(i).b[7][0] == null || catalog.get(i).b[7][0].type != Type.ROOK || !catalog.get(i).b[7][0].black) moved = true;
        }
        if(!moved) {
          if(current.b[3][0] == null && current.b[2][0] == null && current.b[1][0] == null)
            movesList.add(new Move(m.ox, m.oy, m.ox - 3, m.oy));
          if(current.b[5][0] == null && current.b[6][0] == null)
            movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy));
        }
      }
    } else {
      if(m.ox == 4 && m.oy == 7) {
        boolean moved = false;
        for(int i = 0; i < catalog.size(); i++) {
          if(catalog.get(i).b[4][7] == null || catalog.get(i).b[4][7].type != Type.KING || catalog.get(i).b[4][7].black) moved = true;
          if(catalog.get(i).b[0][7] == null || catalog.get(i).b[0][7].type != Type.ROOK || catalog.get(i).b[0][7].black) moved = true;
          if(catalog.get(i).b[7][7] == null || catalog.get(i).b[7][7].type != Type.ROOK || catalog.get(i).b[7][7].black) moved = true;
        }
        if(!moved) {
          if(current.b[3][7] == null && current.b[2][7] == null && current.b[1][7] == null)
            movesList.add(new Move(m.ox, m.oy, m.ox - 3, m.oy));
          if(current.b[5][7] == null && current.b[6][7] == null)
            movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy));
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Move[] getPawnMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(current.b[m.ox][m.oy].black) {
      if(m.oy + 1 < 8 && current.b[m.ox][m.oy+1] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy + 1));
      }
      if(m.ox - 1 >= 0 && m.oy + 1 < 8 && current.b[m.ox-1][m.oy+1] != null && !current.b[m.ox-1][m.oy+1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
      if(m.ox + 1 < 8 && m.oy + 1 < 8 && current.b[m.ox+1][m.oy+1] != null && !current.b[m.ox+1][m.oy+1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
      if(m.oy == 1 && current.b[m.ox][m.oy+1] == null && current.b[m.ox][m.oy+2] == null) 
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy + 2));
      if(catalog.size() > 1) {
        if(m.ox - 1 >= 0 && m.oy == 4) {
          if(current.b[m.ox-1][m.oy+1] == null && catalog.get(turn-1).b[m.ox-1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox-1][m.oy+2].black)
            if(catalog.get(turn-1).b[m.ox-1][m.oy+2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
        }
        if(m.ox+1 < 8 && m.oy == 4) {
          if(current.b[m.ox+1][m.oy+1] == null && catalog.get(turn-1).b[m.ox+1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox+1][m.oy+2].black)
            if(catalog.get(turn-1).b[m.ox+1][m.oy+2].type == Type.PAWN)
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
      if(catalog.size() > 1) {
        if(m.ox - 1 >= 0 && m.oy == 3) {
          if(current.b[m.ox-1][m.oy-1] == null && catalog.get(turn-1).b[m.ox-1][m.oy-2] != null && catalog.get(turn-1).b[m.ox-1][m.oy-2].black)
            if(catalog.get(turn-1).b[m.ox-1][m.oy-2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
        }
        if(m.ox+1 < 8 && m.oy == 3) {
          if(current.b[m.ox+1][m.oy-1] == null && catalog.get(turn-1).b[m.ox+1][m.oy-2] != null && catalog.get(turn-1).b[m.ox+1][m.oy-2].black)
            if(catalog.get(turn-1).b[m.ox+1][m.oy-2].type == Type.PAWN)
              movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
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
  
  void playMove(Move m) {
      if(isValidMove(m)) {
        catalog.add(catalog.get(turn).copy());
        current = catalog.get(turn+1);
        enPassent(m);
        pawnPromo(m);
        castling(m);
        current.move(m.ox, m.oy, m.nx, m.ny);
        turn++;
        current.locateKings();
        if(current.b[m.nx][m.ny].black) {
          if(isAttacked(floor(current.blackKing.x/100), floor(current.blackKing.y/100))) revertTurn();
        } else {
          if(isAttacked(floor(current.whiteKing.x/100), floor(current.whiteKing.y/100))) revertTurn();
        }
      }
  }
  
  void release() {
    if(inHand != null) {
      inHand.setX(ox*100);
      inHand.setY(oy*100);
    }
    if(inHand != null) {
      Move m = new Move (ox, oy, floor(mouseX/100), floor(mouseY/100));
      if(isValidMove(m)) {
        catalog.add(catalog.get(turn).copy());
        current = catalog.get(turn+1);
        enPassent(m);
        pawnPromo(m);
        Boolean castle = castling(m);
        current.move(ox, oy, floor(mouseX/100), floor(mouseY/100));
        turn++;
        if(!castle) revertTurn();
        else {
          current.locateKings();
          if(current.b[m.nx][m.ny].black) {
            if(isAttacked(floor(current.blackKing.x/100), floor(current.blackKing.y/100))) revertTurn();
          } else {
            if(isAttacked(floor(current.whiteKing.x/100), floor(current.whiteKing.y/100))) revertTurn();
          }
        }
      }
    }
    inHand = null;
  }
  
  void pawnPromo(Move m) {
    if(current.b[m.ox][m.oy].type == Type.PAWN) {
      if(current.b[m.ox][m.oy].black) {
        if(m.ny == 7) current.b[m.ox][m.oy] = new Queen(m.nx*100, m.ny*100, true, Type.QUEEN);
      } else {
        if(m.ny == 0) current.b[m.ox][m.oy] = new Queen(m.nx*100, m.ny*100, false, Type.QUEEN);
      }
    }
  }
  
  void enPassent(Move m) {
    if(current.b[m.ox][m.oy].type == Type.PAWN) {
      if(catalog.size() > 1) {
        if(current.b[m.ox][m.oy].black) {
          if(m.ox - 1 >= 0 && m.oy == 4) {
            if(current.b[m.ox-1][m.oy+1] == null && catalog.get(turn-1).b[m.ox-1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox-1][m.oy+2].black) {
              if(catalog.get(turn-1).b[m.ox-1][m.oy+2].type == Type.PAWN)
                current.b[m.ox-1][m.oy] = null;
            }
          }
          if(m.ox+1 < 8 && m.oy == 4) {
            if(current.b[m.ox+1][m.oy+1] == null && catalog.get(turn-1).b[m.ox+1][m.oy+2] != null && !catalog.get(turn-1).b[m.ox+1][m.oy+2].black)
              if(catalog.get(turn-1).b[m.ox+1][m.oy+2].type == Type.PAWN)
                current.b[m.ox+1][m.oy] = null;
          }
        } else {
        if(m.ox - 1 >= 0 && m.oy == 3) {
            if(current.b[m.ox-1][m.oy-1] == null && catalog.get(turn-1).b[m.ox-1][m.oy-2] != null && catalog.get(turn-1).b[m.ox-1][m.oy-2].black)
              if(catalog.get(turn-1).b[m.ox-1][m.oy-2].type == Type.PAWN)
                current.b[m.ox-1][m.oy] = null;
          }
          if(m.ox+1 < 8 && m.oy == 3) {
            if(current.b[m.ox+1][m.oy-1] == null && catalog.get(turn-1).b[m.ox+1][m.oy-2] != null && catalog.get(turn-1).b[m.ox+1][m.oy-2].black)
              if(catalog.get(turn-1).b[m.ox+1][m.oy-2].type == Type.PAWN)
                current.b[m.ox+1][m.oy] = null;
          }
        }
      }
    }
  }
  
  boolean castling(Move m) {
    if(current.b[m.ox][m.oy].type == Type.KING) {
      if(m.ox == 4) {
        if(m.oy == 0) {
          if(m.nx == 1 && m.ny == 0) {
            if(isAttacked(3, 0, true) || isAttacked(2, 0, true) || isAttacked(1, 0, true)) return false;
            current.move(0, 0, 2, 0);
          }
          if(m.nx == 6 && m.ny == 0) {
            if(isAttacked(5, 0, true) || isAttacked(6, 0 , true)) return false;
            current.move(7, 0, 5, 0);
          }
        } else if(m.oy == 7) {
          if(m.nx == 1 && m.ny == 7) {
            if(isAttacked(3, 7, false) || isAttacked(2, 7, false) || isAttacked(1, 7, false)) return false;
            current.move(0, 7, 2, 7);
          }
          if(m.nx == 6 && m.ny == 7) {
            if(isAttacked(5, 7, false) || isAttacked(6, 7, false)) return false;
            current.move(7, 7, 5, 7);
          }
        }
      }
    }
    return true;
  }
  
  void draw() {
    current.draw();
  }
  
}

class Board {
  
  boolean[][] board = new boolean[8][8];
  Piece[][] b = new Piece[8][8];
  Piece blackKing;
  Piece whiteKing;
  
  Board() {
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) board[i][j] = ((i+j)%2 == 0)? true : false;
        b[0][0] = new Rook(0, 0, true, Type.ROOK);
        b[1][0] = new Knight(100, 0, true, Type.KNIGHT);
        b[2][0] = new Bishop(200, 0, true, Type.BISHOP);
        b[3][0] = new Queen(300, 0, true, Type.QUEEN);
        b[4][0] = new King(400, 0, true, Type.KING);
        b[5][0] = new Bishop(500, 0, true, Type.BISHOP); 
        b[6][0] = new Knight(600, 0, true, Type.KNIGHT);
        b[7][0] = new Rook(700, 0, true, Type.ROOK);
        for(int i = 0; i < 8; i++) {b[i][1] = new Pawn(i*100, 100, true, Type.PAWN);}
        b[0][7] = new Rook(0, 700, false, Type.ROOK);
        b[1][7] = new Knight(100, 700, false, Type.KNIGHT);
        b[2][7] = new Bishop(200, 700, false, Type.BISHOP);
        b[3][7] = new Queen(300, 700, false, Type.QUEEN);
        b[4][7] = new King(400, 700, false, Type.KING);
        b[5][7] = new Bishop(500, 700, false, Type.BISHOP); 
        b[6][7] = new Knight(600, 700, false, Type.KNIGHT);
        b[7][7] = new Rook(700, 700, false, Type.ROOK);
        for(int i = 0; i < 8; i++) {b[i][6] = new Pawn(i*100, 600, false, Type.PAWN);}
        blackKing = b[4][0];
        whiteKing = b[4][7];
  }
  
  Board (Piece[][] n_board) {
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) board[i][j] = ((i+j)%2 == 0)? true : false;
    b = n_board;
  }
  
  void move(int x, int y, int nx, int ny) {
    if(b[x][y] != null) {
      b[x][y].setX(nx*100);
      b[x][y].setY(ny*100);
      b[nx][ny] = b[x][y];
      b[x][y] = null;
    }
  }
  
  void draw() {
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        fill(board[i][j]? 255: 125);
        rect(i*100,j*100,100,100);
      }
    }
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        if(b[i][j] != null) {
          b[i][j].draw();
        }
      }
    }
  }
  
  void locateKings() {
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        if(b[i][j] != null && b[i][j].type == Type.KING) {
          if(b[i][j].black) {
            blackKing = b[i][j];
          } else {
            whiteKing = b[i][j];
          }
        }
      }
    }
  }
  
  Board copy() {
    Piece[][] n_board = new Piece[8][8];
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        if(b[i][j] != null)
          switch(b[i][j].type) {
            case ROOK: n_board[i][j] = (Rook)b[i][j].copy(); break;
            case KNIGHT: n_board[i][j] = (Knight)b[i][j].copy(); break;
            case BISHOP: n_board[i][j] = (Bishop)b[i][j].copy(); break;
            case QUEEN: n_board[i][j] = (Queen)b[i][j].copy(); break;
            case KING: n_board[i][j] = (King)b[i][j].copy(); break;
            case PAWN: n_board[i][j] = (Pawn)b[i][j].copy(); break;
          }
      }
    }
    return new Board(n_board);
  }
  
}

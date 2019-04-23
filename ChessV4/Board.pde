class Board {
  
  boolean[][] tiles = new boolean[8][8];
  Piece[][] board = new Piece[8][8];
  Piece blackKing;
  Piece whiteKing;
  
  Board() {
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) tiles[i][j] = ((i+j)%2 == 0)? true : false;
    board[0][0] = new Rook(0, 0, true, Type.ROOK, board);
    board[1][0] = new Knight(100, 0, true, Type.KNIGHT, board);
    board[2][0] = new Bishop(200, 0, true, Type.BISHOP, board);
    board[3][0] = new Queen(300, 0, true, Type.QUEEN, board);
    board[4][0] = new King(400, 0, true, Type.KING, board);
    board[5][0] = new Bishop(500, 0, true, Type.BISHOP, board); 
    board[6][0] = new Knight(600, 0, true, Type.KNIGHT, board);
    board[7][0] = new Rook(700, 0, true, Type.ROOK, board);
    for(int i = 0; i < 8; i++) {board[i][1] = new Pawn(i*100, 100, true, Type.PAWN, board);}
    blackKing = board[4][0];
    board[0][7] = new Rook(0, 700, false, Type.ROOK, board);
    board[1][7] = new Knight(100, 700, false, Type.KNIGHT, board);
    board[2][7] = new Bishop(200, 700, false, Type.BISHOP, board);
    board[3][7] = new Queen(300, 700, false, Type.QUEEN, board);
    board[4][7] = new King(400, 700, false, Type.KING, board);
    board[5][7] = new Bishop(500, 700, false, Type.BISHOP, board); 
    board[6][7] = new Knight(600, 700, false, Type.KNIGHT, board);
    board[7][7] = new Rook(700, 700, false, Type.ROOK, board);
    for(int i = 0; i < 8; i++) {board[i][6] = new Pawn(i*100, 600, false, Type.PAWN, board);}
    whiteKing = board[4][7];
  }
  
  Board (Piece[][] n_board) {
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) tiles[i][j] = ((i+j)%2 == 0)? true : false;
    board = n_board;
  }
  
  void move(int x, int y, int nx, int ny) {
    if(board[x][y] != null) {
      board[x][y].setX(nx*100);
      board[x][y].setY(ny*100);
      board[nx][ny] = board[x][y];
      board[x][y] = null;
    }
  }
  
  void draw() {
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        fill(tiles[i][j]? 255: 125);
        rect(i*100,j*100,100,100);
      }
    }
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        if(board[i][j] != null) {
          board[i][j].draw();
        }
      }
    }
  }
  
  Board copy() {
    Piece[][] n_board = new Piece[8][8];
    Piece blackKing = null;
    Piece whiteKing = null;
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {
        if(board[i][j] != null)
          switch(board[i][j].type) {
            case ROOK: n_board[i][j] = (Rook)board[i][j].copy(); break;
            case KNIGHT: n_board[i][j] = (Knight)board[i][j].copy(); break;
            case BISHOP: n_board[i][j] = (Bishop)board[i][j].copy(); break;
            case QUEEN: n_board[i][j] = (Queen)board[i][j].copy(); break;
            case KING: 
            n_board[i][j] = (King)board[i][j].copy(); 
            if(n_board[i][j].black) {
              blackKing = n_board[i][j];
            } else {
              whiteKing = n_board[i][j];
            }
            break;
            case PAWN: n_board[i][j] = (Pawn)board[i][j].copy(); break;
          }
      }
    }
    Board n_gameBoard = new Board(n_board);
    n_gameBoard.blackKing = blackKing;
    n_gameBoard.whiteKing = whiteKing;
    return n_gameBoard;
  }
  
}

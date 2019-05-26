class Board {
  
  private boolean gameOver;
  private boolean[][] tiles;
  private Piece[][] board;
  private Piece[] blackPieces, whitePieces;
  
  Board() {
    gameOver = false;
    tiles = new boolean[8][8];
    board = new Piece[8][8];
    blackPieces = new Piece[16];
    whitePieces = new Piece[16];
    for(int i = 0; i < 8; i++)
      for(int j = 0; j < 8; j++) tiles[i][j] = ((i+j)%2 == 0)? true : false;
    board[0][0] = new Rook(0, 0, true, Type.ROOK, board);
    blackPieces[0] = board[0][0];
    board[1][0] = new Knight(100, 0, true, Type.KNIGHT, board);
    blackPieces[1] = board[1][0];
    board[2][0] = new Bishop(200, 0, true, Type.BISHOP, board);
    blackPieces[2] = board[2][0];
    board[3][0] = new Queen(300, 0, true, Type.QUEEN, board);
    blackPieces[3] = board[3][0];
    board[4][0] = new King(400, 0, true, Type.KING, board);
    blackPieces[4] = board[4][0];
    board[5][0] = new Bishop(500, 0, true, Type.BISHOP, board); 
    blackPieces[5] = board[5][0];
    board[6][0] = new Knight(600, 0, true, Type.KNIGHT, board);
    blackPieces[6] = board[6][0];
    board[7][0] = new Rook(700, 0, true, Type.ROOK, board);
    blackPieces[7] = board[7][0];
    for(int i = 0; i < 8; i++) {
      board[i][1] = new Pawn(i*100, 100, true, Type.PAWN, board);
      blackPieces[8+i] = board[i][1];
    }
    board[0][7] = new Rook(0, 700, false, Type.ROOK, board);
    whitePieces[0] = board[0][7];
    board[1][7] = new Knight(100, 700, false, Type.KNIGHT, board);
    whitePieces[1] = board[1][7];
    board[2][7] = new Bishop(200, 700, false, Type.BISHOP, board);
    whitePieces[2] = board[2][7];
    board[3][7] = new Queen(300, 700, false, Type.QUEEN, board);
    whitePieces[3] = board[3][7];
    board[4][7] = new King(400, 700, false, Type.KING, board);
    whitePieces[4] = board[4][7];
    board[5][7] = new Bishop(500, 700, false, Type.BISHOP, board);
    whitePieces[5] = board[5][7];
    board[6][7] = new Knight(600, 700, false, Type.KNIGHT, board);
    whitePieces[6] = board[6][7];
    board[7][7] = new Rook(700, 700, false, Type.ROOK, board);
    whitePieces[7] = board[7][7];
    for(int i = 0; i < 8; i++) {
      board[i][6] = new Pawn(i*100, 600, false, Type.PAWN, board);
      whitePieces[8+i] = board[i][6];
    }
  }
  
  Board(Piece[][] n_board) {
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
    debugDraw();
  }
  
  void debugDraw() {
    for(int i = 0; i < 8; i++) {
      image(blackPieces[i].shape, i*100+825, 0+25);
      image(blackPieces[i+8].shape, i*100+825, 125);
      image(whitePieces[i+8].shape, i*100+825, 625);
      image(whitePieces[i].shape, i*100+825, 725);
    }
  }
  
  String toString() {
    return "Board: " + gameOver;
  }
  
}

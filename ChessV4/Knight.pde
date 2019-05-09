class Knight extends Piece {
  
  Knight(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type,n_board);
    shape = (black)? loadImage("Sprites/Chess_ndt60.png") : loadImage("Sprites/Chess_nlt60.png");
  }
  
  Move[] getMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(m.ox + 2 < 8 && m.oy - 1 >= 0) {
      if(board[m.ox+2][m.oy-1] == null || (board[m.ox][m.oy].black != board[m.ox+2][m.oy-1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy - 1));
    }
    if(m.ox + 2 < 8 && m.oy + 1 < 8) {
      if(board[m.ox+2][m.oy+1] == null || (board[m.ox][m.oy].black != board[m.ox+2][m.oy+1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy + 1));
    }
    if(m.ox + 1 < 8 && m.oy + 2 < 8) {
      if(board[m.ox+1][m.oy+2] == null || (board[m.ox][m.oy].black != board[m.ox+1][m.oy+2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 1, m.oy + 2));
    }
    if(m.ox - 1 >= 0 && m.oy + 2 < 8) {
      if(board[m.ox-1][m.oy+2] == null || (board[m.ox][m.oy].black != board[m.ox-1][m.oy+2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 1, m.oy + 2));
    }
    if(m.ox - 2 >= 0 && m.oy + 1 < 8) {
      if(board[m.ox-2][m.oy+1] == null || (board[m.ox][m.oy].black != board[m.ox-2][m.oy+1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy + 1));
    }
    if(m.ox - 2 >= 0 && m.oy - 1 >= 0) {
      if(board[m.ox-2][m.oy-1] == null || (board[m.ox][m.oy].black != board[m.ox-2][m.oy-1].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy - 1));
    }
    if(m.ox - 1 >= 0 && m.oy - 2 >= 0) {
      if(board[m.ox-1][m.oy-2] == null || (board[m.ox][m.oy].black != board[m.ox-1][m.oy-2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox - 1, m.oy - 2));
    }
    if(m.ox + 1 < 8 && m.oy - 2 >= 0) {
      if(board[m.ox+1][m.oy-2] == null || (board[m.ox][m.oy].black != board[m.ox+1][m.oy-2].black))
      movesList.add(new Move(m.ox, m.oy, m.ox + 1, m.oy - 2));
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Piece copy() {
    return new Knight(x, y, black, type, board);
  }
  
}

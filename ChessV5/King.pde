class King extends Piece {
  
  King(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type, n_board);
    shape = (black)? loadImage("Sprites/Chess_kdt60.png") : loadImage("Sprites/Chess_klt60.png");
  }
  
  Move[] getMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(m.oy - 1 >= 0)
      if(board[m.ox][m.oy-1] == null || (board[m.ox][m.oy].black != board[m.ox][m.oy-1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy-1));
    if(m.ox + 1 < 8 && m.oy - 1 >= 0)
      if(board[m.ox+1][m.oy-1] == null || (board[m.ox][m.oy].black != board[m.ox+1][m.oy-1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
    if(m.ox + 1 < 8)
      if(board[m.ox+1][m.oy] == null || (board[m.ox][m.oy].black != board[m.ox+1][m.oy].black))
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy));
    if(m.ox + 1 < 8 && m.oy + 1 < 8)
      if(board[m.ox+1][m.oy+1] == null || (board[m.ox][m.oy].black != board[m.ox+1][m.oy+1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
    if(m.oy + 1 < 8)
      if(board[m.ox][m.oy+1] == null || (board[m.ox][m.oy].black != board[m.ox][m.oy+1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy+1));
    if(m.ox - 1 >= 0 && m.oy + 1 < 8)
      if(board[m.ox-1][m.oy+1] == null || (board[m.ox][m.oy].black != board[m.ox-1][m.oy+1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
    if(m.ox - 1 >= 0)
      if(board[m.ox-1][m.oy] == null || (board[m.ox][m.oy].black != board[m.ox-1][m.oy].black))
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy));
    if(m.ox - 1 >= 0 && m.oy - 1 >= 0)
      if(board[m.ox-1][m.oy-1] == null || (board[m.ox][m.oy].black != board[m.ox-1][m.oy-1].black))
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
    if(board[m.ox][m.oy].black) {
      if(m.ox == 4 && m.oy == 0) {
        if(board[3][0] == null && board[2][0] == null && board[1][0] == null) {
          movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy));
          movesList.get(movesList.size()-1).p2 = this;
        }
        if(board[5][0] == null && board[6][0] == null) {
          movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy));
          movesList.get(movesList.size()-1).p2 = this;
        }
      }
    } else {
      if(m.ox == 4 && m.oy == 7) {
        if(board[3][7] == null && board[2][7] == null && board[1][7] == null) {
          movesList.add(new Move(m.ox, m.oy, m.ox - 2, m.oy));
          movesList.get(movesList.size()-1).p2 = this;
        }
        if(board[5][7] == null && board[6][7] == null) {
          movesList.add(new Move(m.ox, m.oy, m.ox + 2, m.oy));
          movesList.get(movesList.size()-1).p2 = this;
        }
      }
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Piece copy() {
    return new King(x, y, black, type, board);
  }
  
}

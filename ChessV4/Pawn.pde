class Pawn extends Piece {
  
  Pawn(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type, n_board);
    shape = (black)? loadImage("Sprites/Chess_pdt60.png") : loadImage("Sprites/Chess_plt60.png");
  }
  
  Move[] getMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    if(board[m.ox][m.oy].black) {
      if(m.oy + 1 < 8 && board[m.ox][m.oy+1] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy + 1));
      if(m.ox - 1 >= 0 && m.oy + 1 < 8 && board[m.ox-1][m.oy+1] != null && !board[m.ox-1][m.oy+1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
      if(m.ox + 1 < 8 && m.oy + 1 < 8 && board[m.ox+1][m.oy+1] != null && !board[m.ox+1][m.oy+1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
      if(m.oy == 1 && board[m.ox][m.oy+1] == null && board[m.ox][m.oy+2] == null) 
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy + 2));
      if(m.ox - 1 >= 0 && m.oy == 4)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy+1));
      if(m.ox+1 < 8 && m.oy == 4)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy+1));
    } else {
      if(m.oy - 1 >= 0 && board[m.ox][m.oy-1] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy - 1));
      if(m.ox - 1 >= 0 && m.oy - 1 >= 0 && board[m.ox-1][m.oy-1] != null && board[m.ox-1][m.oy-1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
      if(m.ox + 1 < 8 && m.oy - 1 >= 0 && board[m.ox+1][m.oy-1] != null && board[m.ox+1][m.oy-1].black)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
      if(m.oy == 6 && board[m.ox][m.oy-1] == null && board[m.ox][m.oy-2] == null) 
        movesList.add(new Move(m.ox, m.oy, m.ox, m.oy - 2));
      if(m.ox - 1 >= 0 && m.oy == 3)
        movesList.add(new Move(m.ox, m.oy, m.ox-1, m.oy-1));
      if(m.ox+1 < 8 && m.oy == 3)
        movesList.add(new Move(m.ox, m.oy, m.ox+1, m.oy-1));
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Piece copy() {
    return new Pawn(x, y, black, type, board);
  }
  
}

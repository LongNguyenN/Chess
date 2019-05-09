class Bishop extends Piece {
  
  Bishop(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type, n_board);
    shape = (black)? loadImage("Sprites/Chess_bdt60.png") : loadImage("Sprites/Chess_blt60.png");
  }
  
  Move[] getMoves(Move m) {
    ArrayList<Move> movesList = new ArrayList<Move>();
    for(int i = 1; m.ox + i < 8 && m.oy + i < 8; i++) {
      if(board[m.ox+i][m.oy+i] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy + i));
      } else if(board[m.ox][m.oy].black != board[m.ox+i][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy + i));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0 && m.oy - i >= 0; i++) {
      if(board[m.ox-i][m.oy-i] == null) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy - i));
      } else if(board[m.ox][m.oy].black != board[m.ox-i][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy - i));
        break;
      } else break;
    }
    for(int i = 1; m.ox + i < 8 && m.oy - i >= 0; i++) {
      if(board[m.ox+i][m.oy-i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy - i));
      else if(board[m.ox][m.oy].black != board[m.ox+i][m.oy-i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox + i, m.oy - i));
        break;
      } else break;
    }
    for(int i = 1; m.ox - i >= 0 && m.oy + i < 8; i++) {
      if(board[m.ox-i][m.oy+i] == null)
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy + i));
      else if(board[m.ox][m.oy].black != board[m.ox-i][m.oy+i].black) {
        movesList.add(new Move(m.ox, m.oy, m.ox - i, m.oy + i));
        break;
      } else break;
    }
    Move[] moves = movesList.toArray(new Move[movesList.size()]);
    return (moves.length > 0)? moves : null;
  }
  
  Piece copy() {
    return new Bishop(x, y, black, type, board);
  }
  
}

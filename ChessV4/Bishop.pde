class Bishop extends Piece {
  
  Bishop(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type, n_board);
    shape = (black)? loadImage("Sprites/Chess_bdt60.png") : loadImage("Sprites/Chess_blt60.png");
  }
  
  boolean isValid(Move m) {
    if((abs(m.nx - m.ox) != 0) && (((float)abs(m.ny - m.oy)/abs(m.nx - m.ox)) == 1)) {
      if(m.nx != m.ox || m.ny != m.oy)
        return(m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8);
    }
    return false;
  }
  
  Piece copy() {
    return new Bishop(x, y, black, type, board);
  }
  
}

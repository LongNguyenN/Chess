class King extends Piece {
  
  King(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type, n_board);
    shape = (black)? loadImage("Sprites/Chess_kdt60.png") : loadImage("Sprites/Chess_klt60.png");
  }
  
  boolean isValid(Move m) {
    if((abs(m.nx - m.ox) < 2 && abs(m.ny - m.oy) < 2) || (m.ny - m.oy == 0 && (m.nx - m.ox == 2 || m.nx - m.ox == -2))) {
      if(m.nx != m.ox || m.ny != m.oy)
        return(m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8);
    }
    return false;
  }
  
  Piece copy() {
    return new King(x, y, black, type, board);
  }
  
}

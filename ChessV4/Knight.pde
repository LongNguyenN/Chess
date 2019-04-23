class Knight extends Piece {
  
  Knight(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    super(n_x, n_y, n_black, n_type,n_board);
    shape = (black)? loadImage("Sprites/Chess_ndt60.png") : loadImage("Sprites/Chess_nlt60.png");
  }
  
  boolean isValid(Move m) {
    if((abs(m.nx - m.ox) == 1 && abs(m.ny - m.oy) == 2) || (abs(m.nx - m.ox) == 2 && abs(m.ny - m.oy) == 1)) {
      return m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8;
    }
    return false;
  }
  
  Piece copy() {
    return new Knight(x, y, black, type, board);
  }
  
}

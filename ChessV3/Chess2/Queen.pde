class Queen extends Piece {
  
  Queen(int n_x, int n_y, boolean n_black, Type n_type) {
    super(n_x, n_y, n_black, n_type);
    shape = (black)? loadImage("Sprites/Chess_qdt60.png") : loadImage("Sprites/Chess_qlt60.png");
  }
  
  boolean isValid(Move m) {
    if((abs(m.nx - m.ox) != 0) && (((float)abs(m.ny - m.oy)/abs(m.nx - m.ox)) == 1) ||
    (m.nx - m.ox) == 0 || (m.ny - m.oy) == 0) {
      if(m.nx != m.ox || m.ny != m.oy)
        return(m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8);
    }
    return false;
  }
  
  Piece copy() {
    return new Queen(x, y, black, type);
  }
  
}

class Rook extends Piece {
  
  Rook(int n_x, int n_y, boolean n_black, Type n_type) {
    super(n_x, n_y, n_black, n_type);
    shape = (black)? loadImage("Sprites/Chess_rdt60.png") : loadImage("Sprites/Chess_rlt60.png");
  }
  
  boolean isValid(Move m) {
    if((m.nx - m.ox) == 0 || (m.ny - m.oy) == 0) {
      if(m.nx != m.ox || m.ny != m.oy)
        return(m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8);
    }
    return false;
  }
  
  Piece copy() {
    return new Rook(x, y, black, type);
  }
  
}

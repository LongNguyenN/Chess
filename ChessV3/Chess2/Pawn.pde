class Pawn extends Piece {
  
  Pawn(int n_x, int n_y, boolean n_black, Type n_type) {
    super(n_x, n_y, n_black, n_type);
    shape = (black)? loadImage("Sprites/Chess_pdt60.png") : loadImage("Sprites/Chess_plt60.png");
  }
  
  boolean isValid(Move m) {
    if(black) {
      if((abs(m.nx-m.ox) < 2 && m.ny - m. oy == 1) || (m.nx - m.ox == 0 && m.ny - m.oy == 2))
        return m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8;
    } else {
      if((abs(m.nx-m.ox) < 2 && m.ny - m. oy == -1) || (m.nx - m.ox == 0 && m.ny - m.oy == -2))
        return m.nx >= 0 && m.nx < 8 && m.ny >= 0 && m.ny < 8;
    }
    return false;
  }
  
  Piece copy() {
    return new Pawn(x, y, black, type);
  }
  
}

class Move {
  
  private final int ox, oy, nx, ny;
  private Piece p1,p2;
  private Move special;
  
  Move(int n_ox, int n_oy, int n_nx, int n_ny) {
    ox = n_ox;
    oy = n_oy;
    nx = n_nx;
    ny = n_ny;
  }
  
  boolean equals(Move m) {
    return this.ox == m.ox &&
    this.oy == m.oy &&
    this.nx == m.nx &&
    this.ny == m.ny &&
    holdingPiecesAreTheSame(m);
  }
  
  boolean holdingPiecesAreTheSame(Move m) {
    if(p2 == null && m.p2 != null) return false;
    if(p2 != null && m.p2 == null) return false;
    return true;
  }
  
  String toString() {
    return "(" + ox + "," + oy + ")" + "to" + "(" + nx + "," + ny + ")" + " Piece: " + p1 + " " + p2;
  }
  
  Move copy() {
    Move copy = new Move(ox, oy, nx, ny);
    copy.p1 = p1;
    copy.p2 = p2;
    return copy;
  }
  
}

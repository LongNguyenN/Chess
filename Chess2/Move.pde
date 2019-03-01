class Move {
  
  final int ox, oy, nx, ny;
  
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
    this.ny == m.ny;
  }
  
  String toString() {
    return "(" + ox + "," + oy + ")" + "to" + "(" + nx + "," + ny + ")";
  }
  
}

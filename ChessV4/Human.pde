
class Human extends Player {
  
  Piece inHand;
  int ox, oy, nx, ny;
  
  void putPieceClickedInHand() {
    this.ox = mouseX/100;
    this.oy = mouseY/100;
    inHand = refSim.current.board[ox][oy];
  }
  
  void movePieceInHandToMouse() {
    Piece p = refSim.current.board[ox][oy];
    if(p != null) {
      p.x = mouseX*100;
      p.y = mouseY*100;
    }
  }
  
  void placePieceInHand() {
    
  }
  
  Move getMove() {
    return null;
  }
  
}

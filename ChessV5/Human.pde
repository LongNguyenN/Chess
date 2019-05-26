
class Human extends Player {
  
  private Piece inHand;
  private int ox, oy;
  
  Human(boolean ai) {
    super(ai);
  }
  
  void setDesiredMove(Move m) {
    Move move = matchMoveToLegalMoves(m);
    if(move != null) desiredMove = move;
  }
  
  Move matchMoveToLegalMoves(Move m) {
    if(refSim.board[m.ox][m.oy] != null) {
      Move[] legalMoves = refSim.board[m.ox][m.oy].getMoves(m);
      if(legalMoves == null) return null;
      for(Move move : legalMoves) {
        if(move.ox == m.ox && move.nx == m.nx && move.oy == m.oy && move.ny == m.ny) {
          return move;
        }
      }
    }
    return null;
  }
  
  void putClickedInHand() {
    ox = floor(mouseX/100);
    oy = floor(mouseY/100);
    inHand = refSim.board[ox][oy];
  }
  
  void moveInHandToMouse() {
    if(inHand != null) {
      inHand.x = mouseX-50;
      inHand.y = mouseY-50;
    }
  }
  
  void placeInHandOnBoard() {
    if(inHand != null) {
      inHand.x = ox*100;
      inHand.y = oy*100;
      desiredMove = new Move(ox, oy, floor(mouseX/100), floor(mouseY/100));
      inHand = null;
    }
  }
  
}

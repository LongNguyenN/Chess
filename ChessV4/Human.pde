
class Human extends Player {
  
  Piece inHand;
  int ox, oy;
  
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

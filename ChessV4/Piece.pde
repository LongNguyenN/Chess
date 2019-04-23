abstract class Piece {
  
  Type type;
  Piece[][] board;
  int x,y;
  boolean black;
  PImage shape;
  
  Piece(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    this.board = n_board;
    this.x = n_x;
    this.y = n_y;
    this.black = n_black;
    this.type = n_type;
  }
  
  abstract boolean isValid(Move m);
  
  void draw() {
    image(shape, x+20, y+20);
  }
  
  void setX(int n_x) {
    x = n_x;
  }
  
  void setY(int n_y) {
    y = n_y;
  }
  
  abstract Piece copy();
  
}

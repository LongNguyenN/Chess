abstract class Piece {
  
  int x,y;
  boolean black;
  PImage shape;
  Type type;
  
  Piece(int n_x, int n_y, boolean n_black, Type n_type) {
    x = n_x;
    y = n_y;
    black = n_black;
    type = n_type;
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

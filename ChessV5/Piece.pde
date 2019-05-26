abstract class Piece {
  
  protected Type type;
  protected Piece[][] board;
  protected int x,y;
  protected boolean black;
  protected PImage shape;
  
  Piece(int n_x, int n_y, boolean n_black, Type n_type, Piece[][] n_board) {
    this.board = n_board;
    this.x = n_x;
    this.y = n_y;
    this.black = n_black;
    this.type = n_type;
  }
  
  abstract Move[] getMoves(Move m);
  
  void draw() {
    image(shape, x+20, y+20);
  }
  
  void setX(int n_x) {
    x = n_x;
  }
  
  void setY(int n_y) {
    y = n_y;
  }
  
  String toString() {
    return black + " " + type + " (" + x + "," + y + ")";
  }
  
  abstract Piece copy();
  
}

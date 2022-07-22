private Player player1, player2;
private MovAlgo ref;
private boolean gameOver, pause;
private int playerScreen;

class Game {
  
  Game() {
    gameOver = false;
    pause = false;
    ref = new MovAlgo();
    player1 = new Human(false);
    player2 = new Human(false);
    //player1 = new AI(true);
    //player2 = new AI(true);
    playerScreen = 3;
  }
  
  void playGame() {
    if(!pause && !gameOver) {
      if(ref.catalog.size()%2 == 0) {
        makePlayerOneMove();  
      } else if(ref.catalog.size()%2 == 1) {
        makePlayerTwoMove();
      }
      //println(((AI)player1).getPointsFor(true) - ((AI)player1).getPointsFor(false));
    }
    showScreens();
  }
  
  void showScreens() {
    if(playerScreen == 0) {
      ref.draw();
      } else if(playerScreen == 1) {
        player1.refSim.draw();
      } else if(playerScreen == 2) {
        player2.refSim.draw();
      } else if(playerScreen == 3) {
        if(ref.catalog.size()%2 == 0) {
        player1.refSim.draw();
      } else {
        player2.refSim.draw();
      }
    }
  }
  
  void makePlayerOneMove() {
    if(ref.isMate() || ref.isStaleMate()) {
      gameOver = true;
      println("Game");
    } else if(player1.ai) {
      ((AI)player1).findDesiredMove();
      Move move = player1.getMove();
      updateGameStates(move);
    } else if(player1.desiredMove != null) {
      Move move = player1.getMove();
      updateGameStates(move);
    }
  }
  
  void makePlayerTwoMove() {
    if(ref.isMate() || ref.isStaleMate()) {
      gameOver = true;
      println("Game");
    } else if(player2.ai) {
      ((AI)player2).findDesiredMove();
      Move move = player2.getMove();
      updateGameStates(move);
    } else if(player2.desiredMove != null) {
      Move move = player2.getMove();
      updateGameStates(move);
    }
  }
  
  void updateGameStates(Move move) {
    ref.playMove(move.copy());
    player1.updateMove(move.copy());
    player1.desiredMove = null;
    player2.updateMove(move.copy());
    player2.desiredMove = null;
  }
  
  void goBackATurn() {
    ref.revertTurn();
    player1.refSim.revertTurn();
    player2.refSim.revertTurn();
  }
  
  void switchPlayerScreen() {
    switch(playerScreen) {
      case 0: playerScreen = 1; break;
      case 1: playerScreen = 2; break;
      case 2: playerScreen = 3; break;
      case 3: playerScreen = 0; break;
    }
    println("screen: " + playerScreen);
  }
  
  void changePauseState() {
    pause = !pause;
  }
  
  void updateHumanHand() {
    if(!player1.ai && ref.catalog.size()%2 == 0) {
      Human p1 = (Human)player1;
      if(mouseX >= 0 && mouseX <= 800 && mouseY >= 0 && mouseY <= 800) {
        p1.ox = floor(mouseX/100);
        p1.oy = floor(mouseY/100);
        p1.inHand = p1.refSim.board[p1.ox][p1.oy];
      }
    }
    if(!player2.ai && ref.catalog.size()%2 == 1) {
      Human p2 = (Human)player2;
      if(mouseX >= 0 && mouseX <= 800 && mouseY >= 0 && mouseY <= 800) {
        p2.ox = floor(mouseX/100);
        p2.oy = floor(mouseY/100);
        p2.inHand = p2.refSim.board[p2.ox][p2.oy];
      }
    }
  }
  
  void updateHumanMove() {
    if(!player1.ai && ref.catalog.size()%2 == 0) {
      Human p1 = (Human)player1;
      if(p1.inHand != null) {
        p1.inHand.x = mouseX-50;
        p1.inHand.y = mouseY-50;
      }
    }
    if(!player2.ai && ref.catalog.size()%2 == 1) {
      Human p2 = (Human)player2;
      if(p2.inHand != null) {
        p2.inHand.x = mouseX-50;
        p2.inHand.y = mouseY-50;
      }
    }
  }
  
  void dropHumanHand() {
    if(!player1.ai && ref.catalog.size()%2 == 0) {
      Human p1 = (Human)player1;
      if(p1.inHand != null) {
        if(mouseX >= 0 && mouseX <= 800 && mouseY >= 0 && mouseY <= 800) {
          p1.setDesiredMove(new Move(p1.ox, p1.oy, floor(mouseX/100), floor(mouseY/100)));
        }
        p1.inHand.x = p1.ox*100;
        p1.inHand.y = p1.oy*100;
      }
      p1.inHand = null;
    }
    if(!player2.ai && ref.catalog.size()%2 == 1) {
      Human p2 = (Human)player2;
      if(p2.inHand != null) {
        if(mouseX >= 0 && mouseX <= 800 && mouseY >= 0 && mouseY <= 800) {
          p2.setDesiredMove(new Move(p2.ox, p2.oy, floor(mouseX/100), floor(mouseY/100)));
        }
        p2.inHand.x = p2.ox*100;
        p2.inHand.y = p2.oy*100;
      }
      p2.inHand = null;
    }
  }
        
}

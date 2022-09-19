class PongManager {
  class Ball {
    float x;
    float y;
    float speedX;
    float speedY;
    float diameter;
    color c;

    // Constructor method
    Ball(float tempX, float tempY, float tempDiameter) {
      x = tempX;
      y = tempY;
      diameter = tempDiameter;
      speedX = 0;
      speedY = 0;
      c = (225);
    }

    void move() {
      // Add speed to location
      y = y + speedY;
      x = x + speedX;
    }

    void draw(PGraphics canvas) {
      canvas.fill(c); //set the drawing color
      canvas.ellipse(x, y, diameter, diameter); //draw a circle
    }

    //functions to help with collision detection
    float left() {
      return x-diameter/2;
    }
    float right() {
      return x+diameter/2;
    }
    float top() {
      return y-diameter/2;
    }
    float bottom() {
      return y+diameter/2;
    }
  }

  class Paddle {
    float x;
    float y;
    float w;
    float h;
    float speedY;
    float speedX;
    color c;

    Paddle(float tempX, float tempY, float tempW, float tempH) {
      x = tempX;
      y = tempY;
      w = tempW;
      h = tempH;
      speedY = 0;
      speedX = 0;
      c=(255);
    }

    void move() {
      y += speedY;
      x += speedX;
    }

    void draw(PGraphics canvas) {
      canvas.fill(c);
      canvas.rect(x-w/2, y-h/2, w, h);
    }

    //helper functions
    float left() {
      return x-w/2;
    }
    float right() {
      return x+w/2;
    }
    float top() {
      return y-h/2;
    }
    float bottom() {
      return y+h/2;
    }
  }

  Ball ball; // Define the ball as a global object

  Paddle paddleLeft;
  Paddle paddleRight;

  //TODO state management and AFK management
  boolean playing = false;
  int[] playerLastInput = {0, 0};
  String[] players = {"", ""}; //Save UUID of players



  int w = 235;
  int h = 145;
  int x = 410;
  int y = 0;

  int scoreLeft = 0;
  int scoreRight = 0;

  float maxSpeedBall = .3;
  float maxSpeedPaddle = 2;

  PongManager(OOCSI oocsi) {
    oocsi.subscribe("0e3be763-a287-4192-ae5e-52c3608f2a09", "pongOOCSIHandler");

    ball = new Ball(x + w/2, x + y/2, 10); //create a new ball to the center of the window
    ball.speedX = 2; // Giving the ball speed in x-axis
    ball.speedY = random(-maxSpeedBall, maxSpeedBall); // Giving the ball speed in y-axis

    paddleLeft = new Paddle(x + 5, y + h/2, 10, 30);
    paddleRight = new Paddle(x + w - 5, y + h/2, 10, 30);
  }

  void draw(PGraphics canvas) {
    //println(players[0] + " ||| " + players[1]);
    if (!playing) {
      canvas.textSize(50);
      canvas.text("Pong", x, h/2);
      canvas.textSize(30);
      canvas.text("Waiting..", x, h/2 + 50);

      if (players[0].length() > 0 && players[1].length() > 0) {
        playing = true;
      }
    }

    if (playing) {
      if ((scoreLeft >= 10 || scoreRight >= 10)) {
        playing = false;
        players[0] = "";
        players[1] = "";
        scoreLeft = 0;
        scoreRight = 0;
      }

      ball.move(); //calculate a new location for the ball
      ball.draw(canvas); // Draw the ball on the window

      paddleLeft.move();
      paddleLeft.draw(canvas);
      paddleRight.move();
      paddleRight.draw(canvas);

      canvas.fill(255);
      canvas.rect(680, 45, map(scoreLeft, 0, 10, 0, 320), 30);
      canvas.rect(680, 105, map(scoreRight, 0, 10, 0, 320), 30);


      if (ball.right() > x + w) {
        scoreLeft = scoreLeft + 1;
        ball.x = x + w/2;
        ball.y = y + h/2;
        ball.speedX = 2; // Giving the ball speed in x-axis
        ball.speedY = random(-maxSpeedBall, maxSpeedBall); // Giving the ball speed in y-axis
      }
      if (ball.left() < x) {
        scoreRight = scoreRight + 1;
        ball.x = x + w/2;
        ball.y = y + h/2;
        ball.speedX = 2; // Giving the ball speed in x-axis
        ball.speedY = random(-maxSpeedBall, maxSpeedBall); // Giving the ball speed in y-axis
      }

      if (ball.bottom() > y + h) {
        ball.speedY = -ball.speedY;
      }

      if (ball.top() < y) {
        ball.speedY = -ball.speedY;
      }

      if (paddleLeft.bottom() > y + h) {
        paddleLeft.y = y + h-paddleLeft.h/2;
      }

      if (paddleLeft.top() < y) {
        paddleLeft.y = paddleLeft.h/2;
      }

      if (paddleRight.bottom() > y + h) {
        paddleRight.y = y + h-paddleRight.h/2;
      }

      if (paddleRight.top() < y) {
        paddleRight.y = paddleRight.h/2;
      }

      // If the ball gets behind the paddle
      // AND if the ball is int he area of the paddle (between paddle top and bottom)
      // bounce the ball to other direction

      if ( ball.left() < paddleLeft.right() && ball.y > paddleLeft.top() && ball.y < paddleLeft.bottom()) {
        ball.speedX = -ball.speedX;
        ball.speedY = map(ball.y - paddleLeft.y, -paddleLeft.h/2, paddleLeft.h/2, -maxSpeedBall * 4, maxSpeedBall * 4);
      }

      if ( ball.right() > paddleRight.left() && ball.y > paddleRight.top() && ball.y < paddleRight.bottom()) {
        ball.speedX = -ball.speedX;
        ball.speedY = map(ball.y - paddleRight.y, -paddleRight.h/2, paddleRight.h/2, -maxSpeedBall * 4, maxSpeedBall * 4);
      }
    }
  }

  final int UP = 0;
  final int DOWN = 1;

  final int RELEASE = 0;
  final int PRESS = 1;

  void event(int player, int direction, int state) {
    //println("[PONG] event player:" + player + " with direction " + direction + " state of button " + state);
    if (state == -1) return;

    if (player == 0) {
      if (direction == UP) {
        if (state == RELEASE) paddleLeft.speedY=0;
        if (state == PRESS) paddleLeft.speedY=-maxSpeedPaddle;
      }
      if (direction == DOWN) {
        if (state == RELEASE) paddleLeft.speedY=0;
        if (state == PRESS) paddleLeft.speedY=maxSpeedPaddle;
      }
    }

    if (player == 1) {
      if (direction == UP) {
        if (state == RELEASE) paddleRight.speedY=0;
        if (state == PRESS) paddleRight.speedY=-maxSpeedPaddle;
      }
      if (direction == DOWN) {
        if (state == RELEASE) paddleRight.speedY=0;
        if (state == PRESS) paddleRight.speedY=maxSpeedPaddle;
      }
    }
  }

  void requestUUID() {
    oocsi
      .channel("0e3be763-a287-4192-ae5e-52c3608f2a09")
      .data("uuid0", this.players[0])
      .data("uuid1", this.players[1])
      .send();
  }

  void register(int player, String uuid) {
    if (player == -1) return; //<>//

    println("[PONG} register player: " + player + " with UUID: " + uuid);
    this.players[player] = uuid;
  }
}
  

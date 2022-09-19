public void createOverlayLeds()
{
  //Initiate FBO buffer gpu
  ledLayout = createGraphics(1000, 350);

  ledLayout.beginDraw();
  //General color and width settings
  //ledLayout.background(255, 255, 255, 0);
  ledLayout.strokeWeight(1);
  ledLayout.rectMode(CENTER);

  //Draw all the different lines of the LED strip to the buffer
  for (var led : availableLedStrips)
  {
    //ofLogNotice("DRAWING LED STRIP: num led " + ofToString(led.num) + " LED. at position: (" + ofToString(led.p1.x) + "," + ofToString(led.p1.y) + ") , (" + ofToString(led.p2.x) + "," + ofToString(led.p2.y) + ") ");

    var p1 = led.p1;
    var p2 = led.p2;

    ledLayout.fill(255, 255, 255);
    ledLayout.stroke(50,50,50);
    ledLayout.line(p1.x, p1.y, p2.x, p2.y);

    ledLayout.fill(0, 255, 0);
    ledLayout.rect(p1.x, p1.y, 5, 5);

    ledLayout.color(255, 0, 0);
    ledLayout.rect(p2.x, p2.y, 5, 5);
  }

  ledLayout.endDraw();
}

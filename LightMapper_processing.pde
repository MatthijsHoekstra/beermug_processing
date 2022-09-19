import java.util.*; //<>// //<>//
import ch.bildspur.artnet.*;
import nl.tue.id.oocsi.*;
import controlP5.*;

import java.io.File;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileSystemView;

OOCSI oocsi;
ArtNetClient artnet;
Canvas canvas;
Artnet artnetManager;
GUI gui;
PongManager pong;

public Vector<ledStrip> availableLedStrips = new Vector<ledStrip>();
PGraphics ledLayout;

//-----------------CHANGABLE

boolean debug = true;
boolean debugArtnet = true;

int customFrameRate = 60; // fps
int animationLength = 750; // ms
int animationDelay = 250; // ms

//-----------------

void setup() {
  size(1200, 1000);
  frameRate(customFrameRate);
  colorMode(RGB, 255);

  canvas = new Canvas();
  canvas.setup(1000, 350);

  artnetManager = new Artnet();

  gui = new GUI(this);

  availableLedStrips = loadLedGroups();
  createArnetSenders(availableLedStrips);

  artnet = new ArtNetClient(null);
  artnet.start();

  createOverlayLeds();

  oocsi = new OOCSI(this, "beermug", "oocsi.id.tue.nl");
  pong = new PongManager(oocsi);
}

void draw() {
  background(40);

  canvas.updateEffects(); //Update the effects if they have an update function
  canvas.drawEffects(); //Draw the effects to the FBO
  canvas.loadPixels();

  //PGraphics canvas = canvas.getCanvas();
  //canvas.beginDraw();
  
  //canvas.endDraw();
  
  

  updateLEDs();

  gui.update();
  gui.draw();

  canvas.drawCanvasToScreen(20, 220);

  if (gui.showLedOverlay) image(ledLayout, 20, 220);
 
}

void keyPressed(){
  if(keyCode == UP){
    pong.event(1, 0, 1);
  }
  if(keyCode == DOWN){
    pong.event(1, 1, 1);
  }
  if(key == 'a'){
    pong.event(0, 0, 1);
  }
  if(key == 'z'){
    pong.event(0, 1, 1);
  }
}

void keyReleased(){
  if(keyCode == UP){
    pong.event(1, 0, 0);
  }
  if(keyCode == DOWN){
    pong.event(1, 1, 0);
  }
  if(key == 'a'){
    pong.event(0, 0, 0);
  }
  if(key == 'z'){
    pong.event(0, 1, 0);
  }
}

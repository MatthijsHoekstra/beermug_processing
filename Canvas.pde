//C++ TO JAVA CONVERTER WARNING: The following #include directive was ignored:
///#include "ofMain.h"
//C++ TO JAVA CONVERTER WARNING: The following #include directive was ignored:
///#include "ofxShadertoy.h"

public class Canvas
{
  int w, h;
  public final void setup(int w, int h)
  {
    //Initialize canvas onto GPU for rendering
    
    this.w = w;
    this.h = h;

    drawCanvas = createGraphics(w, h);

    drawCanvas.beginDraw();
    drawCanvas.background(0, 0, 0);
    drawCanvas.endDraw();

    //contentManager.setup();

    //shadertoy.load("shaders/blobs.frag");
    ////shadertoy.setHeight(200);
    ////shadertoy.setWidth(1000);
    ////shadertoy.setAnchorPoint(300, -300);
    ////shadertoy.set
    //shadertoy.setAdvanceTime(true);
  }

  public final void updateEffects()
  {
    //C++ TO JAVA CONVERTER NOTE: 'auto' variable declarations are not supported in Java:
    //ORIGINAL LINE: for (auto const& media : contentManager.mediaRunning)
    //for (final int media : contentManager.mediaRunning)
    //{
    //  //ofLogNotice() << "Updating media" << media->mediaType;
    //  media.update();
    //}
  }

  public final void drawEffects()
  {
    drawCanvas.beginDraw();
    drawCanvas.background(0);
    pong.draw(drawCanvas);
    drawCanvas.endDraw();
    //C++ TO JAVA CONVERTER NOTE: 'auto' variable declarations are not supported in Java:
    //ORIGINAL LINE: for (auto const& media : contentManager.mediaRunning)
    //for (final int media : contentManager.mediaRunning)
    //{
    //  //ofLogNotice() << "Drawing media" << media->mediaType;
    //  drawCanvas.begin();
    //  media.draw();
    //  drawCanvas.end();
    //}
  }

  public final void loadPixels()
  {
    drawCanvas.loadPixels();
  }

  public final void drawCanvasToScreen(int x, int y)
  {
    image(drawCanvas, x, y);
  }

  public byte[] getStripPixels(int num, int x1_, int y1_, int x2_, int y2_)
  {
    //ofLogNotice() << "Get strip color: pixels: " << num ;
    //println("Get strip color - pixels: " + (num) + " - pos: " + (x1_) + " , " + (y1_) + " , " + (x2_) + " , " + (y2_) + "");

    byte[] colorStrip = new byte[num * 3];

    int index = 0;
    for (int i = 0; i < num; i++)
    {
      int x = int(map(i, 0, num, x1_, x2_));
      int y = int(map(i, 0, num, y1_, y2_));

      int loc = ( x + y * drawCanvas.width);

      //We expect 3 pixel values, as there are 3 pixels
      for (int j = 0; j < 3; j++)
      {
        color pixel = drawCanvas.pixels[loc];
        byte c = 0;
        switch(j) {
        case 0:
          c = byte(red(pixel));
          break;
        case 1:
          c = byte(green(pixel));
          break;
        case 2:
          c = byte(blue(pixel));
          break;
        }
        
        colorStrip[index] = c;
        index++;
      }
    }

    //println();
    return colorStrip;
  }
  
  PGraphics getCanvas(){
    return this.drawCanvas;
  }

  //void displayEffect(int loc, int id);
  //void displayColor(int loc, ofColor color);
  //void displayMediaFile(int loc, string path);

  public byte[] pixelPointers;

  //public ContentManager contentManager = new ContentManager();

  private PGraphics drawCanvas;
}

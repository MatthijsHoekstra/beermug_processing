public void createArnetSenders(Vector<ledStrip> availableLedStrips)
{
  println("Creating artnet senders");

  Vector<Pair<Integer, String>> artnetList = new Vector<Pair<Integer, String>>();

  Vector<Integer> artnetAdresses = new Vector<Integer>();

  for (var led : availableLedStrips)
  {
    int universe = led.adress[0];

    if (!artnetAdresses.contains(universe))
    {
      artnetList.add(Pair.with(universe, led.ip));
      artnetAdresses.add(universe);
    }
  }

  for (var adressAndIP : artnetList)
  {
    artnetManager.addUniverse(adressAndIP.getValue0(), adressAndIP.getValue1().toString());
  }
}

public class Artnet
{
  ///#include "ofxArtnet.h"

  Artnet() {
  }

  public final boolean addUniverse(int universe, String ip)
  {
    //Checking if the universes are naturally counted
    if (universe > currentAddedUniverse && universe == (currentAddedUniverse + 1))
    {

      artnets.add(new ArtnetSender());
      artnets.get(artnets.size() - 1).setup(ip, universe); //universe i
      //artnets.get(artnets.size() - 1).enableThread(lmConfig.framerate);
      //artnets.back()->setThreadedSend(true);
      //artnets.back()->start(lmConfig::framerate);

      currentAddedUniverse++;

      println("ARTNET: added artnet on universe: " + (universe) + " - ip: " + ip);
      return true;
    } else
    {
      println("ARTNET: help, failed to add universe: " + (universe));
      return false;
    }
  }

  //C++ TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
  //ORIGINAL LINE: void sendDataUniverse(int universe, int numLeds, unique_ptr<unsigned char[]>);
  public final void sendDataUniverse(int universe, int numLeds, byte[] pix)
  {
    //ofLogNotice() << "Artnet: sending to : " << universe << " // number of pixels: " << numLeds * 3;
    //C++ TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
    //ORIGINAL LINE: unsigned char * pixs = pix.get();
    //C++ TO JAVA CONVERTER TODO TASK: Java does not have an equivalent to pointers to value types:
    //ORIGINAL LINE: byte * pixs = pix.get();
    //byte pixs = pix.get();

    //If the universe is not initialized the sendArtnet would crash the program as vector is out of range
    if (universe < artnets.size())
    {
      artnets.get(universe).sendArtnet(pix);
      //ofLogNotice() << "Color Artnet: {" << (int)pixels[0] << "," << (int)pixels[1] << "," << (int)pixels[2] << "}";
    } else
    {
      //ofLogError() << "[ARTNET] Artnet sender not initialized on universe: " << universe;
    }
    //ofLogNotice() << "Artnet: send";
  }

  private ArrayList<ArtnetSender> artnets = new ArrayList<ArtnetSender>();
  private int currentAddedUniverse = -1;
}

class ArtnetSender {

  String ip;
  int universe;

  void setup(String ip, int universe) {
    this.ip = ip;
    this.universe = universe;
  }

  void sendArtnet(byte[] pix) {
    if (debugArtnet) {
      artnet.unicastDmx("127.0.0.1", 0, this.universe, pix);
    } else {
      artnet.unicastDmx(this.ip, 0, this.universe, pix);
    }




    //new Thread(new Runnable() {
    //  private byte[] pix;

    //  String ip_;
    //  int universe_;

    //  public Runnable init(String ip, int universe, byte[] pix) {
    //    this.pix = pix;
    //    this.ip_ = ip;
    //    this.universe_ = universe;
    //    return this;
    //  }

    //  @Override
    //    public void run() {

    //    int subnet = 0;
    //    if (debug) {
    //      switch (this.ip_) {
    //      case "10.0.0.2":
    //        subnet = 1;
    //        break;
    //      case "10.0.0.3":
    //        subnet = 2;
    //        break;
    //      }
    //    }

    //    artnet.unicastDmx("127.0.0.1", 0, this.universe_, this.pix);
    //    return;
    //  }
    //}
    //.init(this.ip, this.universe, pix)).start();
  }
}

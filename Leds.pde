public final void updateLEDs()
{
  int currentLEDStrip = 0;
  int currentUniverse = 0;

  Vector<Integer> numLedStrip = new Vector<Integer>();
  //C++ TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
  //ORIGINAL LINE: vector<unique_ptr<unsigned char[]>> strips;
  Vector<byte[]> strips = new Vector<byte[]>();

  loadPixels();

  while (currentLEDStrip < availableLedStrips.size())
  {
    //ofLogNotice() << "Updating strip: " << currentLEDStrip << " - from number of total strips: " << availableLedStrips.size();
    ledStrip strip = availableLedStrips.get(currentLEDStrip); //Looping through all defined LED strips

    //Adress changes, so new universe, send old one directly
    if (strip.adress[0] != currentUniverse)
    {
      //Counting the total numbers of strips in the current universe
      int totalLEDInStrip = 0;
      for (var n : numLedStrip)
      {
        totalLEDInStrip += n;
      }

      byte[] artnetStrip = new byte[totalLEDInStrip * 3];

      int index = 0;
      int currentStrip = 0;
      for (int i = 0; i < totalLEDInStrip * 3; i++)
      {
        //Go to next unsigned char (next strip) if the total leds of that strip are reached
        if (index > (numLedStrip.get(currentStrip) * 3) - 1)
        {
          index = 0;
          currentStrip++;
        }

        artnetStrip[i] = strips.get(currentStrip)[index]; //Put the all the strips in the current artnet strip
        index++; //Increase index of current strip
      }

      artnetManager.sendDataUniverse(currentUniverse, totalLEDInStrip, artnetStrip);

      numLedStrip.clear();
      strips.clear();
    }

    byte[] coloredStrip = canvas.getStripPixels(strip.num, strip.p1.x, strip.p1.y, strip.p2.x, strip.p2.y);
    strips.add(coloredStrip);

    numLedStrip.add(strip.num);

    //Loop trough all the LEDs
    currentLEDStrip++;
    //Get artnet adress to compare if the universe has changed
    currentUniverse = strip.adress[0];
  }
}

final public Vector<ledStrip> loadLedGroups()
{
  XML config;
  config = loadXML("data/LightMapper.exe.config");

  XML config_LED_Strips = config.getChild("config_LED_Strips");

  XML[] sections = config_LED_Strips.getChildren("section");

  int numSections = sections.length;
  println("Number of sections " + (numSections));

  int currentArtnetUniverse = 0;
  int currentChannel = 0;

  int countBeerMug = 0;

  Vector<ledStrip> availableLedStrips = new Vector<ledStrip>();

  //Figure out where every strip is according to the config file, order into Strip class
  for (int i = 0; i < numSections; i++)
  {
    String nameSection = sections[i].getString("type");
    String ip = sections[i].getString("ip");

    XML[] groups = sections[i].getChildren("group");

    int numGroups = groups.length;
    println();
    println("Number of groups in section " + nameSection + ": " + (numGroups) + " || IP section: " + ip);

    for (int j = 0; j < numGroups; j++)
    {
      //Move into an group of LEDs as they need a seperate artnet universe
      XML[] strips = groups[j].getChildren("strip");

      int numStrips = strips.length;

      println();
      println("Number of strips in group: " + (numStrips));

      for (int k = 0; k < numStrips; k++)
      {
        //Check if the current channel reach is over the limit of 170 LEDs per universe (520 channels)
        //If so make new universe, start at begin
        if (currentChannel > 520)
        {
          currentChannel = 0;
          currentArtnetUniverse++;
        }

        //Move to an individual strip and get the num LEDs
        int numLeds = 0;

        try {
          numLeds = int(strips[k].getChild("led").getContent());
        }
        catch (Exception e) {
        }
        //int numLeds = config.getValue("led", -1); //RGB

        //Get position information out of the XML, led strip object

        XML[] pos_ = strips[k].getChildren("pos");

        int[] pos = new int[4];

        try {
          pos[0] = int(pos_[0].getChild("x1").getContent());
          pos[1] = int(pos_[0].getChild("y1").getContent());
          pos[2] = int(pos_[0].getChild("x2").getContent());
          pos[3] = int(pos_[0].getChild("y2").getContent());
        }
        catch(Exception e) {
        }

        println("LED Strip with " + numLeds + " LEDS at: " + pos[0] + " " + pos[1] + " " + pos[2] + " " + pos[3]);

        if (nameSection.equals("beer_mug"))
        {
          if (k == 0)
          {
            pos[0] = 410;
            pos[1] = int(map(countBeerMug, 0, 28, 0, 145));

            pos[2] = 645;
            pos[3] = pos[1];
          } else if (k == 1)
          {
            pos[0] = 645;
            pos[1] = int(map(countBeerMug, 0, 28, 0, 145));

            pos[2] = 410;
            pos[3] = pos[1];
          }

          countBeerMug++;
        }

        ledStrip strip = new ledStrip(pos[0], pos[1], pos[2], pos[3], numLeds, currentArtnetUniverse, currentChannel, ip);
        //Bring the LED strip to the memory, store information into availableLedStrips vector
        availableLedStrips.add(strip);


        currentChannel = currentChannel + (numLeds * 3); // Compensating for 3 channels per LED
      }
      //  config.popTag();

      //Keep counting the artnet adresses, each group of LEDs gets a new artnet universe
      currentArtnetUniverse++;
      currentChannel = 0;
    }
    //config.popTag();

    println("END SECTION---------- ");
  }

  return new Vector<ledStrip>(availableLedStrips);
}

public class LedGroups
{
  //Stores the information related to the different available groups where media can be stored in
  public class configLedGroup
  {
    public int x;
    public int y;

    public int w;
    public int h;
  }

  public Map<String, configLedGroup> ledGroupsAvailable = new HashMap<String, configLedGroup>();

  //Functions
  public final void addLedGroup(String name, int x, int y, int w, int h)
  {
    LedGroups.configLedGroup properties = new LedGroups.configLedGroup();
    properties.x = x;
    properties.y = y;
    properties.w = w;
    properties.h = h;

    ledGroupsAvailable.put(name, properties);

    println("[LEDGROUPS: addLedGroup] adding: " + (name));
  }

  //public final LedGroups.configLedGroup getLedGroupData(String name)
  //{
  //  if (!ledGroupsAvailable.count(name))
  //  {
  //    return null;
  //  }

  //  return ledGroupsAvailable[name];
  //}
}

public class ofVec2f {
  ofVec2f(int x, int y) {
    this.x = x;
    this.y = y;
  }

  int x;
  int y;
}


public ofVec2f ofVec2f(int x, int y) {
  return new ofVec2f(x, y);
}

public class ledStrip
{
  ledStrip(int x1, int y1, int x2, int y2, int num_, int universe, int channel, String ip_)
  {
    p1 = ofVec2f(x1, y1);
    p2 = ofVec2f(x2, y2);

    num = num_;

    adress[0] = universe;
    adress[1] = channel;

    ip = ip_;

    //println("LED STRIP: created with " + (num) + " LED. at position: (" + (x1) + "," + (y1) + ") , (" + (x2) + "," + (y2) + ") - universe: " + (adress[0]) + " - channel start: " + (adress[1]) + " - located in network at ip: " + ip);
  }

  public ofVec2f p1;
  public ofVec2f p2;

  public int num;

  public int[] adress = new int[2]; // 0 - artnet adress // 1 - channel start
  public String ip = new String();
}

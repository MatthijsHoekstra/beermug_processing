class GUI {

  ControlP5 cp5;
  Chart fpsChart;
  boolean showLedOverlay;


  GUI(PApplet parent) {
    cp5 = new ControlP5(parent);
    setupFpsChart();
  }

  void setupFpsChart() {
    fpsChart = cp5.addChart("frameRate")
      .setPosition(20, 50)
      .setSize(200, 100)
      .setRange(0, customFrameRate + 20)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(1.5)
      .setColorCaptionLabel(color(255))
      ;

    fpsChart.addDataSet("frameRateMin");
    fpsChart.setColors("frameRateMin", color(255, 0, 0));
    fpsChart.setData("frameRateMin", new float[10*120]);

    fpsChart.addDataSet("frameRatePref");
    fpsChart.setColors("frameRatePref", color(0, 255, 0));
    fpsChart.setData("frameRatePref", new float[10*120]);

    fpsChart.addDataSet("frameRate");
    fpsChart.setColors("frameRate", color(255, 255, 255));
    fpsChart.setData("frameRate", new float[10 * 120]);

    cp5.addBang("openVideo")
      .setPosition(300, 50)
      .setSize(40, 40)
      .addListener(new ControlListener() {
      @Override
        public void controlEvent(ControlEvent theEvent) {
        JFileChooser jfc = new JFileChooser(FileSystemView.getFileSystemView().getHomeDirectory());

        int returnValue = jfc.showOpenDialog(null);
        // int returnValue = jfc.showSaveDialog(null);

        if (returnValue == JFileChooser.APPROVE_OPTION) {
          File selectedFile = jfc.getSelectedFile();
          System.out.println(selectedFile.getAbsolutePath());
        }
      }
    }
    );

    cp5.addToggle("showLedOverlay")
      .setPosition(350, 50)
      .setSize(50, 20)
      ;
  }

  void updateFpsChart() {
    fpsChart.push("frameRate", frameRate);
    fpsChart.push("frameRateMin", 30);
    fpsChart.push("frameRatePref", customFrameRate);
  }

  final void update() {
    updateFpsChart();
  }
  final void draw() {
    text(frameRate, 20, 40);
  }
  final void displayStats() {
  }

  final void openVideo() {
    selectInput("Select a file to process:", "fileSelected");
  }

  final void fileSelected() {
  }
}

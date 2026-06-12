import processing.serial.*;
import processing.sound.*;

Serial myPort;
SoundFile[] notes = new SoundFile[5];
String[] noteNames = {"DO", "RE", "MI", "FA", "SO"};
String[] fileNames = {"C4.mp3", "D4.mp3", "E4.mp3", "F4.mp3", "G4.mp3"};

void setup() {
  size(300, 200);
  background(30);
  
  myPort = new Serial(this, "COM5", 2000000);
  
  for (int i = 0; i < 5; i++) {
    notes[i] = new SoundFile(this, fileNames[i]);
  }
}

void draw() {
}

void serialEvent(Serial p) {
  String msg = trim(p.readStringUntil('\n'));
  if (msg == null) return;
  
  for (int i = 0; i < 5; i++) {
    if (msg.equals(noteNames[i])) {
      notes[i].jump(0);  // 同時押し対応
    }
  }
}

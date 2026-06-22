import processing.serial.*;
import processing.sound.*;

Serial myPort;
String[] noteNames = {"C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};
String[] fileNames  = {"C4.mp3", "D4.mp3", "E4.mp3", "F4.mp3", "G4.mp3", "A4.mp3", "B4.mp3", "C5.mp3"};
SoundFile[] notes = new SoundFile[8];

void setup() {
  size(300, 200);
  myPort = new Serial(this, "COM5", 115200);
  myPort.bufferUntil('\n');
  for (int i = 0; i < 8; i++) {
    notes[i] = new SoundFile(this, fileNames[i]);
  }
}

void draw() {}

void serialEvent(Serial p) {
  String msg = trim(p.readStringUntil('\n'));
  if (msg == null) return;

  for (int i = 0; i < noteNames.length; i++) {
    if (msg.equals(noteNames[i])) {
      notes[i].jump(0);
    }
  }
}

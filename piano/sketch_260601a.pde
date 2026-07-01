import processing.serial.*;
import processing.sound.*;

Serial myPort;
//String[] noteNames = {"C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};
//String[] fileNames  = {"C4.mp3", "D4.mp3", "E4.mp3", "F4.mp3", "G4.mp3", "A4.mp3", "B4.mp3", "C5.mp3"};
String[] noteNames = {"C4","D4","E4"};
String[] fileNames  = {"C4.mp3", "D4.mp3", "E4.mp3"};
//SoundFile[] notes = new SoundFile[8];
SoundFile[] notes = new SoundFile[3];

void setup() {
  size(300, 200);
  myPort = new Serial(this, "COM6", 2000000);
  myPort.bufferUntil('\n');
  for (int i = 0; i < 3; i++) {
    notes[i] = new SoundFile(this, fileNames[i]);
  }
}

void draw() {}

void serialEvent(Serial p) {
  String msg = trim(p.readStringUntil('\n'));
  println(msg);
  
  if (msg == null) return;

  if (!msg.startsWith("NOTE:")) return;

  msg = msg.substring(5); // "NOTE:"を削除

  for (int i = 0; i < noteNames.length; i++) {
    if (msg.equals(noteNames[i])) {
      notes[i].stop();
      notes[i].play();
    }
  }
}import processing.serial.*;
import processing.sound.*;

Serial myPort;
//String[] noteNames = {"C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};
//String[] fileNames  = {"C4.mp3", "D4.mp3", "E4.mp3", "F4.mp3", "G4.mp3", "A4.mp3", "B4.mp3", "C5.mp3"};
String[] noteNames = {"C4","D4","E4"};
String[] fileNames  = {"C4.mp3", "D4.mp3", "E4.mp3"};
//SoundFile[] notes = new SoundFile[8];
SoundFile[] notes = new SoundFile[3];

void setup() {
  size(300, 200);
  myPort = new Serial(this, "COM5", 2000000);
  myPort.bufferUntil('\n');
  for (int i = 0; i < 3; i++) {
    notes[i] = new SoundFile(this, fileNames[i]);
  }
}

void draw() {}

void serialEvent(Serial p) {
  String msg = trim(p.readStringUntil('\n'));
  println(msg);
  
  if (msg == null) return;

  if (!msg.startsWith("NOTE:")) return;

  msg = msg.substring(5); // "NOTE:"を削除

  for (int i = 0; i < noteNames.length; i++) {
    if (msg.equals(noteNames[i])) {
      notes[i].stop();
      notes[i].play();
    }
  }
}

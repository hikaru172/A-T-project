#define NUM_SENSORS 3
#define THRESHOLD 50
#define COOLDOWN 200

const int trigPins[NUM_SENSORS] = {3,7,A4};
const int echoPins[NUM_SENSORS] = {2,6,A2};
const String notes[NUM_SENSORS] = {"C4", "D4", "E4"};

bool wasTriggered[NUM_SENSORS] = {false, false, false};
unsigned long lastTriggered[NUM_SENSORS] = {0, 0, 0};
double dist[NUM_SENSORS] = {0, 0, 0};
double lastdist[NUM_SENSORS] = {0, 0, 0};
double lastdist2[NUM_SENSORS] = {0, 0, 0};
double lastdist3[NUM_SENSORS] = {0, 0, 0};

//const int trigPins[NUM_SENSORS] = {3,5,7,9,11,13,A1,A3};
//const int echoPins[NUM_SENSORS] = {2,4,6,8,10,12,A0,A2};
//const String notes[NUM_SENSORS] = {"C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};

//bool wasTriggered[NUM_SENSORS] = {false, false, false, false, false, false, false, false};
//unsigned long lastTriggered[NUM_SENSORS] = {0, 0, 0, 0, 0, 0, 0, 0};
//double dist[NUM_SENSORS] = {0, 0, 0, 0, 0, 0, 0, 0};
//double lastdist[NUM_SENSORS] = {0, 0, 0, 0, 0, 0, 0, 0};
//double lastdist2[NUM_SENSORS] = {0, 0, 0, 0, 0, 0, 0, 0};
//double lastdist3[NUM_SENSORS] = {0, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  Serial.begin(1000000);
  for (int i = 0; i < NUM_SENSORS; i++) {
    pinMode(trigPins[i], OUTPUT);
    pinMode(echoPins[i], INPUT);
  }
}

double getDistance(int i) {
  digitalWrite(trigPins[i], LOW);
  delayMicroseconds(2);
  digitalWrite(trigPins[i], HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPins[i], LOW);
  long d = pulseIn(echoPins[i], HIGH, 30000);
  if (d == 0) return 999;
  return (d / 2.0) * 340.0 * 100.0 / 1000000.0;
}

void loop() {
  for (int i = 0; i < NUM_SENSORS; i++) {
    unsigned long start = millis();
//    double dist = getDistance(i);
    // double dist = getDistance(0);
    dist[i] = getDistance(i);
    unsigned long elapsed = millis() - start;

    // 距離と遅延時間をシリアルモニターに表示
//     Serial.println("sensor");
//     Serial.println(i + 1);
//if(dist <= 100) {
     Serial.println(dist[2]);
     Serial.println("cm");
//}
//     Serial.print("cm  delay:");
//     Serial.print(elapsed);
//     Serial.println("ms");

    unsigned long now = millis();
    if (dist[i] > 0 &&dist[i] < THRESHOLD && (now - lastTriggered[i] > COOLDOWN) && !wasTriggered[i]) {
      Serial.print("NOTE:");
      Serial.println(notes[i]);
      wasTriggered[i] = true;
      lastTriggered[i] = now;
    }
    
    if (dist[i] > 50 && dist[i] < 300 && lastdist[i] > 50 && lastdist2[i] > 50 && lastdist3[i] > 50 ) {
      wasTriggered[i] = false;
    }
    
    lastdist3[i] = lastdist2[i];
    lastdist2[i] = lastdist[i];
    lastdist[i] = dist[i];
  }
  delay(1);
}

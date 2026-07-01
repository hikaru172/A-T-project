#define NUM_SENSORS 3
#define THRESHOLD 50
#define COOLDOWN 2000

const int trigPins[NUM_SENSORS] = {3,7,11};
const int echoPins[NUM_SENSORS] = {2,6,10};
const String notes[NUM_SENSORS] = {"C4", "D4", "E4"};

bool wasTriggered[NUM_SENSORS] = {false, false, false};
unsigned long lastTriggered[NUM_SENSORS] = {0, 0, 0};

void setup() {
  Serial.begin(2000000);
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
    double dist = getDistance(i);
    // double dist = getDistance(0);
    unsigned long elapsed = millis() - start;

    // 距離と遅延時間をシリアルモニターに表示
//     Serial.println("sensor");
//     Serial.println(i + 1);
//if(dist <= 100) {
     Serial.println(dist);
     Serial.println("cm");
//}
//     Serial.print("cm  delay:");
//     Serial.print(elapsed);
//     Serial.println("ms");

    unsigned long now = millis();
    if (dist < THRESHOLD && (now - lastTriggered[i] > COOLDOWN) && !wasTriggered[i]) {
      Serial.print("NOTE:");
      Serial.println(notes[i]);
      wasTriggered[i] = true;
      lastTriggered[i] = now;
    }

     if (dist > 70 && dist < 300) {
      wasTriggered[i] = false;
    }
  }
  delay(1);
}

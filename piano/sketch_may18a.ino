#define NUM_SENSORS 5
#define THRESHOLD 30
#define COOLDOWN 200

const int trigPins[NUM_SENSORS] = {3, 5, 7, 9, 11};
const int echoPins[NUM_SENSORS] = {2, 4, 6, 8, 10};
const String notes[NUM_SENSORS] = {"DO", "RE", "MI", "FA", "SO"};

bool wasTriggered[NUM_SENSORS] = {false, false, false, false, false};
unsigned long lastTriggered[NUM_SENSORS] = {0, 0, 0, 0, 0};

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
    unsigned long elapsed = millis() - start;

    // 距離と遅延時間をシリアルモニターに表示
    Serial.print("sensor");
    Serial.print(i + 1);
    Serial.print(" dist:");
    Serial.print(dist);
    Serial.print("cm  delay:");
    Serial.print(elapsed);
    Serial.println("ms");

    unsigned long now = millis();
    if (dist < THRESHOLD && !wasTriggered[i] && (now - lastTriggered[i] > COOLDOWN)) {
      Serial.println(notes[i]);
      wasTriggered[i] = true;
      lastTriggered[i] = now;
    } else if (dist >= THRESHOLD) {
      wasTriggered[i] = false;
    }
  }
  delay(1);
}
